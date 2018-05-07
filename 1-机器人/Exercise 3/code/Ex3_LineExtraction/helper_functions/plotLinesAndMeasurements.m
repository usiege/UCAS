function plotLinesAndMeasurements(xs, ys, z, segends, referenceZ, dontTouchAxis)
    assert(size(xs, 1) == size(ys, 1) && size(xs, 2) == 1 && size(ys, 2) == 1, 'xs and ys must have format (nPoints, 1)');
    assert(size(z, 1) == 2, 'z must have format (2, nLines)');
    
    if ~ exist('dontTouchAxis', 'var'), dontTouchAxis = false; end
    
    drawSegends = exist('segends', 'var');
    if drawSegends 
        assert(size(segends, 2) == 4 && size(z, 2) == size(segends, 1), 'segends must have format (nLines, 4)');
        x1 = segends(:, 1);
        y1 = segends(:, 2);
        x2 = segends(:, 3);
        y2 = segends(:, 4);
    end

    
    
    
    if ~ dontTouchAxis, hold off; axis auto; end
    plot(xs, ys, 'k.'), hold on, grid on, hold on;
    drawnow;
    if ~ dontTouchAxis, axis manual; end

    drawReference = exist('referenceZ', 'var') && ~ isempty(referenceZ);
    if drawReference
        for i=1:size(referenceZ, 2)
            drawLine(referenceZ(:, i), [ 0.8 0.8 0.8], '-');
        end
    end
    
    color = 0;
    for i=1:size(z, 2),
        if color == 0, c = 'r'; elseif color == 1, c = 'b'; else c = 'g'; end
        if drawSegends, line([x1(i); x2(i)], [y1(i); y2(i)], 'color', c, 'linewidth', 2), end;
        
        drawLine(z(:, i), c, ':');
        color = mod(color + 1, 3);
    end
end

function drawLine(z, color, lineStyle)
    [xz, yz] = pol2cart(z(1), z(2));
    lineFootPoint = [xz; yz];
    plot(lineFootPoint(1), lineFootPoint(2), '+', 'color', color, 'linewidth', 3);
    lineAlpha = z(1);
    deltaVector = [ -sin(lineAlpha); cos(lineAlpha)] * 10;
    linePoints = [lineFootPoint - deltaVector, lineFootPoint + deltaVector];
    line(linePoints(1, :), linePoints(2, :), 'color', color, 'linestyle', lineStyle, 'linewidth', 3);
end
