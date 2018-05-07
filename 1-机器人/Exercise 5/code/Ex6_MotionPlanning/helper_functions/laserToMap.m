function [ map ] = laserToMap( laserDataX, laserDataY, mapResolution, tf )
% LASERTOMAP Creates a local map from a V-Rep laser scan
% Creates a map with resolution mapResolution [m/cell]. The map will
% tightly fit the data.

nLaserPoints = numel(laserDataX);

if ~iscolumn(laserDataX)
    laserDataX = laserDataX';
end

if ~iscolumn(laserDataY)
    laserDataY = laserDataY';
end

% transform the laser points with the homogeneous transformation matrix
% passed in
laserData = tf*[laserDataX'; laserDataY'; ones(size(laserDataX'))];
laserDataX = (laserData(1,:)./laserData(3,:))';
laserDataY = (laserData(2,:)./laserData(3,:))';


minX = min(laserDataX) - mapResolution;
minY = min(laserDataY) - mapResolution;

mapOrigin = [minX, minY];

laserIdx = round(([laserDataX, laserDataY]-repmat(mapOrigin, nLaserPoints, 1))./mapResolution);

mapValues = zeros(max(laserIdx));
mapValues(laserIdx) = 1;

map = MapObject(size(mapValues), mapOrigin, mapResolution, mapValues);

end

