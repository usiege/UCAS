% Input:   XY - [2,N]: X,Y coordinates
%          LINE_POINT_DIST_THRESHOLD [1, 1]: point distance threshold. Where it is exceeded a split is performed
% Output:  alpha - [NLines]: line parameters       
%          r - [NLines]: line parameters
%          segend [NLines, 4] : segment's end point coordinates
%          seglen [NLines, 1] : segment's length
%          pointIdx [NLines, 2] : segment's first and last point index in XY

function [alpha, r, segend, seglen, pointIdx] = extractLines(XY, params)
    % Extract line segments
    [alpha, r, pointIdx] = splitLinesRecursive(XY, 1, size(XY, 2), params);
  
    N = length(r);
    if (N > 1) 
        [alpha, r, pointIdx] = mergeColinearNeigbors(XY, alpha, r, pointIdx, params);
        N = length(r);
    end
    
    % Compute endpoints/lengths of the segments
    segend = zeros(N, 4);
    seglen = zeros(N, 1);
    for i=1:N
        segend(i, :) = [XY(:, pointIdx(i,1))' XY(:, pointIdx(i,2))'];
        % Length
        seglen(i) = sqrt((segend(i,1) - segend(i,3))^2 + (segend(i,2) - segend(i,4))^2);
    end

    % Removing short segments
    goodSegIdx = find((seglen >= params.MIN_SEG_LENGTH) & ((pointIdx(:, 2) - pointIdx(:, 1)) >= params.MIN_POINTS_PER_SEGMENT));
    pointIdx = pointIdx(goodSegIdx, :);
    alpha = alpha(goodSegIdx);
    r = r(goodSegIdx);
    segend = segend(goodSegIdx, :);
    seglen = seglen(goodSegIdx);
end
%--------------------------------------------------------------------
% Main splitting function
function [alpha, r, idx] = splitLinesRecursive(XY, startIdx, endIdx, params)
% Number of input points
    N = endIdx - startIdx + 1;
  
    %it a line using the N points
    [alpha, r] = fitLine(XY(:, startIdx:endIdx));
  
    if (N <= 2)
        idx = [startIdx, endIdx];
        NSegs = 1;
        return
    end
  
    % Find the splitting position (if there is)
    splitPos = findSplitPos(XY(:, startIdx:endIdx), alpha, r, params);
  
    if (splitPos ~= -1) % found a splitting point
        [alpha1, r1, idx1] = splitLinesRecursive(XY, startIdx, splitPos+startIdx-1, params);
        [alpha2, r2, idx2] = splitLinesRecursive(XY, splitPos+startIdx-1, endIdx, params);
        alpha = [alpha1; alpha2];
        r = [r1; r2];
        idx = [idx1; idx2];
    else % no need to split
        idx = [startIdx, endIdx];
    end
    return  % function splitLinesRecursive
end

%---------------------------------------------------------------------
function splitPos = findSplitPos(XY, alpha, r, params)
    % Compute the distances from the points to the fitted line
    d = compDistPointsToLine(XY, alpha, r);

    % Find the splitting position (if there is)
    splitPos = findSplitPosInD(d, params);
end

% ---------------------------------------------------------------------
% This function computes the distances from the input points to
% an input line.
% Note that here we can have negative values for distances (to indicate
% which side relative to the line the point belongs).
% Input:   XY - [2,N] : input points
%          alpha, r : line parameters
% Output:  d - [N]: the distances from the input points to the line.

function d = compDistPointsToLine(XY, alpha, r)
    cosA = cos(alpha);
    sinA = sin(alpha);
  
    N = size(XY,2);
    d = zeros(N,1);
  
    xcosA = XY(1,:) * cosA;
    ysinA = XY(2,:) * sinA;
    d = xcosA + ysinA - r;
  
    return  % function ComDistPointsToLine
end
%---------------------------------------------------------------------

function splitPos = findSplitPosInD(d, params)
    N = length(d);
  
    % Find the local maximum set (2 points)
    farOnPositiveSideB = d > params.LINE_POINT_DIST_THRESHOLD;
    farOnNegativeSideB = d < -params.LINE_POINT_DIST_THRESHOLD;
    
    neigborsFarAwayOnTheSameSideI = find((farOnPositiveSideB(1:N-1) & farOnPositiveSideB(2:N)) | (farOnNegativeSideB(1:N-1) & farOnNegativeSideB(2:N)));
   
    if isempty(neigborsFarAwayOnTheSameSideI) 
        splitPos = -1;
    else
        absDPairSum = abs(d(neigborsFarAwayOnTheSameSideI)) + abs(d(neigborsFarAwayOnTheSameSideI+1));
        [ans, splitPos] = max(absDPairSum);
        splitPos = neigborsFarAwayOnTheSameSideI(splitPos);
        if abs(d(splitPos)) <= abs(d(splitPos + 1)), splitPos = splitPos + 1; end
    end

    % If the split position is toward either end of the segment, find otherway to split.
    if (splitPos ~= -1 && (splitPos < 3 || splitPos > N-2))
        [ans, splitPos] = max(abs(d));
        if (splitPos == 1), splitPos = 2; end;
        if (splitPos == N), splitPos = N-1; end;
    end
  
    return
end
%---------------------------------------------------------------------

function [alphaOut, rOut, pointIdxOut] = mergeColinearNeigbors (XY, alpha, r, pointIdx, params)
    z = [alpha(1), r(1)];
    startIdx = pointIdx(1, 1);
    lastEndIdx = pointIdx(1, 2);
    
    rOut = [];
    alphaOut = [];
    pointIdxOut = [];

    j = 1;
    N = size(r, 1);
    for i = 2:N
        endIdx = pointIdx(i, 2);
        
        [zt(1), zt(2)] = fitLine(XY(:, startIdx : endIdx));
              
        % Find the splitting position in merged segment (if there is)
        splitPos = findSplitPos(XY(:, startIdx:endIdx), zt(1), zt(2), params);

        if (splitPos == -1) % no split necessary, so we finally merge
            z = zt;
        else % no further merging
            alphaOut(j, 1) = z(1);
            rOut(j, 1) = z(2);
            pointIdxOut(j, :) = [startIdx, lastEndIdx];
            j = j + 1;
            z = [alpha(i), r(i)];
            startIdx = pointIdx(i, 1);
        end
        lastEndIdx = endIdx;
    end
    % add last segment
    alphaOut(j, 1) = z(1);
    rOut(j, 1) = z(2);
    pointIdxOut(j, :) = [startIdx, lastEndIdx];
end
