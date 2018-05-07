function M = generateMap(mapImage)

scaling = 5.0/512;
Rt = [ 1   0   -2.5
       0   -1   2.5
       0   0   1];

threshold = 0.01;
minSupport = 20;

mapImage = edge(mapImage,'sobel');
%imshow(mapImage)
[y, x] = find(mapImage ~= 0);
p = Rt * [scaling * [x'; y']; ones(size(x'))] ;
p = p(1:2,:);

M = [];

while 1
    indicesMax = [];
    nMax = [0;0]; dMax = 0;
    for i = 1:100
        indices = randperm(size(p,2));
        [n, d] = getLine(p(:,indices(1:2)));
        t = n'*p - d;
        indices = find(abs(t) < threshold);
        
        if length(indices) > length(indicesMax)
            indicesMax = indices;
            nMax = n;
            dMax = d;
        end
    end
    
    if length(indicesMax) > minSupport
        angle = atan2(nMax(2), nMax(1));
        if angle > pi
            angle = angle - 2 * pi;
        elseif angle < -pi
            angle = angle + 2 * pi;
        end
        
        M = [M, [angle; dMax]];
    else
        break;
    end
    
    p(:, indicesMax) = [];
end

    function [n, d] = getLine(p)
        n = p(:,1) - p(:,2);
        n = n([2 1])/norm(n);
        d = n'*p(:,1);
        if d < 0
            n = -n;
            d = -d;
        end
    end
end