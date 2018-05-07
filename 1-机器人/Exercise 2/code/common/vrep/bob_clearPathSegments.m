function bob_clearPathSegments(connection)
    global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqClearPathSeg',num2str(connection.robotNb)),0,connection.vrep.simx_opmode_oneshot);
    else
        simxSetIntegerSignal(connection.clientID,strcat('Bob_reqClearPathSeg',num2str(connection.robotNb)),0,connection.vrep.simx_opmode_oneshot);
    end
end