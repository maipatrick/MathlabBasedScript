function [COP, COP_vid, GRFfilt,GRFfilt_vid, FM, ind_baseline, O] = get_treadmill_GRF_GUI_Treadmetrix(file, OPTIONS, baseline_correct)
          
% close all
clc
% [filename, pathname] = uigetfile('*.c3d', 'Daten her', 'X:\Steffen\Force_Treadmill');
% file = [pathname, filename];
order = [2;1;3;5;4;6;8;7;9;11;10;12];
exp_flight = 40;
origins = [354 ,	535 ,	43]./1000;

%% Filter coefficients
[b,a] = butter(2, OPTIONS.CutOffGRF/(OPTIONS.freqGRF/2), 'low');
[bp,ap] = butter(2, 10/(OPTIONS.freqGRF/2), 'low');
%% Read in Analog Channels for BAseline Correction
run = 1;
for i = 3:3:12
    try
        A(:,run) = getAnalogChannel(file, num2str(i));
    catch
        A(:,run) = getAnalogChannel(file, ['Electric Potential.',num2str(i)]);
    end
    Afilt(:,run) = filtfilt(bp,ap,double(A(:,run)));
    run = run+1;
end
Fzbl = sum(A,2);
Fzbl_filt = sum(Afilt,2);
% figure
% plot(Fzbl)
% hold on
% plot(Fzbl_filt, 'r');
upperlimit = min(Fzbl_filt) + 1;
ind_low = find(Fzbl_filt < upperlimit);
if ~isempty(find(diff(ind_low) > 1))
    steps(1,:) = find(diff(ind_low) > 1);
    for i = 1:length(steps)
        stepsreal(1,i) = ind_low(steps(i));
        stepsreal(2,i) = 1;
        for j = stepsreal(1,i):-1:1
            if Fzbl(j) > upperlimit
                stepsreal(2,i) = j;
                break
            end
        end
    end
    for i = 1:length(stepsreal)
        barriers(1,i) = stepsreal(2,i) + round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
        barriers(2,i) = stepsreal(1,i) - round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
    end
    % for i = 1:length(steps)
    %    plot([stepsreal(1,i) stepsreal(1,i)], get(gca, 'YLim'), 'k');
    %    plot([stepsreal(2,i) stepsreal(2,i)], get(gca, 'YLim'), 'k');
    %    plot([barriers(1,i) barriers(1,i)], get(gca, 'YLim'), 'g');
    %    plot([barriers(2,i) barriers(2,i)], get(gca, 'YLim'), 'g');
    % end
    % plot(get(gca, 'Xlim'), [upperlimit upperlimit], 'k');
    % assignin('base', 'ind_low', ind_low);
    % assignin('base', 'steps', steps);
    % assignin('base', 'stepsreal', stepsreal);
    % assignin('base', 'barriers', barriers);
    % pause
    
    barriervalues = [];
    for i = 1:length(barriers)-1
        barriervalues = [barriervalues, [barriers(1,i+1):barriers(2,i+1)]];
    end
else
    barriervalues = 1:length(Fzbl);
end
assignin('base', 'barriervalues', barriervalues);
%% Read in Analog Channels
for i = 1:12
    try
        A(:,i) = getAnalogChannel(file, num2str(i));
    catch
        A(:,i) = getAnalogChannel(file, ['Electric Potential.',num2str(i)]);
    end
    O(1,i) = mean(A(barriervalues,i));
    if baseline_correct
        A(:,i) = A(:,i) - O(1,i);
    end
end


%% Baseline correction


%% Calibration Matrix
% C = [-36.5216800000000,0.000230000000000000,-0.000170000000000000,0,0,0,0,0,0,0,0,0;0.000190000000000000,36.4763800000000,-0.000110000000000000,0,0,0,0,0,0,0,0,0;0.000210000000000000,5.00000000000000e-05,143.777320000000,0,0,0,0,0,0,0,0,0;0,0,0,36.4939500000000,2.00000000000000e-05,-0.000200000000000000,0,0,0,0,0,0;0,0,0,0.000140000000000000,-36.5179400000000,-9.00000000000000e-05,0,0,0,0,0,0;0,0,0,0.000140000000000000,-6.00000000000000e-05,143.645140000000,0,0,0,0,0,0;0,0,0,0,0,0,36.5481000000000,0.000150000000000000,-0.000140000000000000,0,0,0;0,0,0,0,0,0,-1.00000000000000e-05,-36.5382200000000,-3.00000000000000e-05,0,0,0;0,0,0,0,0,0,0.000230000000000000,-1.00000000000000e-05,144.100520000000,0,0,0;0,0,0,0,0,0,0,0,0,-36.5887600000000,0.000280000000000000,-0.000160000000000000;0,0,0,0,0,0,0,0,0,-8.00000000000000e-05,36.6160900000000,-8.00000000000000e-05;0,0,0,0,0,0,0,0,0,0.000120000000000000,3.00000000000000e-05,143.504970000000];
% Cv3d = [-36.5216800000000,0.000230000000000000,-0.000170000000000000,0,0,0,0,0,0,0,0,0;0.000190000000000000,36.4763800000000,-0.000110000000000000,0,0,0,0,0,0,0,0,0;0.000210000000000000,5.00000000000000e-05,143.777000000000,0,0,0,0,0,0,0,0,0;0,0,0,36.4939500000000,2.00000000000000e-05,0.000200000000000000,0,0,0,0,0,0;0,0,0,0.000140000000000000,-36.5179400000000,0,0,0,0,0,0,0;0,0,0,0.000140000000000000,-6.00000000000000e-05,143.645000000000,0,0,0,0,0,0;0,0,0,0,0,0,36.5481000000000,0.000150000000000000,0,0,0,0;0,0,0,0,0,0,-1.00000000000000e-05,-36.5382200000000,-3.00000000000000e-05,0,0,0;0,0,0,0,0,0,0.000230000000000000,-1.00000000000000e-05,144.101000000000,0,0,0;0,0,0,0,0,0,0,0,0,-36.5887600000000,0.000280000000000000,0;0,0,0,0,0,0,0,0,0,-8.00000000000000e-05,36.6160900000000,-8.00000000000000e-05;0,0,0,0,0,0,0,0,0,0.000120000000000000,3.00000000000000e-05,143.505000000000];
Cv3d = [-73.0434040000000,0.000115000000000000,-8.50000000000000e-05,0,0,0,0,0,0,0,0,0;9.50000000000000e-05,72.9527960000000,-5.50000000000000e-05,0,0,0,0,0,0,0,0,0;0.000210000000000000,5.00000000000000e-05,143.776993000000,0,0,0,0,0,0,0,0,0;0,0,0,72.9878000000000,1.00000000000000e-05,0.000100000000000000,0,0,0,0,0,0;0,0,0,7.00000000000000e-05,-73.0357980000000,0,0,0,0,0,0,0;0,0,0,0.000140000000000000,-6.00000000000000e-05,143.645004000000,0,0,0,0,0,0;0,0,0,0,0,0,73.0962000000000,7.50000000000000e-05,0,0,0,0;0,0,0,0,0,0,-5.00000000000000e-06,-73.0764000000000,-1.50000000000000e-05,0,0,0;0,0,0,0,0,0,0.000230000000000000,-1.00000000000000e-05,144.100998000000,0,0,0;0,0,0,0,0,0,0,0,0,-73.1775980000000,0.000140000000000000,0;0,0,0,0,0,0,0,0,0,-4.00000000000000e-05,73.2322000000000,-4.00000000000000e-05;0,0,0,0,0,0,0,0,0,0.000120000000000000,3.00000000000000e-05,143.505005000000];

%% Scale Analog Channels
for i = 1:size(A,1)
    F(:,i) = Cv3d * A(i,:)';
end
SO = Cv3d * O';
O = O';
%% Filter Analog Channels
Fraw = sum(F([3,6,9,12],:),1);

for i = 1:12
    FF(i,:) = filtfilt(b,a,double(F(i,:)));
end




% Fx = -F(1,:) + F(4,:) + F(7,:) - F(10,:);
% Fy = F(2,:) - F(5,:) - F(8,:) + F(11,:);
% Fz = F(3,:) + F(6,:) + F(9,:) + F(12,:);

% Fx = F(2,:) + F(5,:) + F(8,:) + F(11,:);
% Fy = F(1,:) + F(4,:) + F(7,:) + F(10,:);
% Fz = F(3,:) + F(6,:) + F(9,:) + F(12,:);

% Fx = +F(1,:) + F(4,:) + F(7,:) + F(10,:);
% Fy = +F(2,:) + F(5,:) + F(8,:) + F(11,:);
% Fz = F(3,:) + F(6,:) + F(9,:) + F(12,:);

FFx = +FF(1,:) + FF(4,:) + FF(7,:) + FF(10,:);
FFy = +FF(2,:) + FF(5,:) + FF(8,:) + FF(11,:);
FFz = FF(3,:) + FF(6,:) + FF(9,:) + FF(12,:);

Fx = FFx;
Fy = FFy;
Fz = FFz;

%% Plattenmomente berechnen
% Mx = origins(1) * (FF(3,:) - FF(6,:) - FF(9,:) + FF(12,:))  +  origins(3) * (FF(2,:) + FF(5,:) + FF(8,:) + FF(11,:));
% My = origins(2) * (-FF(3,:) + FF(6,:) + FF(9,:) - FF(12,:)) +  origins(3) * (-FF(1,:) - FF(4,:) - FF(7,:) - FF(10,:));
% Mz = origins(1) * (-FF(1,:) + FF(4,:) + FF(7,:) - FF(10,:)) +  origins(2) * (FF(2,:) + FF(5,:) - FF(8,:) - FF(11,:));

% Mx = origins(1) * (F(3,:) - F(6,:) - F(9,:) + F(12,:))  +  origins(3) * (-F(2,:) - F(5,:) - F(8,:) - F(11,:));
% My = origins(2) * (-F(3,:) - F(6,:) + F(9,:) + F(12,:)) +  origins(3) * (F(1,:) + F(4,:) + F(7,:) + F(10,:));
% Mz = origins(1) * (-F(1,:) + F(4,:) + F(7,:) - F(10,:)) +  origins(2) * (F(2,:) + F(5,:) - F(8,:) - F(11,:));

Mx = origins(1) * (FF(3,:) - FF(6,:) - FF(9,:) + FF(12,:))  +  origins(3) * (-FF(2,:) - FF(5,:) - FF(8,:) - FF(11,:));
My = origins(2) * (-FF(3,:) - FF(6,:) + FF(9,:) + FF(12,:)) +  origins(3) * (FF(1,:) + FF(4,:) + FF(7,:) + FF(10,:));
Mz = origins(1) * (-FF(1,:) + FF(4,:) + FF(7,:) - FF(10,:)) +  origins(2) * (FF(2,:) + FF(5,:) - FF(8,:) - FF(11,:));

%% CoP berechnen

CoPx = ((My - origins(3)*2 * Fx)./-Fz) + origins(2)+ 0.035;
CoPy = -(-((Mx + origins(3)*2 * Fy)./Fz) + origins(1))- 0.035;
% CoPx = ((My - origins(3) * Fx)./-Fz) + origins(2) + 0.035;
% CoPy = -(-((Mx + origins(3) * Fy)./Fz) + origins(1)) - 0.035;


%% Free Moment berechnen
FMtemp = Mz - Fy.*(CoPx-origins(2)) + Fx.*(-CoPy-origins(1));
%% Comparison with Original Force V3D
% load('p:\brueggeman_install\OF.mat');
% load('p:\brueggeman_install\OCoP.mat');
% xorder = [1;4;7;10;13];
% yorder = [2;5;8;11;14];
% zorder = [3;6;9;12;15];
% for i = 1:size(OF,1)
%     for j = 1:5
%         FOx(i*5-(5-j)) = OF(i,xorder(j));
%         FOy(i*5-(5-j)) = OF(i,yorder(j));
%         FOz(i*5-(5-j)) = OF(i,zorder(j));
%         
%         OCoPx(i*5-(5-j)) = OCoP(i,xorder(j));
%         OCoPy(i*5-(5-j)) = OCoP(i,yorder(j));
%         OCoPz(i*5-(5-j)) = OCoP(i,zorder(j));
%     end
% end


%% CoP berechnen
% run = 1;
% for i = -0.1:0.0001:0.2
%     CoPx = ((My - i * Fx)./-Fz) + origins(2);
%     CoPy = -((Mx + i * Fy)./Fz) + origins(1);
%     differenz(1,run) = i;
%     differenz(2,run) = mean((OCoPx(3200:3500) - CoPy(3200:3500)).^2);
%     run = run+1;
% end
% [dmin, ndmin] = min(differenz(2,:));
%
% plot([-0.1:0.0001:0.2],differenz(2,:));


%% Parameter zusammenfassen zu Output
COP.Both = [CoPx; CoPy; zeros(1,length(CoPx))].*1000;
GRF.Both = [Fx;Fy;Fz];
GRFfilt.Both = [FFx;FFy;FFz];
FM.Both = [zeros(1,length(FMtemp)); zeros(1,length(FMtemp)); FMtemp];
try
    ind_baseline = barriers;
catch
   ind_baseline = 1:length(Fx); 
end

GRFfilt_vid.Both = GRFfilt.Both(:,1:OPTIONS.ftkratio:end);
COP_vid.Both = COP.Both(:,1:OPTIONS.ftkratio:end);


