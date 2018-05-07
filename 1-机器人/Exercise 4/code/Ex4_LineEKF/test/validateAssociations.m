function [varargout] = validateAssociations()

tolerance = 1e-3;
success = 1;

load data/validationData.mat

try
    
    success = validateMeasurementFunction();
    
    for i = 1:length(associationData)
        
        [v, H, R] = associateMeasurements(associationData(i).x, associationParams.P, associationData(i).h, associationParams.R, associationData(i).M, associationParams.g);
        
        [indexRef, indexSolution] = getOrder(associationData(i).H, H);      %do associations by matching H. if this fails, something is wrong with H.
        
        if any(reshape(abs(v(:, indexSolution) - associationData(i).v), [], 1) > tolerance) || ...
                any(reshape(abs(H(:, :, indexSolution) - associationData(i).H), [], 1) > tolerance) || ...
                any(reshape(abs(R(:, :, indexSolution) - associationParams.R), [], 1) > tolerance)
            
            abs(v(:, indexSolution) - associationData(i).v)
            reshape(abs(H(:, :, indexSolution) - associationData(i).H), [], 1)
            reshape(abs(R(:, :, indexSolution) - associationParams.R), [], 1)
            
            fprintf('Error in the associations!\n');
            success = 0;
            break;
        end
    end
    
    if success == 1
        fprintf('association function appears to be correct!\n');
    end
    
catch exception
    fprintf('Error in the user supplied function. Please make sure that your function is syntactically correct and adheres to the conventions described in the exercise!\n')
    success = 0;
    rethrow(exception);
end


if nargout == 1
    varargout{1} = success;
end
