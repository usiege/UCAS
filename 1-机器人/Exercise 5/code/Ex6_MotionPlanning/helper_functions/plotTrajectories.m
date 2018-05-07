function handlesOut = plotTrajectories(debugInput, handlesIn)

% delete the old objects from the figure
    for i=1:size(handlesIn,1)
        for j=1:size(handlesIn,2)
            try % we don't want the program to fail because of the visualization
                delete(handlesIn(i,j,1));
                delete(handlesIn(i,j,2));
            end
        end
    end
            
    for i=1:size(debugInput.trajectories,1)
        for j=1:1:size(debugInput.trajectories,2)
            if isnan(debugInput.scores(i,j))
                color = 'r';
                width = 1;
            elseif all(size(debugInput.bestSampleIdx) == [1,2]) && all([i,j] == debugInput.bestSampleIdx)
                color = 'm';
                width = 2;
            elseif debugInput.distTerms(i,j) < 1000
                color = 'y';
                width = 2;
            else
                color = 'b';
                width = 1;
            end
            handlesOut(i,j,1) = plot(debugInput.trajectories{i,j}(:,2), debugInput.trajectories{i,j}(:,1), 'Color', color, 'LineWidth', width);
            handlesOut(i,j,2) = plot(debugInput.trajectories{i,j}(debugInput.nStepsBrake(i,j), 2), debugInput.trajectories{i,j}(debugInput.nStepsBrake(i,j), 1), 'ok');
        end
    end
end