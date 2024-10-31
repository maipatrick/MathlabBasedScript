function modifiedVec = zeroEverySecondPeakAbove50(vec)
    % Function to identify every second peak with value greater than 50 in the input vector 'vec'
    % and set it to zero.
    
    % Find peaks and their locations in the vector
    [peaks, locs] = findpeaks(vec);
    
    % Filter out the peaks that are greater than 50
    peaksAbove50 = find(peaks > 50);
    
    % Check if there are any peaks above 50
    if length(peaksAbove50) < 2
        % If there are fewer than two peaks above 50, return the original vector
        modifiedVec = vec;
        return;
    end
    
    % Loop through every second peak that is above 50, starting from the second one
    for i = 2:2:length(peaksAbove50)
        % Get the location of the peak above 50
        peakLoc = locs(peaksAbove50(i));
        
        % Set that peak to zero
        vec(peakLoc) = 0;
    end
    
    % Return the modified vector
    modifiedVec = vec;
end