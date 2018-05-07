function [connection] = simulation_openConnection(connection, robotNb)
%SIMULATION_OPENCONNECTION Opens a remote connection to V-REP. Note that
%the V-REP simulation has to be running at this point.

	global isoctave;
    if (isempty(isoctave))
        err = MException('VREP:RemoteApiError', ...
                        'You have to call simulation_setup() first');
        throw(err);
    end

    connection.robotNb = robotNb;
    
     % to properly close the last opened connection if it wasn't closed:
    global lastConnectionId;
    if ~isempty(lastConnectionId)
        if (isoctave)
            simxFinish(lastConnectionId);
        else
            connection.vrep.simxFinish(lastConnectionId);
        end
    end

    % 19997 is the port specified in remoteApiConnections.txt in the V-Rep
    % folder.
    % Additionally V-Rep opens port 19999 on simulation start in the bob
    % script. You could also use that port here, but then simulation has to
    % be started manually before connecting through MATLAB.
    if (isoctave)
        connection.clientID=simxStart('127.0.0.1',19997,true,true,5000,5);
    else
        connection.clientID=connection.vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
    end

    if (connection.clientID<=-1)
        err = MException('VREP:RemoteApiError', ...
                        'Could not open connection');
        throw(err);
    end
    lastConnectionId = connection.clientID;
end