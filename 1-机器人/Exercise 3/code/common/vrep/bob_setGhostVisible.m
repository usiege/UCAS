function bob_setGhostVisible(connection,visible)
	global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqGhostVisibility',num2str(connection.robotNb)),visible,connection.vrep.simx_opmode_oneshot);
    else
        simxSetIntegerSignal(connection.clientID,strcat('Bob_reqGhostVisibility',num2str(connection.robotNb)),visible,connection.vrep.simx_opmode_oneshot);
    end
end