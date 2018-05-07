function simulation_stop(connection)
    global isoctave;
    if ~isoctave
        connection.vrep.simxStopSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);
    else
        simxStopSimulation(connection.clientID,connection.vrep.simx_opmode_oneshot_wait);
    end
end