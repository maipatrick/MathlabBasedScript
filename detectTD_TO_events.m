function stepEvents = detectTD_TO_events(GRFz, threshold, minFrames)
% DETECTTD_TO_EVENTS detects TD and TO events based on vertical GRF
% 
% Inputs:
%   GRFz       - Vector of vertical ground reaction force (1D array)
%   threshold  - Force threshold for detecting contact (e.g. 50 N)
%   minFrames  - Minimum consecutive frames above/below threshold to count
%
% Output:
%   stepEvents - Nx2 array, where each row is [TD_index, TO_index]

    % Ensure column vector
    GRFz = GRFz(:);
    N = length(GRFz);
    
    % Binary contact signal: 1 = contact (above threshold), 0 = no contact
    contact = GRFz > threshold;
    
    % Find transitions
    diffContact = diff([0; contact; 0]);  % pad to catch endpoints
    startContact = find(diffContact == 1);  % TD candidate
    endContact   = find(diffContact == -1); % TO candidate
    
    % Filter events by minimum duration
    TD = [];
    TO = [];
    for i = 1:length(startContact)
        duration = endContact(i) - startContact(i);
        if duration >= minFrames
            TD(end+1,1) = startContact(i); %#ok<AGROW>
            TO(end+1,1) = endContact(i)-1;  %#ok<AGROW>
        end
    end
    
    % Pack output
    stepEvents = [TD TO];
end
