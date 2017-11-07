function [leftVelRadPerSec rightVelRadPerSec] = bob_getWheelSpeeds(connection)

    global isoctave;
    if ~isoctave
        [ result,data ]=connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_velocities',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
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
        vel=connection.vrep.simxUnpackFloats(data);
    else
        [ result,data ]=simxGetStringSignal(connection.clientID,strcat('Bob_velocities',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        if(isempty(data))
            error('empty data returned');
        end
        vel=simxUnpackFloats(data);
    end
    
    leftVelRadPerSec=vel(1);
    rightVelRadPerSec=vel(2);

end