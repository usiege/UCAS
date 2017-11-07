function [ map ] = loadMapFromImage( filename )
%LOADMAPFROMIMAGE Loads an image into a map data structure that can later
%be used for the dijkstra algorithm

if nargin < 1
    [file, path] = uigetfile({'*.png; *.bmp; *.jpg', 'Image Files (*.png,*.bmp,*.jpg)'}, ...
        'Select the image file');
    filename = [path, file];
end

map = im2double(imread(filename));

if (any(any(map~=1 & map~=0)))
    error('Only black-and-white images allowed. Use black color for obstacle regions');
end

map(map==0) = -1;
map(map==1) = 0;

end

