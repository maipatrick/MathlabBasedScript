clc
clear all
close all
data =  load('C:\Users\adpatrick\OneDrive - nih.no\Desktop\MilitaryLoadAnalysis\Walking\FP1.mat');

parameter = 'MOMENTS';
trialname = fieldnames(data.MARKERS);

size(data.NORMAL.L.MOMENTS.LEFT_ANKLE.X)

stepEvents = detectTD_TO_events(data.FP.(trialname{1, 1}).GRFfilt.Left(end,:), 100, 20);
stepEvents_vid = fix(stepEvents/data.OPTIONS.ftkratio  );

for st = 1 : length(stepEvents)-1
% stepEvents(st,1)
% stepEvents(st+1,1)    LeftAnkleMomentInProximal
data.NORMAL.L.MOMENTS_GAIT.LEFT_HIP.X(:,st) = normalize_vector (data.KINETICS.(trialname{1, 1}).LeftAnkleMomentInProximal(2,stepEvents(st,1):stepEvents(st+1,1)), 0.5)./data.OPTIONS.mass;
figure(1)
subplot(2,1,1)
plot(data.NORMAL.L.MOMENTS_GAIT.LEFT_HIP.X(:,st))
ylabel ('Ankle flexion moment [Nm/kg]')
hold on
grf(:,st) = normalize_vector (data.FP.(trialname{1, 1}).GRFfilt.Left(3,stepEvents(st,1):stepEvents(st+1,1)), 0.5);

subplot(2,1,2)
plot(grf(:,st) )
hold on
xlabel ('Gait cycle dont mint the 201 data points')
ylabel ('GRF')
title ([num2str(stepEvents_vid(st,1)), '    ',num2str(stepEvents_vid(st+1,1))])
end

figure(2)

subplot(3,3,1)

plot(data.NORMAL.L.MOMENTS.LEFT_HIP.X)
stan_plot_stance
ylabel ('Hip moments [Nm/kg]')
title ('Frontal plane')
subplot(3,3,2)
plot(data.NORMAL.L.MOMENTS.LEFT_HIP.Y)
stan_plot_stance
title ('Sagittal plane')

subplot(3,3,3)
plot(data.NORMAL.L.MOMENTS.LEFT_HIP.Z)
stan_plot_stance
title ('Transversal plane')


subplot(3,3,4)
plot(data.NORMAL.L.MOMENTS.LEFT_KNEE.X)
stan_plot_stance
ylabel ('Knee moments [Nm/kg]')
subplot(3,3,5)
plot(data.NORMAL.L.MOMENTS.LEFT_KNEE.Y)
stan_plot_stance
subplot(3,3,6)
plot(data.NORMAL.L.MOMENTS.LEFT_KNEE.Z)
stan_plot_stance

subplot(3,3,7)
plot(data.NORMAL.L.MOMENTS.LEFT_ANKLE.X)
stan_plot_stance
ylabel ('Ankle moments [Nm/kg]')

subplot(3,3,8)
plot(data.NORMAL.L.MOMENTS.LEFT_ANKLE.Y)
stan_plot_stance
subplot(3,3,9)
plot(data.NORMAL.L.MOMENTS.LEFT_ANKLE.Z)
stan_plot_stance



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

