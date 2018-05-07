function simulation_start(connection)
    global isoctave;
    if (isoctave)
        simxStartSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);

        % make sure the scripts on the V-REP side had the time to execute at least once
        % (e.g. to set the signals). So we simply send 3 dummy requests (effectively waiting a bit here):
        simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
        simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
        simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
    else
        connection.vrep.simxStartSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);

        % make sure the scripts on the V-REP side had the time to execute at least once
        % (e.g. to set the signals). So we simply send 3 dummy requests (effectively waiting a bit here):
        connection.vrep.simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
        connection.vrep.simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
        connection.vrep.simxGetFloatSignal(connection.clientID,'',connection.vrep.simx_opmode_oneshot_wait);
    end
end