function plotLinesAndMeasurementsPolar(theta, rho, z, segends, referenceZ)
    [xs, ys] = pol2cart(theta, rho);
    if exist('referenceZ',  'var')
        plotLinesAndMeasurements(xs, ys, z, segends, referenceZ);
    elseif exist('segends',  'var')
        plotLinesAndMeasurements(xs, ys, z, segends);
    else
        plotLinesAndMeasurements(xs, ys, z);
    end
end
