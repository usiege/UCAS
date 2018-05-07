function [wheelDiameter] = bob_getWheelDiameter(connection)

    global isoctave;
    if ~isoctave
        [result,wheelDiameter]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_wheelDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                            'simxGetStringSignal failed');
            throw(err);
        end
        if(isempty(wheelDiameter))
            err = MException('VREP:RemoteApiError', ...
                'Empty data returned');
            throw(err);
        end
    else
        [result,wheelDiameter]=simxGetFloatSignal(connection.clientID,strcat('Bob_wheelDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(wheelDiameter))
            error('Empty data returned');
        end
    end
end