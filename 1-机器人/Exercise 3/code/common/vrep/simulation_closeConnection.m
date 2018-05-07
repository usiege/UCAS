function [] = simulation_closeConnection(connection)
    global isoctave;
    if ~isoctave
        connection.vrep.simxFinish(connection.clientID);
    else
        simxFinish(connection.clientID);
    end
end