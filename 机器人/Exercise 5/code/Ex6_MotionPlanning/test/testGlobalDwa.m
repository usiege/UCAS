%% Test Script

% Tests the implemented (global) dynamic window approach 
% by passing predefined inputs and checking the outputs for correctness.

more off;
clear all;
startup;

%% Prepare data
[robotStateArray, goalPosition, map, parameters, maxDelta] = prepareTestDwa();
% use the global DWA approach
parameters.globalPlanningOn = true;

% turn plotting on/off
parameters.plot = false;

%% Call the dynamic window approach (DWA) function
% first load the Dijkstra data
fileDir = fileparts(mfilename('fullpath'));
load([fileDir, '/dijkstraSolution.mat']);
% create a map object from the gradient direction data
gradientDirectionMap = createMap(map.origin, map.resolution, solution.costGradientDirection.eightConnectivity);
results = cell(numel(robotStateArray), 2);
for i = 1:numel(robotStateArray)
    [results{i,1}, results{i,2}, results{i,3}] = dynamicWindowApproach(robotStateArray{i,1}, goalPosition, map, parameters, gradientDirectionMap );
end


%% Test outputs

% Load solution values
load([fileDir, '/globalDwaSolution.mat']);

% Compare output to solution values
for i = 1:numel(robotStateArray)
    assert (all(abs(results{i,3}.window - globalDwaSolution{i,3}.window) < maxDelta), ...
            'Global DWA: the returned dynamic window differs from the solution, check your implementation of computeDynamicWindow().');
    
    assert (all(all(abs(results{i,3}.headingTerms - globalDwaSolution{i,3}.headingTerms) < maxDelta)), ...
            'Global DWA: the returned heading terms of the cost function differ from the solution, check the implementation of scoreTrajectory()');
    
    assert (all(all(abs(results{i,3}.scores - globalDwaSolution{i,3}.scores) < maxDelta)), ...
            'Global DWA: the returned cost function values differ from the solution, check the computation of the variable "scores"');
    
    assert (abs(results{i,3}.scores(results{i,3}.bestSampleIdx(1), results{i,3}.bestSampleIdx(2)) - globalDwaSolution{i,3}.maxScore) < maxDelta, ...
            'Global DWA: You did not find the best score');

end

% If the script reaches this point, everything was successfull (asserts did
% not trigger)
disp('Congratulations! All checks successful, your implementation is most likely correct!');
