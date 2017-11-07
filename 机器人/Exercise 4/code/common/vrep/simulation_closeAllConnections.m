function [] = simulation_closeAllConnections(connection)

connection.clientID = -1; % placeholder for "all connections"
simulation_closeConnection(connection);  % make sure all connections are closed

end