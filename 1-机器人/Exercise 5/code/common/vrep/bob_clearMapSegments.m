function bob_clearMapSegments(connection)
    global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqClearMapSeg',num2str(connection.robotNb)),0,connection.vrep.simx_opmode_oneshot);
    else
       simxSetIntegerSignal(connection.clientID,strcat('Bob_reqClearMapSeg',num2str(connection.robotNb)),0,connection.vrep.simx_opmode_oneshot); 
    end
end