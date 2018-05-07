function [ costs, costGradientDirection, path ] = dijkstra( map, goalIdx, parameters, startIdx )
% DIJKSTRA Dijkstra's algorithm
% Returns a distance map as well as its gradient. An explicit path is
% optional. If the path is requested, the startIdx has to be passed in.


% Dilate the image by the robot radius so the output values respect the
% robot base size.
distInput = map;
distInput(distInput ~= 0) = 1;
distanceMap = bwdist(distInput);
dilatedMap = distanceMap;
dilatedMap(distanceMap <= parameters.robotRadius) = -1;

% Check inputs
if nargout < 3
    inputsValid = checkInputs(map, dilatedMap, goalIdx, parameters);
else
    inputsValid = checkInputs(map, dilatedMap, goalIdx, parameters, startIdx);
end
if ~inputsValid
    err = MException('Dijkstra:InvalidInputs', ...
                    'Dijkstra algorithm got invalid inputs');
    throw(err);
end

% Cost field
% Cells with value inf were never visited
costs = inf*ones(size(dilatedMap));
visited = 0*ones(size(dilatedMap));  % keep track of which nodes were already expanded
isOnHeap = 0*ones(size(dilatedMap)); % keep track of which nodes are currently on the heap

mapSize = size(dilatedMap);

% We compute the distance to the goal at every cell in the map. We start
% from the goal.
costs(goalIdx(1), goalIdx(2)) = TODO;
firstNode.f = costs(goalIdx(1), goalIdx(2));
firstNode.idx = goalIdx;
heap = {firstNode};                     % push start node onto heap
isOnHeap(goalIdx(1), goalIdx(2)) = 1;   % keep track which nodes are on the heap

maxHeapSize = 0;  % keep track of the maximum heap size for informational purposes
cnt = 0;
msgLength = 0;
% hWaitBar = waitbar(0, '');


% Insert a suitable termination criterion here
while TODO
    if (numel(heap) > maxHeapSize)
        maxHeapSize = numel(heap);
    end

    % Sort heap
    % This is inefficient in this implementation, but Matlab does not provide a fast data
    % structure to do that. For the sake of educational purposes, we use
    % the inefficient implementation by sorting an array in every step.
    minHeapCost = inf;
    for i=1:numel(heap)
        if (heap{i}.f < minHeapCost)
            minHeapIdx = i;
            minHeapCost = heap{i}.f;
        end
    end

    % Now the best-cost node is in the 1st entry. Pop best-cost node from
    % heap.
    expandedNodeIdx = heap{minHeapIdx}.idx;
    heap(minHeapIdx) = [];
    visited(expandedNodeIdx(1), expandedNodeIdx(2)) = 1;

    % Expand the node. this creates a list of child nodes.
    newNodesIdx = expandNode(expandedNodeIdx, parameters.connectivity);

    for i=1:numel(newNodesIdx)

        newNodeIdx = newNodesIdx{i};

        % Check for out of map movements
        if (any(newNodeIdx > mapSize) ||any(newNodeIdx < 1))
            continue;
        end

        % Skip already expanded nodes
        if (visited(newNodeIdx(1), newNodeIdx(2)) == 1)
           continue;
        end

        % compute new node cost
        cost = computeCost(dilatedMap, expandedNodeIdx, newNodeIdx);

        % update node costs
        newCost = costs(expandedNodeIdx(1), expandedNodeIdx(2)) + cost;
        if (costs(newNodeIdx(1), newNodeIdx(2)) > newCost)
            costs(newNodeIdx(1), newNodeIdx(2)) = newCost;

            % We should prevent from inserting the same node on the heap
            % again. This is not crucial though.
            if (isOnHeap(newNodeIdx(1), newNodeIdx(2)))

                % Find the node on the heap in order to update the cost
                for j=1:numel(heap)
                   if all( newNodeIdx == heap{j}.idx )
                       heap{j}.f = newCost;
                       break;
                   end
                end

            else

                % insert new node into heap
                heapNode.f = newCost;
                heapNode.idx = newNodeIdx;
                heap = [heap, {heapNode}];
                isOnHeap(newNodeIdx(1), newNodeIdx(2)) = 1;
            end
        end

    end

    if mod(cnt,100) == 0
        fprintf(repmat('\b',1,msgLength));
        msg = [ 'Computing, expanded ', num2str(cnt), '/', num2str(numel(dilatedMap)), ' nodes'];
        fprintf(msg);
        msgLength=numel(msg);
    end

    cnt = cnt+1;

end

fprintf('\nMaximum heap size: %u, expanded nodes: %u\n', maxHeapSize, cnt);
% close(hWaitBar); % This does not work in octave, since there the waitbar
% is not a figure.

% Compute the cost gradient
costGradientDirection = computeCostGradient(costs);

% Optionally, compute an explicit path
if nargout > 2
    path = extractBestCostPath(costs, startIdx, goalIdx, parameters.connectivity);
end

end


function nodes = expandNode(node, connectivity)
% EXPANDNODE Creates a Matlab cell containing all the children of a node.
% Connectivity gives the number of children and might be either 4 or 8 in this implementation.

% Compute the children for the 4-connectivity
nodes = cell(connectivity, 1);
nodes{1} = TODO
nodes{2} = TODO
nodes{3} = TODO
nodes{4} = TODO

% Compute the children for the 8-connectivity. The children for the
% 4-connectivity are a subset of these.
if (connectivity > 4)
    nodes{5} = TODO
    nodes{6} = TODO
    nodes{7} = TODO
    nodes{8} = TODO
end

end

function cost = computeCost(dilatedMap, cell1, cell2)
% COMPUTECOST Compute the costs to travel from cell1 to cell2.
% In most applications this will be the euclidean distance between the
% nodes.

    if (dilatedMap(cell2(1), cell2(2)) ~= -1)
        cost = TODO
    else
        cost = inf; % in collision
    end
end

function [costGradientDirection] = computeCostGradient(costs)
% COMPUTECOSTGRADIENT Computes the gradient direction of the
% cost/distance map via a convolution with a central differences kernel.

% Gradient convolution mask
convMask = 0.5*[-1, 0, 1];

% Convolute the image with the gradient mask for x- and y direction
gx = conv2(costs, convMask', 'same');
gy = conv2(costs, convMask, 'same');

% At the boundary, conv2 does not compute a valid gradient. Here we use the
% difference quotient.
gx(1,:) = costs(1,:) - costs(2,:);
gx(end,:) = costs(end-1,:) - costs(end,:);
gy(:,1) = costs(:,1) - costs(:,2);
gy(:,end) = costs(:,end-1) - costs(:,end);

costGradientDirection = TODO
end

function path = extractBestCostPath(costs, startIdx, goalIdx, connectivity)
% EXTRACTBESTCOSTPATH Extracts the resulting path from start to goal

mapSize = size(costs);

% Initialize empty solution path
path = zeros(0, size(startIdx, 2));

% Insert the start position into the path
idx = startIdx;
path = [path; idx];

% At every step, go to the predecessor of the current node, that has the
% minimum cost until a suitable termination condition is met.
while TODO

    % Get all the predecessors of this node
    nodes = expandNode(idx, connectivity);
    minCost = inf;
    minCostIdx = 1;

    % Find the predecessor with the minimum cost
    predecessorFound = false;
    for i=1:numel(nodes)

        if ~(any(nodes{i} > mapSize) ||any(nodes{i} < 1)) && costs(nodes{i}(1), nodes{i}(2)) < minCost
            minCost = TODO
            minCostIdx = TODO
            predecessorFound = true;
        end
    end

    if (~predecessorFound)
        err = MException('Dijkstra:AlgorithmicError', ...
                    'Dijkstra algorithm could not find predecessor while extracting the final path');
        throw(err);
    end

    % Insert the predecessor into the final path
    idx = minCostIdx;
    path = TODO
end

end


function isValid = checkInputs(map, dilatedMap, goalIdx, parameters, startIdx)
% CHECKINPUTS Checks the input to the Dijkstra algorithm for their validity

    isValid = true;

    if ~isfield(parameters, 'robotRadius')
        disp('parameters needs field robotRadius');
        isValid = false;
    end
    if ~isfield(parameters, 'connectivity')
        disp('parameters needs field connectivity');
        isValid = false;
    else
        if (parameters.connectivity ~= 4 && parameters.connectivity ~=8 )
            disp('Unsupported connectivity (only 4 and 8 supported)');
            isValid = false;
        end
    end

    % Check that start and goal position are valid
    mapSize = size(map);

    if (any(goalIdx > mapSize) ||any(goalIdx < 1))
        disp('The goal position is out of the map boundaries, aborting.');
        isValid = false;
    end

    if nargin > 5
        if (any(startIdx > mapSize) ||any(startIdx < 1))
            disp('The start position is out of the map boundaries, aborting.');
            isValid = false;
        end
    end

    if dilatedMap(goalIdx(1), goalIdx(2)) == -1
        disp('The goal position is on an obstacle, you can never reach that, aborting.');
        isValid = false;
    end

    if nargin > 5
        if dilatedMap(startIdx(1), startIdx(2)) == -1
            disp('The start position is on an obstacle, you cannot move, aborting.');
            isValid = false;
        end
    end

end
