%% Test Script

% Tests the implemented Dijkstra algorithm by passing predefined
% inputs and checking the outputs for correctness.

% WARNING: Do not change anything in this script!

more off;
clear all;
startup;

%% Problem setup

% Define current robot state
robotState.x = 1.0;
robotState.y = 25.0;

% Define the goal position
goalPosition.x = 30.0;
goalPosition.y = 35.0;

% parameters for Dijkstra algorithm
parameters.robotRadius = 1.0; % Robot radius for map dilation

%% Call the main algorithm

% Load a map
fileDir = fileparts(mfilename('fullpath'));
[ img ] = loadMapFromImage( [fileDir, '/../maps/simple_100x100.png'] );
map = createMap([-10.0, -5.0], 0.5, img);

% Run Dijkstra's Algorithm with a 4-connectivity
startIdx = worldToMap(map.origin, map.resolution, [robotState.x, robotState.y]);
goalIdx = worldToMap(map.origin, map.resolution, [goalPosition.x, goalPosition.y]);
parameters.connectivity = 4;
[ costs.fourConnectivity, costGradientDirection.fourConnectivity, dijkstraPath.fourConnectivity ] = ...
    dijkstra( map.data, goalIdx, parameters, startIdx );

if isempty(dijkstraPath.fourConnectivity)
   error('The path should not by empty, check your implementation for the 4-connectivity.'); 
end

% compute the path cost (4-connectivity)
distVecFour = dijkstraPath.fourConnectivity(2:end,:) - dijkstraPath.fourConnectivity(1:end-1,:);
pathCostVec.fourConnectivity = diag(sqrt(distVecFour*distVecFour'));
pathCost.fourConnectivity = sum(pathCostVec.fourConnectivity);

% Convert the path to cartesian coordinates
pathCartesian = size(dijkstraPath.fourConnectivity);
for i=1:size(dijkstraPath.fourConnectivity,1)
   pathCartesian(i,:) = mapToWorld(map.origin, map.resolution, dijkstraPath.fourConnectivity(i,:));
end

% Plot the results
figure;
plotCosts(costs.fourConnectivity, [map.origin(2), map.origin(2)+map.resolution*map.size(2)], ...
    [map.origin(1), map.origin(1)+map.resolution*map.size(1)], 'Dijkstra costmap 4-connectivity');
plotPath(pathCartesian);

% Run Dijkstra's Algorithm with a 8-connectivity
parameters.connectivity = 8;
[ costs.eightConnectivity, costGradientDirection.eightConnectivity, dijkstraPath.eightConnectivity ] = ...
    dijkstra( map.data, goalIdx, parameters, startIdx );

if isempty(dijkstraPath.eightConnectivity)
   error('The path should not by empty, check your implementation for the 8-connectivity.'); 
end

% compute the path cost (8-connectivity)
distVecEight = dijkstraPath.eightConnectivity(2:end,:) - dijkstraPath.eightConnectivity(1:end-1,:);
pathCostVec.eightConnectivity = diag(sqrt(distVecEight*distVecEight'));
pathCost.eightConnectivity = sum(pathCostVec.eightConnectivity);

% Convert the path to cartesian coordinates
pathCartesian = size(dijkstraPath.eightConnectivity);
for i=1:size(dijkstraPath.eightConnectivity,1)
   pathCartesian(i,:) = mapToWorld(map.origin, map.resolution, dijkstraPath.eightConnectivity(i,:));
end

% Plot the results
figure;
plotCosts(costs.eightConnectivity, [map.origin(2), map.origin(2)+map.resolution*map.size(2)], ...
    [map.origin(1), map.origin(1)+map.resolution*map.size(1)], 'Dijkstra costmap 8-connectivity');
plotPath(pathCartesian);


%% Check the output

% define accuracy for checks
maxDelta = 1e-4;

% Load solution values
load([fileDir, '/dijkstraSolution.mat']);

% Compare output to loaded values
assert (all(abs(1 - pathCostVec.fourConnectivity) < maxDelta), ...
    'UnitTest: Expansion of nodes incorrect. Check the function expandNode()');

diffCost = costs.fourConnectivity - solution.costs.fourConnectivity;
diffCost2 = diffCost;
diffCost(isnan(diffCost)) = 0; % Note: inf - inf = NaN
assert (all(all(abs(diffCost) < maxDelta)), ...
    'UnitTest: The returned cost map for the 4-connectivity differs from the solution, check your Dijkstra algorithm implementation.');
assert (all(all(isinf(costs.fourConnectivity(isnan(diffCost2))))), ...
    'UnitTest: The returned cost map for the 4-connectivity differs from the solution, check your Dijkstra algorithm implementation.');

assert (all(all(abs(costGradientDirection.fourConnectivity - solution.costGradientDirection.fourConnectivity) < maxDelta | ...
    isnan(solution.costGradientDirection.fourConnectivity))), ...
    'UnitTest: The returned cost gradient direction for the 4-connectivity differs from the solution.');

assert (pathCost.fourConnectivity - solution.pathCost.fourConnectivity < maxDelta, ...
    'UnitTest: The returned path cost for the 4-connectivity path differs from the solution');

assert (abs(min(pathCostVec.eightConnectivity) - 1) < maxDelta && abs(max(pathCostVec.eightConnectivity) - sqrt(2)) < maxDelta, ...
    'UnitTest: Expansion of nodes incorrect. Check the function expandNode()');

diffCost = costs.eightConnectivity - solution.costs.eightConnectivity;
diffCost2 = diffCost;
diffCost(isnan(diffCost)) = 0; % Note: inf - inf = NaN
assert (all(all(abs(diffCost) < maxDelta)), ...
    'UnitTest: The returned cost map for the 8-connectivity differs from the solution, check your Dijkstra algorithm implementation.');
assert (all(all(isinf(costs.fourConnectivity(isnan(diffCost2))))), ...
    'UnitTest: The returned cost map for the 8-connectivity differs from the solution, check your Dijkstra algorithm implementation.');

assert (all(all(abs(costGradientDirection.eightConnectivity - solution.costGradientDirection.eightConnectivity) < maxDelta | ...
    isnan(solution.costGradientDirection.eightConnectivity))), ...
    'UnitTest: The returned cost gradient direction for the 8-connectivity differs from the solution.');

assert (pathCost.eightConnectivity - solution.pathCost.eightConnectivity < maxDelta, ...
    'UnitTest: The returned path cost for the 8-connectivity path differs from the solution');

% If the script reaches this point, everything was successfull (asserts did
% not trigger)
disp('Congratulations! All checks successful, your implementation is most likely correct!');
