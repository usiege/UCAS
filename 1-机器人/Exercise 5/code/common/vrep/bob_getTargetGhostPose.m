function [x y gamma] = bob_getTargetGhostPose(connection)
    global isoctave;
    if ~isoctave
        [result,data]=connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_targetGhostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                            'simxGetStringSignal failed');
            throw(err);
        end
        if(isempty(data))
            err = MException('VREP:RemoteApiError', ...
                'Empty data returned');
            throw(err);
        end
        pose=connection.vrep.simxUnpackFloats(data);
    else
        [result,data]=simxGetStringSignal(connection.clientID,strcat('Bob_targetGhostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(data))
            error('Empty data returned');
        end
        pose=simxUnpackFloats(data);
    end
	x=pose(1);
	y=pose(2);
	gamma=pose(3); % rad
end