function hax = plotMap(map, hax, varargin)
    if  nargin > 2; axes(hax); end
    dispData = zeros(map.size(1), map.size(2), 3);
    for i = 1:map.size(1)
        for j = 1:map.size(2)
            if map.data(i,j) == 0
                dispData(i,j,:) = 1;
            else
                dispData(i,j,:) = 0;
            end
        end
    end
    image(linspace(map.origin(2), map.origin(2) + map.resolution*size(map.data,1),size(map.data,1)), ...
        linspace(map.origin(1), map.origin(1) + map.resolution*size(map.data,2),size(map.data,2)), ...
        dispData);
    hax = gca;
end