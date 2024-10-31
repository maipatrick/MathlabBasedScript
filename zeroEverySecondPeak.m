function modifiedVec = zeroEverySecondPeak(vec)
    % Function to identify every second peak in the input vector 'vec'
    % and set it to zero.
    
    % Find peaks in the vector
    [peaks, locs] = findpeaks(vec);
    
    % Initialize a logical index array to keep track of peaks
    peakIndex = false(size(vec));
    
    % Mark the locations of the peaks
    peakIndex(locs) = true;
    
    % Identify every second peak by starting with the second peak
    for i = 2:2:length(locs)
        vec(locs(i)) = 0; % Set every second peak to zero
    end
    
    % Output the modified vector
    modifiedVec = vec;
end