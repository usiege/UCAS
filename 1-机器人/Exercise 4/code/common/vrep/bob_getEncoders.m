function [leftEnc rightEnc] = bob_getEncoders(connection)
    global isoctave;
    if ~isoctave
        [ result,data]=connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_encoders',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
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
        enc=connection.vrep.simxUnpackFloats(data);
    else
        [ result,data]=simxGetStringSignal(connection.clientID,strcat('Bob_encoders',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(data))
            error('Empty data returned');
        end
        enc=simxUnpackFloats(data);
    end
    
	leftEnc=enc(1);  %rad
	rightEnc=enc(2); %rad
end