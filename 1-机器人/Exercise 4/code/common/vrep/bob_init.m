function [bodyDiameter wheelDiameter interWheelDist scannerPose] = bob_init(connection)

    global isoctave;
    
	% start some data streaming from V-REP to Matlab:
    if ~isoctave
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_encoders',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_velocities',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_pose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_ghostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_laserData',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_targetGhostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
       
        % get some robot constants:
        
        if nargout > 0
            [result,bodyDiameter]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_bodyDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                err = MException('VREP:RemoteApiError', ...
                                'simxGetFloatSignal failed');
                throw(err);
            end
        end
        
        if nargout > 1
            [result,wheelDiameter]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_wheelDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                err = MException('VREP:RemoteApiError', ...
                                'simxGetFloatSignal failed');
                throw(err);
            end
        end
        
        if nargout > 2
            [result,interWheelDist]=connection.vrep.simxGetFloatSignal(connection.clientID,strcat('Bob_interWheelDist',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                err = MException('VREP:RemoteApiError', ...
                                'simxGetFloatSignal failed');
                throw(err);
            end
        end
        
        if nargout > 3
            [result,data]=connection.vrep.simxGetStringSignal(connection.clientID,strcat('Bob_laserScannerPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                err = MException('VREP:RemoteApiError', ...
                                'simxGetFloatSignal failed');
                throw(err);
            end
            scannerPose=connection.vrep.simxUnpackFloats(data);
        end
    
    else
        simxGetStringSignal(connection.clientID,strcat('Bob_encoders',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        simxGetStringSignal(connection.clientID,strcat('Bob_velocities',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        simxGetStringSignal(connection.clientID,strcat('Bob_pose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        simxGetStringSignal(connection.clientID,strcat('Bob_ghostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        simxGetStringSignal(connection.clientID,strcat('Bob_laserData',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        simxGetStringSignal(connection.clientID,strcat('Bob_targetGhostPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_streaming);
        % get some robot constants:
        
        if nargout > 0
            [result,bodyDiameter]=simxGetFloatSignal(connection.clientID,strcat('Bob_bodyDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                error('simxGetFloatSignal failed');
            end
        end
        
        if nargout > 1
            [result,wheelDiameter]=simxGetFloatSignal(connection.clientID,strcat('Bob_wheelDiameter',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                error('simxGetFloatSignal failed');
            end
        end
        
        if nargout > 2
            [result,interWheelDist]=simxGetFloatSignal(connection.clientID,strcat('Bob_interWheelDist',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
               error('simxGetFloatSignal failed');
            end
        end
        
        if nargout > 3
            [result,data]=simxGetStringSignal(connection.clientID,strcat('Bob_laserScannerPose',num2str(connection.robotNb)),connection.vrep.simx_opmode_oneshot_wait);
            if (result~=connection.vrep.simx_error_noerror)
                error('simxGetFloatSignal failed');
            end
            scannerPose=simxUnpackFloats(data);
        end
    end
	
end