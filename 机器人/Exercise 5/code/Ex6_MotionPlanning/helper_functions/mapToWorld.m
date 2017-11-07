function point = mapToWorld(mapOrigin, mapResolution, cell)
	point = cell.*mapResolution + mapOrigin;
end