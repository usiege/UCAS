function [varargout] = validateMeasurementFunction()

tolerance = 1e-5;
success = 1;

load data/validationData.mat

try
    
    for i = 1:length(measurementData)
        for j = 1:size(measurementData(i).M, 2)
            [h, Hx] = measurementFunction(measurementData(i).x, measurementData(i).M(:,j));
            
            if any(abs(h - measurementData(i).h(:,j)) > tolerance) || ...
                    any(reshape(abs(Hx - measurementData(i).Hx(:,:,j)), [], 1) > tolerance)
                success = 0;
                fprintf('Measurement function is incorrect!\n');
                break;
            end
        end
    end
    
    if success == 1
        fprintf('measurement function appears to be correct!\n');
    end
    
catch
    fprintf('Error in the user supplied function. Please make sure that your function is syntactically correct and adheres to the conventions described in the exercise!\n')
    success = 0;
end

if nargout == 1
    varargout{1} = success;
end
