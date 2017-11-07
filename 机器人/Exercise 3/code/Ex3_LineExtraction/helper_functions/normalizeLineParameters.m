function [alpha, r, isRNegated] = normalizeLineParameters (alpha, r)
    if r < 0
        alpha = alpha + pi;
        r = -r;
        isRNegated = 1;
    else
        isRNegated = 0;
    end
    
    if alpha > pi, alpha = alpha - 2 * pi; 
    elseif alpha < -pi, alpha = alpha + 2 * pi;
    end
end