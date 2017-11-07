function [z, R, segends] = extractLinesPolar(theta, rho, C_TR, params)
    if length(theta) == 0
        z = [];
        R = [];
        segends = [];
        return;
    end
    
    [x,y] = pol2cart(theta, rho);
    [alpha, r, segends, ans, idx] = extractLines([x;y], params);
    
    z = [alpha, r]';
    
    R = zeros(2, 2, size(alpha, 2));
    
    N = size(alpha, 1);
    if size(C_TR, 1) > 0
        R = zeros(2, 2, size(alpha, 2));
    
        N = size(alpha, 1);
        for i = 1:size(alpha, 1)
            range =idx(i, 1):idx(i, 2);
            nPointsInSegment = size(range, 2);
            [ans, ans, R(:, :, i)] = fitLinePolar(theta(range), rho(range), [ C_TR(range, range),  zeros(nPointsInSegment);  zeros(nPointsInSegment),  C_TR(N + range, N + range)]);
        end
    end
end
