function [] = plotCosts( costs, xaxis, yaxis, plotTitle)
%PLOTCOSTS Plots the cost matrix returned by the dijkstra algorithm

if nargin < 4
    plotTitle = 'Dijkstra costmap';
end

% Set infinite costs to -1 and ignore negative values in the colormap
costs(costs==inf) = -1;
clims = [min(min(costs)) max(max(costs))];

if nargin > 2
    imagesc(xaxis, yaxis, costs, clims);
else 
    imagesc(costs, clims);
end
colormap(jet);
colorbar();

% Image coordinates are used, that's why x and y are switched
xlabel('y');
ylabel('x');
axis image;
title(plotTitle);

end

