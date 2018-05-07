function [ ] = plotPath( path, varargin )
%PLOTPATH Plots path into the current axes

if isempty(path)
   return; 
end

isHoldOn = ishold();
hold on;
plot(path(:,2), path(:,1), varargin{:});
plot(path(1,2), path(1,1), 'og', 'MarkerFaceColor', 'g');
plot(path(end,2), path(end,1), 'or', 'MarkerFaceColor', 'r');
if (~isHoldOn)
    hold off;
end

end

