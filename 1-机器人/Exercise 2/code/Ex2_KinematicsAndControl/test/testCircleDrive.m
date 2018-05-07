%% Test Script

% Tests the implemented (local) dynamic window approach 
% by passing predefined inputs and checking the outputs for correctness.

more off;
close all

%% Test parameters
vu = 1.0;
omega = 2.0;
parameters.wheelRadius = 0.25/2.0;
parameters.interWheelDistance = 0.25;

%% Run test
T = 0.001;                   % Timestep
N = 10000;                   % Number of timesteps
X = zeros(3,N);             % Robot State
X(:,1) = [0.5; 0.0; pi/2];  % Initial State
correctRadius = true;       % Checks whether the obtained radius is 0.5m
for i=2:N
    % Call the wheel speed calculation function
    [LeftWheelVelocity, RightWheelVelocity ] = calculateWheelSpeeds(vu, omega, parameters);

    % Calculate speed and simulate robot (Euler-forward)
    M = [parameters.wheelRadius/2 parameters.wheelRadius/2; parameters.wheelRadius/(parameters.interWheelDistance) -parameters.wheelRadius/(parameters.interWheelDistance)];
    v = M*[RightWheelVelocity;LeftWheelVelocity];
    dx = [cos(X(3,i-1)) 0; sin(X(3,i-1)) 0; 0 1]*v;
    X(:,i) = X(:,i-1)+T*dx;
    
    % Check the obtained radius
    if(abs(v(1)/v(2)-0.5) > 0.02)
        correctRadius = false;
    end
end

% Reference Trajectory
a = [0:0.01:2*pi];
Xref = [0.5*cos(a); 0.5*sin(a)];

% Ploting
figure(1)
plot(X(1,:),X(2,:),'b'), hold on
plot(Xref(1,:),Xref(2,:),'r--')
axis equal
xlabel('x[m]')
ylabel('y[m]')
title('Trajectory of robot')
legend('Simulated trajectory', 'Reference trajectory')

assert (all(all(correctRadius)), ...
    'Circle Drive Test: the obtained radius was not 0.5m everywhere!');

% If the script reaches this point, everything was successfull (asserts did
% not trigger)
disp('Congratulations! All checks successful, your implementation is most likely correct!');
