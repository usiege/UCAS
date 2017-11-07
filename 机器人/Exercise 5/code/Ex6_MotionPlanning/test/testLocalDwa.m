%% Test Script

% Tests the implemented (local) dynamic window approach 
% by passing predefined inputs and checking the outputs for correctness.

more off;
clear all;
startup;
fileDir = fileparts(mfilename('fullpath'));

%% Prepare data
[robotStateArray, goalPosition, map, parameters, maxDelta] = prepareTestDwa();
% use the local DWA approach
parameters.globalPlanningOn = false;

% turn plotting on/off
parameters.plot = false;

%% Call the dynamic window approach (DWA) function
results = cell(numel(robotStateArray), 3);
for i = 1:numel(robotStateArray)    
    [results{i,1}, results{i,2}, results{i,3}] = dynamicWindowApproach( robotStateArray{i,1}, goalPosition, map, parameters);
end


%% Test the outputs

% Load solution values
load([fileDir, '/localDwaSolution.mat']);

% Compare output to solution values
for i = 1:numel(robotStateArray)
    assert (all(abs(results{i,3}.window - localDwaSolution{i,3}.window) < maxDelta), ...
            'Local DWA: the returned dynamic window differs from the solution, check your implementation of computeDynamicWindow().');
        
    assert (all(all(abs(results{i,3}.headingTerms - localDwaSolution{i,3}.headingTerms) < maxDelta)), ...
            'Local DWA: the returned heading terms of the cost function differ from the solution, check the implementation of scoreTrajectory()');
        
    assert (all(all(abs(results{i,3}.scores - localDwaSolution{i,3}.scores) < maxDelta)), ...
            'Local DWA: the returned cost function values differ from the solution, check the computation of the variable "scores"');
        
    assert (abs(results{i,3}.scores(results{i,3}.bestSampleIdx(1), results{i,3}.bestSampleIdx(2)) - localDwaSolution{i,3}.maxScore) < maxDelta, ...
            'Global DWA: You did not find the best score');
end

% If the script reaches this point, everything was successfull (asserts did
% not trigger)
disp('Congratulations! All checks successful, your implementation is most likely correct!');
