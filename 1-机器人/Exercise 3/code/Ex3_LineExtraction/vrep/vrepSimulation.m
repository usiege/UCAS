%% V-REP Simulation Exercise 3: Line Extraction and EKF

% In order to run the simulation:
%   - Start V-Rep
%   - Load the scene matlab/common/vrep/mooc_exercise.ttt
%   - Start this script

% Add paths
startup;

% Initialize connection with V-Rep
connection = simulation_setup();

try

simulation_closeAllConnections(connection);  % make sure all connections are closed
connection = simulation_openConnection(connection, 0);
simulation_start(connection);
[bodyDiameter ans ans ans] = bob_init(connection);
bob_setGhostVisible(connection, 1);

params.MIN_SEG_LENGTH = 0.01;
params.LINE_POINT_DIST_THRESHOLD = 0.005;
params.MIN_POINTS_PER_SEGMENT = 20;

mapImg = bob_getMap(connection);
M = generateMap(mapImg);
g = sqrt(10);
b = bob_getInterWheelDistance(connection);
d = bob_getWheelDiameter(connection);
P = diag([ 0.1; 0.1; 0.01]);
k = 3e-2;
x = zeros(3,1);

simStep = 50e-3;    % simulation step duration in seconds
laserRate = .5;     % laser rate in Hz, no intermediate propagations with the motion model will be performed


simulation_setStepped(connection, true);

u = [0;0];
v = [0;0];
bob_setWheelSpeeds(connection, 0.25, 0.5);

for i = 1:30
    for l = 1:round(laserRate/simStep)
        simulation_triggerStep(connection);
    end
    [x(1), x(2), x(3)] = bob_getPose(connection);
    
    % extract lines
    [laserX, laserY] = bob_getLaserData(connection);
    theta = atan2(laserY, laserX);
    rho = sqrt(sum([laserX .* laserX ; laserY .* laserY], 1));
    inRangeIdx = find(rho < 4.9);
    
    theta  = theta(inRangeIdx);
    rho  = rho(inRangeIdx);
    laserX = laserX(inRangeIdx);
    laserY = laserY(inRangeIdx);
    
    [z, R, segends] = extractLinesPolar(theta, rho, [], params);
    
    % transform body to world coordinates / parameters
    segendsW = zeros(size(segends));
    segendsW(:, 1:2) = transformCartesianBodyToWorld(x, segends(:, 1:2));
    segendsW(:, 3:4) = transformCartesianBodyToWorld(x, segends(:, 3:4));
    XYPW = transformCartesianBodyToWorld(x, [laserX' laserY']);
    zLW = transformLineParameterBodyToWorld(x, [z(1, :); z(2, :)]);
    
    clf;
    
    axis manual;
    imagesc([ -2.5, 2.5], [2.5 -2.5], mapImg);
    set(gca, 'YDir', 'normal');
    colormap([ 1 1 1; 0.8 0.8 0.8 ]);
    axis([-2.75, 2.75, -2.75, 2.75]);
    hold on;
    plotLinesAndMeasurements(XYPW(:,1), XYPW(:,2), zLW, segendsW, [], true);
    hold on, plot(x(1), x(2), 'r+', 'linewidth', 10);
    drawnow;
    
    % wait
    %'press any key', pause
end
simulation_stop(connection);
simulation_closeConnection(connection);

catch exception
    simulation_closeConnection(connection);
    rethrow(exception);
end
