function [ map ] = createMap( origin, resolution, data )
%CREATEMAP Creates a map struct with origin given in cartesian coordinates
%and resolution in meter/cell.

map.origin = origin;          % position of the upper left corner in [m]
map.resolution = resolution;  % size of one cell in [m]
map.size = size(data);        % size in cells of the map
map.data = data;              % the actual data

end

