function modifiedVec = setEverySecondColToZero(vec, indices)
    % Function to set every second column from the indices matrix in the
    % input vector `vec` to zero. The input matrix `indices` has two rows:
    %   - First row: indices where values become greater than 50.
    %   - Second row: indices where values fall below or equal to 50.

    % Loop through every second column in the indices matrix
    for col = 2:2:size(indices, 2)
        % Get the start and end indices for the current second column
        startIdx = indices(1, col);
        endIdx = indices(2, col);

        % Set the values between startIdx and endIdx (inclusive) to zero
        vec(startIdx:endIdx) = 0;
    end

    % Output the modified vector
    modifiedVec = vec;
end
