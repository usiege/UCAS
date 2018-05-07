% Make sure to have the simulation scene mooc_exercise.ttt running in V-REP!

% simulation setup, will add the matlab paths
connection = simulation_setup();

% the robot we want to interact with
robotNb = 0;

% open the connection
connection = simulation_openConnection(connection, robotNb);

% start simulation if not already started
simulation_start(connection);

% initialize connection
[bodyDiameter wheelDiameter interWheelDist scannerPose] = bob_init(connection);
[bodyDiameter] = bob_getBodyDiameter(connection);
[wheelDiameter] = bob_getWheelDiameter(connection);
[interWheelDist] = bob_getInterWheelDistance(connection);
[scannerPose] = bob_getScannerPose(connection);

% set motor velocities in deg/sec (non-blocking function):
bob_setWheelSpeeds(connection,pi,pi/2);

% make ghost visible/invisible (non-blocking function)
bob_setGhostVisible(connection,true);

% set ghost pose (x,y,gamma), where positions are in meter, orientation in degrees (non-blocking function):
bob_setGhostPose(connection,0.5,0.5,pi/4);

% clear all map segments (non-blocking function):
bob_clearMapSegments(connection);

% Add one map segment (x0,y0,x1,y1) (non-blocking function):
bob_addMapSegment(connection,0.1,0.2,0.8,0.9);

% clear all path segments (non-blocking function):
bob_clearPathSegments(connection);

% Add one path segment (x0,y0,x1,y1) (non-blocking function):
bob_addPathSegment(connection,0.5,0.4,0.6,0.9);

% get motor velocities in deg/sec (non-blocking function):
[leftVel rightVel] = bob_getWheelSpeeds(connection);

% get motor encoders in deg (non-blocking function):
[leftEnc rightEnc] = bob_getEncoders(connection);

% get robot pose (x,y,gamma), where positions are in meter, orientation in degrees (non-blocking function):
[x y gamma] = bob_getPose(connection);

% get ghost pose (x,y,gamma), where positions are in meter, orientation in degrees (non-blocking function):
[x y gamma] = bob_getGhostPose(connection);

% get laser data (non-blocking function). X/Y coords. are in meters, and relative to the laser scanner reference frame.
[laserDataX laserDataY] = bob_getLaserData(connection);
scatter(laserDataX,laserDataY);

% Get the global map (BLOCKING function, can also be made non-blocking if needed):
img=bob_getMap(connection); % image has 512x512 values, corresponding to the 5x5 m^2 terrain
imshow(img);

% Set the goal position ghost visible
bob_setTargetGhostVisible(connection, 1);

% Get the target position
[x y gamma] = bob_getTargetGhostPose(connection);

% Enable mouse navigation
simulation_setMouseNavigation(connection,1);

% Enable mouse navigation
simulation_selectObject(connection,1);

% now enable stepped simulation mode:
simulation_setStepped(connection,true);

% and step 20 times:
for i=0:20
    simulation_triggerStep(connection);
    pause(0.1);
end

% now disable stepped simulation mode:
simulation_setStepped(connection,false);

% stop the simulation
simulation_stop(connection);

% close the connection
simulation_closeConnection(connection);