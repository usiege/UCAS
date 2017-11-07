function [ ] = plotDijkstraResults( costs, path, varargin )
%PLOTDIJKSTRARESULTS Plots the costmap and the path returned by the
%Dijkstra algorithm

plotCosts( costs );
plotPath( path, varargin{:} );

end

