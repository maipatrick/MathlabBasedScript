function modifiedVec = zeroFromSecondPeak(vec)
    % Function to identify peaks and set values to zero starting from the 
    % second peak and moving backwards until the values fall below 50 or
    % exceed 50.
    
    % Find peaks in the vector
    [~, locs] = findpeaks(vec);
    
    % Check if there are enough peaks
    if length(locs) < 2
        % If there are less than two peaks, nothing needs to be changed
        modifiedVec = vec;
        return;
    end
    
    % Loop through every second peak starting from the second one
    for i = 2:2:length(locs)
        % Get the location of the second peak
        peakLoc = locs(i);
        
        % Start moving backwards from the second peak
        for j = peakLoc:-1:1
            % Check if the value is between 0 and 50
            if vec(j) < 50 || vec(j) > 50
                % Stop when the value is less than or greater than 50
                break;
            end
            % Set the value to zero
            vec(j) = 0;
        end
    end
    
    % Output the modified vector
    modifiedVec = vec;
end