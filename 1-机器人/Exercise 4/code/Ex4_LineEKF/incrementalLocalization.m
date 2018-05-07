function [x_posterori, P_posterori] = incrementalLocalization(x, P, u, S, M, params, k, g, b)
% [x_posterori, P_posterori] = incrementalLocalization(x, P, u, S, R, M,
% k, b, g) returns the a posterori estimate of the state and its covariance,
% given the previous state estimate, control inputs, laser measurements and
% the map

C_TR = diag([repmat(0.1^2, 1, size(S, 2)) repmat(0.1^2, 1, size(S, 2))]);


