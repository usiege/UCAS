function [laserDataX laserDataY] = bob_getLaserData(connection)
    global isoctave;
    if ~isoctave
        [result,data]=connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_laserData',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                            'simxGetStringSignal failed');
            throw(err);
        end
        laserData=connection.vrep.simxUnpackFloats(data);
    else
        [result,data]=simxGetStringSignal(connection.clientID,strcat('Bob_laserData',num2str(connection.robotNb)),connection.vrep.simx_opmode_buffer);
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetStringSignal failed');
        end
        laserData=simxUnpackFloats(data);
    end
	laserDataX=laserData(1:2:end-1);
    laserDataY=laserData(2:2:end);
end