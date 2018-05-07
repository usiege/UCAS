function simulation_setStepped(connection,steppedSimulation)
    global isoctave;
    if ~isoctave
        connection.vrep.simxSynchronous(connection.clientID,steppedSimulation);
    else
        simxSynchronous(connection.clientID,steppedSimulation);
    end
end