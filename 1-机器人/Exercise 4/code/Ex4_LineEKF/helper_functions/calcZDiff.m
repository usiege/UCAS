function d = calcZDiff(z1, z2) 
    assert(isequal(size(z1), size(z2)), 'z1 and z2 must have same format');
    assert(size(z1, 1) == 2, 'z1 and z2 must have (2, nLines)-format');
    
    dz = z1 - z2;
    dz(1, :) =  abs(mod(dz(1, :), 2 * pi));
    gtPi = find(dz(1, :) > pi);
    
    dz(1, gtPi) = 2 * pi - dz(1, gtPi);
    d = sqrt(sum(dz.*dz, 1));
end
