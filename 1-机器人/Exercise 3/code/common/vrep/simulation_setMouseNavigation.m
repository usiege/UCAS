function simulation_setMouseNavigation(connection,index)
% SIMULATION_SETMOUSENAVIGATION
% allows to set the mouse navigation mode: 0=camera pan, 1=object shift, 2=object rotate
	global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqNavigation',num2str(connection.robotNb)),index,connection.vrep.simx_opmode_oneshot);
    else
        simxSetIntegerSignal(connection.clientID,strcat('Bob_reqNavigation',num2str(connection.robotNb)),index,connection.vrep.simx_opmode_oneshot);
    end
end