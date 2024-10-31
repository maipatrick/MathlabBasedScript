function VelocityFilt = getBeltVelocity(c3dfile, frameRate, axisorder, UpperVelocityLimit, xUpperLimit, xLowerLimit,yLSLL, yLSRL, yRSLL, yRSRL, zUpperLimit, zLowerLimit)
% Function getBeltVelocity returns the instantantaneous velocity of a treadmill belt using reflective marker patches and a motion capture system.
% The function works with c3d files and requires the btk toolkit to be
% installed for reading the c3d file data into Matlab. The treadmill do not
% have to be labeled, but need to exist as 'ghost markers' in the c3d file.
%
% Output: Filtered (20Hz Butterworth low-pass filter) instantaneous
% treadmill belt velocity
%
% Input: 

% c3dfile: string containing the full file name to the *.c3d file
% containing the marker coordinate data.

%frame rate: marker frame rate in Hz

% axis order: string defining the orientation of the laboratory
% coordinate system relative to the running direction. Currently supported
% orders are 'XYZ' (x-axis in running direction; y-medial to left;
% z-vertical upwards) and 'YXZ' (x-axis medial to left; y-pointing in
% opposite to running direction; z-vertical upwards).

% UpperVelocityLimit: Approximately the highest belt velocity expected
% within the trial

% xUpperLimit: coordinate of the front end of the treadmill (in lab
% coordinate system within treadmill marker patches can
% be expected

% xLowerLimit: coordinate of the rear end of the treadmill (in lab
% coordinate system within treadmill marker patches can
% be expected

% yLSLL: left border of the array of marker patches attached to the left side of the treadmill
% (in lab coordinate system) within treadmill marker patches can
% be expected

% yLSRL: right border of the array of marker patches attached to the left side of the treadmill
% (in lab coordinate system)

% yRSLL: left border of the array of marker patches attached to the right side of the treadmill
% (in lab coordinate system) within treadmill marker patches can
% be expected

% yRSRL: right border of the array of marker patches attached to the right side of the treadmill
% (in lab coordinate system) within treadmill marker patches can
% be expected

% zUpperLimit: upper vertical border within treadmill marker patches can
% be expected (in lab coordinate system)

% zlowerLimit: lower vertical border within treadmill marker patches can
% be expected (in lab coordinate system)




%% Acquiring data

% addpath(genpath('BTK'))
acq = btkReadAcquisition(c3dfile);
markers = btkGetMarkers(acq);
% raw = markers;
fieldName = fieldnames(markers)'; % Acquiring the marker names

%% Overall loop - looping through all markers
for i = 1:length(fieldName)
    if axisorder == 'YXZ'
        markers.(fieldName{i}) = markers.(fieldName{i})(:,[2,1,3]);

        markers.(fieldName{i})(:,1) = -markers.(fieldName{i})(:,1);
        
        xUpperLimit = -xUpperLimit;
        xLowerLimit = -xLowerLimit;
    end
    
    % Identify if marker is in the control volume
    % Looping through all timeframes
    for j = 1:length(markers.(fieldName{i}))
        % Display x markers location as NaN if not in control volume
        if (markers.(fieldName{i})(j,1) < xLowerLimit) || (markers.(fieldName{i})(j,1) > xUpperLimit) || (markers.(fieldName{i})(j,1) == 0)
            markers.(fieldName{i})(j,1) = NaN;
            % Display y markers location as NaN if not in control volume
        elseif(markers.(fieldName{i})(j,2) > yLSLL) || (markers.(fieldName{i})(j,2) < yRSRL)
            markers.(fieldName{i})(j,1) = NaN;
        elseif (markers.(fieldName{i})(j,2) > yLSRL) && (markers.(fieldName{i})(j,2) < yRSLL)
            markers.(fieldName{i})(j,1) = NaN;
            % Display z markers location as NaN if not in control volume
        elseif (markers.(fieldName{i})(j,3) < zLowerLimit) || (markers.(fieldName{i})(j,3) > zUpperLimit)
            markers.(fieldName{i})(j,1) = NaN;
        end
    end
    
    %% Calculating velocity for each marker at each timeframe
    % Identifying if the marker appears for at least 6 consecutive timeframes
    for j = 1:length(markers.(fieldName{i}))-5
        if ~isnan(markers.(fieldName{i})(j,1))...
                && ~isnan(markers.(fieldName{i})(j+1,1))... 
                && ~isnan(markers.(fieldName{i})(j+2,1))... 
                && ~isnan(markers.(fieldName{i})(j+3,1))... 
                && ~isnan(markers.(fieldName{i})(j+4,1))... 
                && ~isnan(markers.(fieldName{i})(j+5,1))
                
            % Calculating the absolute difference between marker positions in
            % x-direction at three timestamps and calculating the average distance.
            k = 0;
            while k <= 3
                absDiff1 = abs(markers.(fieldName{i})(j+1+k,1) - markers.(fieldName{i})(j+k,1));
                absDiff2 = abs(markers.(fieldName{i})(j+2+k,1) - markers.(fieldName{i})(j+1+k,1));
                aveDist(j+1+k) = (absDiff1 + absDiff2) / 2;
                k = k + 1;
            end
            % Calculating the instantaneous velocity with the known
            % framerate for each marker at each timeframe.
            velocity.(fieldName{i})(1,1) = NaN;
            velocity.(fieldName{i})(j+1,1) = aveDist(j+1) / (1000/frameRate);
            % Filter out velocity outliers that are due to marker jumps.
            if velocity.(fieldName{i})(j+1,1) >= UpperVelocityLimit
                velocity.(fieldName{i})(j+1,1) = NaN;
            end
        else
           velocity.(fieldName{i})(j+1,1) = NaN; 
            
        end
    end
end

%% Creating the output velocity vector
% Creating a vector of zeros
velocitySum = zeros(length(velocity.(fieldName{i})),1);
velocitySum(:,2) = 0; % Creating a column of ones !!!!!!!!!!!!!!!!!!! = 0 BAD BECAUSE OF CASE OF /0 !!!!!!!!!!!
% Summing up the velocities if more than one velocity for any
% timeframe is available
for i = 1:length(fieldName)
    for j = 1:length(velocity.(fieldName{i}))
        % Execute the following command only if a number is inside.
        if isnan(velocity.(fieldName{i})(j,1)) == 0
            % Adding Up the velocities at each timeframe
            velocitySum(j,1) = velocitySum(j,1) + velocity.(fieldName{i})(j,1);
            % Counting how many velocities were added
            velocitySum(j,2) = velocitySum(j,2) + 1;
        end
    end
end
% Calculating the average velocity
aveVelocity = velocitySum(:,1) ./ velocitySum(:,2);

if sum(find(isnan(aveVelocity))) ~= 1 %means there're more NaN-elementes in aveVelocity than just the first
    %handle missing values, otherwise filtfilt results in
    %complete NaN-array. For now use builtin fillgaps fcn:
    aveVelocity = fillgaps(aveVelocity);
end
% Filtering the data
[b,a] = butter(2, 20/(frameRate/2), 'low');
aveVelocityFilt(2:length(aveVelocity)) = filtfilt(b,a,aveVelocity(2:end));
aveVelocityFilt(1) = aveVelocityFilt(2);
% SOL.(subjects(m, :)).(strcat('S', (velocities(h, :)))) = aveVelocityFilt';
% clearvars velocity velocitySum markers raw fieldName aveDist aveVelocity aveVelocityFilt
