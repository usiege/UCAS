function bob_setTargetGhostVisible(connection,visible)
	global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqTargetGhostVisibility',num2str(connection.robotNb)),visible,connection.vrep.simx_opmode_oneshot);
    else
        simxSetIntegerSignal(connection.clientID,strcat('Bob_reqTargetGhostVisibility',num2str(connection.robotNb)),visible,connection.vrep.simx_opmode_oneshot);
    end
end