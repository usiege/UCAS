% % % % % % % % % % % % % % % % % % % % % % 
% Line extraction test script
% % % % % % % % % % % % % % % % % % % % % % 

startup;
close all;
clear all;

% params for line extraction
params.MIN_SEG_LENGTH = 0.01;
params.LINE_POINT_DIST_THRESHOLD = 0.005;
params.MIN_POINTS_PER_SEGMENT = 20;

for testIndex=1:6,
    fprintf('Testing laser scan %i: ', testIndex);
    
    load(sprintf('../test/data/testLineExtraction%d', testIndex)); % loads z, R, theta, rho
    
    C_TR = diag([ones(size(theta)), ones(size(rho))]);
    
    [zT, RT, segendsT] = extractLinesPolar(theta, rho, C_TR, params);
    
    N = size(z, 2);
    Ps = perms(1:N);
    green = false;
    for i = 1:size(Ps, 1)
        P = Ps(i,:);
        zError = max(calcZDiff(z(:, P), zT));
        if zError > 1E-3
            continue;
        end
        
        rIsGood = true;
        for j = 1:size(RT, 3)
            rError = norm(RT(:, :, j) - R(:, :, P(j)));
            if (rError > 1E-3)
                rIsGood = false;
                break;
            end
        end
        if not(rIsGood)
            continue;
        end
        
        green = true;
        break;
    end
    
    if green
        fprintf 'OK\n'
    else
        fprintf 'Failed\n'
        clf;
        plotLinesAndMeasurementsPolar(theta', rho', zT, segendsT, z);
        drawnow
        disp 'Press ENTER to continue'
        pause
    end
end
