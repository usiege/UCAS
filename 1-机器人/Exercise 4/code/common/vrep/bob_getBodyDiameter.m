function [bodyDiameter] = bob_getBodyDiameter(connection)
    global isoctave;
    if ~isoctave
        [result,bodyDiameter]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_bodyDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                            'simxGetStringSignal failed');
            throw(err);
        end
        if(isempty(bodyDiameter))
            err = MException('VREP:RemoteApiError', ...
                'Empty data returned');
            throw(err);
        end
    else
        [result,bodyDiameter]=simxGetFloatSignal(connection.clientID,strcat('Bob_bodyDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(bodyDiameter))
            error('Empty data returned');
        end
    end
end