function indices = findGreaterThan50(vec)
    % Function to find indices where the values in the input vector 'vec'
    % exceed 50 and then fall back below or equal to 50. These indices are stored in 
    % two rows: 
    % - First row for the start index (when it goes above 50)
    % - Second row for the end index (when it falls below or equals 50)
    
    above50 = false;  % Logical flag to track if we are currently above 50
    startIndices = [];  % Initialize array to store the start indices
    endIndices = [];    % Initialize array to store the end indices

    for i = 1:length(vec)
        if vec(i) > 50 && ~above50
            % If the value exceeds 50 and we were previously below or equal to 50
            startIndices = [startIndices, i];  % Store the index where it first exceeds 50
            above50 = true;  % Set the flag indicating we are above 50
        elseif vec(i) <= 50 && above50
            % If the value falls below or equals 50 and we were previously above 50
            endIndices = [endIndices, i];  % Store the index where it falls below or equals 50
            above50 = false;  % Reset the flag indicating we are below 50
        end
    end

    % If the vector ends while still above 50, add the last index as an endpoint
    if above50
        endIndices = [endIndices, length(vec)];
    end

    % Combine the start and end indices into a 2-row matrix
    indices = [startIndices; endIndices];
end
