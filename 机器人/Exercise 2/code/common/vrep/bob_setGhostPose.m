function bob_setGhostPose(connection,x,y,gamma)
    global isoctave;
    if ~isoctave
        signalValue=connection.vrep.simxPackFloats([x,y,gamma]);
        connection.vrep.simxSetStringSignal(connection.clientID,strcat('Bob_reqGhostPose',num2str(connection.robotNb)),signalValue,connection.vrep.simx_opmode_oneshot);
    else
        signalValue=simxPackFloats([x,y,gamma]);
        simxSetStringSignal(connection.clientID,strcat('Bob_reqGhostPose',num2str(connection.robotNb)),signalValue,connection.vrep.simx_opmode_oneshot);
    end
end