%% Test Script

% Tests the implemented (local) Dynamic Window Approach with a simple simulation.

more off;
startup;

%% Define parameters
parameters.simTime = 5.0;
parameters.timestep = 0.1; 
parameters.nVelSamples = 11;        % should be uneven
parameters.nOmegaSamples = 11;      % should be uneven
parameters.robotRadius = 0.1;
parameters.headingScoring = 0.3;
parameters.velocityScoring = 0.45;
parameters.obstacleDistanceScoring = 0.25;
parameters.objectiveFcnSmoothingKernel = fspecial('gaussian', [3,3], 1.0);
parameters.maxVel = 0.2;
parameters.maxOmega = pi;
parameters.maxAcc = 1.0;
parameters.maxOmegaDot = pi;
parameters.plot = false;
parameters.connectivity = 8;
parameters.goalBrakingDistance = 0.5;

% use the local DWA approach
parameters.globalPlanningOn = false;

% Define the goal position
goalPosition.x = 3.0;
goalPosition.y = 3.5;

%% Load a map
fileDir = fileparts(mfilename('fullpath'));
[ img ] = loadMapFromImage( [fileDir, '/../maps/simple_100x100.png'] );
map = createMap([-1.0, -0.5], 0.05, img);

%% Define start pose of the robot

% The Local DWA should be able to reach the goal starting at this pose
robotState.x = 1.5;
robotState.y = 1.5;
robotState.heading = 0.0;
robotState.vel = 0.0;
robotState.omega = 0.0;

% Use this starting point instead (comment in) to see how the robot gets stuck
% robotState.x = 0.5;
% robotState.y = 2.0;
% robotState.heading = 0.0;
% robotState.vel = 0.0;
% robotState.omega = 0.0;

%% plot the map
figure;
plotMap(map);
hold on;
plot(goalPosition.y, goalPosition.x, 'or', 'MarkerFaceColor', 'r');

%% Call the dynamic window approach (DWA) function
goalDist = hypot(robotState.y - goalPosition.y, robotState.x - goalPosition.x);
nSpeedZeroCnt = 0; % Let's count the number of successive zero robot speeds to detect whether we are stuck and then abort the simulation
robotIsStuck = 0;
handles = [];

while ~robotIsStuck
    % compute the commands
    [ v, omega, debug ] = dynamicWindowApproach( robotState, goalPosition, map, parameters );
    % update the robot pose (we assume that it perfectly executes the
    % commands)
    robotState = updateRobotState(robotState, v, omega, parameters.timestep);
    
    % plot the robot position
    plot(robotState.y, robotState.x, 'og', 'MarkerFaceColor', 'g');
    % plot the trajectory set
    if debug.valid
        handles = plotTrajectories(debug, handles);
    end   
    drawnow;
    robotState
    
    goalDist = hypot(robotState.y - goalPosition.y, robotState.x - goalPosition.x);
    
    % Detect whether robot is stuck or has reached the goal
    if (robotState.vel < 1e-2)
        nSpeedZeroCnt = nSpeedZeroCnt + 1;
    else
        nSpeedZeroCnt = 0;
    end
    if nSpeedZeroCnt > 20
        robotIsStuck = 1;
    end
end
