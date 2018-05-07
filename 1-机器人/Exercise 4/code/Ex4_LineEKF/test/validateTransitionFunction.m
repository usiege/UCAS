function [varargout] = validateTransitionFunction()

tolerance = 1e-5;
success = 1;

load data/validationData.mat

try
    
    for i = 1:length(transitionData)
        [x, Fx, Fu] = transitionFunction(transitionData(i).x, transitionData(i).u, transitionParams.b);
        
        if any(abs(x - transitionData(i).x_priori) > tolerance) || ...
                any(reshape(abs(Fx - transitionData(i).Fx_priori), [], 1) > tolerance) || ...
                any(reshape(abs(Fu - transitionData(i).Fu_priori), [], 1) > tolerance)
                success = 0;
                fprintf('State transition function is incorrect!\n');
                break;
        end
    end
    
    if success == 1
        
        %plot forward integration path to motivate measurement updates
        x(:,1) = filterData(1).x_gt;
        for i = 2:length(filterData)
            x(:,i) = transitionFunction(filterData(i-1).x, filterData(i).u, filterParams.b);
        end
        
        a = [filterData.x_gt];  plot(a(1,:), a(2,:), 'b-'); hold on, axis equal;
        plot(x(1,:), x(2,:), 'g-')
        title('robot path');
        xlabel('x'), ylabel('y');
        legend({'ground truth','forward integration'});
        axis equal

        fprintf('State transition function appears to be correct!\n');
    end
    
catch
    fprintf('Error in the user supplied function. Please make sure that your function is syntactically correct and adheres to the conventions described in the exercise!\n')
    success = 0;
end

if nargout == 1
    varargout{1} = success;
end
