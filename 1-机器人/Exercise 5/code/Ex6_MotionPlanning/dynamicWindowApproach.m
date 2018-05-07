function [ vSolution, omegaSolution, debug ] = dynamicWindowApproach( robotState, goalPosition, localMap, parameters, globalGradientMap)
%DYNAMICWINDOWAPPROACH Computes commands for a differetial drive robot via
%the dynamic window approach.
%   The inputs to the function are
%   - robotState: the current robot state [x,y,heading,vel,omega] given in 
%                 the map coordinate frame
%   - goalPosition: the goal position [x,y] in the map coordinate frame
%   - localMap: the map of the local environment of the robot
%   - parameters: the parameter struct, conatining the following fields:
%       globalPlanningOn: use global navigation function or not? [bool]
%       simTime: lookahead time for trajectory simulation [seconds]
%       timestep: time increment for one planning step [seconds]
%       nVelSamples: number of linear velocity samples
%       nOmegaSamples: number of angular velocity samples
%       headingScoring: weighting factor for heading term in cost fcn. 
%       velocityScoring: weighting factor for velocity term in cost fcn.
%       obstacleDistanceScoring: weighting factor for distance term in cost fcn.
%       objectiveFcnSmoothingKernel: smoothing kernel to smooth the resulting 2D cost field, e.g. a gaussian kernel
%       maxVel: maximum linear velocity of the robot [meters/second]
%       maxOmega: maximum angular velocity of the robot [radians/second]
%       maxAcc: maximum linear acceleration of the robot [meters/seconds^2]
%       maxOmegaDot: maximum angular acceleration of the robot [radians/seconds^2]
%       robotRadius: radius of the robot's circular footprint [meters]
%       goalBrakingDistance: distance from goal at which robot starts to brake [meters]
%   - globalGradientMap: (optional) a map of the gradient direction of the global
%                        navigation function (only for global DWA)

%% Start timer
tic;

%% Check inputs
checkInputs(robotState, goalPosition, parameters);

%% Precomputations

% Compute the dynamic window. These are the velocities that are reachable
% within the next time interval parameters.timestep
[minVel, maxVel, minOmega, maxOmega] = computeDynamicWindow(robotState, parameters);

% Compute the velocity and omega samples for a uniform sampling of the
% velocity space
velSamples = linspace(minVel, maxVel, parameters.nVelSamples);
omegaSamples = linspace(minOmega, maxOmega, parameters.nOmegaSamples);

% make sure we have 0 speed in the samples, if it is reachable
if minVel*maxVel < 0.0
    if isempty(find(abs(velSamples) < 1e-3, 1))
        velSamples = [velSamples, 0.0];
    end
end
if minOmega*maxOmega < 0
    if isempty(find(abs(omegaSamples) < 1e-3, 1))
        omegaSamples = [omegaSamples, 0.0];
    end
end

% the current distance to the goal
distToGoal = hypot(robotState.x-goalPosition.x, robotState.y-goalPosition.y);

% If we have reached the goal, we want to stop. We have to take into
% account the resolution of the map for defining "goal reached".
if distToGoal < 1.5*localMap.resolution
    vSolution = min(abs(velSamples));
    omegaSolution = min(abs(omegaSamples));
    if nargout > 2
        debug.valid = false;
    end
else
    % Compute the obstacle distance transform. Later we can query the robot
    % collision state for a particular cell via a simple lookup localObstacleDistanceMap(idx1, idx2)
    % < robotRadius.
    maps.localObstacleDistanceMap = localMap;
    distInput = localMap.data;
    distInput(distInput ~= 0) = 1;
    maps.localObstacleDistanceMap.data = bwdist(distInput).*localMap.resolution;

    if parameters.globalPlanningOn
        maps.globalGradientMap = globalGradientMap;
    end

    %% Sample the velocity space and compute the trajectoy costs to identify the best trajectory

    headingTerms = zeros(numel(velSamples),numel(omegaSamples));
    velTerms     = zeros(numel(velSamples),numel(omegaSamples));
    distTerms    = zeros(numel(velSamples),numel(omegaSamples));
    
    if nargout > 2
        debug.valid = true;
        debug.trajectories = cell(numel(velSamples),numel(omegaSamples));
        debug.nStepsBrake = zeros(numel(velSamples),numel(omegaSamples));
    end

    % the radius around the goal within which we want to decelerate
    goalBrakingDistance = max(1.5*(parameters.maxVel^2/parameters.maxAcc), parameters.goalBrakingDistance);

    % Iterate over the velocity search space to find the least cost trajectory
    for idxVel = 1:1:numel(velSamples)
        for idxOmega = 1:1:numel(omegaSamples)

            % Extract the current v/omega sample
            velSample = velSamples(idxVel);
            omegaSample = omegaSamples(idxOmega);

            if ~(velSample == 0 && omegaSample == 0)  

                % compute the braking time
                brakingTime = parameters.timestep + max(abs(velSample)/parameters.maxAcc, abs(omegaSample)/parameters.maxOmegaDot);

                % define the desired resolutions for the trajectory simulation
                angularResolution = 0.3; % rad
                distanceResolution = maps.localObstacleDistanceMap.resolution;

                % compute the time increment for the trajectory simulation
                if velSample == 0
                    simGranularity = angularResolution/abs(omegaSample);
                elseif omegaSample == 0
                    simGranularity = distanceResolution/abs(velSample);
                else
                    simGranularity = min(distanceResolution/abs(velSample), angularResolution/abs(omegaSample));
                end
                simGranularity = min(parameters.timestep, simGranularity);

                % compute the number of steps for the trajectory simulation
                % length of braking trajectory = nStepsBrake * velSample
                nStepsBrake = ceil(brakingTime/simGranularity);
                % length of full simulated trajectory = nStepsFull * velSample
                nStepsFull = ceil(max(brakingTime, parameters.simTime)/simGranularity);
            else
                % we at least want to take one step... even if we won't move, we want to score our current position
                nStepsBrake = 1;
                nStepsFull = 1;
                simGranularity = 0.0; % it does not matter in the case of stillstand
            end

            % Compute trajectory
            trajectory = computeTrajectory(robotState, velSample, omegaSample, simGranularity, nStepsFull);
            
            if nargout > 2
                debug.trajectories{idxVel, idxOmega} = trajectory;
                debug.nStepsBrake(idxVel, idxOmega) = nStepsBrake;
            end

            % Score trajectory
            [headingTerms(idxVel,idxOmega), ...
             distTerms(idxVel,idxOmega), ...
             velTerms(idxVel,idxOmega)] = scoreTrajectory(trajectory, nStepsBrake, goalPosition, maps, distToGoal, goalBrakingDistance, parameters);

        end
    end
    

    %% Find the best trajectory within the search space

    % Check whether we have found a suitable (collision-free) solution. If not, the best we can
    % do is brake as soon as possible.
    if isnan(max(max(velTerms)))
        warning('DynamicWindow:NoSolution', 'Could not find suitable trajectory, braking');
        scores = NaN*ones(numel(velSamples), numel(omegaSamples));
        vSolution = min(abs(velSamples));
        omegaSolution = min(abs(omegaSamples));
        solutionFound = false;
    else    
        % Normalize the 3 components of the score function. Pay attention that
        % we do not divide by zero. The min and max calls do not consider NaN
        % values, so they will be sorted out automatically.
        minDistTerm = min(min(distTerms));
        maxDistTerm = max(max(distTerms));    
        if abs(maxDistTerm - minDistTerm) > 1e-5        
            distTermsNormalized = (distTerms - minDistTerm)/(maxDistTerm - minDistTerm);
        else
            distTermsNormalized = zeros(size(distTerms));
        end
        minHeadingTerm = min(min(headingTerms));
        maxHeadingTerm = max(max(headingTerms));
        if abs(maxHeadingTerm - minHeadingTerm) > 1e-5
            headingTermsNormalized = (headingTerms - minHeadingTerm)/(maxHeadingTerm - minHeadingTerm);
        else
            headingTermsNormalized = zeros(size(headingTerms));
        end
        minVelTerm = min(min(velTerms));
        maxVelTerm = max(max(velTerms));
        if abs(maxVelTerm - minVelTerm) > 1e-5
            velTermsNormalized = (velTerms - minVelTerm)/(maxVelTerm - minVelTerm);
        else
            velTermsNormalized = zeros(size(velTerms));
        end

        % TASK (Ex. 6.1): Compute the values of the cost function G(v,omega) from 
        % headingTermsNormalized = values of heading(v,omega)
        % distTermsNormalized = values of dist(v,omega)
        % velTermsNormalized = values of vel(v,omega)
        scores = TODO

        
        % Apply smoothing kernel
        scores = filter2(parameters.objectiveFcnSmoothingKernel, scores);

        % find the maximum score
        [maxVec, idxVec] = max(scores);
        [maxScore, idxOmegaBest] = max(maxVec);
        idxVelBest = idxVec(idxOmegaBest);

        % Get the best commands. These commands are send to the robot
        % platform.
        vSolution = velSamples(idxVelBest);
        omegaSolution = omegaSamples(idxOmegaBest);
        solutionFound = true;
    end
    
    % Attach debug output that let's us check for the correctness of the
    % algorithm's internals
    if nargout > 2
        debug.window = [minVel, maxVel, minOmega, maxOmega];
        debug.velSamples = velSamples;
        debug.omegaSamples = omegaSamples;
        debug.headingTerms = headingTerms;
        debug.distTerms = distTerms;
        debug.velTerms = velTerms;
        debug.scores = scores;
        debug.maxScore = NaN;
        debug.bestSampleIdx = [];
        if solutionFound
            debug.headingTermsNormalized = headingTermsNormalized;
            debug.distTermsNormalized = distTermsNormalized;
            debug.velTermsNormalized = velTermsNormalized;
            debug.maxScore = maxScore;
            debug.bestSampleIdx = [idxVelBest, idxOmegaBest];
        end
    end
    
    % Plot the cost function
    if parameters.plot
        if solutionFound
            figure;
            grid on; hold on;
            surf(velSamples, omegaSamples, scores');
            xlabel('velocity');
            ylabel('omega');
            zlabel('cost');
            title('Cost function');

            % Plot the minimum of the cost function
            plot3(velSamples(idxVelBest), omegaSamples(idxOmegaBest), maxScore, 'or', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

            hold off;
        else
            warning('DynamicWindow:NoSolution', 'Cannot plot cost function if all edges are in collision');
        end
    end
end

% Print elapsed time for profiling
elapsedTime = toc();
fprintf('DWA took %.2f ms\n', elapsedTime*1e3);

end


function [minVel, maxVel, minOmega, maxOmega] = computeDynamicWindow(robotState, parameters)
% COMPUTEDYNAMICWINDOW Computes the window around the current velocities
% that are within the dynamic capabilities of the robot. These are the
% velocities that are reachable within the next time interval given the
% robot's maximum translational and rotational acceleration. We consider
% the robot to have equal maximum acceleration and deceleration
% capabilities, so the constants parameters.maxAcc and
% parameters.maxOmegaDot can be used for the maximum deceleration as well.

    %TASK (Ex. 6.1): Compute the dynamic window. Hint: pay attention to the
    %absolute maximum and minimum velocities of the robot!
    maxVel = TODO
    minVel = TODO
    maxOmega = TODO
    minOmega = TODO

end

function trajectory = computeTrajectory(robotState, vel, omega, dt, nSteps)
%COMPUTETRAJECTORY Computes a single trajectory with nSteps steps belonging to the input velocity
%and omega sample. The time resolution of the trajectory is dt.

%     trajectory = zeros(nSteps,6);
    
    % We will compute circular arcs for nSteps steps with a time resolution
    % of dt
%     arcLength = 0;
    angle = omega*dt;
    if omega ~= 0
        radius = vel/omega;            
        deltaX = radius*sin(angle);
        deltaY = radius*(1-cos(angle));
        ds = abs(angle*radius);
    else
        deltaX = vel*dt;
        deltaY = 0;
        ds = deltaX;
    end
    
    heading = robotState.heading + linspace(angle, nSteps*angle, nSteps);
    coshead = cos(heading);
    sinhead = sin(heading);
    deltaXGlobal = coshead*deltaX - sinhead*deltaY;
    deltaYGlobal = sinhead*deltaX + coshead*deltaY;
    
    s = linspace(ds, nSteps*ds, nSteps);
    
    x = robotState.x + cumsum(deltaXGlobal);
    y = robotState.y + cumsum(deltaYGlobal);
    v = vel*ones(1, nSteps);
    w = omega*ones(1, nSteps); 
    
    trajectory = [x', y', heading', v', w', s'];

end

function [headingTerm, distTerm, velTerm] = scoreTrajectory(trajectory, nStepsBrake, goalPosition, maps, distToGoal, goalBrakingDistance, parameters)
% SCORETRAJECTORY Computes a cost for a given trajectory
% Invalid trajectories will get a NaN value assigned.

    % only admissible trajectories will receive values other than NaN. This
    % way, we can sort out the non-admissible ones.
    headingTerm = NaN;
    distTerm = NaN;
    velTerm = NaN;
 
    % Check for collision. If in collision, we do not have to
    % compute the other cost terms. If the trajectory collides within the
    % braking distance, the trajectory is considered to be not admissible
    [closestDistanceToObstacleOnCurvature, stepsBeforeCollision] = computeDistanceToClosestObstacleOnCurvature(trajectory, maps.localObstacleDistanceMap, parameters.robotRadius);
    if (stepsBeforeCollision >= nStepsBrake)

        % Obstacle distance term
        distTerm = closestDistanceToObstacleOnCurvature;

        % Compute velocity term (final speed)
        % we want to stop at the goal, so we let the value of the optimal
        % velocity decrease linearly within a certain radius around the
        % goal
        if distToGoal > goalBrakingDistance
            velOptimal = parameters.maxVel;
        else
            velOptimal = parameters.maxVel/goalBrakingDistance * distToGoal;
        end
        velTerm = -abs(velOptimal - trajectory(end,4));

        % heading or global planner term
        % Compute heading term. In the original paper, the heading
        % offset is computed at the position where the robot will be when
        % "exerting maximal deceleration after the next interval."
        % We denote this pose by robotStopPose, and compute it assuming
        % that the robot continues on the same arc while braking:
        robotStopPose.x = trajectory(nStepsBrake,1);
        robotStopPose.y = trajectory(nStepsBrake,2);
        robotStopPose.heading = trajectory(nStepsBrake,3);
          
        if ~parameters.globalPlanningOn
            
            % TASK (Ex. 6.1): Compute the value of the function heading(v,omega).
            % Hint: use angleDiff(angle1, angle2) instead of angle1-angle2
            headingTerm = TODO
            
        else
            % Compute the difference between the cost gradient orientation and 
            % the robot orientation at the end of the braking trajectory.
            finalTrajectoryIdx = round(([robotStopPose.x, robotStopPose.y]-maps.globalGradientMap.origin)./maps.globalGradientMap.resolution);
            if ~(any(finalTrajectoryIdx > maps.globalGradientMap.size) || any(finalTrajectoryIdx < 1))
                
                gradientDirection = maps.globalGradientMap.data(finalTrajectoryIdx(1), finalTrajectoryIdx(2));
                if isnan(gradientDirection) % that's the case at the goal cell, which is the only extremum in the cost function
                    headingTerm = inf;
                else       
                    % TASK (Ex. 6.3): Compute the heading term for the case where
                    % we incorporate the global navigation function.
                    % headingTerm = TODO
                    
                end
            end
        end
    end

end

function [distanceAlongArc, stepsBeforeCollision] = computeDistanceToClosestObstacleOnCurvature(trajectory, distanceMap, robotRadius)
% COMPUTEDISTANCETOCLOSESTOBSTACLEONCURVATURE Trajectories are circular
% arcs. This function computes the distance from the current robot position to the closest obstacle along
% that circular arc.

    distanceAlongArc = 1e3;
    stepsBeforeCollision = 1e3;
    
    idx = round(((trajectory(:,1:2)-repmat(distanceMap.origin, size(trajectory, 1), 1)))./distanceMap.resolution);
    
    % Find the first position that goes out of the map
    outOfMap = any(idx > repmat(distanceMap.size, size(trajectory, 1), 1), 2) | any(idx < 1, 2);
    firstOutOfMap = find(outOfMap == 1);
    if ~isempty(firstOutOfMap)
        distanceAlongArc = trajectory(firstOutOfMap(1),6);
        return;
    end

    % Find the first position that collides
    ind = sub2ind(distanceMap.size, idx(:,1), idx(:,2));
    distances = distanceMap.data(ind);
    idxInCollision = find(distances <= robotRadius, 1);
    if ~isempty(idxInCollision)
        distanceAlongArc = trajectory(idxInCollision(1),6);
        stepsBeforeCollision = idxInCollision(1)-1;
        return;
    end
  
end


function checkInputs(robotState, goalPosition, parameters)
% CHECKINPUTS Checks the inputs to the dynamicWindowApproach() function for
% validity

    if ~isfield(parameters, 'globalPlanningOn'); error('parameters needs field globalPlanningOn'); end
    if ~isfield(parameters, 'simTime'); error('parameters needs field simTime'); end
    if ~isfield(parameters, 'timestep'); error('parameters needs field timestep'); end
    if ~isfield(parameters, 'nVelSamples'); error('parameters needs field nVelSamples'); end
    if ~isfield(parameters, 'nOmegaSamples'); error('parameters needs field nOmegaSamples'); end
    if ~isfield(parameters, 'headingScoring'); error('parameters needs field headingScoring'); end
    if ~isfield(parameters, 'velocityScoring'); error('parameters needs field velocityScoring'); end
    if ~isfield(parameters, 'obstacleDistanceScoring'); error('parameters needs field obstacleDistanceScoring'); end
    if ~isfield(parameters, 'maxVel'); error('parameters needs field maxVel'); end
    if ~isfield(parameters, 'maxOmega'); error('parameters needs field maxOmega'); end
    if ~isfield(parameters, 'maxAcc'); error('parameters needs field maxAcc'); end
    if ~isfield(parameters, 'maxOmegaDot'); error('parameters needs field maxOmegaDot'); end
    if ~isfield(parameters, 'robotRadius'); error('parameters needs field robotRadius'); end
    if ~isfield(parameters, 'goalBrakingDistance'); error('parameters needs field goalBrakingDistance'); end

    if ~isfield(robotState, 'x'); error('robot state needs field x'); end
    if ~isfield(robotState, 'y'); error('robot state needs field y'); end
    if ~isfield(robotState, 'heading'); error('robot state needs field heading'); end
    if ~isfield(robotState, 'vel'); error('robot state needs field vel'); end
    if ~isfield(robotState, 'omega'); error('robot state needs field omega'); end

    if ~isfield(goalPosition, 'x'); error('robot state needs field x'); end
    if ~isfield(goalPosition, 'y'); error('robot state needs field y'); end

    if ~isfield(parameters, 'plot')
        parameters.plot = false;
    end
    
    if (parameters.maxAcc == 0); error('Invalid maximum translational acceleration'); end
    if (parameters.maxOmegaDot == 0); error('Invalid maximum rotational acceleration'); end
end

function rval = angleDiff(angle2, angle1)
% ANGLEDIFF Computes the difference between two angles.
% The input angles have to be given in rad. The output is in the range [-pi, pi]
    angle1 = mod(angle1, 2*pi);
    angle2 = mod(angle2, 2*pi);
    rval = mod((angle2-angle1)+pi, 2*pi) -pi;
end
