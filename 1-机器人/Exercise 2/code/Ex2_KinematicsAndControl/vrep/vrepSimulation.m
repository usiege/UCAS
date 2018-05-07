%% V-REP Simulation Exercise 3: Kinematic Control
% Tests the implemented control algorithm within a V-Rep simulation.

% In order to run the simulation:
%   - Start V-Rep
%   - Load the scene matlab/common/vrep/mooc_exercise.ttt
%   - Hit the run button
%   - Start this script

%% Parameters setup
 
%% Define parameters for Dijkstra and Dynamic Window Approach
parameters.dist_threshold= 0.25; % threshold distance to goal
parameters.angle_threshold = 0.1; % threshold orientation to goal

%% Initialize connection with V-Rep
startup;
connection = simulation_setup();
connection = simulation_openConnection(connection, 0);
simulation_start(connection);

%% Get static data from V-Rep
bob_init(connection);

parameters.wheelDiameter = bob_getWheelDiameter(connection);
parameters.wheelRadius = parameters.wheelDiameter/2.0;
parameters.interWheelDistance = bob_getInterWheelDistance(connection);
parameters.scannerPoseWrtBob = bob_getScannerPose(connection);

% controller parameters
parameters.Krho = 0.5;
parameters.Kalpha = 1.5;
parameters.Kbeta = -0.6;
parameters.backwardAllowed = true;
parameters.useConstantSpeed = true;
parameters.constantSpeed = 0.4;

bob_setTargetGhostPose(connection, -1, 0, 0);
bob_setTargetGhostVisible(connection, 1);


%% CONTROL LOOP.
EndCond = 0;

while (~EndCond)
    %% CONTROL STEP.
    % Get pose and goalPose from vrep
    [x, y, theta] = bob_getPose(connection);
    [xg, yg, thetag] = bob_getTargetGhostPose(connection);
    
    % run control step
    [ vu, omega ] = calculateControlOutput([x, y, theta], [xg, yg, thetag], parameters);

    % Calculate wheel speeds
    [LeftWheelVelocity, RightWheelVelocity ] = calculateWheelSpeeds(vu, omega, parameters);

    % End condition
    dtheta = abs(normalizeAngle(theta-thetag));

    rho = sqrt((xg-x)^2+(yg-y)^2);  % pythagoras theorem, sqrt(dx^2 + dy^2)
    EndCond = (rho < parameters.dist_threshold && dtheta < parameters.angle_threshold) || rho > 5;    
    
    % SET ROBOT WHEEL SPEEDS.
    bob_setWheelSpeeds(connection, LeftWheelVelocity, RightWheelVelocity);
end

%% Bring Bob to standstill
bob_setWheelSpeeds(connection, 0.0, 0.0);

simulation_stop(connection);
simulation_closeConnection(connection);

% msgbox('Simulation ended');
