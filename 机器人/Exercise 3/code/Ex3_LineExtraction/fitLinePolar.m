function [alpha, r, C_AR] = fitLinePolar(theta, rho, C_TR)
% This function calculates a line (alpha, r) fitted to the points given by (theta, rho) according to the book pp. 243
% If C_TR is given it also calculates the uncertainty of (alpha, r). (see p. 248 and p. 114)

    N = size(theta, 2);
    
    if (size(theta, 1) ~= 1) || (size(rho, 1) ~= 1)
        error('fitLinePolar only accepts column vectors');
    end
    if (size(rho, 2) ~= N)
        error('theta and rho must have matching size. But size(theta, 2) = %d, and size(rho, 2) = %d', size(theta, 2), size(rho, 2));
    end
    
    covarianceRequested = exist('C_TR', 'var');

    rhoSquare = rho .* rho;

    cs = cos(theta);
    cs2 = cos(2 * theta);

    sn = sin(theta);
    sn2 = sin(2 * theta);

    
    thetaTemp = theta' * ones(1, N);
    thetaDyadSum = thetaTemp + thetaTemp';
    cosThetaDyadSum = cos(thetaDyadSum);
    
    rhoDyad = rho'* rho;
    csIJ = sum(sum(rhoDyad .* cosThetaDyadSum));

    if covarianceRequested
        sinThetaDyadSum = sin(thetaDyadSum);
        grad_thetaCsIJ = -sum(rhoDyad .* sinThetaDyadSum, 1) - sum(rhoDyad .* sinThetaDyadSum, 2)';
        grad_rhoCsIJ = 2 * rho * cosThetaDyadSum;
    end
    

    
    y = rhoSquare * sn2' - 2/N * rho * cs' * rho * sn';
    
    x = rhoSquare * cs2' - csIJ / N;
    
    alpha = 0.5 * (atan2(y, x) + pi);
    
    r = rho * cos(theta - ones(size(theta)) * alpha)' / N;
    
    alphaOrg = alpha;
    [alpha, r, isRNegated] = normalizeLineParameters(alpha, r);
    
    if covarianceRequested
        grad_rhoY = 2 * sn2 .* rho - 2/N * (cs * (rho * sn') + sn *(rho * cs'));
        grad_rhoX = 2 * cs2 .* rho - 1/N * (grad_rhoCsIJ);
        grad_thetaY = rhoSquare .* (2 * cs2) - 2/N * ((rho .* - sn) * (rho * sn') + (rho .* cs) *(rho * cs'));
        grad_thetaX = rhoSquare .* (-2 * sn2) - 1/N * (grad_thetaCsIJ);

        if x ~= 0
            gradAlpha = 0.5/((y / x) ^2 + 1) * ([grad_thetaY, grad_rhoY] / x - y ./ x^2 *[grad_thetaX, grad_rhoX]); % apply 0.5 * atan(y/x)'s diff.
        else
            % using atan2(y, x) = 2 atan( y / (sqrt ( x^2 + y^2) + x)) for that case.
            % the derivative with respect ot y is zero and
            %  d/dx 0.5 * atan2 (y, x)|_x=0 
            %= atan'(sign(y))  d/dx (y / (sqrt ( x^2 + y^2) + x))|_x=0
            %= 0.5             -y / (sqrt ( x^2 + y^2) + x)^2 * d/dx (sqrt ( x^2 + y^2) + x)|_x=0
            %= 0.5             -1 / y                         *  (                        1)
        
            gradAlpha = 0.5 * (-1 / y) * [grad_thetaX, grad_rhoX];
        end
    
        % we need the gradient of : 
        %   r = rho * cos(theta - ones(size(theta)) * alpha)' / N;
        grad_rhoR = (cos(theta - ones(size(theta)) * alphaOrg) + rho * sin(theta - ones(size(theta)) * alphaOrg)' * gradAlpha(1, N+1:2*N)) / N;
        grad_thetaR = (rho .* (-sin(theta - ones(size(theta)) * alphaOrg)) * (eye(N) - ones(size(theta))' * gradAlpha(1, 1:N))) / N;
    
        gradR = [grad_thetaR, grad_rhoR];
    
        if isRNegated
            gradR = - gradR;
        end
    
        F_TR= [gradAlpha; gradR];
    
        C_AR = F_TR * C_TR * F_TR';
    end
end

