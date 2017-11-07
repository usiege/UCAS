function simulation_triggerStep(connection)

    global isoctave;
    if ~isoctave
        connection.vrep.simxSynchronousTrigger(connection.clientID);
    else
        simxSynchronousTrigger(connection.clientID);
    end
end