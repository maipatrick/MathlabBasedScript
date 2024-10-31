function [COP, COP_vid, GRFfilt,GRFfilt_vid, FM, ind_baseline, O] = get_treadmill_GRF_GUI_MoTrack(file, OPTIONS, baseline_correct)
ind_baseline=0;
O = 0;
% close all
% clc
% [filename, pathname] = uigetfile('*.c3d', 'Daten her', 'C:\TextBL\Cond1\S001_test\');
% file = [pathname, filename];
% order = [2;1;3;5;4;6;8;7;9;11;10;12];
exp_flight = 40;
% origins = [354 ,	535 ,	43]./1000;

%% Filter coefficients
[b,a] = butter(2, OPTIONS.CutOffGRF/(OPTIONS.freqGRF/2), 'low');
[bp,ap] = butter(2, 10/(OPTIONS.freqGRF/2), 'low');
%% Read in Analog Channels for BAseline Correction
%% Express data into Newtons
% Step 1: convert to Volts
% acq = btkReadAcquisition(file);
% [analogs, analogsInfo] = btkGetAnalogs(acq);
% force = [analogs.F1X,analogs.F1Y,analogs.F1Z,analogs.M1X,analogs.M1Y,analogs.M1Z,analogs.F2X,analogs.F2Y,analogs.F2Z,analogs.M2X,analogs.M2Y,analogs.M2Z];
% range = 10; % +/- 5V
% resolution = 16; % resolution [bits]
% % force = force*range/(2^resolution);
 
% Step 2: convert to Newtons
% force(:,[1:2 7:8]) = force(:,[1:2 7:8])*500; % Fx and Fy of forceplates 1 and 2
% force(:,[3 9]) = force(:,[3 9])*1000; % Fz of forceplates 1 and 2
% force(:,[4 10]) = force(:,[4 10])*800; % these are moments x from forceplates 1 and 2
% force(:,[5 6 11 12]) = force(:,[5 6 11 12])*400; % these are moments y,z from forceplates 1 and 2
% 
% 
DAT.acq = load(file);
name = fieldnames (DAT.acq ); 
DAT.force = DAT.acq.(name{1, 1}).Force(OPTIONS.ForcePlateNumber).Force*-1;
DAT.moment = DAT.acq.(name{1, 1}).Force(OPTIONS.ForcePlateNumber).Moment*-1;
DAT.cop = DAT.acq.(name{1, 1}).Force(OPTIONS.ForcePlateNumber).COP*-1;


for i = 1: 3

GRFfilt(i,:) = filtfilt(b,a,double(DAT.force(i,:)));
DAT.FILTmoment(i,:) =  filtfilt(b,a,double(DAT.moment(i,:)));
COP(i,:) =  filtfilt(b,a,double(DAT.cop(i,:)));
end
FM = zeros (1, length(COP(1,:)));
GRFfilt_vid.Both = GRFfilt(:,1:OPTIONS.ftkratio:end);
COP_vid.Both = COP(:,1:OPTIONS.ftkratio:end);
a = 2;
%% filter force, moment and cop

% run = 1;
% for i = 6*OPTIONS.ForcePlateNumber-3
%     A  =force(:,i);
%     Afilt(:,run) = filtfilt(bp,ap,double(force(:,i)));
%     run = run+1;
% end
% % Fzbl = sum(A,2);
% Fzbl = -sum(A,2);
% Fzbl_filt = -sum(Afilt,2);
% % figure
% % plot(Fzbl)
% % hold on
% % plot(Fzbl_filt, 'r');
% upperlimit = min(Fzbl_filt) + 100;
% ind_low = find(Fzbl_filt < upperlimit);
% if ~isempty(find(diff(ind_low) > 100))
%     steps(1,:) = find(diff(ind_low) > 100);
%     for i = 1:length(steps)
%         stepsreal(1,i) = ind_low(steps(i));
%         stepsreal(2,i) = 1;
%         for j = stepsreal(1,i):-1:1
%             if Fzbl(j) > upperlimit
%                 stepsreal(2,i) = j;
%                 break
%             end
%         end
%     end
%     for i = 1:length(stepsreal)
%         barriers(1,i) = stepsreal(2,i) + round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
%         barriers(2,i) = stepsreal(1,i) - round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
%     end
%     for i = 1:length(steps)
%        plot([stepsreal(1,i) stepsreal(1,i)], get(gca, 'YLim'), 'k');
%        plot([stepsreal(2,i) stepsreal(2,i)], get(gca, 'YLim'), 'k');
%        plot([barriers(1,i) barriers(1,i)], get(gca, 'YLim'), 'g');
%        plot([barriers(2,i) barriers(2,i)], get(gca, 'YLim'), 'g');
%     end
%     plot(get(gca, 'Xlim'), [upperlimit upperlimit], 'k');
%     assignin('base', 'ind_low', ind_low);
%     assignin('base', 'steps', steps);
%     assignin('base', 'stepsreal', stepsreal);
%     assignin('base', 'barriers', barriers);
%     pause
    
%     barriervalues = [];
%     for i = 1:length(barriers)-1
%         barriervalues = [barriervalues, [barriers(1,i+1):barriers(2,i+1)]];
%     end
% else
%     barriervalues = 1:length(Fzbl);
% end
% assignin('base', 'barriervalues', barriervalues);
% 


% %% Baseline correction
% O = mean(force(barriervalues,:),1);
% for i = 1:12
%     if baseline_correct
%         force(:,i) = force(:,i) - O(i);
%     end
% end


%% Filter Analog Channels

% 
% for i = 1:12
%     FF(i,:) = filtfilt(b,a,double(force(:,i)))';
% end

% %% Rotate forces to MoTrack Global Coordinate System
% Rforce = [0 1 0;1 0 0;0 0 -1];
% for i = 1:3:12
%    for j = 1:size(force,1)
%        Frot(i:i+2,j) = Rforce'*FF(i:i+2,j);
%    end
% end

% %% CoP berechnen
% for j = 1:size(Frot,2)
%     CoP1(1,j) = ((-0.015*Frot(7,j)+Frot(11,j)) / -Frot(9,j)).*1000 ;
%     CoP1(2,j) = ((0.015*Frot(8,j)+Frot(10,j)) / Frot(9,j)).*1000;
%     CoP1(3,j) = 0;
% end




% %% Free Moment berechnen
% FMtemp = Frot(12,:) - Frot(8,:).*(CoP1(1,:)./1000) + Frot(7,:).*(CoP1(2,:)./1000);
% 
% 


% %% Parameter zusammenfassen zu Output
% for pp  =1:size(CoP1, 2)
%     COP.Both(:,pp) = CoP1(:,pp) + [-1627; -1180; 0];
% end
% GRFfilt.Both = Frot(7:9,:);
% FM.Both = [zeros(1,length(FMtemp)); zeros(1,length(FMtemp)); FMtemp];
% try
%     ind_baseline = barriers;
% catch
%    ind_baseline = 1:length(FM.Both); 
% end
% 
% GRFfilt_vid.Both = GRFfilt.Both(:,1:OPTIONS.ftkratio:end);
% COP_vid.Both = COP.Both(:,1:OPTIONS.ftkratio:end);



