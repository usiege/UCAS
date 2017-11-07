% % % % % % % % % % % % % % % % % % % % % % 
% runAndCheckFitLine
% Runs line fitting on the points in XY and compares with zExpected.
% If the error is too big the lines and points are plottet and the error is printed.
% % % % % % % % % % % % % % % % % % % % % % 


function runAndCheckFitLine(testIndex, XY, zExpected, maxError)
    fprintf('Testing line fitting %i : ', testIndex);
        
    [alphaT, rT] = fitLine(XY);
    zT = [alphaT; rT];
    zError = calcZDiff(zExpected, zT);
        
    if not(exist('maxError', 'var'))
        maxError = 1E-3;
    end
    if zError < maxError
        fprintf 'OK\n'
    else
        fprintf ('Failed : expected [%f, %f] but got [%f, %f] (delta = %f)\n', zExpected(1), zExpected(2), alphaT, rT, zError);
        clf;
        plotLinesAndMeasurements(XY(1, :)', XY(2, :)', zExpected);
        drawnow
        disp 'Press ENTER to continue'
        pause
    end
end
