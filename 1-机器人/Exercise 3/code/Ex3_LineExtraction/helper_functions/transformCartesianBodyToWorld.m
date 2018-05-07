function XYWorld = transformCartesianBodyToWorld(xState, XY)
    assert(isequal(size(xState), [3, 1]) , 'xState must have format (3, 1)');
    assert(size(XY, 2) == 2 , 'XY must have format (nPoints, 2)');

    cs = cos(xState(3));
    sn = sin(xState(3));
    
    R=[ cs sn; -sn cs ];
    
    XYWorld = zeros(size(XY));
    
    for i = 1:size(XY,1)
        XYWorld(i, :) = XY(i, :) * R + xState(1:2, 1)';
    end
end
