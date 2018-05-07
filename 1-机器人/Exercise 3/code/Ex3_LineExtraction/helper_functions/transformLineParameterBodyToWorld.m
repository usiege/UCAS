function zWorld = transformLineParameterBodyToWorld(xState, z)
    assert(isequal(size(xState), [3, 1]) , 'xState must have format (3, 1)');
    assert(size(z, 1) == 2 , 'z must have format (2, nLines)');

    zWorld = zeros(size(z));
    for i = 1:size(z,2)
        m = z(:, i);
        theta = m(1) + xState(3);
        zWorld(:,i) = [...
            theta
            m(2) + (xState(1)*cos(theta) + xState(2)*sin(theta))
        ];
        [zWorld(1, i), zWorld(2, i), ans] = normalizeLineParameters(zWorld(1, i), zWorld(2, i));
    end
end
