function [FP] = optimize_force_mill(MARKERS, OPTIONS,FP)


stepEvents = detectTD_TO_events(FP.GRFfilt.Both(end,:), OPTIONS.ForceTreshold, 30);
stepEvents_vid = fix(stepEvents./OPTIONS.ftkratio);

%% all events now I need to get onlz valid events this is when
%a) the foot markers at each TD are within the boundaries of the force
%plate
%b) cop within the foot marker of the leg of interest
% first redeterime TD and TO considering all steps
% simple version for now
% if strcmp(OPTIONS.AnalyzedLeg, 'L')
%
% else
%
% end
%
force = FP.GRFfilt.Both(:,:);
cop = FP.COP.Both(:,:);
for i = 2: 2:length(stepEvents)
    stepEvents(i,1);
    stepEvents(i,2);
    force(:,[stepEvents(i,1)-300: stepEvents(i,2)]+200)  = 0;
    cop(:,[stepEvents(i,1)-300: stepEvents(i,2)]+200)  = 0;
    % FP.COP_vid.Left(:,[stepEvents(i,1), stepEvents(i,2)])  == 0;
    % FP.GRFfilt_vid.Left(:,[stepEvents(i,1), stepEvents(i,2)]) == 0;
end
lauf = 1;
for i = 1: 2:length(stepEvents)
    FP.CONTACT(1,lauf) = stepEvents(i,1);
    FP.CONTACT(2,lauf) = stepEvents(i,2);
    FP.CONTACT_vid(1,lauf) = fix(stepEvents(i,1)/OPTIONS.ftkratio);
    FP.CONTACT_vid(2,lauf) = fix(stepEvents(i,2)/OPTIONS.ftkratio);
    lauf = lauf+1;
    % FP.COP_vid.Left(:,[stepEvents(i,1), stepEvents(i,2)])  == 0;
    % FP.GRFfilt_vid.Left(:,[stepEvents(i,1), stepEvents(i,2)]) == 0;
end
FP.COP.Left = cop;
FP.GRFfilt.Left = force;

%%
% %plot fp corners
% for c = 1 : 4
%     scatter(FP.CORNERPOINTS(c,1), FP.CORNERPOINTS(c,2), 'MarkerFaceColor','k', 'MarkerEdgeColor','flat')
%     hold on
%     if c <=3
%         plot ([FP.CORNERPOINTS(c,1), FP.CORNERPOINTS(c+1,1)], [FP.CORNERPOINTS(c,2), FP.CORNERPOINTS(c+1,2)], 'k')
%     else
%         plot ([FP.CORNERPOINTS(1,1), FP.CORNERPOINTS(4,1)], [FP.CORNERPOINTS(1,2), FP.CORNERPOINTS(4,2)], 'k')
%     end
% end
% scatter(MARKERS.Filt.forefoot_lat_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.forefoot_lat_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(MARKERS.Filt.forefoot_med_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.forefoot_med_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(MARKERS.Filt.toe_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.toe_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(MARKERS.Filt.calc_back_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.calc_back_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(MARKERS.Filt.calc_lat_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.calc_lat_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(MARKERS.Filt.calc_med_left.data(1, FP.CONTACT_vid(1,1)),MARKERS.Filt.calc_med_left.data(2, FP.CONTACT_vid(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','r' )
% scatter(cop(1, FP.CONTACT(1,1)),cop(2, FP.CONTACT(1,1)), 'MarkerEdgeColor','flat', 'MarkerFaceColor','g' )
% 
% axis equal
end