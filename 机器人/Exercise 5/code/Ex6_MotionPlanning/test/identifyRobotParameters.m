%% Initialization

if(exist('bob','class'))
    bob.delete();
end

%% Parameters setup

% Add paths
fileDir = fileparts(mfilename('fullpath')); % path to this m-file
paths = genpath([fileDir, '/..']); % add all paths for exercise 6
paths = [paths, ':', fileDir, '/../../helper_functions'];
if(strcmp(computer,'GLNXA64'))
    paths = [paths, ':', fileDir, '/../../v-rep_interface/linuxLibrary64Bit'];
elseif(strcmp(computer,'GLNX8632'))
    paths = [paths, ':', fileDir, '/../../v-rep_interface/linuxLibrary32Bit'];
elseif(strcmp(computer,'PCWIN32'))
    paths = [paths, ':', fileDir, '/../../v-rep_interface/windowsLibrary32Bit'];
else
    error('Not supported operation system detected');
end
addpath( paths );

%% Initialize connection with V-Rep

% check if connection already exists
if(~exist('bob','class'))
    bob = Bob;
end

%% Get static data from V-Rep

bodyDiameter = bob.getBodyDiameter();
parameters.robotRadius = bodyDiameter/2.0;

wheelDiameter = bob.getWheelDiameter();
wheelRadius = wheelDiameter/2.0;
interWheelDistance = bob.getInterWheelDist();

vDesired = 0.0;      % [m/s]
omegaDesired = pi/12; % [rad/s]

vBob = 0.0;
omegaBob = 0.0;
tStart = tic;
time = 0.0;
dv = inf;
dOmega = inf;

M = [wheelRadius/2,                 wheelRadius/2; ...
    wheelRadius/interWheelDistance, -wheelRadius/interWheelDistance];

% v/omega to wheel speeds
wheelSpeedsRadPerSecDesired = M  \ [vDesired; omegaDesired];

bob.setVelocity(wheelSpeedsRadPerSecDesired(1), wheelSpeedsRadPerSecDesired(2));

% measure the velocity response
while dv > 1e-2 && dOmega > 1e-2
    
    [wheelSpeedLeftRadPerSec, wheelSpeedRightRadPerSec] = bob.getVelocity(); % in deg/s
    
    % wheel speeds to v/omega
    wheelSpeedsRadPerSec = [wheelSpeedLeftRadPerSec; wheelSpeedRightRadPerSec];
    vOmega = M*wheelSpeedsRadPerSec;
    vBob = [vBob; vOmega(1)];
    omegaBob = [omegaBob; vOmega(2)];
    time = [time; toc(tStart)];
    
    dv = abs(vDesired - vBob(end));
    dOmega = abs(omegaDesired - omegaBob(end));
end

%% Plot the velocity response

figure;
plot(time, vBob);