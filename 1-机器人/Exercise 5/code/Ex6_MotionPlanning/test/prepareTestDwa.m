%% Preparation for testing the Dynamic Window Approach

function [robotStateArray, goalPosition, map, parameters, maxDelta] = prepareTestDwa()
    %% Problem setup

    % Define parameters
    parameters.simTime = 5.0;
    parameters.timestep = 0.1; 
    parameters.nVelSamples = 11;        % should be uneven
    parameters.nOmegaSamples = 11;      % should be uneven
    parameters.robotRadius = 0.1;
    parameters.headingScoring = 0.3;
    parameters.velocityScoring = 0.45;
    parameters.obstacleDistanceScoring = 0.25;
    parameters.objectiveFcnSmoothingKernel = fspecial('gaussian', [3,3], 1.0);
    parameters.maxVel = 0.5;
    parameters.maxOmega = 5;
    parameters.maxAcc = 1.0;
    parameters.maxOmegaDot = 5.0;
    parameters.plot = false;
    parameters.connectivity = 8;
    parameters.goalBrakingDistance = 0.5;

    % Define the goal position
    goalPosition.x = 3.0;
    goalPosition.y = 3.5;

    %% Load a map
    fileDir = fileparts(mfilename('fullpath'));
    [ img ] = loadMapFromImage( [fileDir, '/../maps/simple_100x100.png'] );
    map = createMap([-1.0, -0.5], 0.05, img);


    %% Define a robot state array
    nRobotPoses = 20;
    robotStateArray = cell(nRobotPoses,1);
    for i = 1:nRobotPoses
        robotStateArray{i,1}.x = i*map.resolution*nRobotPoses/map.size(1) - map.origin(1);
        robotStateArray{i,1}.y = i*map.resolution*nRobotPoses/map.size(1) - map.origin(2);
        robotStateArray{i,1}.heading = i*pi/nRobotPoses;
        robotStateArray{i,1}.vel = i*parameters.maxVel/nRobotPoses;
        robotStateArray{i,1}.omega = i*parameters.maxOmega/nRobotPoses;
    end
    
    % define accuracy for checks
    maxDelta = 1e-4;
end