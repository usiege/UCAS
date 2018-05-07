%% V-REP Simulation Exercise 3: Line Extraction and EKF

% In order to run the simulation:
%   - Start V-Rep
%   - Load the scene matlab/common/vrep/mooc_exercise.ttt
%   - Hit the run button in V-REP
%   - Start this script

%% Parameters setup

% try

%% Initialize connection with V-Rep
startup;

connection = simulation_setup();
connection = simulation_openConnection(connection, 0);
simulation_start(connection);
[bodyDiameter wheelDiameter interWheelDist scannerPose] = bob_init(connection);
bob_setGhostVisible(connection, 1);

params.MIN_SEG_LENGTH = 0.01;
params.LINE_POINT_DIST_THRESHOLD = 0.005;
params.MIN_POINTS_PER_SEGMENT = 20;

img = bob_getMap(connection);
M = generateMap(img);
g = sqrt(1);
b = bob_getInterWheelDistance(connection);
d = bob_getWheelDiameter(connection);
P = diag([ 0.01; 0.01; 0.01]);

k = 0.9;
x = zeros(3,1);
[x(1), x(2), x(3)] = bob_getPose(connection);

simStep = 50e-3;    % simulation step duration in seconds
laserRate = .5;     % laser rate in Hz, no intermediate propagations with the motion model will be performed

laserRate = simStep;

simulation_setStepped(connection, true);

u = [0;0];
v = [0;0];


bob_setWheelSpeeds(connection, 0.9, 1.0);

for i = 1:300
    
    for l = 1:round(laserRate/simStep)
        simulation_triggerStep(connection);
    end
    
    [v(1), v(2)] = bob_getWheelSpeeds(connection);
    dt = 50e-3*round(laserRate/simStep);
    u = (v + abs(v).* (k * randn(size(u)))) * dt * d/2;
    
    % extract lines
    [laserX, laserY] = bob_getLaserData(connection);
    theta = atan2(laserY, laserX);
    rho = laserX./cos(theta);
    inRangeIdx = find(rho < 4.9);
    theta  = theta(inRangeIdx);
    rho  = rho(inRangeIdx);
    
    [x, P] = incrementalLocalization(x, P, u, [theta; rho], M, params, k, g, b);
    
    % plot pose estimate in vrep
    bob_setGhostPose(connection, x(1), x(2), x(3));
    
end
simulation_stop(connection);
simulation_closeConnection(connection);

% catch exception
%     simulation_closeConnection(connection);
%     rethrow(exception);
% end
