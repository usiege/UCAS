function [interWheelDist] = bob_getInterWheelDistance(connection)

    global isoctave;
    
    if ~isoctave
        [result,interWheelDist]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_interWheelDist',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                            'simxGetStringSignal failed');
            throw(err);
        end
        if(isempty(interWheelDist))
            err = MException('VREP:RemoteApiError', ...
                'Empty data returned');
            throw(err);
        end
    else
        [result,interWheelDist]=simxGetFloatSignal(connection.clientID,strcat('Bob_interWheelDist',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(interWheelDist))
            error('simxGetStringSignal failed');
        end
    end
end