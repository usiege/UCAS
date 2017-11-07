function simulation_selectObject(connection,index)
% SIMULATION_SELECTOBJECT
% allows to select one specific object: -1= no object is selected, 0=Bob is selected, 1=ghost is selected, 2=target ghost is selected 

	global isoctave;
    if ~isoctave
        connection.vrep.simxSetIntegerSignal(connection.clientID,strcat('Bob_reqSelection',num2str(connection.robotNb)),index,connection.vrep.simx_opmode_oneshot);
    else
        simxSetIntegerSignal(connection.clientID,strcat('Bob_reqSelection',num2str(connection.robotNb)),index,connection.vrep.simx_opmode_oneshot);
    end
end