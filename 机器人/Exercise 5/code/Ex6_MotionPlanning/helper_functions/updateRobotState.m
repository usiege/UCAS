function newState = updateRobotState(oldState, vel, omega, timestep)
    angle = omega*timestep;
    if omega ~= 0
        radius = vel/omega;            
        deltaX = radius*sin(angle);
        deltaY = radius*(1-cos(angle));
    else
        deltaX = vel*timestep;
        deltaY = 0;
    end
    deltaXGlobal = cos(oldState.heading)*deltaX - sin(oldState.heading)*deltaY;
    deltaYGlobal = sin(oldState.heading)*deltaX + cos(oldState.heading)*deltaY;
    newState.x = oldState.x + deltaXGlobal;
    newState.y = oldState.y + deltaYGlobal;
    newState.heading = oldState.heading + angle;
    newState.vel = vel;
    newState.omega = omega;
end