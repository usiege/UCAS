function index = worldToMap(mapOrigin, mapResolution, point)
    index = round((point-repmat(mapOrigin, size(point,1), 1))./mapResolution);
end