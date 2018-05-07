function simulation_pause(connection)
    global isoctave;
    if ~isoctave;
        connection.vrep.simxPauseSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);
    else
        simxPauseSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);
    end
end