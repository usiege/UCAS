function [x_posteriori, P_posteriori] = filterStep(x, P, u, Z, R, M, k, g, b)
% [x_posteriori, P_posteriori] = filterStep(x, P, u, z, R, M, k, g, b)
% returns an a posteriori estimate of the state and its covariance

% additional bells and whistles in case no line was detected, please
% incorporate this at a sensical position in your code
if size(Z,2) == 0
    x_posteriori = x_priori;
    P_posteriori = P_priori;
    return;
end

