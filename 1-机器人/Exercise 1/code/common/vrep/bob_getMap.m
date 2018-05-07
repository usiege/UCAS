function [img] = bob_getMap(connection)
    global isoctave;
    if ~isoctave
        if (connection.robotNb==0)
            [result,h]=connection.vrep.simxGetObjectHandle(connection.clientID,'Bob_mapSensor',connection.vrep.simx_opmode_oneshot_wait);
        else
            [result,h]=connection.vrep.simxGetObjectHandle(connection.clientID,strcat('Bob_mapSensor',num2str(connection.robotNb-1)),connection.vrep.simx_opmode_oneshot_wait);
        end
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                'simxGetObjectHandle failed');
            throw(err);
        end
        [result,resolution,img]=connection.vrep.simxGetVisionSensorImage2(connection.clientID,h,1,connection.vrep.simx_opmode_oneshot_wait);
        img=mat2gray(img);
        if (result~=connection.vrep.simx_error_noerror)
            err = MException('VREP:RemoteApiError', ...
                'simxGetVisionSensorImage2 failed');
            throw(err);
        end
    else
        if (connection.robotNb==0)
            [result,h]=simxGetObjectHandle(connection.clientID,'Bob_mapSensor',connection.vrep.simx_opmode_oneshot_wait);
        else
            [result,h]=simxGetObjectHandle(connection.clientID,strcat('Bob_mapSensor',num2str(connection.robotNb-1)),connection.vrep.simx_opmode_oneshot_wait);
        end
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetObjectHandle failed');
        end
        [result,img]=simxGetVisionSensorImage(connection.clientID,h,1,connection.vrep.simx_opmode_oneshot_wait);
		img=img/255;
        if (result~=connection.vrep.simx_error_noerror)
            error('simxGetVisionSensorImage2 failed');
        end
    end
end