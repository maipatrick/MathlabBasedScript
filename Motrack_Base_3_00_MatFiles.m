function Motrack_Base_2_11()
%MoTrackBase is the main function incooperating the key functionality of
%the program

% Data is shared between all child functions by declaring the variables
% here (they become global to the function). We keep things tidy by putting
% all GUI stuff in one structure and all data stuff in another. As the app
% grows, we might consider making these objects rather than structures.
% test PM
data = createData();
gui = createInterface();



%-------------------------------------------------------------------------%
    function data = createData()
        % Create the shared data-structure for this application
        data.Report{1}.Header = 'Joint Kinematics';
        data.Report{1}.Replace = 'Kapitel1';


    end % createData

%-------------------------------------------------------------------------%
    function gui = createInterface()
        % Create the user interface for the application and return a
        % structure of handles for global use.
        gui = struct();
        % Open a window and add some menus
        gui.Window = figure( ...
            'Name', 'MoTrack', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'Color', [1 1 1], ...
            'Position', [100 100 1200 800], ...
            'HandleVisibility', 'off' );


        % + File menu
        gui.FileMenu = uimenu( gui.Window, 'Label', 'File' );
        uimenu( gui.FileMenu, 'Label', 'Save Log File', 'Callback', @onSaveLogFile );
        uimenu( gui.FileMenu, 'Label', 'Exit', 'Callback', @onExit );

        % + View menu
        gui.ViewMenu = uimenu( gui.Window, 'Label', 'View' );


        % + Help menu
        helpMenu = uimenu( gui.Window, 'Label', 'Help' );
        uimenu( helpMenu, 'Label', 'Documentation', 'Callback', @onHelp );


        % Arrange the main interface
        mainLayout = uix.VBox( 'Parent', gui.Window, 'Spacing', 3 , 'Position', [0 0 1 1], 'BackgroundColor', [1 1 1]);
        VLogoAxes = axes( 'Parent', mainLayout,  ...
            'Position', [0 1010 590 200]);

        imshow('header.jpg', 'Parent', VLogoAxes);

        % + Create the panels
        gui.mainPanel = uix.TabPanel( 'Parent', mainLayout, 'Padding', 4 , 'Position', [0 0 1200 500], 'BackgroundColor', [1 1 1], 'HighlightColor', [1 1 1]);
        set(mainLayout, 'Heights', [170;630])
        p1 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        p2 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        p3 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        p4 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        p5 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        %         p6 = uipanel( gui.mainPanel, 'BackgroundColor', [1 1 1]);
        gui.mainPanel.TabTitles = {'Conditions', 'Subjects', 'Settings', 'Run Model', 'Analysis/Reporting'};% '', ''};
        gui.mainPanel.Selection = 1;
        gui.mainPanel.FontName = 'Arial';
        gui.mainPanel.FontSize = 14;

        gui.sfolder = 'c:\m_files\TUD\';
        % + Create the panels


        % + Adjust the main layout
        set( gui.mainPanel, 'TabWidth', 160  );



        % + Create the controls
        % Create data structure
        data.errorlog = {};
        % Create Tab1 Components
        gui.ConditionsList = uicontrol( 'Style', 'list', ...
            'BackgroundColor', 'w', ...
            'FontSize', 12, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Center', ...
            'Parent', p1, ...
            'Position', [10 170 516 217], ...
            'String', {});

        gui.BrowseTopFolder = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [446 430 80 25], ...
            'String', 'Browse', ...
            'Callback', @onBrowseTopFolder);

        gui.LoadExistingConditions = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [540 390 250 25], ...
            'String', 'Load existing Conditions', ...
            'Callback', @onLoadExistingConditions);

        uicontrol('Style', 'text', ...
            'String', 'Top Folder: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p1, ...
            'Position', [10 455 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Left', ...
            'Visible', 'on');

        gui.EditTopFolder = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [10 430 435 25], ...
            'String', 'Please selct top folder for the study / analysis');

        gui.ConditionToAdd = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [10 390 503 25], ...
            'String', 'Condition Name');

        gui.AddCondition = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [447 390 38 25], ...
            'String', '+', ...
            'Callback', @onAddCondition);

        gui.RemCondition = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [488 390 38 25], ...
            'String', '-', ...
            'Callback', @onRemCondition);

        gui.CreateFolderStructure = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [10 10 250 40], ...
            'String', 'Create Folder Structure', ...
            'Callback', @onCreateFolderStructure);

        gui.Next1 = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p1, ...
            'Position', [1000 10 140 40], ...
            'String', 'Next -->', ...
            'Callback', @onNext);



        % Create Tab2 Components
        gui.Back2 = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [10 10 250 40], ...
            'String', '<-- Back', ...
            'Callback', @onBack);

        gui.Next2 = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [1000 10 140 40], ...
            'String', 'Next -->', ...
            'Callback', @onNext);

        uicontrol('Style', 'text', ...
            'String', 'Name: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p2, ...
            'Position', [10 498 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.Name = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [263 500 300 25], ...
            'String', '');

        uicontrol('Style', 'text', ...
            'String', 'Age (years): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p2, ...
            'Position', [10 458 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.Age = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [263 460 300 25], ...
            'String', '');
        uicontrol('Style', 'text', ...
            'String', 'Body Height (cm): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p2, ...
            'Position', [10 418 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.Height = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [263 420 300 25], ...
            'String', '');
        uicontrol('Style', 'text', ...
            'String', 'Body Mass (kg): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p2, ...
            'Position', [10 378 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.Mass = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [263 380 300 25], ...
            'String', '');
        uicontrol('Style', 'text', ...
            'String', 'Foot Length (cm): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p2, ...
            'Position', [10 338 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.FootLength = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [263 340 300 25], ...
            'String', '');

        gui.AddSubject = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [607 490 38 25], ...
            'String', '+', ...
            'Callback', @onAddSubject);

        gui.RemSubject = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [648 490 38 25], ...
            'String', '-', ...
            'Callback', @onRemSubject);

        gui.LoadExistingSubjects = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [560 540 200 25], ...
            'String', 'Load existing Subjects', ...
            'Callback', @onLoadExistingSubjects);

        gui.LoadExistingSubjects = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [560 540 200 25], ...
            'String', 'Load existing Subjects', ...
            'Callback', @onLoadExistingSubjects);

        gui.LoadSubjectsFromExcel = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [765 540 300 25], ...
            'String', 'Load Subjects from Excel', ...
            'Callback', @onLoadSubjectsFromExcel);

        gui.SubjectList = uicontrol( 'Style', 'list', ...
            'BackgroundColor', 'w', ...
            'FontSize', 10, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Center', ...
            'Parent', p2, ...
            'Position', [750 100 350 425], ...
            'String', {},...
            'Callback', @onSubjectList);

        gui.ExpandFolderStructure = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [500 10 250 40], ...
            'String', 'Expand Folder Structure', ...
            'Callback', @onExpandFolderStructure);
        gui.UpdateCSV = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p2, ...
            'Position', [290 280 250 40], ...
            'String', 'Save Anthro Changes', ...
            'Callback', @onUpdateCSV);

        % Create tab3 components
        uicontrol('Style', 'text', ...
            'String', 'Experimental Setup: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 538 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.ExperimentalSetup = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 540 300 25], ...
            'String', {'Overground - No Phase Detection','Treadmill - No Phase Detection','Treadmill - Running Kinematic Phase Detection', 'Overground - Knee flexion based detection', 'Treadmill - Walking Kinematic Phase Detection', 'Bertec Instrumented Treadmill Running (Kinematics + Kinetics)', 'Locomotion - Stance Phase Overground (1 FP)','Treadmetrix Instrumented Treadmill Running (Kinematics + Kinetics)', 'Kinematics Only - Event Based Detection', 'Treadmill Running - Zebris based detection'},...
            'Callback', @onExperimentalSetup);
        %         'String', {'Overground - No Phase Detection','Overground - Force Plate Phase Detection','Overground - Event Phase Detection','Treadmill - No Phase Detection','Treadmill - Force Plate Phase Detection','Treadmill - Event Phase Detection'});
        gui.NstepsText = uicontrol('Style', 'text', ...
            'String', 'Steps: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [570 538 60 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'off');
        gui.Nsteps = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [630 540 100 25], ...
            'Visible', 'off', ...
            'String', '1');
        uicontrol('Style', 'text', ...
            'String', 'Running Speed (m/s): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 498 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.RunningSpeed = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 500 100 25], ...
            'String', '1');

        uicontrol('Style', 'text', ...
            'String', 'Static Reference Specifier: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 458 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.RefSpecifier = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 460 100 25], ...
            'String', 'Static');
        uicontrol('Style', 'text', ...
            'String', 'Filter Order Kinematic Data: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 418 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.FilterOrderKinematics = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 420 100 25], ...
            'String', '4');
        uicontrol('Style', 'text', ...
            'String', 'Cut-Off Frequency Kinematic Data (Hz): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 378 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.CutOffKinematics = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 380 100 25], ...
            'String', '20');
        gui.FilterOrderForceText = uicontrol('Style', 'text', ...
            'String', 'Filter Order Force Data: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 338 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'off');
        gui.FilterOrderForce = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 340 100 25], ...
            'Visible', 'off', ...
            'String', '4');
        gui.CutOffForceText = uicontrol('Style', 'text', ...
            'String', 'Cut-Off Frequency Force Data (Hz): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 298 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'off');
        gui.CutOffForce = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 300 100 25], ...
            'Visible', 'off', ...
            'String', '20');

        uicontrol('Style', 'text', ...
            'String', 'Analyzed Leg: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 258 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.AnalyzedLeg = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 260 100 25], ...
            'Visible', 'on', ...
            'String', {'Right','Left','Both'});

        gui.ForcePlateNumberText = uicontrol('Style', 'text', ...
            'String', 'Force Plate Number: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 218 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'off');

        gui.ForcePlateNumber = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 220 100 25], ...
            'Visible', 'on', ...
            'String', {'1','2','3','4','5','6', '7','8','9','10','11','12'}, ...
            'Value', 2);

        gui.ForceTresholdText = uicontrol('Style', 'text', ...
            'String', 'Stance Detection Threshold (N): ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [10 178 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'off');

        gui.ForceTreshold = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [263 180 100 25], ...
            'Visible', 'off', ...
            'String', {'50'});

        gui.RotateMarkersButton = uicontrol('Style', 'pushbutton', ...
            'String', 'Rotate Traj.', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [800 50 100 25], ...
            'BackgroundColor', [1 1 1], ...
            'Callback', @onRotateMarkersButton,...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');

        gui.RotateMarkersEdit = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [905 50 200 25], ...
            'Visible', 'on', ...
            'String', {'[1 0 0; 0 1 0; 0 0 1]'});

        gui.Back3 = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [10 10 250 40], ...
            'String', '<-- Back', ...
            'Callback', @onBack);

        gui.Next3 = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [1000 10 140 40], ...
            'String', 'Next -->', ...
            'Callback', @onNext);

        startData = [cell(78,1),{'head_front_left';'head_front_right';'head_back_right';'head_back_left';'ear_left';'ear_right';'C_7';'B_10';'SIAS_left';'SIAS_right';'SIPS_right';'SIPS_left';'acrom_left';'acrom_right';'clav';'sternum';'shoulder_left';'elbow_top_left';'elbow_med_left';'elbow_lat_left';'shoulder_right';'elbow_top_right';'elbow_med_right';'elbow_lat_right';'hand_med_left';'hand_lat_left';'hand_top_left';'hand_med_right';'hand_lat_right';'hand_top_right';'epi_lat_left';'epi_med_left';'epi_lat_right';'epi_med_right';'mal_lat_left';'mal_med_left';'mal_lat_right';'mal_med_right';'calc_med_left';'calc_back_left';'calc_lat_left';'calc_med_right';'calc_back_right';'calc_lat_right';'forfoot_med_right';'forfoot_lat_right';'toe_right';'forefoot_med_left';'forefoot_lat_left';'toe_left';'cluster_upperarm_left_1';'cluster_upperarm_left_2';'cluster_upperarm_left_3';'cluster_lowerarm_left_1';'cluster_lowerarm_left_2';'cluster_lowerarm_left_3';'cluster_lowerarm_right_1';'cluster_lowerarm_right_2';'cluster_lowerarm_right_3';'cluster_upperarm_right_1';'cluster_upperarm_right_2';'cluster_upperarm_right_3';'cluster_femur_left_1';'cluster_femur_left_2';'cluster_femur_left_3';'cluster_femur_left_4';'cluster_femur_right_1';'cluster_femur_right_2';'cluster_femur_right_3';'cluster_femur_right_4';'cluster_tibia_left_1';'cluster_tibia_left_2';'cluster_tibia_left_3';'cluster_tibia_left_4';'cluster_tibia_right_1';'cluster_tibia_right_2';'cluster_tibia_right_3';'cluster_tibia_right_4'}];
        gui.MarkerTable = uitable(p3,'Data',startData,...
            'Position', [900 150 250 400],...
            'ColumnName', {'Is', 'New'},...
            'CellSelectionCallback', @onMarkerTableSelection,...
            'ColumnEditable', [true true]);
        %             'ColumnWidth', '125');
        gui.BrowseOldC3D = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [1050 552 100 25], ...
            'String', 'Browse', ...
            'Callback', @onBrowseOldC3D);
        gui.OldMarkerList = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 10, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Center', ...
            'Parent', p3, ...
            'Position', [900 550 150 25], ...
            'String', {'Load from C3D'});
        gui.ChangeMarkerNames = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [900 100 250 40], ...
            'String', 'Change Marker Names', ...
            'Callback', @onChangeMarkerNames);
        gui.SaveAnalogData = uicontrol( 'Style', 'checkbox', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'BackgroundColor', [1 1 1], ...
            'Position', [50 100 250 40], ...
            'String', 'Save Analog Data');
        gui.UseRawContact = uicontrol('Style', 'checkbox', ...
            'String', 'Use raw GRF for contact detection', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [50 135 400 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Left', ...
            'Value', 1,...
            'Visible', 'off');
        gui.RefToStatic = uicontrol('Style', 'checkbox', ...
            'String', 'Reference Joint Angles to Static Trial', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p3, ...
            'Position', [50 75 400 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Left', ...
            'Value', 0,...
            'Visible', 'on');
        gui.MarkerSetPictureList = {'Fontal_inkl_Marker.jpg'; 'Dorsal_inkl_Marker.jpg'; 'Links_inkl_Marker.jpg'; 'Rechts_inkl_Marker.jpg'; 'Arm_links_inkl_Marker.jpg'; 'Arm_rechts_inkl_Marker.jpg';'Fuesse_inkl_Marker.jpg'};
        gui.MarkerSetActPict = 1;

        gui.MarkerSetPlot = axes( 'Parent', p3,  ...
            'Position', [0.33 0.15 0.40 0.7]);
        try
            imshow('Fontal_inkl_Marker.jpg', 'Parent', gui.MarkerSetPlot);
            gui.MarkerSetNext = uicontrol( 'Style', 'pushbutton', ...
                'FontSize', 14, ...
                'FontName', 'Arial', ...
                'HorizontalAlignment', 'Left', ...
                'Parent', p3, ...
                'Position', [590 50 38 25], ...
                'String', '>', ...
                'Callback', @onMarkerSetNext);
        catch
        end
        gui.MarkerSetPrevious = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p3, ...
            'Position', [635 50 38 25], ...
            'String', '<', ...
            'Callback', @onMarkerSetPrevious);

        % Create tab4 components
        gui.Back4 = uicontrol( 'Style', 'pushbutton', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p4, ...
            'Position', [10 10 250 40], ...
            'String', '<-- Back', ...
            'Callback', @onBack);

        gui.Next4 = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p4, ...
            'Position', [1000 10 140 40], ...
            'String', 'Next -->', ...
            'Callback', @onNext);

        gui.RunModel = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p4, ...
            'Position', [10 400 140 40], ...
            'String', 'Run Model', ...
            'Callback', @onRunModel);
        uicontrol('Style', 'text', ...
            'String', 'Which conditions to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p4, ...
            'Position', [10 178 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.WhichConditions = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p4, ...
            'Position', [263 180 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Which subjects to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p4, ...
            'Position', [10 148 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.WhichSubjects = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p4, ...
            'Position', [263 150 100 25], ...
            'Visible', 'on', ...
            'String', {':'});


        % Create tab5 components
        uicontrol('Style', 'text', ...
            'String', 'Which conditions to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 478 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.SingleGraphsWhichConditions = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 480 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Which subjects to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 448 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.SingleGraphsWhichSubjects = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 450 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Which leg?: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 418 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.SingleGraphsAnalyzedLeg = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 420 100 25], ...
            'Visible', 'on', ...
            'String', {'Right','Left'});


        uicontrol('Style', 'text', ...
            'String', 'Results Folder: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 388 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.SingleGraphsFolder = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 390 100 25], ...
            'Visible', 'on', ...
            'String', {'Please select folder'});
        gui.SingleGraphsBrowse = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [365 390 70 25], ...
            'String', 'Browse', ...
            'Callback', @onSingleGraphsBrowse);
        gui.SingleGraphs = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [213 510 200 25], ...
            'String', 'Single Subject Graphs', ...
            'Callback', @onSingleGraphs);

        uicontrol('Style', 'text', ...
            'String', 'Which conditions to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [510 478 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.MeanGraphsWhichConditions = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [763 480 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Which leg?: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [510 418 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.MeanGraphsAnalyzedLeg = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [763 420 100 25], ...
            'Visible', 'on', ...
            'String', {'Right','Left'});
        uicontrol('Style', 'text', ...
            'String', 'Results Folder: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [510 388 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.MeanGraphsFolder = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [763 390 100 25], ...
            'Visible', 'on', ...
            'String', {'Please select folder'});
        gui.MeanGraphsBrowse = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [865 390 70 25], ...
            'String', 'Browse', ...
            'Callback', @onMeanGraphsBrowse);
        uicontrol('Style', 'text', ...
            'String', 'Which subjects to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [510 448 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.MeanGraphsWhichSubjects = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [763 450 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        gui.MeanGraphs = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [713 510 200 25], ...
            'String', 'Mean Graphs Graphs', ...
            'Callback', @onMeanGraphs);




        uicontrol('Style', 'text', ...
            'String', 'Which conditions to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 178 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.RLGraphsWhichConditions = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 180 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Which subjects to analyze: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 148 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.RLGraphsWhichSubjects = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 150 100 25], ...
            'Visible', 'on', ...
            'String', {':'});
        uicontrol('Style', 'text', ...
            'String', 'Results Folder: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [10 118 250 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.RLGraphsFolder = uicontrol( 'Style', 'edit', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [263 120 100 25], ...
            'Visible', 'on', ...
            'String', {'Please select folder'});
        gui.RLGraphsBrowse = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [365 120 70 25], ...
            'String', 'Browse', ...
            'Callback', @onRLGraphsBrowse);
        gui.RLGraphs = uicontrol( 'Style', 'pushbutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [213 210 200 25], ...
            'String', 'Right/Left Graphs', ...
            'Callback', @onRLGraphs);

        uicontrol('Style', 'text', ...
            'String', 'Graph language: ', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'Parent', p5, ...
            'Position', [600 118 200 25], ...
            'BackgroundColor', [1 1 1], ...
            'HorizontalAlignment', 'Right', ...
            'Visible', 'on');
        gui.GraphLanguage = uicontrol( 'Style', 'popupmenu', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [800 120 100 25], ...
            'Visible', 'on', ...
            'String', {'English','German'});
        gui.SaveSVG = uicontrol( 'Style', 'radiobutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [600 50 300 25], ...
            'Visible', 'on', ...
            'String', 'Save .svg graphs?');
        gui.SaveFIG = uicontrol( 'Style', 'radiobutton', ...
            'BackgroundColor', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'Left', ...
            'Parent', p5, ...
            'Position', [600 30 300 25], ...
            'Visible', 'on', ...
            'String', 'Save .fig graphs?');

    end % createInterface

%-------------------------------------------------------------------------%
% Callback Functions
%-------------------------------------------------------------------------%

% Callback Functions Tab1
    function onBrowseTopFolder(~,~)

        set(gui.EditTopFolder, 'String', uigetdir('c:\', 'Bitte Ordner angeben'));
    end % onBrowseTopFolder

% Add a new condition to the project
    function onAddCondition(~,~)
        actString = get(gui.ConditionsList, 'String');
        newString = get(gui.ConditionToAdd, 'String');

        lString = length(actString);
        actString{lString+1,1} = newString;

        set(gui.ConditionsList, 'String', actString);
        set(gui.ConditionsList, 'Value', lString+1);

    end % onAddCondition

% Remove a condition from the project
    function onRemCondition(~,~)
        actString = get(gui.ConditionsList, 'String');
        actVal = get(gui.ConditionsList, 'Value');
        lString = length(actString);
        if lString == 1
            set(gui.ConditionsList, 'Value', 1);
            set(gui.ConditionsList, 'String', '');
        else
            if actVal == lString
                actString = actString(1:actVal-1);
                set(gui.ConditionsList, 'Value', lString-1);
                set(gui.ConditionsList, 'String', actString);
            else
                for v = actVal:lString-1
                    actString(v) = actString(v+1);
                    set(gui.ConditionsList, 'String', actString(1:end-1));
                end
            end
        end
    end % % onRemCondition

% Load already existing conditions from an existing folder structure
    function onLoadExistingConditions(~,~)
        pathname = uigetdir(get(gui.EditTopFolder, 'String'));
        contents = dir(pathname);
        r = 1;
        for i = 3:length(contents)
            if contents(i).isdir
                NewList(r,1) = {contents(i).name};  %#ok<AGROW>
                r = r+1;
            end
        end
        set(gui.ConditionsList, 'String', NewList);
    end % onLoadExistingConditions

% Generates a new folder structure from the existing condition list
    function onCreateFolderStructure(~,~)
        data.OPTIONS.TopFolder = get(gui.EditTopFolder, 'String');
        data.OPTIONS.ConditionFolders = get(gui.ConditionsList, 'String');

        for i = 1:length(data.OPTIONS.ConditionFolders)
            mkdir([data.OPTIONS.TopFolder, '\', data.OPTIONS.ConditionFolders{i}]);
        end
    end % onCreateFolderStructure

% Go to the next tab
    function onNext(~,~)
        try
            set(gui.mainPanel, 'Selection', get(gui.mainPanel, 'Selection') + 1);
        catch
        end
    end % onNext

% Go to the previous tab
    function onBack(~,~)
        try
            set(gui.mainPanel, 'Selection', get(gui.mainPanel, 'Selection') - 1);
        catch
        end
    end % onBack

% Creates a new subject using the information provided in the edit fields
% on the right hand side of the Subjects Tab. Information is also stored in
% the data.Subjets structure.
    function onAddSubject(~,~)
        actString = get(gui.SubjectList, 'String');
        lString = length(actString);
        actVal = lString+1;
        if actVal < 10
            newString = ['S00',num2str(actVal),'_', get(gui.Name, 'String')];
        elseif actVal < 100
            newString = ['S0',num2str(actVal),'_', get(gui.Name, 'String')];
        else
            newString = ['S',num2str(actVal),'_', get(gui.Name, 'String')];
        end

        actString{lString+1,1} = newString;
        set(gui.SubjectList, 'String', actString);
        set(gui.SubjectList, 'Value', lString+1);

        data.Subjects{actVal}.Name = newString;
        data.Subjects{actVal}.Age = str2double(get(gui.Age, 'String'));
        data.Subjects{actVal}.Height = str2double(get(gui.Height, 'String'));
        data.Subjects{actVal}.Mass = str2double(get(gui.Mass, 'String'));
        data.Subjects{actVal}.FootLength = str2double(get(gui.FootLength, 'String'));

        assignin('base', 'data', data);
    end % onAddSubject

% Removes a subject from the subject list
    function onRemSubject(~,~)
        actString = get(gui.SubjectList, 'String');
        actVal = get(gui.SubjectList, 'Value');
        lString = length(actString);
        if actVal == lString
            actString = actString(1:actVal-1);
            set(gui.SubjectList, 'Value', lString-1);
            set(gui.SubjectList, 'String', actString);
            data.Subjects = data.Subjects(1:end-1);
        else
            for v = actVal:lString-1
                actString(v) = actString(v+1);
                set(gui.SubjectList, 'String', actString(1:end-1));
                data.Subjects{v} = data.Subjects{v+1};
            end
            data.Subjects = data.Subjects(1:end-1);
        end
        assignin('base', 'data', data);
    end % % onRemSubject

% Loads already esisting subjects from an existing folder structure.
    function onLoadExistingSubjects(~,~)
        pathname = uigetdir(get(gui.EditTopFolder, 'String'));
        contents = dir(pathname);
        r = 1;
        for i = 3:length(contents)
            if contents(i).isdir
                NewList(r,1) = {contents(i).name};  %#ok<AGROW>
                r = r+1;
            end
        end
        set(gui.SubjectList, 'String', NewList);
        set(gui.SubjectList, 'Value', length(NewList));
        updateAnthro(length(NewList));
    end % onLoadExistingSubjects

% Loads subject list from Excel file
    function onLoadSubjectsFromExcel(~,~)
        [filename, pathname] = uigetfile('*.xlsx', 'Please choose .xlsx anthro file',get(gui.EditTopFolder, 'String'));
        [N,T] = xlsread([pathname, filename]);
        r = 1;
        for i = 2:size(T,1)
            if i-1 < 10
                %                 NewList(r,1) = {['S00',num2str(i-1),'_',T{i}]};
                NewList(r,1) = {[T{i}]};
            elseif i-1 < 100
                %                 NewList(r,1) = {['S0',num2str(i-1),'_',T{i}]};
                NewList(r,1) = {[T{i}]};
            else
                %                 NewList(r,1) = {['S',num2str(i-1),'_',T{i}]};
                NewList(r,1) = {[T{i}]};
            end
            data.Subjects{i-1}.Name = T{i};
            data.Subjects{i-1}.Age = N(i-1,3);
            data.Subjects{i-1}.Height = N(i-1,1);
            data.Subjects{i-1}.Mass = N(i-1,2);
            data.Subjects{i-1}.FootLength = N(i-1,4);
            r = r+1;
        end
        set(gui.SubjectList, 'String', NewList);
        set(gui.SubjectList, 'Value', length(NewList));

    end %onLoadSubjectsFromExcel

% Executes when a subject from the subject list is being selected.
    function onSubjectList(~,~)
        ind = get(gui.SubjectList, 'Value');
        updateAnthro(ind);
    end %onSubjectList

% Updates the information in the left hand side edit fields based on the
% information contained in the individual subject anthro .csv
    function updateAnthro(ind)
        try
            TFolder = get(gui.EditTopFolder, 'String');
            CondNames = get(gui.ConditionsList, 'String');
            SubjNames = get(gui.SubjectList, 'String');
            CSVs = dir([TFolder, '\', CondNames{1}, '\', SubjNames{ind},'\','*.csv']);
            try
                CSVDATA = csvread([TFolder, '\', CondNames{1}, '\', SubjNames{ind},'\',CSVs.name]);
            catch
                CSVDATA = xlsread([TFolder, '\', CondNames{1}, '\', SubjNames{ind},'\',CSVs.name]);

            end
            set(gui.Name, 'String', CSVs.name(1:end-4));
            set(gui.Height, 'String', num2str(CSVDATA(1)));
            set(gui.Mass, 'String', num2str(CSVDATA(2)));
            set(gui.FootLength, 'String', num2str(CSVDATA(3)));
            set(gui.Age, 'String', num2str(CSVDATA(4)));
        catch
            data.errorlog = [data.errorlog; {['Problems with folder structure - Not the same number of subjects in all conditions?']}];
        end
    end %updateAnthro

% Expands the conditions folder structure to include subfolders for each
% subjet in each condition folder.
    function onExpandFolderStructure(~,~)

        for ncond = 1:length(data.OPTIONS.ConditionFolders)
            for i = 1:length(data.Subjects)
                mkdir([data.OPTIONS.TopFolder, '\', data.OPTIONS.ConditionFolders{ncond}, '\', data.Subjects{i}.Name]);
                SubInfo = [data.Subjects{i}.Height; data.Subjects{i}.Mass; data.Subjects{i}.FootLength; data.Subjects{i}.Age];
                csvwrite([data.OPTIONS.TopFolder, '\', data.OPTIONS.ConditionFolders{ncond},...
                    '\', data.Subjects{i}.Name,'\', data.Subjects{i}.Name, '.csv'], SubInfo);
            end
        end
    end % onExpandFolderStructure

% Updates the information contained in the indivudual anthro file based on
% the new information in the edit fields on the left hand side of the
% Subjects tab.
    function onUpdateCSV(~,~)
        actVal = get(gui.SubjectList, 'Value');
        TopFolder = get(gui.EditTopFolder, 'String');
        ConFolders = get(gui.ConditionsList, 'String');
        data.Subjects{actVal}.Name = get(gui.Name, 'String');
        data.Subjects{actVal}.Age = str2double(get(gui.Age, 'String'));
        data.Subjects{actVal}.Height = str2double(get(gui.Height, 'String'));
        data.Subjects{actVal}.Mass = str2double(get(gui.Mass, 'String'));
        data.Subjects{actVal}.FootLength = str2double(get(gui.FootLength, 'String'));

        for ncond = 1:length(ConFolders)
            for i = actVal

                SubInfo = [data.Subjects{i}.Height; data.Subjects{i}.Mass; data.Subjects{i}.FootLength; data.Subjects{i}.Age];
                csvwrite([TopFolder, '\', ConFolders{ncond},...
                    '\', data.Subjects{i}.Name,'\', data.Subjects{i}.Name, '.csv'], SubInfo);
            end
        end
    end %onUpdateCSV

    function onBrowseOldC3D(~,~)
        %Loads marker labels from a .c3d file as inout for the change marker label functionality
        [filename, pathname] = uigetfile('*.c3d', 'Please select example c3d file', 'c:\');
        [~, Labels, ~, ~, ~, ~, ~] = getlabeledmarkers_GUI([pathname, filename]);
        set(gui.OldMarkerList, 'String', Labels);
    end %onBrowseOldC3D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function onMarkerTableSelection(~,xc)
        % if you select a certain entry in the Marker Table, then this
        % entry will be replaced by the current value in the old marker
        % list on top of the marker table
        if ~isempty(xc.Indices)
            oldData = get(gui.MarkerTable, 'Data');
            sampleData = get(gui.OldMarkerList, 'String');
            ValsampleData = get(gui.OldMarkerList, 'Value');
            xc.Indices
            oldData(xc.Indices(1), xc.Indices(2)) = sampleData(ValsampleData)
            set(gui.MarkerTable, 'Data', oldData);
        end
    end %onMarkerTableSelection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function onChangeMarkerNames(~,~)
        % This function prepares the input data and executes the
        % ChangeMarkerNames function which changes the marker names inside
        % all c3d files in the current project folder structure
        TData = get(gui.MarkerTable, 'Data')
        run = 1;
        for i = 1:length(TData)
            if ~isempty(TData{i,1})
                indToChange(run) = i;
                run = run+1;
            end
        end
        OLD_NAMES = TData(indToChange,1)'
        NEW_NAMES = TData(indToChange,2)'
        ChangeMarkerNames(OLD_NAMES, NEW_NAMES);
    end % onChangeMarkerNames

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function ChangeMarkerNames(OLD_NAMES, NEW_NAMES)
        %Changes marker Names (given in OLD_NAMES) to new marker names
        %(NEW_NAMES) in all c3d files in the current project folder
        %structure
        superordner = char(get(gui.EditTopFolder, 'String'));
        sordner = dir(superordner);
        for n_ordner = 3:size(sordner,1)
            ueberordner = [superordner,'\',char(sordner(n_ordner).name)];
            ordner = dir(ueberordner);
            n_dir = 1;
            for d = 3:size(ordner,1)
                if ordner(d).isdir
                    Geruest(n_dir).pathnametest = cellstr([char(ueberordner),'\', ordner(d).name, '\']);
                    C3ds = dir([char(Geruest(n_dir).pathnametest),'*.c3d']);

                    for e = 1:size(C3ds,1)
                        Geruest(n_dir).filenametest(e) = cellstr(C3ds(e).name);
                    end
                    n_dir = n_dir+1;
                    clear C3ds
                end
            end


            for n_probanden = 1:n_dir-1

                pathname = char(Geruest(n_probanden).pathnametest);

                filename = Geruest(n_probanden).filenametest;
                n_trials = length(filename);



                for i = 1:length(filename)
                    fname = [pathname, char(filename(1,i))];


                    disp(fname)
                    u_strich = findstr(fname, '_');


                    M = c3dserver;
                    openc3d(M,0, fname);
                    acq = btkReadAcquisition(fname);
                    index1(i,1) = M.GetParameterIndex('POINT', 'LABELS');
                    length1(i,1) = M.GetParameterLength(index1(i,1));
                    for j = 0:length1(i,1)-1;
                        Marker_Labels(j+1,i) = cellstr(M.GetParameterValue(index1(i,1),j));
                        for z = 1:length(OLD_NAMES)
                            if j == 1
                                disp(char(Marker_Labels(j+1,i)))
                                disp(OLD_NAMES{z})
                            end
                            if strmatch(char(Marker_Labels(j+1,i)) ,OLD_NAMES{z}, 'exact')
                                %                                 M.SetParameterValue(index1(i,1),j, char(NEW_NAMES(z)));

                                [points, pointsInfo] = btkSetPointLabel(acq, OLD_NAMES{z}, NEW_NAMES{z})
                                disp('ja')
                            else
                                disp('nein')
                            end
                        end
                    end



                    nRet = M.SaveFile('',-1);
                    closec3d(M);

                    btkWriteAcquisition(acq, fname);
                    btkDeleteAcquisition(acq);
                end
            end



            clear Geruest
        end
    end %ChangeMarkerNames

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function onExperimentalSetup(~,~)
        % Handles the visibility of the n_steps edit field
        if (get(gui.ExperimentalSetup, 'Value') == 3) ||  (get(gui.ExperimentalSetup, 'Value') == 4) ||  (get(gui.ExperimentalSetup, 'Value') == 5)  ||  (get(gui.ExperimentalSetup, 'Value') == 6)  ||  (get(gui.ExperimentalSetup, 'Value') == 7)  ||  (get(gui.ExperimentalSetup, 'Value') == 8)  ||  (get(gui.ExperimentalSetup, 'Value') == 10)
            set(gui.Nsteps, 'Visible', 'on');
            set(gui.NstepsText, 'Visible', 'on');
            if (get(gui.ExperimentalSetup, 'Value') == 6) ||  (get(gui.ExperimentalSetup, 'Value') == 7)  ||  (get(gui.ExperimentalSetup, 'Value') == 8)
                set(gui.CutOffForce, 'Visible', 'on');
                set(gui.ForcePlateNumber, 'Visible', 'on');
                set(gui.ForceTreshold, 'Visible', 'on');
                set(gui.CutOffForceText, 'Visible', 'on');
                set(gui.ForcePlateNumberText, 'Visible', 'on');
                set(gui.ForceTresholdText, 'Visible', 'on');
                set(gui.UseRawContact, 'Visible', 'on');
            else
                set(gui.CutOffForce, 'Visible', 'off');
                set(gui.ForcePlateNumber, 'Visible', 'off');
                set(gui.ForceTreshold, 'Visible', 'off');
                set(gui.CutOffForceText, 'Visible', 'off');
                set(gui.ForcePlateNumberText, 'Visible', 'off');
                set(gui.ForceTresholdText, 'Visible', 'off');
                set(gui.UseRawContact, 'Visible', 'off');
            end
        else
            set(gui.Nsteps, 'Visible', 'off');
            set(gui.NstepsText, 'Visible', 'off');

            set(gui.CutOffForce, 'Visible', 'off');
            set(gui.ForcePlateNumber, 'Visible', 'off');
            set(gui.ForceTreshold, 'Visible', 'off');
            set(gui.CutOffForceText, 'Visible', 'off');
            set(gui.ForcePlateNumberText, 'Visible', 'off');
            set(gui.ForceTresholdText, 'Visible', 'off');
            set(gui.UseRawContact, 'Visible', 'off');
        end


    end %onExperimentalSetup

    function onExit
        % User wants to quit out of the application
        delete( gui.Window );
    end %onExit

    function onSingleGraphs(~,~)
        evalin('base', 'clear');
        % Put all the settings information into one structure

        data.OPTIONS.ForcePlateNumber = get(gui.ForcePlateNumber, 'Value');
        data.OPTIONS.ExperimentalSetup = get(gui.ExperimentalSetup, 'Value');
        data.OPTIONS.TopFolder = get(gui.EditTopFolder, 'String');
        data.OPTIONS.ConditionFolders = get(gui.ConditionsList, 'String');
        data.OPTIONS.RunningSpeed = str2double(get(gui.RunningSpeed, 'String'));
        data.OPTIONS.RefSpecifier = get(gui.RefSpecifier, 'String');
        data.OPTIONS.FilterOrder = str2double(get(gui.FilterOrderKinematics, 'String'));
        data.OPTIONS.CutOffMarkers = str2double(get(gui.CutOffKinematics, 'String'));
        data.OPTIONS.CutOffGRF = str2double(get(gui.CutOffForce, 'String'));
        data.OPTIONS.ForceTreshold = str2double(get(gui.ForceTreshold, 'String'));
        assignin('base', 'OPTIONS', data.OPTIONS);
        TopFolder = get(gui.EditTopFolder, 'String')
        subfolders = dir(TopFolder)
        char(subfolders(3).name)


        assignin('base', 'Bedingung', get(gui.ConditionsList, 'String'));
        assignin('base', 'ueberordner', TopFolder);

        whichConditions = get(gui.SingleGraphsWhichConditions, 'String');
        if strcmp(whichConditions, ':')
            WC = 1:length(get(gui.ConditionsList, 'String'));
        else
            WC = eval(whichConditions{1});
        end
        matfiles = dir([TopFolder,'\',char(subfolders(WC(1)+2).name), '\', '*.mat'])
        pathname = char([TopFolder,'\',subfolders(WC(1)+2).name, '\'])
        filename = char(matfiles(1).name);
        load([pathname, filename], 'NORMAL');

        whichSubjects = get(gui.SingleGraphsWhichSubjects, 'String');
        if strcmp(whichSubjects, ':')
            WS = 1:length(matfiles);
        else
            WS = eval(whichSubjects{1});
        end





        if get(gui.SingleGraphsAnalyzedLeg, 'Value') == 1
            Leg = 'R';
        elseif get(gui.SingleGraphsAnalyzedLeg, 'Value') == 2
            Leg = 'L';
        end

        AngleNames = fieldnames(NORMAL.(Leg).ANGLES);
        %         AngleNames = {'RIGHT_ANKLE', 'RIGHT_KNEE', 'RIGHT_HIP'};
        AxesNames = {'X','Y','Z'}; %{'Y'};
        % %
        assignin('base', 'Leg', Leg);
        Language = get(gui.GraphLanguage, 'Value');
        assignin('base', 'Language', Language);
        % %
        assignin('base', 'WCSS', WC);
        assignin('base', 'WSSS', WS);
        assignin('base', 'CurveType', 'ANGLES');
        assignin('base', 'ExpCond', data.OPTIONS.ExperimentalSetup);
        assignin('base', 'OutputDirectory', [get(gui.SingleGraphsFolder, 'String'),'\ANGLES\']);
        for t = 1:length(AngleNames)
            for ti = 1:length(AxesNames)
                mkdir([get(gui.SingleGraphsFolder, 'String'),'\ANGLES\', AngleNames{t}, '\', AxesNames{ti}]);
                options.format = 'html';
                options.outputDir = [get(gui.SingleGraphsFolder, 'String'),'\ANGLES\', AngleNames{t}, '\', AxesNames{ti}];
                options.showCode = false;
                assignin('base', 't', t);
                assignin('base', 'ti', ti);
                assignin('base', 'AngleNames', AngleNames);
                assignin('base', 'AxesNames', AxesNames);
                publish('SingleCurves', options);

                %                 clearvars -except t ti AngleNames AxesNames
            end
        end
        if (data.OPTIONS.ExperimentalSetup == 6) || (data.OPTIONS.ExperimentalSetup == 7)
            MomentNames = fieldnames(NORMAL.(Leg).MOMENTS);
            assignin('base', 'CurveType', 'MOMENTS');
            evalin('base', 'clear AngleNames');
            for t = 1:length(MomentNames)
                for ti = 1:length(AxesNames)
                    mkdir([get(gui.SingleGraphsFolder, 'String'),'\MOMENTS\', MomentNames{t}, '\', AxesNames{ti}]);
                    options.format = 'html';
                    options.outputDir = [get(gui.SingleGraphsFolder, 'String'),'\MOMENTS\', MomentNames{t}, '\', AxesNames{ti}];
                    options.showCode = false;
                    assignin('base', 't', t);
                    assignin('base', 'ti', ti);
                    assignin('base', 'AngleNames', MomentNames);
                    assignin('base', 'AxesNames', AxesNames);
                    publish('SingleCurves', options);

                    %                 clearvars -except t ti AngleNames AxesNames
                end
            end
        end

    end %onSingleGraphs



    function onMeanGraphs(~,~)
        evalin('base', 'clear');
        % Put all the settings information into one structure

        OPTIONS.ForcePlateNumber = get(gui.ForcePlateNumber, 'Value');
        OPTIONS.ExperimentalSetup = get(gui.ExperimentalSetup, 'Value');
        OPTIONS.TopFolder = get(gui.EditTopFolder, 'String');
        OPTIONS.ConditionFolders = get(gui.ConditionsList, 'String');
        OPTIONS.RunningSpeed = str2double(get(gui.RunningSpeed, 'String'));
        OPTIONS.RefSpecifier = get(gui.RefSpecifier, 'String');
        OPTIONS.FilterOrder = str2double(get(gui.FilterOrderKinematics, 'String'));
        OPTIONS.CutOffMarkers = str2double(get(gui.CutOffKinematics, 'String'));
        OPTIONS.CutOffGRF = str2double(get(gui.CutOffForce, 'String'));
        OPTIONS.ForceTreshold = str2double(get(gui.ForceTreshold, 'String'));

        TopFolder = get(gui.EditTopFolder, 'String')
        subfolders = dir(TopFolder)

        whichConditions = get(gui.MeanGraphsWhichConditions, 'String');
        if strcmp(whichConditions, ':')
            WC = 1:length(get(gui.ConditionsList, 'String'));
        else
            WC = eval(whichConditions{1});
        end






        char(subfolders(3).name)
        matfiles = dir([TopFolder,'\',char(subfolders(WC(1)+2).name), '\', '*.mat'])
        pathname = char([TopFolder,'\',subfolders(WC(1)+2).name, '\'])
        filename = char(matfiles(1).name);
        load([pathname, filename], 'NORMAL');

        assignin('base', 'Bedingung', get(gui.ConditionsList, 'String'));
        assignin('base', 'ueberordner', TopFolder);

        whichSubjects = get(gui.MeanGraphsWhichSubjects, 'String');
        if strcmp(whichSubjects, ':')
            WS = 1:length(matfiles);
        else
            WS = eval(whichSubjects{1});
        end


        if get(gui.MeanGraphsAnalyzedLeg, 'Value') == 1
            Leg = 'R';
        elseif get(gui.MeanGraphsAnalyzedLeg, 'Value') == 2
            Leg = 'L';
        end
        Language = get(gui.GraphLanguage, 'Value');
        assignin('base', 'Language', Language);
        try
            AngleNames = fieldnames(NORMAL.(Leg).ANGLES);
        catch
            try

            catch

            end
        end
        AxesNames = {'X','Y','Z'}; %{'Y'};

        assignin('base', 'Leg', Leg);

        assignin('base', 'WCMG', WC);
        assignin('base', 'WSMG', WS);
        assignin('base', 'CurveType', 'ANGLES');

        mkdir([get(gui.MeanGraphsFolder, 'String'),'\ANGLES\']);
        options.format = 'html';
        options.outputDir = [get(gui.MeanGraphsFolder, 'String'),'\ANGLES\'];
        options.showCode = false;
        assignin('base', 'OutputDir', options.outputDir);
        assignin('base', 'AngleNames', AngleNames);
        assignin('base', 'AxesNames', AxesNames);
        SaveSVG = get(gui.SaveSVG, 'Value');
        SaveFIG = get(gui.SaveFIG, 'Value');
        assignin('base', 'SaveSVG', SaveSVG);
        assignin('base', 'SaveFIG', SaveFIG);
        publish('MeanCurves', options);

        %                 clearvars -except t ti AngleNames AxesNames

        if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7) || (OPTIONS.ExperimentalSetup == 8)
            MomentNames = fieldnames(NORMAL.(Leg).MOMENTS);
            assignin('base', 'CurveType', 'MOMENTS');
            evalin('base', 'clear AngleNames');

            mkdir([get(gui.MeanGraphsFolder, 'String'),'\POWER\']);
            options.format = 'html';
            options.outputDir = [get(gui.MeanGraphsFolder, 'String'),'\MOMENTS\'];
            options.showCode = false;
            assignin('base', 'OutputDir', options.outputDir);
            assignin('base', 'AngleNames', MomentNames);
            assignin('base', 'AxesNames', AxesNames);
            SaveSVG = get(gui.SaveSVG, 'Value');
            assignin('base', 'SaveSVG', SaveSVG);
            SaveFIG = get(gui.SaveFIG, 'Value');
            assignin('base', 'SaveFIG', SaveFIG);
            publish('MeanCurves', options);


            PowerNames = fieldnames(NORMAL.(Leg).POWER);
            assignin('base', 'CurveType', 'POWER');
            evalin('base', 'clear AngleNames');

            mkdir([get(gui.MeanGraphsFolder, 'String'),'\POWER\']);
            options.format = 'html';
            options.outputDir = [get(gui.MeanGraphsFolder, 'String'),'\POWER\'];
            options.showCode = false;
            assignin('base', 'OutputDir', options.outputDir);
            assignin('base', 'AngleNames', PowerNames);
            assignin('base', 'AxesNames', AxesNames);
            SaveSVG = get(gui.SaveSVG, 'Value');
            assignin('base', 'SaveSVG', SaveSVG);
            publish('MeanCurves', options);

            GRFNames = fieldnames(NORMAL.(Leg).GRF);
            assignin('base', 'CurveType', 'GRF');
            evalin('base', 'clear AngleNames');

            mkdir([get(gui.MeanGraphsFolder, 'String'),'\GRF\']);
            options.format = 'html';
            options.outputDir = [get(gui.MeanGraphsFolder, 'String'),'\GRF\'];
            options.showCode = false;
            assignin('base', 'OutputDir', options.outputDir);
            assignin('base', 'AngleNames', GRFNames);
            assignin('base', 'AxesNames', AxesNames);
            SaveSVG = get(gui.SaveSVG, 'Value');
            assignin('base', 'SaveSVG', SaveSVG);
            publish('MeanCurves', options);

            %                 clearvars -except t ti AngleNames AxesNames
        end


    end %onMeanGraphs




    function onRLGraphs(~,~)
        evalin('base', 'clear');
        % Put all the settings information into one structure

        OPTIONS.ForcePlateNumber = get(gui.ForcePlateNumber, 'Value');
        OPTIONS.ExperimentalSetup = get(gui.ExperimentalSetup, 'Value');
        OPTIONS.TopFolder = get(gui.EditTopFolder, 'String');
        OPTIONS.ConditionFolders = get(gui.ConditionsList, 'String');
        OPTIONS.RunningSpeed = str2double(get(gui.RunningSpeed, 'String'));
        OPTIONS.RefSpecifier = get(gui.RefSpecifier, 'String');
        OPTIONS.FilterOrder = str2double(get(gui.FilterOrderKinematics, 'String'));
        OPTIONS.CutOffMarkers = str2double(get(gui.CutOffKinematics, 'String'));
        OPTIONS.CutOffGRF = str2double(get(gui.CutOffForce, 'String'));
        OPTIONS.ForceTreshold = str2double(get(gui.ForceTreshold, 'String'));



        TopFolder = get(gui.EditTopFolder, 'String')
        subfolders = dir(TopFolder)
        char(subfolders(3).name)
        matfiles = dir([TopFolder,'\',char(subfolders(3).name), '\', '*.mat'])
        pathname = char([TopFolder,'\',subfolders(3).name, '\'])
        filename = char(matfiles(1).name);
        load([pathname, filename], 'NORMAL');
        BedingungTemp = get(gui.ConditionsList, 'String');
        for bt = 1:length(BedingungTemp)
            BedingungLeg(bt*2-1) =  {[BedingungTemp{bt}, '_right']};
            BedingungLeg(bt*2) =  {[BedingungTemp{bt}, '_left']};
        end
        assignin('base', 'Bedingung', BedingungTemp);
        assignin('base', 'BedingungLeg', BedingungLeg);
        assignin('base', 'ueberordner', TopFolder);

        whichConditions = get(gui.RLGraphsWhichConditions, 'String');
        if strcmp(whichConditions, ':')
            WC = 1:length(get(gui.ConditionsList, 'String'));
        else
            WC = eval(whichConditions{1});
        end


        whichSubjects = get(gui.RLGraphsWhichSubjects, 'String');
        if strcmp(whichSubjects, ':')
            WS = 1:length(matfiles);
        else
            WS = eval(whichSubjects{1});
        end

        if get(gui.AnalyzedLeg, 'Value') == 1
            Leg = 'R';
        elseif get(gui.AnalyzedLeg, 'Value') == 2
            Leg = 'L';
        end
        Language = get(gui.GraphLanguage, 'Value');
        assignin('base', 'Language', Language);
        AngleNamesL = fieldnames(NORMAL.L.ANGLES);
        AngleNamesR = fieldnames(NORMAL.R.ANGLES);
        AxesNames = {'X','Y','Z'}; %{'Y'};

        %         assignin('base', 'Leg', Leg);

        assignin('base', 'WCLRG', WC);
        assignin('base', 'WSLRG', WS);
        assignin('base', 'CurveType', 'ANGLES');

        mkdir([get(gui.RLGraphsFolder, 'String'),'\ANGLES\']);
        options.format = 'html';
        options.outputDir = [get(gui.RLGraphsFolder, 'String'),'\ANGLES\'];
        options.showCode = false;
        assignin('base', 'OutputDir', options.outputDir);
        assignin('base', 'AngleNamesL', AngleNamesL);
        assignin('base', 'AngleNamesR', AngleNamesR);
        assignin('base', 'AxesNames', AxesNames);
        publish('RLCurves', options);

        %                 clearvars -except t ti AngleNames AxesNames

        if (gui.ExperimentalSetup == 6) || (gui.ExperimentalSetup == 7)
            MomentNames = fieldnames(NORMAL.(Leg).MOMENTS);
            assignin('base', 'CurveType', 'MOMENTS');
            evalin('base', 'clear AngleNames');

            mkdir([get(gui.MeanGraphsFolder, 'String'),'\MOMENTS\']);
            options.format = 'html';
            options.outputDir = [get(gui.MeanGraphsFolder, 'String'),'\MOMENTS\'];
            options.showCode = false;

            assignin('base', 'AngleNames', MomentNames);
            assignin('base', 'AxesNames', AxesNames);
            publish('MeanCurves', options);

            %                 clearvars -except t ti AngleNames AxesNames
        end


    end %onRLGraphs

    function onSingleGraphsBrowse(~,~)
        pathname = uigetdir('Please select folder', 'C:\');
        set(gui.SingleGraphsFolder, 'String', pathname);
    end %onSingleGraphsBrowse

    function onMeanGraphsBrowse(~,~)
        pathname = uigetdir('Please select folder', 'C:\');
        set(gui.MeanGraphsFolder, 'String', pathname);
    end %onSingleGraphsBrowse

    function onRLGraphsBrowse(~,~)
        pathname = uigetdir('Please select folder', 'C:\');
        set(gui.RLGraphsFolder, 'String', pathname);
    end %onSingleGraphsBrowse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function onSaveLogFile(~,~)
        % Saves the error Log File as .txt file to Matlab's current folder.
        fid = fopen([cd, '\LogFile.txt'], 'w');
        [x,y] = size(data.errorlog);
        for i = 1:x
            fprintf(fid, '%s\r\n', data.errorlog{i});

        end
        fclose(fid);
    end %onSaveLogFile

    function onMarkerSetNext(~,~)
        % Changes the picture that is used to visualize the marker set to
        % the next picture
        if gui.MarkerSetActPict < length(gui.MarkerSetPictureList)
            gui.MarkerSetActPict = gui.MarkerSetActPict + 1;
            imshow(gui.MarkerSetPictureList{gui.MarkerSetActPict}, 'Parent', gui.MarkerSetPlot);
        end
    end %onMarkerSetNext

    function onMarkerSetPrevious(~,~)
        % Changes the picture that is used to visualize the marker set to
        % the previous picture
        if gui.MarkerSetActPict > 1
            gui.MarkerSetActPict = gui.MarkerSetActPict - 1;
            imshow(gui.MarkerSetPictureList{gui.MarkerSetActPict}, 'Parent', gui.MarkerSetPlot);
        end
    end %onMarkerSetNext

    function onRotateMarkersButton(~,~)
        superordner = char(get(gui.EditTopFolder, 'String'));
        sordner = dir(superordner);
        for n_ordner = 3:size(sordner,1)
            ueberordner = [superordner,'\',char(sordner(n_ordner).name)];
            ordner = dir(ueberordner);
            n_dir = 1;
            for d = 3:size(ordner,1)
                if ordner(d).isdir
                    Geruest(n_dir).pathnametest = cellstr([char(ueberordner),'\', ordner(d).name, '\']);
                    C3ds = dir([char(Geruest(n_dir).pathnametest),'*.c3d']);

                    for e = 1:size(C3ds,1)
                        Geruest(n_dir).filenametest(e) = cellstr(C3ds(e).name);
                    end
                    n_dir = n_dir+1;
                    clear C3ds
                end
            end


            for n_probanden = 1:n_dir-1

                pathname = char(Geruest(n_probanden).pathnametest);

                filename = Geruest(n_probanden).filenametest;
                n_trials = length(filename);



                for i = 1:length(filename)
                    fname = [pathname, char(filename(1,i))];
                    MARKERS = getlabeledmarkers_GUI(fname);
                    Mnames = fieldnames(MARKERS);
                    disp(fname)
                    u_strich = findstr(fname, '_');


                    M = c3dserver;
                    openc3d(M,0, fname);
                    start = M.GetVideoFrame(0);
                    ende = M.GetVideoFrame(1);
                    index1(i,1) = M.GetParameterIndex('POINT', 'LABELS');
                    length1(i,1) = M.GetParameterLength(index1(i,1));
                    for j = 0:length1(i,1)-1;
                        Marker_Labels(j+1,i) = cellstr(M.GetParameterValue(index1(i,1),j));
                        for z = 1:length(Mnames)
                            if strmatch(char(Marker_Labels(j+1,i)) ,Mnames(z), 'exact')

                                for jj = 0:2
                                    Mold(jj+1,:) = cell2mat(M.GetPointDataEx(j,jj,start,ende,'1'));
                                end
                                RMString = get(gui.RotateMarkersEdit, 'String');
                                RotMat = eval(char(RMString))
                                for jjj = 1:size(Mold,2)
                                    MNew(:,jjj) = RotMat*Mold(:,jjj);
                                end
                                for l = 0:2
                                    M.SetPointDataEx(j, l, start, single(MNew(l+1,:)));
                                end
                            end
                        end
                    end



                    nRet = M.SaveFile('',-1);

                    closec3d(M);
                    clear Mold MNew RMString RotMat
                end
            end



            clear Geruest
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starts the main analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function onRunModel(~,~)

        ALV = get(gui.AnalyzedLeg, 'Value');
        ALC = get(gui.AnalyzedLeg, 'String');
        ALS = char(ALC(ALV));
        % Put all the settings information into one structure
        data.OPTIONS.AnalyzedLeg = ALS(1);
        data.OPTIONS.ForcePlateNumber = get(gui.ForcePlateNumber, 'Value');
        data.OPTIONS.ExperimentalSetup = get(gui.ExperimentalSetup, 'Value');
        data.OPTIONS.TopFolder = get(gui.EditTopFolder, 'String');
        data.OPTIONS.ConditionFolders = get(gui.ConditionsList, 'String');
        data.OPTIONS.RunningSpeed = str2double(get(gui.RunningSpeed, 'String'));
        data.OPTIONS.RefSpecifier = get(gui.RefSpecifier, 'String');
        data.OPTIONS.FilterOrder = str2double(get(gui.FilterOrderKinematics, 'String'));
        data.OPTIONS.CutOffMarkers = str2double(get(gui.CutOffKinematics, 'String'));
        data.OPTIONS.CutOffGRF = str2double(get(gui.CutOffForce, 'String'));
        data.OPTIONS.ForceTreshold = str2double(get(gui.ForceTreshold, 'String'));
        assignin('base', 'OPTIONS', data.OPTIONS);


        mainmodel   % This is the main function for the analysis
    end % onRunModel






% Calling this function starts the analysis of the data provided in the
% folder structure.
    function mainmodel(~,~)

        clc


        OPTIONS = data.OPTIONS;
        ConditionFolders = dir(OPTIONS.TopFolder);
        whichConditions = get(gui.WhichConditions, 'String');
        % WC is created from the information provided in the Run Model tab
        if strcmp(whichConditions, ':')
            WC = 1:length(ConditionFolders)-2;
        else
            WC = eval(whichConditions{1});
        end

        for n_condition = WC  %Main loop trough the different condition folders
            [FRAMEWORK, n_subjects] = get_file_framework([OPTIONS.TopFolder,'\', char(ConditionFolders(n_condition+2).name)]); % The FRAMEWORK variable is constructed for each Condition folder
            % WS is created from the information provided in the Run Model tab
            whichSubjects = get(gui.WhichSubjects, 'String');
            if strcmp(whichSubjects, ':')
                WS = 1:n_subjects;
            else
                WS = eval(whichSubjects{1});
            end

            for n_sub = WS %Loop troigh  individual subject folders for the given condition
                %                 try % By surrounding the entire for loop with a try end statement, the analysis will not stop due to a single error
                % in the raw data provided. Probems are logged i nthe
                % error file to understand why a cretain analysis was
                % interrupted.

                % Set specific folder variables and athropometric information for this Condition - Subject
                % Combination - they will be deleted at the end of n_sub loop
                pathname = char(FRAMEWORK(n_sub).pathname);
                filename = FRAMEWORK(n_sub).filename;
                anthrofile = [pathname, FRAMEWORK(n_sub).anthro];
                [OPTIONS.ANTHRO, OPTIONS.mass, OPTIONS.RunningSpeed] = getANTHRO_GUI(anthrofile, 'ZAT1983');

                %% Find the reference trial
                % try
                ind_reftrial = get_reftrial(filename, OPTIONS.RefSpecifier);
                [REFFRAME, REFMARKERS, ~] = get_refinfo_GUI([pathname,char(filename(ind_reftrial))], OPTIONS);
                %                 catch
                %                     try
                %                         data.errorlog = [data.errorlog; {[pathname,char(filename(ind_reftrial)), ' : Probelems reading or filtering data']}];
                %                     end
                %  end

                % Once again to determine MoIs
                try
                    [OPTIONS.ANTHRO, OPTIONS.mass, OPTIONS.RunningSpeed] = getANTHRO_GUI(anthrofile, 'ZAT1983', REFFRAME);
                end
                %% Analysis of dynamic trials
                runi = 0;

                %                 if mat-files exists
                %                     startTrial = Zahl aus Mat datei
                %                 else
                %                     startTrial = 1
                %                 end
                %


                for i = 1:length(filename) %loop trough all dynamic trials

                    if isempty(strfind(char(filename(1,i)), OPTIONS.RefSpecifier))
                        runi = runi +1;
                        %% Determine Structname (name to identify individual trials)
                        name = correctumlaut(char(filename(1,i)));
                        disp(name);
                        structname = ['T_', name(1:end-4)];
                        % Reading Analog Data if wanted
                        if get(gui.SaveAnalogData, 'Value')
                            ANALOG.(structname) = getAllAnalogChannels([pathname, char(filename(1,i))]);
                        end
                        try
                            BELTVELOCITY.(structname).All = getBeltVelocity([pathname, char(filename(1,i))],[-300 1500], [-144 -154], [-634 -644], [-10 10]);
                        end

                        structname = genvarname(structname);
                        % Reading labeled marker trajectories
                        %                         try
                        [MARKERS.(structname).Raw, LABELS.(structname).Exist, ~, OPTIONS.start, ~, OPTIONS.FreqKinematics, OPTIONS.ftkratio, nframes.(structname)] = getlabeledmarkers_GUI_mat_DYNAMIC([pathname, char(filename(1,i))]);
                        OPTIONS.freqGRF = OPTIONS.FreqKinematics*OPTIONS.ftkratio;
                        % Filtering marker trajectories
                        ExistentMarkers = LABELS.(structname).Exist;
                        [b,a] = butter(OPTIONS.FilterOrder/2, OPTIONS.CutOffMarkers/(OPTIONS.FreqKinematics/2), 'low');
                        for t = 1:length(ExistentMarkers)
                            MARKERS.(structname).Filt.(char(ExistentMarkers(t,1))) = markersfilt(MARKERS.(structname).Raw.(char(ExistentMarkers(t,1))), b, a);
                            indisnan = isnan(MARKERS.(structname).Filt.(char(ExistentMarkers(t,1))).data);
                            MARKERS.(structname).Filt.(char(ExistentMarkers(t,1))).data(indisnan) = 0;
                        end
                        %                         catch
                        %                             data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Probelems reading or filtering data']}];
                        %                         end
                        %%
                        % Optimizing marker trajectories
                        % Right leg
                        % right forefoot
                        if OPTIONS.AnalyzedLeg ~= 'L'
                            %                             try
                            OPTI.RightForefoot = SVDopti(hinten(MARKERS.(structname).Filt.forfoot_lat_right.data, MARKERS.(structname).Filt.forfoot_med_right.data, MARKERS.(structname).Filt.toe_right.data), hinten(REFMARKERS.Filt.forfoot_lat_right.data, REFMARKERS.Filt.forfoot_med_right.data, REFMARKERS.Filt.toe_right.data));
                            [MARKERS.(structname).Opti.forfoot_lat_right.data, MARKERS.(structname).Opti.forfoot_med_right.data, MARKERS.(structname).Opti.toe_right.data] = vorne(OPTI.RightForefoot);
                            %                             catch
                            %                                 data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Forefoot Marker']}];
                            %                             end
                            % right rearfoot
                            %                             try
                            OPTI.RightRearfoot = SVDopti(hinten(MARKERS.(structname).Filt.calc_back_right.data, MARKERS.(structname).Filt.calc_med_right.data, MARKERS.(structname).Filt.calc_lat_right.data), hinten(REFMARKERS.Filt.calc_back_right.data, REFMARKERS.Filt.calc_med_right.data, REFMARKERS.Filt.calc_lat_right.data));
                            [MARKERS.(structname).Opti.calc_back_right.data, MARKERS.(structname).Opti.calc_med_right.data, MARKERS.(structname).Opti.calc_lat_right.data] = vorne(OPTI.RightRearfoot);
                            %                             catch
                            %                                 data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right REarfoot Marker']}];
                            %                             end
                            % right shank
                            %                             try
                            OPTI.RightShank = SVDopti(hinten(MARKERS.(structname).Filt.cluster_tibia_right_1.data, MARKERS.(structname).Filt.cluster_tibia_right_2.data, MARKERS.(structname).Filt.cluster_tibia_right_3.data, MARKERS.(structname).Filt.cluster_tibia_right_4.data), hinten(REFMARKERS.Filt.cluster_tibia_right_1.data, REFMARKERS.Filt.cluster_tibia_right_2.data, REFMARKERS.Filt.cluster_tibia_right_3.data, REFMARKERS.Filt.cluster_tibia_right_4.data));
                            [MARKERS.(structname).Opti.cluster_tibia_right_1.data, MARKERS.(structname).Opti.cluster_tibia_right_2.data, MARKERS.(structname).Opti.cluster_tibia_right_3.data, MARKERS.(structname).Opti.cluster_tibia_right_4.data] = vorne(OPTI.RightShank);
                            %                             catch
                            %                                 data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Shank Marker']}];
                            %                             end
                            % right thigh
                            %                            try
                            OPTI.RightThigh = SVDopti(hinten(MARKERS.(structname).Filt.cluster_femur_right_1.data, MARKERS.(structname).Filt.cluster_femur_right_2.data, MARKERS.(structname).Filt.cluster_femur_right_3.data, MARKERS.(structname).Filt.cluster_femur_right_4.data), hinten(REFMARKERS.Filt.cluster_femur_right_1.data, REFMARKERS.Filt.cluster_femur_right_2.data, REFMARKERS.Filt.cluster_femur_right_3.data, REFMARKERS.Filt.cluster_femur_right_4.data));
                            [MARKERS.(structname).Opti.cluster_femur_right_1.data, MARKERS.(structname).Opti.cluster_femur_right_2.data, MARKERS.(structname).Opti.cluster_femur_right_3.data, MARKERS.(structname).Opti.cluster_femur_right_4.data] = vorne(OPTI.RightThigh);
                            %                             catch
                            %                                 data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Thigh Marker']}];
                            %                             end
                            % right pelvis
                            %                             try
                            OPTI.RightPelvis = SVDopti(hinten(MARKERS.(structname).Filt.SIAS_right.data, MARKERS.(structname).Filt.SIAS_left.data, MARKERS.(structname).Filt.SIPS_right.data, MARKERS.(structname).Filt.SIPS_left.data), hinten(REFMARKERS.Filt.SIAS_right.data, REFMARKERS.Filt.SIAS_left.data, REFMARKERS.Filt.SIPS_right.data, REFMARKERS.Filt.SIPS_left.data));
                            [MARKERS.(structname).Opti.SIAS_right.data, MARKERS.(structname).Opti.SIAS_left.data, MARKERS.(structname).Opti.SIPS_right.data, MARKERS.(structname).Opti.SIPS_left.data] = vorne(OPTI.RightPelvis);
                            %                             catch
                            %                                 data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Pelvis Marker']}];
                            %                             end
                        end
                        % Left leg
                        % left forefoot
                        if OPTIONS.AnalyzedLeg ~= 'R'
                            try
                                OPTI.LeftForefoot = SVDopti(hinten(MARKERS.(structname).Filt.forefoot_lat_left.data, MARKERS.(structname).Filt.forefoot_med_left.data, MARKERS.(structname).Filt.toe_left.data), hinten(REFMARKERS.Filt.forefoot_lat_left.data, REFMARKERS.Filt.forefoot_med_left.data, REFMARKERS.Filt.toe_left.data));
                                [MARKERS.(structname).Opti.forefoot_lat_left.data, MARKERS.(structname).Opti.forefoot_med_left.data, MARKERS.(structname).Opti.toe_left.data] = vorne(OPTI.LeftForefoot);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Forefoot Marker']}];
                            end
                            % left rearfoot
                            try
                                OPTI.LeftRearfoot = SVDopti(hinten(MARKERS.(structname).Filt.calc_back_left.data, MARKERS.(structname).Filt.calc_med_left.data, MARKERS.(structname).Filt.calc_lat_left.data), hinten(REFMARKERS.Filt.calc_back_left.data, REFMARKERS.Filt.calc_med_left.data, REFMARKERS.Filt.calc_lat_left.data));
                                [MARKERS.(structname).Opti.calc_back_left.data, MARKERS.(structname).Opti.calc_med_left.data, MARKERS.(structname).Opti.calc_lat_left.data] = vorne(OPTI.LeftRearfoot);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Rearfoot Marker']}];
                            end
                            % left shank
                            try
                                OPTI.LeftShank = SVDopti(hinten(MARKERS.(structname).Filt.cluster_tibia_left_1.data, MARKERS.(structname).Filt.cluster_tibia_left_2.data, MARKERS.(structname).Filt.cluster_tibia_left_3.data, MARKERS.(structname).Filt.cluster_tibia_left_4.data), hinten(REFMARKERS.Filt.cluster_tibia_left_1.data, REFMARKERS.Filt.cluster_tibia_left_2.data, REFMARKERS.Filt.cluster_tibia_left_3.data, REFMARKERS.Filt.cluster_tibia_left_4.data));
                                [MARKERS.(structname).Opti.cluster_tibia_left_1.data, MARKERS.(structname).Opti.cluster_tibia_left_2.data, MARKERS.(structname).Opti.cluster_tibia_left_3.data, MARKERS.(structname).Opti.cluster_tibia_left_4.data] = vorne(OPTI.LeftShank);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Shank Marker']}];
                            end
                            % left thigh
                            try
                                OPTI.LeftThigh = SVDopti(hinten(MARKERS.(structname).Filt.cluster_femur_left_1.data, MARKERS.(structname).Filt.cluster_femur_left_2.data, MARKERS.(structname).Filt.cluster_femur_left_3.data, MARKERS.(structname).Filt.cluster_femur_left_4.data), hinten(REFMARKERS.Filt.cluster_femur_left_1.data, REFMARKERS.Filt.cluster_femur_left_2.data, REFMARKERS.Filt.cluster_femur_left_3.data, REFMARKERS.Filt.cluster_femur_left_4.data));
                                [MARKERS.(structname).Opti.cluster_femur_left_1.data, MARKERS.(structname).Opti.cluster_femur_left_2.data, MARKERS.(structname).Opti.cluster_femur_left_3.data, MARKERS.(structname).Opti.cluster_femur_left_4.data] = vorne(OPTI.LeftThigh);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Thigh Marker']}];
                            end
                            % left pelvis
                            try
                                OPTI.LeftPelvis = SVDopti(hinten(MARKERS.(structname).Filt.SIAS_right.data, MARKERS.(structname).Filt.SIAS_left.data, MARKERS.(structname).Filt.SIPS_right.data, MARKERS.(structname).Filt.SIPS_left.data), hinten(REFMARKERS.Filt.SIAS_right.data, REFMARKERS.Filt.SIAS_left.data, REFMARKERS.Filt.SIPS_right.data, REFMARKERS.Filt.SIPS_left.data));
                                [MARKERS.(structname).Opti.SIAS_right.data, MARKERS.(structname).Opti.SIAS_left.data, MARKERS.(structname).Opti.SIPS_right.data, MARKERS.(structname).Opti.SIPS_left.data] = vorne(OPTI.LeftPelvis);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Pelvis Marker']}];
                            end
                        end

                        if OPTIONS.AnalyzedLeg == 'B'
                            %Head
                            try
                                OPTI.Head = SVDopti(hinten(MARKERS.(structname).Filt.head_front_right.data, MARKERS.(structname).Filt.head_front_left.data, MARKERS.(structname).Filt.head_back_right.data, MARKERS.(structname).Filt.head_back_left.data), hinten(REFMARKERS.Filt.head_front_right.data, REFMARKERS.Filt.head_front_left.data, REFMARKERS.Filt.head_back_right.data, REFMARKERS.Filt.head_back_left.data));
                                [MARKERS.(structname).Opti.head_front_right.data, MARKERS.(structname).Opti.head_front_left.data, MARKERS.(structname).Opti.head_back_right.data, MARKERS.(structname).Opti.head_back_left.data] = vorne(OPTI.Head);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Head Marker']}];
                            end
                            % Right Upper Extremity
                            % Right Upper Arm
                            try
                                OPTI.RightUpperArm = SVDopti(hinten(MARKERS.(structname).Filt.cluster_upperarm_right_1.data, MARKERS.(structname).Filt.cluster_upperarm_right_2.data, MARKERS.(structname).Filt.cluster_upperarm_right_3.data), hinten(REFMARKERS.Filt.cluster_upperarm_right_1.data, REFMARKERS.Filt.cluster_upperarm_right_2.data, REFMARKERS.Filt.cluster_upperarm_right_3.data));
                                [MARKERS.(structname).Opti.cluster_upperarm_right_1.data, MARKERS.(structname).Opti.cluster_upperarm_right_2.data, MARKERS.(structname).Opti.cluster_upperarm_right_3.data] = vorne(OPTI.RightUpperArm);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Upperarm Marker']}];
                            end
                            % Right Lower Arm
                            try
                                OPTI.RightLowerArm = SVDopti(hinten(MARKERS.(structname).Filt.cluster_lowerarm_right_1.data, MARKERS.(structname).Filt.cluster_lowerarm_right_2.data, MARKERS.(structname).Filt.cluster_lowerarm_right_3.data), hinten(REFMARKERS.Filt.cluster_lowerarm_right_1.data, REFMARKERS.Filt.cluster_lowerarm_right_2.data, REFMARKERS.Filt.cluster_lowerarm_right_3.data));
                                [MARKERS.(structname).Opti.cluster_lowerarm_right_1.data, MARKERS.(structname).Opti.cluster_lowerarm_right_2.data, MARKERS.(structname).Opti.cluster_lowerarm_right_3.data] = vorne(OPTI.RightLowerArm);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Right Lowerarm Marker']}];
                            end
                            % Left Upper Extremity
                            % Left Upper Arm
                            try
                                OPTI.LeftUpperArm = SVDopti(hinten(MARKERS.(structname).Filt.cluster_upperarm_left_1.data, MARKERS.(structname).Filt.cluster_upperarm_left_2.data, MARKERS.(structname).Filt.cluster_upperarm_left_3.data), hinten(REFMARKERS.Filt.cluster_upperarm_left_1.data, REFMARKERS.Filt.cluster_upperarm_left_2.data, REFMARKERS.Filt.cluster_upperarm_left_3.data));
                                [MARKERS.(structname).Opti.cluster_upperarm_left_1.data, MARKERS.(structname).Opti.cluster_upperarm_left_2.data, MARKERS.(structname).Opti.cluster_upperarm_left_3.data] = vorne(OPTI.LeftUpperArm);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Left Right Upperarm Marker']}];
                            end
                            % Left Lower Arm
                            try
                                OPTI.LeftLowerArm = SVDopti(hinten(MARKERS.(structname).Filt.cluster_lowerarm_left_1.data, MARKERS.(structname).Filt.cluster_lowerarm_left_2.data, MARKERS.(structname).Filt.cluster_lowerarm_left_3.data), hinten(REFMARKERS.Filt.cluster_lowerarm_left_1.data, REFMARKERS.Filt.cluster_lowerarm_left_2.data, REFMARKERS.Filt.cluster_lowerarm_left_3.data));
                                [MARKERS.(structname).Opti.cluster_lowerarm_left_1.data, MARKERS.(structname).Opti.cluster_lowerarm_left_2.data, MARKERS.(structname).Opti.cluster_lowerarm_left_3.data] = vorne(OPTI.LeftLowerArm);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Left Lowerarm Marker']}];
                            end

                            % Trunk
                            try
                                OPTI.Trunk = SVDopti(hinten(MARKERS.(structname).Filt.clav.data, MARKERS.(structname).Filt.C_7.data, MARKERS.(structname).Filt.sternum.data), hinten(REFMARKERS.Filt.clav.data, REFMARKERS.Filt.C_7.data, REFMARKERS.Filt.sternum.data));
                                [MARKERS.(structname).Opti.clav.data, MARKERS.(structname).Opti.C_7.data, MARKERS.(structname).Opti.sternum.data] = vorne(OPTI.Trunk);
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Missing Trunk Marker']}];
                            end
                        end



                        % Determining Anatomical reference frames from tracking
                        % markers (technical frames), further calculate angular
                        % velocities and accelerations of the anatomical frames
                        % for each segment

                        % Right leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        if OPTIONS.AnalyzedLeg ~= 'L'
                            % Right Forefoot

                            try
                                [FRAME.(structname).Technical.RightForefoot.O, FRAME.(structname).Technical.RightForefoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.toe_right.data, MARKERS.(structname).Opti.forfoot_lat_right.data, MARKERS.(structname).Opti.forfoot_med_right.data);
                                for g = 1:size(FRAME.(structname).Technical.RightForefoot.R, 3)
                                    FRAME.(structname).Anatomical.RightForefoot.R(:,:,g) = FRAME.(structname).Technical.RightForefoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightForefoot.R;
                                    FRAME.(structname).Anatomical.RightForefoot.O(:,g) = FRAME.(structname).Technical.RightForefoot.O(:,g) + (FRAME.(structname).Technical.RightForefoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightForefoot.O);
                                end
                                [FRAME.(structname).Anatomical.RightForefoot.V, FRAME.(structname).Anatomical.RightForefoot.ACC, FRAME.(structname).Anatomical.RightForefoot.LinV, FRAME.(structname).Anatomical.RightForefoot.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.RightForefoot.R,FRAME.(structname).Anatomical.RightForefoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.rad = getwinkel(FRAME.(structname).Anatomical.RightForefoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Forefoot Coordinate System']}];
                            end
                            %Right Rearfoot
                            try
                                [FRAME.(structname).Technical.RightRearfoot.O, FRAME.(structname).Technical.RightRearfoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.calc_back_right.data, MARKERS.(structname).Opti.calc_med_right.data, MARKERS.(structname).Opti.calc_lat_right.data);
                                for g = 1:size(FRAME.(structname).Technical.RightRearfoot.R, 3)
                                    FRAME.(structname).Anatomical.RightRearfoot.R(:,:,g) = FRAME.(structname).Technical.RightRearfoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightRearfoot.R;
                                    FRAME.(structname).Anatomical.RightRearfoot.O(:,g) = FRAME.(structname).Technical.RightRearfoot.O(:,g) + (FRAME.(structname).Technical.RightRearfoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightRearfoot.O);
                                end
                                [FRAME.(structname).Anatomical.RightRearfoot.V, FRAME.(structname).Anatomical.RightRearfoot.ACC, FRAME.(structname).Anatomical.RightRearfoot.LinV, FRAME.(structname).Anatomical.RightRearfoot.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.RightRearfoot.R,FRAME.(structname).Anatomical.RightRearfoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.rad = getwinkel(FRAME.(structname).Anatomical.RightRearfoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Rearfoot Coordinate System']}];
                            end
                            %Right Foot
                            try
                                [FRAME.(structname).Technical.RightFoot.O, FRAME.(structname).Technical.RightFoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.calc_back_right.data, MARKERS.(structname).Opti.forfoot_lat_right.data, MARKERS.(structname).Opti.forfoot_med_right.data);
                                for g = 1:size(FRAME.(structname).Technical.RightFoot.R, 3)
                                    FRAME.(structname).Anatomical.RightFoot.R(:,:,g) = FRAME.(structname).Technical.RightFoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightFoot.R;
                                    FRAME.(structname).Anatomical.RightFoot.O(:,g) = FRAME.(structname).Technical.RightFoot.O(:,g) + (FRAME.(structname).Technical.RightFoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightFoot.O);
                                end
                                [FRAME.(structname).Anatomical.RightFoot.V, FRAME.(structname).Anatomical.RightFoot.ACC, FRAME.(structname).Anatomical.RightFoot.LinV, FRAME.(structname).Anatomical.RightFoot.LinACC, FRAME.(structname).Anatomical.RightFoot.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightFoot.R,FRAME.(structname).Anatomical.RightFoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Foot.rad = getwinkel(FRAME.(structname).Anatomical.RightFoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Foot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Foot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Foot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Foot Coordinate System']}];
                            end
                            %Right Shank
                            try
                                [FRAME.(structname).Technical.RightShank.O, FRAME.(structname).Technical.RightShank.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_tibia_right_1.data, MARKERS.(structname).Opti.cluster_tibia_right_2.data, MARKERS.(structname).Opti.cluster_tibia_right_3.data, MARKERS.(structname).Opti.cluster_tibia_right_4.data);
                                for g = 1:size(FRAME.(structname).Technical.RightShank.R, 3)
                                    FRAME.(structname).Anatomical.RightShank.R(:,:,g) = FRAME.(structname).Technical.RightShank.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightShank.R;
                                    FRAME.(structname).Anatomical.RightShank.O(:,g) = FRAME.(structname).Technical.RightShank.O(:,g) + (FRAME.(structname).Technical.RightShank.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightShank.O);
                                end
                                [FRAME.(structname).Anatomical.RightShank.V, FRAME.(structname).Anatomical.RightShank.ACC, FRAME.(structname).Anatomical.RightShank.LinV, FRAME.(structname).Anatomical.RightShank.LinACC, FRAME.(structname).Anatomical.RightShank.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightShank.R,FRAME.(structname).Anatomical.RightShank.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Shank.rad = getwinkel(FRAME.(structname).Anatomical.RightShank.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Shank.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Shank.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Shank.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Shank Coordinate System']}];
                            end
                            %Right Thigh
                            try
                                [FRAME.(structname).Technical.RightThigh.O, FRAME.(structname).Technical.RightThigh.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_femur_right_1.data, MARKERS.(structname).Opti.cluster_femur_right_2.data, MARKERS.(structname).Opti.cluster_femur_right_3.data, MARKERS.(structname).Opti.cluster_femur_right_4.data);
                                for g = 1:size(FRAME.(structname).Technical.RightThigh.R, 3)
                                    FRAME.(structname).Anatomical.RightThigh.R(:,:,g) = FRAME.(structname).Technical.RightThigh.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightThigh.R;
                                    FRAME.(structname).Anatomical.RightThigh.O(:,g) = FRAME.(structname).Technical.RightThigh.O(:,g) + (FRAME.(structname).Technical.RightThigh.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightThigh.O);
                                end
                                [FRAME.(structname).Anatomical.RightThigh.V, FRAME.(structname).Anatomical.RightThigh.ACC, FRAME.(structname).Anatomical.RightThigh.LinV, FRAME.(structname).Anatomical.RightThigh.LinACC, FRAME.(structname).Anatomical.RightThigh.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightThigh.R,FRAME.(structname).Anatomical.RightThigh.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Thigh.rad = getwinkel(FRAME.(structname).Anatomical.RightThigh.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Thigh.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Thigh.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Thigh.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Thigh Coordinate System']}];
                            end
                            %Right Pelvis
                            try
                                [FRAME.(structname).Technical.RightPelvis.O, FRAME.(structname).Technical.RightPelvis.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.SIAS_right.data, MARKERS.(structname).Opti.SIAS_left.data, MARKERS.(structname).Opti.SIPS_right.data, MARKERS.(structname).Opti.SIPS_left.data);
                                for g = 1:size(FRAME.(structname).Technical.RightPelvis.R, 3)
                                    FRAME.(structname).Anatomical.RightPelvis.R(:,:,g) = FRAME.(structname).Technical.RightPelvis.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightPelvis.R;
                                    FRAME.(structname).Anatomical.RightPelvis.O(:,g) = FRAME.(structname).Technical.RightPelvis.O(:,g) + (FRAME.(structname).Technical.RightPelvis.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightPelvis.O);
                                end
                                [FRAME.(structname).Anatomical.RightPelvis.V, FRAME.(structname).Anatomical.RightPelvis.ACC, FRAME.(structname).Anatomical.RightPelvis.LinV, FRAME.(structname).Anatomical.RightPelvis.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.RightPelvis.R,FRAME.(structname).Anatomical.RightPelvis.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.rad = getwinkel(FRAME.(structname).Anatomical.RightPelvis.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Pelvis Coordinate System']}];
                            end
                        end
                        % Left leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if OPTIONS.AnalyzedLeg ~= 'R'
                            % Left Forefoot
                            try
                                [FRAME.(structname).Technical.LeftForefoot.O, FRAME.(structname).Technical.LeftForefoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.toe_left.data, MARKERS.(structname).Opti.forefoot_lat_left.data, MARKERS.(structname).Opti.forefoot_med_left.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftForefoot.R, 3)
                                    FRAME.(structname).Anatomical.LeftForefoot.R(:,:,g) = FRAME.(structname).Technical.LeftForefoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftForefoot.R;
                                    FRAME.(structname).Anatomical.LeftForefoot.O(:,g) = FRAME.(structname).Technical.LeftForefoot.O(:,g) + (FRAME.(structname).Technical.LeftForefoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftForefoot.O);
                                end
                                [FRAME.(structname).Anatomical.LeftForefoot.V, FRAME.(structname).Anatomical.LeftForefoot.ACC, FRAME.(structname).Anatomical.LeftForefoot.LinV, FRAME.(structname).Anatomical.LeftForefoot.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftForefoot.R,FRAME.(structname).Anatomical.LeftForefoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.rad = getwinkel(FRAME.(structname).Anatomical.LeftForefoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Forefoot Coordinate System']}];
                            end
                            %Left Rearfoot
                            try
                                [FRAME.(structname).Technical.LeftRearfoot.O, FRAME.(structname).Technical.LeftRearfoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.calc_back_left.data, MARKERS.(structname).Opti.calc_med_left.data, MARKERS.(structname).Opti.calc_lat_left.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftRearfoot.R, 3)
                                    FRAME.(structname).Anatomical.LeftRearfoot.R(:,:,g) = FRAME.(structname).Technical.LeftRearfoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftRearfoot.R;
                                    FRAME.(structname).Anatomical.LeftRearfoot.O(:,g) = FRAME.(structname).Technical.LeftRearfoot.O(:,g) + (FRAME.(structname).Technical.LeftRearfoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftRearfoot.O);
                                end
                                [FRAME.(structname).Anatomical.LeftRearfoot.V, FRAME.(structname).Anatomical.LeftRearfoot.ACC, FRAME.(structname).Anatomical.LeftRearfoot.LinV, FRAME.(structname).Anatomical.LeftRearfoot.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftRearfoot.R,FRAME.(structname).Anatomical.LeftRearfoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.rad = getwinkel(FRAME.(structname).Anatomical.LeftRearfoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Rearfoot Coordinate System']}];
                            end
                            %Left Foot
                            try
                                [FRAME.(structname).Technical.LeftFoot.O, FRAME.(structname).Technical.LeftFoot.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.calc_back_left.data, MARKERS.(structname).Opti.forefoot_lat_left.data, MARKERS.(structname).Opti.forefoot_med_left.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftFoot.R, 3)
                                    FRAME.(structname).Anatomical.LeftFoot.R(:,:,g) = FRAME.(structname).Technical.LeftFoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftFoot.R;
                                    FRAME.(structname).Anatomical.LeftFoot.O(:,g) = FRAME.(structname).Technical.LeftFoot.O(:,g) + (FRAME.(structname).Technical.LeftFoot.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftFoot.O);
                                end
                                [FRAME.(structname).Anatomical.LeftFoot.V, FRAME.(structname).Anatomical.LeftFoot.ACC, FRAME.(structname).Anatomical.LeftFoot.LinV, FRAME.(structname).Anatomical.LeftFoot.LinACC, FRAME.(structname).Anatomical.LeftFoot.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftFoot.R,FRAME.(structname).Anatomical.LeftFoot.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Foot.rad = getwinkel(FRAME.(structname).Anatomical.LeftFoot.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Foot.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Foot.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Foot.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Foot Coordinate System']}];
                            end

                            %Left Shank
                            try
                                [FRAME.(structname).Technical.LeftShank.O, FRAME.(structname).Technical.LeftShank.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_tibia_left_1.data, MARKERS.(structname).Opti.cluster_tibia_left_2.data, MARKERS.(structname).Opti.cluster_tibia_left_3.data, MARKERS.(structname).Opti.cluster_tibia_left_4.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftShank.R, 3)
                                    FRAME.(structname).Anatomical.LeftShank.R(:,:,g) = FRAME.(structname).Technical.LeftShank.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftShank.R;
                                    FRAME.(structname).Anatomical.LeftShank.O(:,g) = FRAME.(structname).Technical.LeftShank.O(:,g) + (FRAME.(structname).Technical.LeftShank.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftShank.O);
                                end
                                [FRAME.(structname).Anatomical.LeftShank.V, FRAME.(structname).Anatomical.LeftShank.ACC, FRAME.(structname).Anatomical.LeftShank.LinV, FRAME.(structname).Anatomical.LeftShank.LinACC, FRAME.(structname).Anatomical.LeftShank.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftShank.R,FRAME.(structname).Anatomical.LeftShank.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Shank.rad = getwinkel(FRAME.(structname).Anatomical.LeftShank.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Shank.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Shank.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Shank.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Shank Coordinate System']}];
                            end
                            %Left Thigh
                            try
                                [FRAME.(structname).Technical.LeftThigh.O, FRAME.(structname).Technical.LeftThigh.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_femur_left_1.data, MARKERS.(structname).Opti.cluster_femur_left_2.data, MARKERS.(structname).Opti.cluster_femur_left_3.data, MARKERS.(structname).Opti.cluster_femur_left_4.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftThigh.R, 3)
                                    FRAME.(structname).Anatomical.LeftThigh.R(:,:,g) = FRAME.(structname).Technical.LeftThigh.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftThigh.R;
                                    FRAME.(structname).Anatomical.LeftThigh.O(:,g) = FRAME.(structname).Technical.LeftThigh.O(:,g) + (FRAME.(structname).Technical.LeftThigh.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftThigh.O);
                                end
                                [FRAME.(structname).Anatomical.LeftThigh.V, FRAME.(structname).Anatomical.LeftThigh.ACC, FRAME.(structname).Anatomical.LeftThigh.LinV, FRAME.(structname).Anatomical.LeftThigh.LinACC, FRAME.(structname).Anatomical.LeftThigh.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftThigh.R,FRAME.(structname).Anatomical.LeftThigh.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Thigh.rad = getwinkel(FRAME.(structname).Anatomical.LeftThigh.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Thigh.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Thigh.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Thigh.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Thigh Coordinate System']}];
                            end
                            %Left Pelvis
                            try
                                [FRAME.(structname).Technical.LeftPelvis.O, FRAME.(structname).Technical.LeftPelvis.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.SIAS_right.data, MARKERS.(structname).Opti.SIAS_left.data, MARKERS.(structname).Opti.SIPS_right.data, MARKERS.(structname).Opti.SIPS_left.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftPelvis.R, 3)
                                    FRAME.(structname).Anatomical.LeftPelvis.R(:,:,g) = FRAME.(structname).Technical.LeftPelvis.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftPelvis.R;
                                    FRAME.(structname).Anatomical.LeftPelvis.O(:,g) = FRAME.(structname).Technical.LeftPelvis.O(:,g) + (FRAME.(structname).Technical.LeftPelvis.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftPelvis.O);
                                end
                                [FRAME.(structname).Anatomical.LeftPelvis.V, FRAME.(structname).Anatomical.LeftPelvis.ACC, FRAME.(structname).Anatomical.LeftPelvis.LinV, FRAME.(structname).Anatomical.LeftPelvis.LinACC] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftPelvis.R,FRAME.(structname).Anatomical.LeftPelvis.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.rad = getwinkel(FRAME.(structname).Anatomical.LeftPelvis.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Pelvis Coordinate System']}];
                            end
                        end

                        if OPTIONS.AnalyzedLeg == 'B'
                            % Head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            try
                                [FRAME.(structname).Technical.Head.O, FRAME.(structname).Technical.Head.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.head_front_right.data, MARKERS.(structname).Opti.head_front_left.data, MARKERS.(structname).Opti.head_back_right.data, MARKERS.(structname).Opti.head_back_left.data);
                                for g = 1:size(FRAME.(structname).Technical.Head.R, 3)
                                    FRAME.(structname).Anatomical.Head.R(:,:,g) = FRAME.(structname).Technical.Head.R(:,:,g) * REFFRAME.Technical_to_Anatomical.Head.R;
                                    FRAME.(structname).Anatomical.Head.O(:,g) = FRAME.(structname).Technical.Head.O(:,g) + (FRAME.(structname).Technical.Head.R(:,:,g) * REFFRAME.Technical_to_Anatomical.Head.O);
                                end
                                [FRAME.(structname).Anatomical.Head.V, FRAME.(structname).Anatomical.Head.ACC, FRAME.(structname).Anatomical.Head.LinV, FRAME.(structname).Anatomical.Head.LinACC, FRAME.(structname).Anatomical.Head.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.Head.R,FRAME.(structname).Anatomical.Head.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Head.rad = getwinkel(FRAME.(structname).Anatomical.Head.R);
                                WINKEL.(structname).SEGMENT.Classic.Head.grad.X = WINKEL.(structname).SEGMENT.Classic.Head.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Head.grad.Y = WINKEL.(structname).SEGMENT.Classic.Head.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Head.grad.Z = WINKEL.(structname).SEGMENT.Classic.Head.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Head Coordinate System']}];
                            end
                            % Right Upper Extremity
                            % Right Upper Arm
                            try
                                [FRAME.(structname).Technical.RightUpperArm.O, FRAME.(structname).Technical.RightUpperArm.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_upperarm_right_1.data, MARKERS.(structname).Opti.cluster_upperarm_right_2.data, MARKERS.(structname).Opti.cluster_upperarm_right_3.data);
                                for g = 1:size(FRAME.(structname).Technical.RightUpperArm.R, 3)
                                    FRAME.(structname).Anatomical.RightUpperArm.R(:,:,g) = FRAME.(structname).Technical.RightUpperArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightUpperArm.R;
                                    FRAME.(structname).Anatomical.RightUpperArm.O(:,g) = FRAME.(structname).Technical.RightUpperArm.O(:,g) + (FRAME.(structname).Technical.RightUpperArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightUpperArm.O);
                                end
                                [FRAME.(structname).Anatomical.RightUpperArm.V, FRAME.(structname).Anatomical.RightUpperArm.ACC, FRAME.(structname).Anatomical.RightUpperArm.LinV, FRAME.(structname).Anatomical.RightUpperArm.LinACC, FRAME.(structname).Anatomical.RightUpperArm.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightUpperArm.R,FRAME.(structname).Anatomical.RightUpperArm.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.rad = getwinkel(FRAME.(structname).Anatomical.RightUpperArm.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Upperarm Coordinate System']}];
                            end
                            % Right Lower Arm
                            try
                                [FRAME.(structname).Technical.RightLowerArm.O, FRAME.(structname).Technical.RightLowerArm.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_lowerarm_right_1.data, MARKERS.(structname).Opti.cluster_lowerarm_right_2.data, MARKERS.(structname).Opti.cluster_lowerarm_right_3.data);
                                for g = 1:size(FRAME.(structname).Technical.RightLowerArm.R, 3)
                                    FRAME.(structname).Anatomical.RightLowerArm.R(:,:,g) = FRAME.(structname).Technical.RightLowerArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightLowerArm.R;
                                    FRAME.(structname).Anatomical.RightLowerArm.O(:,g) = FRAME.(structname).Technical.RightLowerArm.O(:,g) + (FRAME.(structname).Technical.RightLowerArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightLowerArm.O);
                                end
                                [FRAME.(structname).Anatomical.RightLowerArm.V, FRAME.(structname).Anatomical.RightLowerArm.ACC, FRAME.(structname).Anatomical.RightLowerArm.LinV, FRAME.(structname).Anatomical.RightLowerArm.LinACC, FRAME.(structname).Anatomical.RightLowerArm.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightLowerArm.R,FRAME.(structname).Anatomical.RightLowerArm.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.rad = getwinkel(FRAME.(structname).Anatomical.RightLowerArm.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Lowerarm Coordinate System']}];
                            end
                            % Right Hand
                            try
                                [FRAME.(structname).Technical.RightHand.O, FRAME.(structname).Technical.RightHand.R] = get_technical_frame_GUI(MARKERS.(structname).Filt.hand_med_right.data, MARKERS.(structname).Filt.hand_lat_right.data, MARKERS.(structname).Filt.hand_top_right.data);
                                for g = 1:size(FRAME.(structname).Technical.RightHand.R, 3)
                                    FRAME.(structname).Anatomical.RightHand.R(:,:,g) = FRAME.(structname).Technical.RightHand.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightHand.R;
                                    FRAME.(structname).Anatomical.RightHand.O(:,g) = FRAME.(structname).Technical.RightHand.O(:,g) + (FRAME.(structname).Technical.RightHand.R(:,:,g) * REFFRAME.Technical_to_Anatomical.RightHand.O);
                                end
                                [FRAME.(structname).Anatomical.RightHand.V, FRAME.(structname).Anatomical.RightHand.ACC, FRAME.(structname).Anatomical.RightHand.LinV, FRAME.(structname).Anatomical.RightHand.LinACC, FRAME.(structname).Anatomical.RightHand.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.RightHand.R,FRAME.(structname).Anatomical.RightHand.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Right_Hand.rad = getwinkel(FRAME.(structname).Anatomical.RightHand.R);
                                WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.X = WINKEL.(structname).SEGMENT.Classic.Right_Hand.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Y = WINKEL.(structname).SEGMENT.Classic.Right_Hand.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Z = WINKEL.(structname).SEGMENT.Classic.Right_Hand.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Hand Coordinate System']}];
                            end


                            % Left Upper Extremity
                            % Left Upper Arm
                            try
                                [FRAME.(structname).Technical.LeftUpperArm.O, FRAME.(structname).Technical.LeftUpperArm.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_upperarm_left_1.data, MARKERS.(structname).Opti.cluster_upperarm_left_2.data, MARKERS.(structname).Opti.cluster_upperarm_left_3.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftUpperArm.R, 3)
                                    FRAME.(structname).Anatomical.LeftUpperArm.R(:,:,g) = FRAME.(structname).Technical.LeftUpperArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftUpperArm.R;
                                    FRAME.(structname).Anatomical.LeftUpperArm.O(:,g) = FRAME.(structname).Technical.LeftUpperArm.O(:,g) + (FRAME.(structname).Technical.LeftUpperArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftUpperArm.O);
                                end
                                [FRAME.(structname).Anatomical.LeftUpperArm.V, FRAME.(structname).Anatomical.LeftUpperArm.ACC, FRAME.(structname).Anatomical.LeftUpperArm.LinV, FRAME.(structname).Anatomical.LeftUpperArm.LinACC, FRAME.(structname).Anatomical.LeftUpperArm.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftUpperArm.R,FRAME.(structname).Anatomical.LeftUpperArm.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.rad = getwinkel(FRAME.(structname).Anatomical.LeftUpperArm.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Upperarm Coordinate System']}];
                            end
                            % Left Lower Arm
                            try
                                [FRAME.(structname).Technical.LeftLowerArm.O, FRAME.(structname).Technical.LeftLowerArm.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.cluster_lowerarm_left_1.data, MARKERS.(structname).Opti.cluster_lowerarm_left_2.data, MARKERS.(structname).Opti.cluster_lowerarm_left_3.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftLowerArm.R, 3)
                                    FRAME.(structname).Anatomical.LeftLowerArm.R(:,:,g) = FRAME.(structname).Technical.LeftLowerArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftLowerArm.R;
                                    FRAME.(structname).Anatomical.LeftLowerArm.O(:,g) = FRAME.(structname).Technical.LeftLowerArm.O(:,g) + (FRAME.(structname).Technical.LeftLowerArm.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftLowerArm.O);
                                end
                                [FRAME.(structname).Anatomical.LeftLowerArm.V, FRAME.(structname).Anatomical.LeftLowerArm.ACC, FRAME.(structname).Anatomical.LeftLowerArm.LinV, FRAME.(structname).Anatomical.LeftLowerArm.LinACC, FRAME.(structname).Anatomical.LeftLowerArm.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftLowerArm.R,FRAME.(structname).Anatomical.LeftLowerArm.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.rad = getwinkel(FRAME.(structname).Anatomical.LeftLowerArm.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Lowerarm Coordinate System']}];
                            end
                            % Left Hand
                            try
                                [FRAME.(structname).Technical.LeftHand.O, FRAME.(structname).Technical.LeftHand.R] = get_technical_frame_GUI(MARKERS.(structname).Filt.hand_med_left.data, MARKERS.(structname).Filt.hand_lat_left.data, MARKERS.(structname).Filt.hand_top_left.data);
                                for g = 1:size(FRAME.(structname).Technical.LeftHand.R, 3)
                                    FRAME.(structname).Anatomical.LeftHand.R(:,:,g) = FRAME.(structname).Technical.LeftHand.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftHand.R;
                                    FRAME.(structname).Anatomical.LeftHand.O(:,g) = FRAME.(structname).Technical.LeftHand.O(:,g) + (FRAME.(structname).Technical.LeftHand.R(:,:,g) * REFFRAME.Technical_to_Anatomical.LeftHand.O);
                                end
                                [FRAME.(structname).Anatomical.LeftHand.V, FRAME.(structname).Anatomical.LeftHand.ACC, FRAME.(structname).Anatomical.LeftHand.LinV, FRAME.(structname).Anatomical.LeftHand.LinACC, FRAME.(structname).Anatomical.LeftHand.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.LeftHand.R,FRAME.(structname).Anatomical.LeftHand.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Left_Hand.rad = getwinkel(FRAME.(structname).Anatomical.LeftHand.R);
                                WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.X = WINKEL.(structname).SEGMENT.Classic.Left_Hand.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Y = WINKEL.(structname).SEGMENT.Classic.Left_Hand.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Z = WINKEL.(structname).SEGMENT.Classic.Left_Hand.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Hand Coordinate System']}];
                            end

                            % Trunk
                            try
                                [FRAME.(structname).Technical.Trunk.O, FRAME.(structname).Technical.Trunk.R] = get_technical_frame_GUI(MARKERS.(structname).Opti.clav.data, MARKERS.(structname).Opti.C_7.data, MARKERS.(structname).Opti.sternum.data);
                                for g = 1:size(FRAME.(structname).Technical.Trunk.R, 3)
                                    FRAME.(structname).Anatomical.Trunk.R(:,:,g) = FRAME.(structname).Technical.Trunk.R(:,:,g) * REFFRAME.Technical_to_Anatomical.Trunk.R;
                                    FRAME.(structname).Anatomical.Trunk.O(:,g) = FRAME.(structname).Technical.Trunk.O(:,g) + (FRAME.(structname).Technical.Trunk.R(:,:,g) * REFFRAME.Technical_to_Anatomical.Trunk.O);
                                end
                                [FRAME.(structname).Anatomical.Trunk.V, FRAME.(structname).Anatomical.Trunk.ACC, FRAME.(structname).Anatomical.Trunk.LinV, FRAME.(structname).Anatomical.Trunk.LinACC, FRAME.(structname).Anatomical.Trunk.Theta] = getsegmentderivatives(FRAME.(structname).Anatomical.Trunk.R,FRAME.(structname).Anatomical.Trunk.O, OPTIONS.FreqKinematics);
                                WINKEL.(structname).SEGMENT.Classic.Trunk.rad = getwinkel(FRAME.(structname).Anatomical.Trunk.R);
                                WINKEL.(structname).SEGMENT.Classic.Trunk.grad.X = WINKEL.(structname).SEGMENT.Classic.Trunk.rad.X./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Y = WINKEL.(structname).SEGMENT.Classic.Trunk.rad.Y./pi*180;
                                WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Z = WINKEL.(structname).SEGMENT.Classic.Trunk.rad.Z./pi*180;
                            catch
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Trunk Coordinate System']}];
                            end
                        end
                        %% Calculate Joint Angles
                        % Right Hip
                        try
                            R.(structname).Right_Hip_to_Thigh = getR_ref_norm(FRAME.(structname).Anatomical.RightPelvis.R, FRAME.(structname).Anatomical.RightThigh.R, REFFRAME.Joint.Right_Pelvis_to_Thigh, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_Hip_to_Thigh = getderivateM3point(R.(structname).Right_Hip_to_Thigh)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_Hip_to_Thigh = getTheta(R_Punkt.(structname).Right_Hip_to_Thigh, R.(structname).Right_Hip_to_Thigh);
                            JOINT.(structname).Right_Hip.AngV(1,:) =  THETA.(structname).Right_Hip_to_Thigh(3,2,:);
                            JOINT.(structname).Right_Hip.AngV(2,:) =  THETA.(structname).Right_Hip_to_Thigh(1,3,:);
                            JOINT.(structname).Right_Hip.AngV(3,:) =  THETA.(structname).Right_Hip_to_Thigh(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Hip.rad = getwinkel(R.(structname).Right_Hip_to_Thigh);
                            WINKEL.(structname).JOINT.Classic.Right_Hip.grad.X = WINKEL.(structname).JOINT.Classic.Right_Hip.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Hip.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Hip.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Hip Joint Angle']}];
                        end
                        % Right Knee
                        try
                            R.(structname).Right_Thigh_to_Shank = getR_ref_norm(FRAME.(structname).Anatomical.RightThigh.R, FRAME.(structname).Anatomical.RightShank.R, REFFRAME.Joint.Right_Thigh_to_Shank, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_Thigh_to_Shank = getderivateM3point(R.(structname).Right_Thigh_to_Shank)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_Thigh_to_Shank = getTheta(R_Punkt.(structname).Right_Thigh_to_Shank, R.(structname).Right_Thigh_to_Shank);
                            JOINT.(structname).Right_Knee.AngV(1,:) =  THETA.(structname).Right_Thigh_to_Shank(3,2,:);
                            JOINT.(structname).Right_Knee.AngV(2,:) =  THETA.(structname).Right_Thigh_to_Shank(1,3,:);
                            JOINT.(structname).Right_Knee.AngV(3,:) =  THETA.(structname).Right_Thigh_to_Shank(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Knee.rad = getwinkel(R.(structname).Right_Thigh_to_Shank);
                            WINKEL.(structname).JOINT.Classic.Right_Knee.grad.X = WINKEL.(structname).JOINT.Classic.Right_Knee.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Knee.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Knee.rad.Z./pi*180;
                        catch ME
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Knee Joint Angle']}];
                        end
                        % Right Ankle
                        try
                            R.(structname).Right_Shank_to_Rearfoot = getR_ref_norm(FRAME.(structname).Anatomical.RightShank.R, FRAME.(structname).Anatomical.RightRearfoot.R, REFFRAME.Joint.Right_Shank_to_Rearfoot, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_Shank_to_Rearfoot = getderivateM3point(R.(structname).Right_Shank_to_Rearfoot)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_Shank_to_Rearfoot = getTheta(R_Punkt.(structname).Right_Shank_to_Rearfoot, R.(structname).Right_Shank_to_Rearfoot);
                            JOINT.(structname).Right_Ankle.AngV(1,:) =  THETA.(structname).Right_Shank_to_Rearfoot(3,2,:);
                            JOINT.(structname).Right_Ankle.AngV(2,:) =  THETA.(structname).Right_Shank_to_Rearfoot(1,3,:);
                            JOINT.(structname).Right_Ankle.AngV(3,:) =  THETA.(structname).Right_Shank_to_Rearfoot(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Ankle.rad = getwinkel(R.(structname).Right_Shank_to_Rearfoot);
                            WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.X = WINKEL.(structname).JOINT.Classic.Right_Ankle.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Ankle.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Ankle.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Ankle Joint Angle']}];
                        end

                        % Right MPT Joint
                        try
                            R.(structname).Right_Rearfoot_to_Forefoot = getR_ref_norm(FRAME.(structname).Anatomical.RightRearfoot.R, FRAME.(structname).Anatomical.RightForefoot.R, REFFRAME.Joint.Right_Rearfoot_to_Forefoot, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_Rearfoot_to_Forefoot = getderivateM3point(R.(structname).Right_Rearfoot_to_Forefoot)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_Rearfoot_to_Forefoot = getTheta(R_Punkt.(structname).Right_Rearfoot_to_Forefoot, R.(structname).Right_Rearfoot_to_Forefoot);
                            JOINT.(structname).Right_MPJ.AngV(1,:) =  THETA.(structname).Right_Rearfoot_to_Forefoot(3,2,:);
                            JOINT.(structname).Right_MPJ.AngV(2,:) =  THETA.(structname).Right_Rearfoot_to_Forefoot(1,3,:);
                            JOINT.(structname).Right_MPJ.AngV(3,:) =  THETA.(structname).Right_Rearfoot_to_Forefoot(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_MPJ.rad = getwinkel(R.(structname).Right_Rearfoot_to_Forefoot);
                            WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.X = WINKEL.(structname).JOINT.Classic.Right_MPJ.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Y = WINKEL.(structname).JOINT.Classic.Right_MPJ.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Z = WINKEL.(structname).JOINT.Classic.Right_MPJ.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right MPT Joint Angle']}];
                        end


                        % Right Shoulder Joint
                        try
                            R.(structname).Trunk_to_Right_UpperArm = getR_ref_norm(FRAME.(structname).Anatomical.Trunk.R, FRAME.(structname).Anatomical.RightUpperArm.R, REFFRAME.Joint.Trunk_to_RightUpperArm, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Trunk_to_RightUpperArm = getderivateM3point(R.(structname).Trunk_to_Right_UpperArm)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Trunk_to_RightUpperArm = getTheta(R_Punkt.(structname).Trunk_to_RightUpperArm, R.(structname).Trunk_to_Right_UpperArm);
                            JOINT.(structname).Right_Shoulder.AngV(1,:) =  THETA.(structname).Trunk_to_RightUpperArm(3,2,:);
                            JOINT.(structname).Right_Shoulder.AngV(2,:) =  THETA.(structname).Trunk_to_RightUpperArm(1,3,:);
                            JOINT.(structname).Right_Shoulder.AngV(3,:) =  THETA.(structname).Trunk_to_RightUpperArm(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Shoulder.rad = getwinkel(R.(structname).Trunk_to_Right_UpperArm);
                            WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.X = WINKEL.(structname).JOINT.Classic.Right_Shoulder.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Shoulder.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Shoulder.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Shoulder Joint Angle']}];
                        end

                        % Right Elbow Joint
                        try
                            R.(structname).Right_UpperArm_to_LowerArm = getR_ref_norm(FRAME.(structname).Anatomical.RightUpperArm.R, FRAME.(structname).Anatomical.RightLowerArm.R, REFFRAME.Joint.Right_UpperArm_to_LowerArm, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_UpperArm_to_LowerArm = getderivateM3point(R.(structname).Right_UpperArm_to_LowerArm)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_UpperArm_to_LowerArm = getTheta(R_Punkt.(structname).Right_UpperArm_to_LowerArm, R.(structname).Right_UpperArm_to_LowerArm);
                            JOINT.(structname).Right_Elbow.AngV(1,:) =  THETA.(structname).Right_UpperArm_to_LowerArm(3,2,:);
                            JOINT.(structname).Right_Elbow.AngV(2,:) =  THETA.(structname).Right_UpperArm_to_LowerArm(1,3,:);
                            JOINT.(structname).Right_Elbow.AngV(3,:) =  THETA.(structname).Right_UpperArm_to_LowerArm(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Elbow.rad = getwinkel(R.(structname).Right_UpperArm_to_LowerArm);
                            WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.X = WINKEL.(structname).JOINT.Classic.Right_Elbow.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Elbow.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Elbow.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Elbow Joint Angle']}];
                        end

                        % Right Wrist Joint
                        try
                            R.(structname).Right_LowerArm_to_Hand = getR_ref_norm(FRAME.(structname).Anatomical.RightLowerArm.R, FRAME.(structname).Anatomical.RightHand.R, REFFRAME.Joint.Right_LowerArm_to_Hand, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Right_LowerArm_to_Hand = getderivateM3point(R.(structname).Right_LowerArm_to_Hand)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Right_LowerArm_to_Hand = getTheta(R_Punkt.(structname).Right_LowerArm_to_Hand, R.(structname).Right_LowerArm_to_Hand);
                            JOINT.(structname).Right_Wrist.AngV(1,:) =  THETA.(structname).Right_LowerArm_to_Hand(3,2,:);
                            JOINT.(structname).Right_Wrist.AngV(2,:) =  THETA.(structname).Right_LowerArm_to_Hand(1,3,:);
                            JOINT.(structname).Right_Wrist.AngV(3,:) =  THETA.(structname).Right_LowerArm_to_Hand(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Right_Wrist.rad = getwinkel(R.(structname).Right_LowerArm_to_Hand);
                            WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.X = WINKEL.(structname).JOINT.Classic.Right_Wrist.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.Y = WINKEL.(structname).JOINT.Classic.Right_Wrist.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.Z = WINKEL.(structname).JOINT.Classic.Right_Wrist.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right Wrist Joint Angle']}];
                        end

                        % Left Hip
                        try
                            R.(structname).Left_Hip_to_Thigh = getR_ref_norm(FRAME.(structname).Anatomical.LeftPelvis.R, FRAME.(structname).Anatomical.LeftThigh.R, REFFRAME.Joint.Left_Pelvis_to_Thigh, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_Hip_to_Thigh = getderivateM3point(R.(structname).Left_Hip_to_Thigh)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_Hip_to_Thigh = getTheta(R_Punkt.(structname).Left_Hip_to_Thigh, R.(structname).Left_Hip_to_Thigh);
                            JOINT.(structname).Left_Hip.AngV(1,:) =  THETA.(structname).Left_Hip_to_Thigh(3,2,:);
                            JOINT.(structname).Left_Hip.AngV(2,:) =  THETA.(structname).Left_Hip_to_Thigh(1,3,:);
                            JOINT.(structname).Left_Hip.AngV(3,:) =  THETA.(structname).Left_Hip_to_Thigh(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Hip.rad = getwinkel(R.(structname).Left_Hip_to_Thigh);
                            WINKEL.(structname).JOINT.Classic.Left_Hip.grad.X = WINKEL.(structname).JOINT.Classic.Left_Hip.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Hip.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Hip.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Hip Joint Angle']}];
                        end
                        % Left Knee
                        try
                            R.(structname).Left_Thigh_to_Shank = getR_ref_norm(FRAME.(structname).Anatomical.LeftThigh.R, FRAME.(structname).Anatomical.LeftShank.R, REFFRAME.Joint.Left_Thigh_to_Shank, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_Thigh_to_Shank = getderivateM3point(R.(structname).Left_Thigh_to_Shank)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_Thigh_to_Shank = getTheta(R_Punkt.(structname).Left_Thigh_to_Shank, R.(structname).Left_Thigh_to_Shank);
                            JOINT.(structname).Left_Knee.AngV(1,:) =  THETA.(structname).Left_Thigh_to_Shank(3,2,:);
                            JOINT.(structname).Left_Knee.AngV(2,:) =  THETA.(structname).Left_Thigh_to_Shank(1,3,:);
                            JOINT.(structname).Left_Knee.AngV(3,:) =  THETA.(structname).Left_Thigh_to_Shank(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Knee.rad = getwinkel(R.(structname).Left_Thigh_to_Shank);
                            WINKEL.(structname).JOINT.Classic.Left_Knee.grad.X = WINKEL.(structname).JOINT.Classic.Left_Knee.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Knee.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Knee.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Knee Joint Angle']}];
                        end
                        % Left Ankle
                        try
                            R.(structname).Left_Shank_to_Rearfoot = getR_ref_norm(FRAME.(structname).Anatomical.LeftShank.R, FRAME.(structname).Anatomical.LeftRearfoot.R, REFFRAME.Joint.Left_Shank_to_Rearfoot, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_Shank_to_Rearfoot = getderivateM3point(R.(structname).Left_Shank_to_Rearfoot)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_Shank_to_Rearfoot = getTheta(R_Punkt.(structname).Left_Shank_to_Rearfoot, R.(structname).Left_Shank_to_Rearfoot);
                            JOINT.(structname).Left_Ankle.AngV(1,:) =  THETA.(structname).Left_Shank_to_Rearfoot(3,2,:);
                            JOINT.(structname).Left_Ankle.AngV(2,:) =  THETA.(structname).Left_Shank_to_Rearfoot(1,3,:);
                            JOINT.(structname).Left_Ankle.AngV(3,:) =  THETA.(structname).Left_Shank_to_Rearfoot(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Ankle.rad = getwinkel(R.(structname).Left_Shank_to_Rearfoot);
                            WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.X = WINKEL.(structname).JOINT.Classic.Left_Ankle.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Ankle.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Ankle.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Ankle Joint Angle']}];
                        end

                        %Left MTP
                        try
                            R.(structname).Left_Rearfoot_to_Forefoot = getR_ref_norm(FRAME.(structname).Anatomical.LeftRearfoot.R, FRAME.(structname).Anatomical.LeftForefoot.R, REFFRAME.Joint.Left_Rearfoot_to_Forefoot, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_Rearfoot_to_Forefoot = getderivateM3point(R.(structname).Left_Rearfoot_to_Forefoot)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_Rearfoot_to_Forefoot = getTheta(R_Punkt.(structname).Left_Rearfoot_to_Forefoot, R.(structname).Left_Rearfoot_to_Forefoot);
                            JOINT.(structname).Left_MPJ.AngV(1,:) =  THETA.(structname).Left_Rearfoot_to_Forefoot(3,2,:);
                            JOINT.(structname).Left_MPJ.AngV(2,:) =  THETA.(structname).Left_Rearfoot_to_Forefoot(1,3,:);
                            JOINT.(structname).Left_MPJ.AngV(3,:) =  THETA.(structname).Left_Rearfoot_to_Forefoot(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_MPJ.rad = getwinkel(R.(structname).Left_Rearfoot_to_Forefoot);
                            WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.X = WINKEL.(structname).JOINT.Classic.Left_MPJ.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Y = WINKEL.(structname).JOINT.Classic.Left_MPJ.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Z = WINKEL.(structname).JOINT.Classic.Left_MPJ.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left MTP Joint Angle']}];
                        end

                        % Left Shoulder Joint
                        try
                            R.(structname).Trunk_to_Left_UpperArm = getR_ref_norm(FRAME.(structname).Anatomical.Trunk.R, FRAME.(structname).Anatomical.LeftUpperArm.R, REFFRAME.Joint.Trunk_to_LeftUpperArm, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Trunk_to_LeftUpperArm = getderivateM3point(R.(structname).Trunk_to_Left_UpperArm)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Trunk_to_LeftUpperArm = getTheta(R_Punkt.(structname).Trunk_to_LeftUpperArm, R.(structname).Trunk_to_Left_UpperArm);
                            JOINT.(structname).Left_Shoulder.AngV(1,:) =  THETA.(structname).Trunk_to_LeftUpperArm(3,2,:);
                            JOINT.(structname).Left_Shoulder.AngV(2,:) =  THETA.(structname).Trunk_to_LeftUpperArm(1,3,:);
                            JOINT.(structname).Left_Shoulder.AngV(3,:) =  THETA.(structname).Trunk_to_LeftUpperArm(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Shoulder.rad = getwinkel(R.(structname).Trunk_to_Left_UpperArm);
                            WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.X = WINKEL.(structname).JOINT.Classic.Left_Shoulder.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Shoulder.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Shoulder.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Shoulder Joint Angle']}];
                        end

                        % Left Elbow Joint
                        try
                            R.(structname).Left_UpperArm_to_LowerArm = getR_ref_norm(FRAME.(structname).Anatomical.LeftUpperArm.R, FRAME.(structname).Anatomical.LeftLowerArm.R, REFFRAME.Joint.Left_UpperArm_to_LowerArm, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_UpperArm_to_LowerArm = getderivateM3point(R.(structname).Left_UpperArm_to_LowerArm)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_UpperArm_to_LowerArm = getTheta(R_Punkt.(structname).Left_UpperArm_to_LowerArm, R.(structname).Left_UpperArm_to_LowerArm);
                            JOINT.(structname).Left_Elbow.AngV(1,:) =  THETA.(structname).Left_UpperArm_to_LowerArm(3,2,:);
                            JOINT.(structname).Left_Elbow.AngV(2,:) =  THETA.(structname).Left_UpperArm_to_LowerArm(1,3,:);
                            JOINT.(structname).Left_Elbow.AngV(3,:) =  THETA.(structname).Left_UpperArm_to_LowerArm(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Elbow.rad = getwinkel(R.(structname).Left_UpperArm_to_LowerArm);
                            WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.X = WINKEL.(structname).JOINT.Classic.Left_Elbow.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Elbow.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Elbow.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Elbow Joint Angle']}];
                        end

                        % Left Wrist Joint
                        try
                            R.(structname).Left_LowerArm_to_Hand = getR_ref_norm(FRAME.(structname).Anatomical.LeftLowerArm.R, FRAME.(structname).Anatomical.LeftHand.R, REFFRAME.Joint.Left_LowerArm_to_Hand, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Left_LowerArm_to_Hand = getderivateM3point(R.(structname).Left_LowerArm_to_Hand)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Left_LowerArm_to_Hand = getTheta(R_Punkt.(structname).Left_LowerArm_to_Hand, R.(structname).Left_LowerArm_to_Hand);
                            JOINT.(structname).Left_Wrist.AngV(1,:) =  THETA.(structname).Left_LowerArm_to_Hand(3,2,:);
                            JOINT.(structname).Left_Wrist.AngV(2,:) =  THETA.(structname).Left_LowerArm_to_Hand(1,3,:);
                            JOINT.(structname).Left_Wrist.AngV(3,:) =  THETA.(structname).Left_LowerArm_to_Hand(2,1,:);
                            WINKEL.(structname).JOINT.Classic.Left_Wrist.rad = getwinkel(R.(structname).Left_LowerArm_to_Hand);
                            WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.X = WINKEL.(structname).JOINT.Classic.Left_Wrist.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.Y = WINKEL.(structname).JOINT.Classic.Left_Wrist.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.Z = WINKEL.(structname).JOINT.Classic.Left_Wrist.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Left Wrist Joint Angle']}];
                        end

                        % Trunk to Head
                        try
                            R.(structname).Trunk_to_Head = getR_ref_norm(FRAME.(structname).Anatomical.Trunk.R, FRAME.(structname).Anatomical.Head.R, REFFRAME.Joint.Trunk_to_Head, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Trunk_to_Head = getderivateM3point(R.(structname).Trunk_to_Head)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Trunk_to_Head = getTheta(R_Punkt.(structname).Trunk_to_Head, R.(structname).Trunk_to_Head);
                            JOINT.(structname).TrunktoHead.AngV(1,:) =  THETA.(structname).Trunk_to_Head(3,2,:);
                            JOINT.(structname).TrunktoHead.AngV(2,:) =  THETA.(structname).Trunk_to_Head(1,3,:);
                            JOINT.(structname).TrunktoHead.AngV(3,:) =  THETA.(structname).Trunk_to_Head(2,1,:);
                            WINKEL.(structname).JOINT.Classic.TrunktoHead.rad = getwinkel(R.(structname).Trunk_to_Head);
                            WINKEL.(structname).JOINT.Classic.TrunktoHead.grad.X = WINKEL.(structname).JOINT.Classic.TrunktoHead.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.TrunktoHead.grad.Y = WINKEL.(structname).JOINT.Classic.TrunktoHead.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.TrunktoHead.grad.Z = WINKEL.(structname).JOINT.Classic.TrunktoHead.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right TrunktoHead Joint Angle']}];
                        end

                        % Pelvis to Trunk
                        try
                            R.(structname).Pelvis_to_Trunk = getR_ref_norm(FRAME.(structname).Anatomical.RightPelvis.R, FRAME.(structname).Anatomical.Trunk.R, REFFRAME.Joint.Pelvis_to_Trunk, get(gui.RefToStatic, 'Value'));
                            R_Punkt.(structname).Pelvis_to_Trunk = getderivateM3point(R.(structname).Pelvis_to_Trunk)./(1/OPTIONS.FreqKinematics);
                            THETA.(structname).Pelvis_to_Trunk = getTheta(R_Punkt.(structname).Pelvis_to_Trunk, R.(structname).Pelvis_to_Trunk);
                            JOINT.(structname).PelvistoTrunk.AngV(1,:) =  THETA.(structname).Pelvis_to_Trunk(3,2,:);
                            JOINT.(structname).PelvistoTrunk.AngV(2,:) =  THETA.(structname).Pelvis_to_Trunk(1,3,:);
                            JOINT.(structname).PelvistoTrunk.AngV(3,:) =  THETA.(structname).Pelvis_to_Trunk(2,1,:);
                            WINKEL.(structname).JOINT.Classic.PelvistoTrunk.rad = getwinkel(R.(structname).Pelvis_to_Trunk);
                            WINKEL.(structname).JOINT.Classic.PelvistoTrunk.grad.X = WINKEL.(structname).JOINT.Classic.PelvistoTrunk.rad.X./pi*180;
                            WINKEL.(structname).JOINT.Classic.PelvistoTrunk.grad.Y = WINKEL.(structname).JOINT.Classic.PelvistoTrunk.rad.Y./pi*180;
                            WINKEL.(structname).JOINT.Classic.PelvistoTrunk.grad.Z = WINKEL.(structname).JOINT.Classic.PelvistoTrunk.rad.Z./pi*180;
                        catch
                            data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Right PelvistoTrunk Joint Angle']}];
                        end


                        %% Calculate Center of Mass
                        try
                            for h = 1:size(FRAME.(structname).Anatomical.RightForefoot.O,2)
                                MARKERS.(structname).Calc.CoM_MALE(:,h) = FRAME.(structname).Anatomical.Head.O(:,h).*0.0694 + FRAME.(structname).Anatomical.Trunk.O(:,h).*0.4346 + FRAME.(structname).Anatomical.RightUpperArm.O(:,h).*0.0271 + FRAME.(structname).Anatomical.LeftUpperArm.O(:,h).*0.0271...
                                    + FRAME.(structname).Anatomical.RightLowerArm.O(:,h).*0.0162 + FRAME.(structname).Anatomical.LeftLowerArm.O(:,h).*0.0162 + FRAME.(structname).Anatomical.RightHand.O(:,h).*0.0061 + FRAME.(structname).Anatomical.LeftHand.O(:,h).*0.0061...
                                    + FRAME.(structname).Anatomical.RightThigh.O(:,h).*0.1416 + FRAME.(structname).Anatomical.LeftThigh.O(:,h).*0.1416 + FRAME.(structname).Anatomical.RightShank.O(:,h).*0.0433 + FRAME.(structname).Anatomical.LeftShank.O(:,h).*0.0433...
                                    + FRAME.(structname).Anatomical.RightFoot.O(:,h).*0.0137 + FRAME.(structname).Anatomical.LeftFoot.O(:,h).*0.0137;
                            end
                            MARKERS.(structname).Calc.VCoM_MALE = getderivateCOMVEL3point(MARKERS.(structname).Calc.CoM_MALE)./(1/OPTIONS.FreqKinematics) / 1000;
                        catch
                            %                             data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine Center of Mass']}];
                        end

                        %% Read in force data
                        if (OPTIONS.ExperimentalSetup == 6)

                            [FP.(structname).COP, FP.(structname).COP_vid,  FP.(structname).GRFfilt,FP.(structname).GRFfilt_vid, FP.(structname).FM, FP.(structname).ind_baseline] = get_treadmill_GRF_GUI_MoTrack_mat([pathname, char(filename(1,i))], OPTIONS, 1);


                            CONTACT.(structname) = getContactTreadmill_MoTrack(FP.(structname), MARKERS.(structname), OPTIONS);
                            FP.(structname).GRFfilt.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).GRFfilt.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Left = zeros(size(FP.(structname).GRFfilt.Both));

                            for w = 1:size(CONTACT.(structname).EVENTS_R,2)
                                FP.(structname).GRFfilt.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).COP.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).FM.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                            end

                            for w = 1:size(CONTACT.(structname).EVENTS_L,2)
                                FP.(structname).GRFfilt.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).COP.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).FM.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                            end
                            try
                                size(FRAME.(structname).Anatomical.LeftFoot.R);
                                use = 'LeftFoot';
                            catch
                                size(FRAME.(structname).Anatomical.RightFoot.R);
                                use = 'RightFoot';

                            end
                            for d = 1:size(FRAME.(structname).Anatomical.(use).R, 3)
                                try
                                    MARKERS.(structname).Derived.RightMPJC(:,d) = FRAME.(structname).Anatomical.RightForefoot.O(:,d)  +  FRAME.(structname).Anatomical.RightForefoot.R(:,:,d) * REFMARKERS.Derived.RightMPJCinForefoot;
                                    MARKERS.(structname).Derived.RightAnkleJC(:,d) = FRAME.(structname).Anatomical.RightShank.O(:,d)  +  FRAME.(structname).Anatomical.RightShank.R(:,:,d) * REFMARKERS.Derived.RightAnkleJCinShank;
                                    MARKERS.(structname).Derived.RightKneeJC(:,d) = FRAME.(structname).Anatomical.RightThigh.O(:,d)  +  FRAME.(structname).Anatomical.RightThigh.R(:,:,d) * REFMARKERS.Derived.RightKneeJCinThigh;
                                    MARKERS.(structname).Derived.RightHipJC(:,d) = FRAME.(structname).Anatomical.RightPelvis.O(:,d)  +  FRAME.(structname).Anatomical.RightPelvis.R(:,:,d) * REFMARKERS.Derived.RightHipJCinPelvis;
                                end
                                try
                                    MARKERS.(structname).Derived.LeftMPJC(:,d) = FRAME.(structname).Anatomical.LeftForefoot.O(:,d)  +  FRAME.(structname).Anatomical.LeftForefoot.R(:,:,d) * REFMARKERS.Derived.LeftMPJCinForefoot;
                                    MARKERS.(structname).Derived.LeftAnkleJC(:,d) = FRAME.(structname).Anatomical.LeftShank.O(:,d)  +  FRAME.(structname).Anatomical.LeftShank.R(:,:,d) * REFMARKERS.Derived.LeftAnkleJCinShank;
                                    MARKERS.(structname).Derived.LeftKneeJC(:,d) = FRAME.(structname).Anatomical.LeftThigh.O(:,d)  +  FRAME.(structname).Anatomical.LeftThigh.R(:,:,d) * REFMARKERS.Derived.LeftKneeJCinThigh;
                                    MARKERS.(structname).Derived.LeftHipJC(:,d) = FRAME.(structname).Anatomical.LeftPelvis.O(:,d)  +  FRAME.(structname).Anatomical.LeftPelvis.R(:,:,d) * REFMARKERS.Derived.LeftHipJCinPelvis;
                                end
                            end
                            a=2;
                            KINETICS.(structname) = InverseDynamik_Hof(FRAME.(structname).Anatomical, OPTIONS, FP.(structname), MARKERS.(structname));

                        end

                        if OPTIONS.ExperimentalSetup == 7
                            %                             try
                            if OPTIONS.AnalyzedLeg == 'R'
                                [FP.(structname).Forceplate,  RFP, Cornerpoints, freq_grf] = getFPdata_MAX_OG_VS_TM_MAT([pathname, char(filename(1,i))], OPTIONS.ForcePlateNumber, OPTIONS.CutOffGRF, MARKERS.(structname).Opti.calc_back_right.data, 0, 1);
                                bbbb= 2;
                            else
                                [FP.(structname).Forceplate,  RFP, Cornerpoints, freq_grf] = getFPdata_MAX_OG_VS_TM_MAT([pathname, char(filename(1,i))], OPTIONS.ForcePlateNumber, OPTIONS.CutOffGRF, MARKERS.(structname).Opti.calc_back_left.data, 0, 1);
                            end
                            %                                 if get(gui.UseRawContact, 'Value')
                            %                                     CONTACT.(structname) = getContact_FP(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).GlobalRAW, OPTIONS.ForceTreshold);
                            %                                 else
                            %                                     CONTACT.(structname) = getContact_FP(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global, OPTIONS.ForceTreshold);
                            %                                 end
                            %                                 if get(gui.UseRawContact, 'Value')
                            %                                     CONTACT.(structname) = getContact_FPsprintstart(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).GlobalRAW, FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).COPglobal, OPTIONS.ForceTreshold);
                            %                                 else
                            %                                     CONTACT.(structname) = getContact_FPsprintstart(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global, FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).COPglobal, OPTIONS.ForceTreshold);
                            %                                 end
                            if get(gui.UseRawContact, 'Value')
                                CONTACT.(structname) = getContact_FP(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).GlobalRAW(3,:), OPTIONS.ForceTreshold, 1); %ausprobieren mit der 1
                            else
                                CONTACT.(structname) = getContact_FP(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global(3,:), OPTIONS.ForceTreshold);
                            end
                            FP.(structname).GRFfilt.Right = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            FP.(structname).GRFfilt.Left = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            FP.(structname).COP.Right = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            FP.(structname).COP.Left = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            FP.(structname).FM.Right = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            FP.(structname).FM.Left = zeros(size(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global));
                            if OPTIONS.AnalyzedLeg == 'R' || OPTIONS.AnalyzedLeg == 'B'
                                FP.(structname).GRFfilt.Right(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global(:,CONTACT.(structname));
                                FP.(structname).COP.Right(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).COPglobal(:,CONTACT.(structname));
                                %                                 FP.(structname).FM.Right(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).FreeMomentglobal(:,CONTACT.(structname));
                            elseif OPTIONS.AnalyzedLeg == 'L' || OPTIONS.AnalyzedLeg == 'B'
                                FP.(structname).GRFfilt.Left(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).Global(:,CONTACT.(structname));
                                FP.(structname).COP.Left(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).COPglobal(:,CONTACT.(structname));
                                %                                 FP.(structname).FM.Left(:,CONTACT.(structname)) = FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).FreeMomentglobal(:,CONTACT.(structname));
                            end

                            try
                                letrial = size(FRAME.(structname).Anatomical.RightFoot.R, 3);
                            catch
                                letrial = size(FRAME.(structname).Anatomical.LeftFoot.R, 3);
                            end

                            for d = 1:letrial
                                try
                                    MARKERS.(structname).Derived.RightMPJC(:,d) = FRAME.(structname).Anatomical.RightForefoot.O(:,d)  +  FRAME.(structname).Anatomical.RightForefoot.R(:,:,d) * REFMARKERS.Derived.RightMPJCinForefoot;
                                    MARKERS.(structname).Derived.RightAnkleJC(:,d) = FRAME.(structname).Anatomical.RightShank.O(:,d)  +  FRAME.(structname).Anatomical.RightShank.R(:,:,d) * REFMARKERS.Derived.RightAnkleJCinShank;
                                    MARKERS.(structname).Derived.RightKneeJC(:,d) = FRAME.(structname).Anatomical.RightThigh.O(:,d)  +  FRAME.(structname).Anatomical.RightThigh.R(:,:,d) * REFMARKERS.Derived.RightKneeJCinThigh;
                                    MARKERS.(structname).Derived.RightHipJC(:,d) = FRAME.(structname).Anatomical.RightPelvis.O(:,d)  +  FRAME.(structname).Anatomical.RightPelvis.R(:,:,d) * REFMARKERS.Derived.RightHipJCinPelvis;
                                end
                                try
                                    MARKERS.(structname).Derived.LeftMPJC(:,d) = FRAME.(structname).Anatomical.LeftForefoot.O(:,d)  +  FRAME.(structname).Anatomical.LeftForefoot.R(:,:,d) * REFMARKERS.Derived.LeftMPJCinForefoot;
                                    MARKERS.(structname).Derived.LeftAnkleJC(:,d) = FRAME.(structname).Anatomical.LeftShank.O(:,d)  +  FRAME.(structname).Anatomical.LeftShank.R(:,:,d) * REFMARKERS.Derived.LeftAnkleJCinShank;
                                    MARKERS.(structname).Derived.LeftKneeJC(:,d) = FRAME.(structname).Anatomical.LeftThigh.O(:,d)  +  FRAME.(structname).Anatomical.LeftThigh.R(:,:,d) * REFMARKERS.Derived.LeftKneeJCinThigh;
                                    MARKERS.(structname).Derived.LeftHipJC(:,d) = FRAME.(structname).Anatomical.LeftPelvis.O(:,d)  +  FRAME.(structname).Anatomical.LeftPelvis.R(:,:,d) * REFMARKERS.Derived.LeftHipJCinPelvis;
                                end

                            end


                            KINETICS.(structname) = InverseDynamik_Hof(FRAME.(structname).Anatomical, OPTIONS, FP.(structname), MARKERS.(structname));


                            %                             end

                            %% Calculate joint Power
                            % left MTP joint
                            try
                                KINETICS.(structname).LeftMPJointPower = KINETICS.(structname).LeftMPJMomentInProximal.*fit_n(JOINT.(structname).Left_MPJ.AngV, length(KINETICS.(structname).LeftMPJMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left MTP joint power']}];
                            end
                            % left ankle joint
                            try
                                KINETICS.(structname).LeftAnkleJointPower = KINETICS.(structname).LeftAnkleMomentInProximal.*fit_n(JOINT.(structname).Left_Ankle.AngV, length(KINETICS.(structname).LeftAnkleMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left ankle joint power']}];
                            end
                            % left knee joint
                            try
                                KINETICS.(structname).LeftKneeJointPower = KINETICS.(structname).LeftKneeMomentInProximal.*fit_n(JOINT.(structname).Left_Knee.AngV, length(KINETICS.(structname).LeftKneeMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left knee joint power']}];
                            end
                            % left hip joint
                            try
                                KINETICS.(structname).LeftHipJointPower = KINETICS.(structname).LeftHipMomentInProximal.*fit_n(JOINT.(structname).Left_Hip.AngV, length(KINETICS.(structname).LeftHipMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left hip joint power']}];
                            end
                            % right MTP joint
                            try
                                KINETICS.(structname).RightMPJointPower = KINETICS.(structname).RightMPJMomentInProximal.*fit_n(JOINT.(structname).Right_MPJ.AngV, length(KINETICS.(structname).RightMPJMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right MTP joint power']}];
                            end
                            % right ankle joint
                            try
                                KINETICS.(structname).RightAnkleJointPower = KINETICS.(structname).RightAnkleMomentInProximal.*fit_n(JOINT.(structname).Right_Ankle.AngV, length(KINETICS.(structname).RightAnkleMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right ankle joint power']}];
                            end
                            % right knee joint
                            try
                                KINETICS.(structname).RightKneeJointPower = KINETICS.(structname).RightKneeMomentInProximal.*fit_n(JOINT.(structname).Right_Knee.AngV, length(KINETICS.(structname).RightKneeMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right knee joint power']}];
                            end
                            % right hip joint
                            try
                                KINETICS.(structname).RightHipJointPower = KINETICS.(structname).RightHipMomentInProximal.*fit_n(JOINT.(structname).Right_Hip.AngV, length(KINETICS.(structname).RightHipMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right hip joint power']}];
                            end
                        end


                        if (OPTIONS.ExperimentalSetup == 8)

                            [FP.(structname).COP, FP.(structname).COP_vid,  FP.(structname).GRFfilt,FP.(structname).GRFfilt_vid, FP.(structname).FM, FP.(structname).ind_baseline] = get_treadmill_GRF_GUI_Treadmetrix([pathname, char(filename(1,i))], OPTIONS, 1);


                            CONTACT.(structname) = getContactTreadmill_MoTrack(FP.(structname), MARKERS.(structname), OPTIONS);

                            %%
                            %                             BELTVELOCITY.(structname).Corr = BELTVELOCITY.(structname).All;
                            %                             for evv = 1:length(CONTACT.(structname).EVENTSvid)-1
                            %                                 BELTVELOCITY.(structname).Corr(CONTACT.(structname).EVENTSvid(2,evv)+1 : CONTACT.(structname).EVENTSvid(1,evv+1)-1) = BELTVELOCITY.(structname).Corr(CONTACT.(structname).EVENTSvid(2,evv)+1);
                            %                             end

                            %                             figure
                            %                             plot(BELTVELOCITY.(structname).All, 'r');
                            %                             hold on
                            %                             plot(BELTVELOCITY.(structname).Corr, 'g');
                            %                             plot(FP.(structname).GRFfilt_vid.Both(3,:)./1000, 'k')
                            %                             for evv = 1:length(CONTACT.(structname).EVENTSvid)
                            %                                 plot([CONTACT.(structname).EVENTSvid(1,evv) CONTACT.(structname).EVENTSvid(1,evv)], get(gca, 'Ylim'), 'k--')
                            %                                 plot([CONTACT.(structname).EVENTSvid(2,evv) CONTACT.(structname).EVENTSvid(2,evv)], get(gca, 'Ylim'), 'k--')
                            %                             end




                            FP.(structname).GRFfilt.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).GRFfilt.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Left = zeros(size(FP.(structname).GRFfilt.Both));

                            for w = 1:size(CONTACT.(structname).EVENTS_R,2)
                                FP.(structname).GRFfilt.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).COP.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).FM.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                            end

                            for w = 1:size(CONTACT.(structname).EVENTS_L,2)
                                FP.(structname).GRFfilt.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).COP.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).FM.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                            end

                            for d = 1:size(FRAME.(structname).Anatomical.RightFoot.R, 3)
                                try
                                    MARKERS.(structname).Derived.RightMPJC(:,d) = FRAME.(structname).Anatomical.RightForefoot.O(:,d)  +  FRAME.(structname).Anatomical.RightForefoot.R(:,:,d) * REFMARKERS.Derived.RightMPJCinForefoot;
                                    MARKERS.(structname).Derived.RightAnkleJC(:,d) = FRAME.(structname).Anatomical.RightShank.O(:,d)  +  FRAME.(structname).Anatomical.RightShank.R(:,:,d) * REFMARKERS.Derived.RightAnkleJCinShank;
                                    MARKERS.(structname).Derived.RightKneeJC(:,d) = FRAME.(structname).Anatomical.RightThigh.O(:,d)  +  FRAME.(structname).Anatomical.RightThigh.R(:,:,d) * REFMARKERS.Derived.RightKneeJCinThigh;
                                    MARKERS.(structname).Derived.RightHipJC(:,d) = FRAME.(structname).Anatomical.RightPelvis.O(:,d)  +  FRAME.(structname).Anatomical.RightPelvis.R(:,:,d) * REFMARKERS.Derived.RightHipJCinPelvis;
                                    MARKERS.(structname).Derived.RightShoulderJC(:,d) = FRAME.(structname).Anatomical.Trunk.O(:,d)  +  FRAME.(structname).Anatomical.Trunk.R(:,:,d) * REFMARKERS.Derived.RightShoulderJCinTrunk;
                                    MARKERS.(structname).Derived.RightElbowJC(:,d) = FRAME.(structname).Anatomical.RightUpperArm.O(:,d)  +  FRAME.(structname).Anatomical.RightUpperArm.R(:,:,d) * REFMARKERS.Derived.RightElbowJCinUpperArm;
                                    MARKERS.(structname).Derived.RightWristJC(:,d) = FRAME.(structname).Anatomical.RightLowerArm.O(:,d)  +  FRAME.(structname).Anatomical.RightLowerArm.R(:,:,d) * REFMARKERS.Derived.RightWristJCinLowerArm;
                                end
                                try
                                    MARKERS.(structname).Derived.LeftMPJC(:,d) = FRAME.(structname).Anatomical.LeftForefoot.O(:,d)  +  FRAME.(structname).Anatomical.LeftForefoot.R(:,:,d) * REFMARKERS.Derived.LeftMPJCinForefoot;
                                    MARKERS.(structname).Derived.LeftAnkleJC(:,d) = FRAME.(structname).Anatomical.LeftShank.O(:,d)  +  FRAME.(structname).Anatomical.LeftShank.R(:,:,d) * REFMARKERS.Derived.LeftAnkleJCinShank;
                                    MARKERS.(structname).Derived.LeftKneeJC(:,d) = FRAME.(structname).Anatomical.LeftThigh.O(:,d)  +  FRAME.(structname).Anatomical.LeftThigh.R(:,:,d) * REFMARKERS.Derived.LeftKneeJCinThigh;
                                    MARKERS.(structname).Derived.LeftHipJC(:,d) = FRAME.(structname).Anatomical.LeftPelvis.O(:,d)  +  FRAME.(structname).Anatomical.LeftPelvis.R(:,:,d) * REFMARKERS.Derived.LeftHipJCinPelvis;
                                    MARKERS.(structname).Derived.LeftShoulderJC(:,d) = FRAME.(structname).Anatomical.Trunk.O(:,d)  +  FRAME.(structname).Anatomical.Trunk.R(:,:,d) * REFMARKERS.Derived.LeftShoulderJCinTrunk;
                                    MARKERS.(structname).Derived.LeftElbowJC(:,d) = FRAME.(structname).Anatomical.LeftUpperArm.O(:,d)  +  FRAME.(structname).Anatomical.LeftUpperArm.R(:,:,d) * REFMARKERS.Derived.LeftElbowJCinUpperArm;
                                    MARKERS.(structname).Derived.LeftWristJC(:,d) = FRAME.(structname).Anatomical.LeftLowerArm.O(:,d)  +  FRAME.(structname).Anatomical.LeftLowerArm.R(:,:,d) * REFMARKERS.Derived.LeftWristJCinLowerArm;
                                end
                                try
                                    MARKERS.(structname).Derived.NeckJC(:,d) = FRAME.(structname).Anatomical.Trunk.O(:,d)  +  FRAME.(structname).Anatomical.Trunk.R(:,:,d) * REFMARKERS.Derived.NeckJCinTrunk;
                                end
                            end

                            [KINETICS.(structname), IGlobal.(structname)] = InverseDynamik_Hof(FRAME.(structname).Anatomical, OPTIONS, FP.(structname), MARKERS.(structname));

                            %% Calculate joint Power
                            % left MTP joint
                            try
                                KINETICS.(structname).LeftMPJointPower = KINETICS.(structname).LeftMPJMomentInProximal.*fit_n(JOINT.(structname).Left_MPJ.AngV, length(KINETICS.(structname).LeftMPJMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left MTP joint power']}];
                            end
                            % left ankle joint
                            try
                                KINETICS.(structname).LeftAnkleJointPower = KINETICS.(structname).LeftAnkleMomentInProximal.*fit_n(JOINT.(structname).Left_Ankle.AngV, length(KINETICS.(structname).LeftAnkleMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left ankle joint power']}];
                            end
                            % left knee joint
                            try
                                KINETICS.(structname).LeftKneeJointPower = KINETICS.(structname).LeftKneeMomentInProximal.*fit_n(JOINT.(structname).Left_Knee.AngV, length(KINETICS.(structname).LeftKneeMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left knee joint power']}];
                            end
                            % left hip joint
                            try
                                KINETICS.(structname).LeftHipJointPower = KINETICS.(structname).LeftHipMomentInProximal.*fit_n(JOINT.(structname).Left_Hip.AngV, length(KINETICS.(structname).LeftHipMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left hip joint power']}];
                            end
                            % right MTP joint
                            try
                                KINETICS.(structname).RightMPJointPower = KINETICS.(structname).RightMPJMomentInProximal.*fit_n(JOINT.(structname).Right_MPJ.AngV, length(KINETICS.(structname).RightMPJMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right MTP joint power']}];
                            end
                            % right ankle joint
                            try
                                KINETICS.(structname).RightAnkleJointPower = KINETICS.(structname).RightAnkleMomentInProximal.*fit_n(JOINT.(structname).Right_Ankle.AngV, length(KINETICS.(structname).RightAnkleMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right ankle joint power']}];
                            end
                            % right knee joint
                            try
                                KINETICS.(structname).RightKneeJointPower = KINETICS.(structname).RightKneeMomentInProximal.*fit_n(JOINT.(structname).Right_Knee.AngV, length(KINETICS.(structname).RightKneeMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right knee joint power']}];
                            end
                            % right hip joint
                            try
                                KINETICS.(structname).RightHipJointPower = KINETICS.(structname).RightHipMomentInProximal.*fit_n(JOINT.(structname).Right_Hip.AngV, length(KINETICS.(structname).RightHipMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right hip joint power']}];
                            end

                            % right shoulder joint
                            try
                                KINETICS.(structname).RightShoulderJointPower = KINETICS.(structname).RightShoulderMomentInProximal.*fit_n(JOINT.(structname).Right_Shoulder.AngV, length(KINETICS.(structname).RightShoulderMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right shoulder joint power']}];
                            end

                            % right elbow joint
                            try
                                KINETICS.(structname).RightElbowJointPower = KINETICS.(structname).RightElbowMomentInProximal.*fit_n(JOINT.(structname).Right_Elbow.AngV, length(KINETICS.(structname).RightElbowMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right elbow joint power']}];
                            end

                            % right wrist joint
                            try
                                KINETICS.(structname).RightWristJointPower = KINETICS.(structname).RightWristMomentInProximal.*fit_n(JOINT.(structname).Right_Wrist.AngV, length(KINETICS.(structname).RightWristMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating right wrist joint power']}];
                            end


                            % left shoulder joint
                            try
                                KINETICS.(structname).LeftShoulderJointPower = KINETICS.(structname).LeftShoulderMomentInProximal.*fit_n(JOINT.(structname).Left_Shoulder.AngV, length(KINETICS.(structname).LeftShoulderMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left shoulder joint power']}];
                            end

                            % left elbow joint
                            try
                                KINETICS.(structname).LeftElbowJointPower = KINETICS.(structname).LeftElbowMomentInProximal.*fit_n(JOINT.(structname).Left_Elbow.AngV, length(KINETICS.(structname).LeftElbowMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left elbow joint power']}];
                            end

                            % left wrist joint
                            try
                                KINETICS.(structname).LeftWristJointPower = KINETICS.(structname).LeftWristMomentInProximal.*fit_n(JOINT.(structname).Left_Wrist.AngV, length(KINETICS.(structname).LeftWristMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating left wrist joint power']}];
                            end


                            % neck joint
                            try
                                KINETICS.(structname).NeckJointPower = KINETICS.(structname).NeckMomentInProximal.*fit_n(JOINT.(structname).TrunktoHead.AngV, length(KINETICS.(structname).NeckMomentInProximal));
                            catch
                                data.errorlog = [data.errorlog; {[structname, ' : Problems calculating neck joint power']}];
                            end

                            try
                                ENERGY.(structname).Potential.CoM = MARKERS.(structname).Calc.CoM_MALE(3,:).*OPTIONS.mass.*9.81./1000; %/1000 wg mm zu m
                                ENERGY.(structname).Potential.RightFoot = FRAME.(structname).Anatomical.RightFoot.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Foot.*9.81./1000;
                                ENERGY.(structname).Potential.LeftFoot = FRAME.(structname).Anatomical.LeftFoot.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Foot.*9.81./1000;
                                ENERGY.(structname).Potential.RightShank = FRAME.(structname).Anatomical.RightShank.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Shank.*9.81./1000;
                                ENERGY.(structname).Potential.LeftShank = FRAME.(structname).Anatomical.LeftShank.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Shank.*9.81./1000;
                                ENERGY.(structname).Potential.RightThigh = FRAME.(structname).Anatomical.RightThigh.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Thigh.*9.81./1000;
                                ENERGY.(structname).Potential.LeftThigh = FRAME.(structname).Anatomical.LeftThigh.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Thigh.*9.81./1000;
                                ENERGY.(structname).Potential.RightUpperArm = FRAME.(structname).Anatomical.RightUpperArm.O(3,:).*OPTIONS.ANTHRO.SegmentMass.UpperArm.*9.81./1000;
                                ENERGY.(structname).Potential.LeftUpperArm = FRAME.(structname).Anatomical.LeftUpperArm.O(3,:).*OPTIONS.ANTHRO.SegmentMass.UpperArm.*9.81./1000;
                                ENERGY.(structname).Potential.RightLowerArm = FRAME.(structname).Anatomical.RightLowerArm.O(3,:).*OPTIONS.ANTHRO.SegmentMass.LowerArm.*9.81./1000;
                                ENERGY.(structname).Potential.LeftLowerArm = FRAME.(structname).Anatomical.LeftLowerArm.O(3,:).*OPTIONS.ANTHRO.SegmentMass.LowerArm.*9.81./1000;
                                ENERGY.(structname).Potential.RightHand = FRAME.(structname).Anatomical.RightHand.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Hand.*9.81./1000;
                                ENERGY.(structname).Potential.LeftHand = FRAME.(structname).Anatomical.LeftHand.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Hand.*9.81./1000;
                                ENERGY.(structname).Potential.Trunk = FRAME.(structname).Anatomical.Trunk.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Trunk.*9.81./1000;
                                ENERGY.(structname).Potential.Head = FRAME.(structname).Anatomical.Head.O(3,:).*OPTIONS.ANTHRO.SegmentMass.Head.*9.81./1000;

                                CorrMat = zeros(3,length(FRAME.(structname).Anatomical.RightFoot.O));
                                CorrMat(1,1:length(BELTVELOCITY.(structname).All)) = BELTVELOCITY.(structname).All;
                                CorrMat(1,length(BELTVELOCITY.(structname).All):end) = BELTVELOCITY.(structname).All(end);

                                ENERGY.(structname).Kinetic.CoM = 0.5.*OPTIONS.mass.*(MARKERS.(structname).Calc.VCoM_MALE + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightFoot = 0.5.*OPTIONS.ANTHRO.SegmentMass.Foot.*(FRAME.(structname).Anatomical.RightFoot.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftFoot = 0.5.*OPTIONS.ANTHRO.SegmentMass.Foot.*(FRAME.(structname).Anatomical.LeftFoot.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightShank = 0.5.*OPTIONS.ANTHRO.SegmentMass.Shank.*(FRAME.(structname).Anatomical.RightShank.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftShank = 0.5.*OPTIONS.ANTHRO.SegmentMass.Shank.*(FRAME.(structname).Anatomical.LeftShank.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightThigh = 0.5.*OPTIONS.ANTHRO.SegmentMass.Thigh.*(FRAME.(structname).Anatomical.RightThigh.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftThigh = 0.5.*OPTIONS.ANTHRO.SegmentMass.Thigh.*(FRAME.(structname).Anatomical.LeftThigh.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightUpperArm = 0.5.*OPTIONS.ANTHRO.SegmentMass.UpperArm.*(FRAME.(structname).Anatomical.RightUpperArm.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftUpperArm = 0.5.*OPTIONS.ANTHRO.SegmentMass.UpperArm.*(FRAME.(structname).Anatomical.LeftUpperArm.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightLowerArm = 0.5.*OPTIONS.ANTHRO.SegmentMass.LowerArm.*(FRAME.(structname).Anatomical.RightLowerArm.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftLowerArm = 0.5.*OPTIONS.ANTHRO.SegmentMass.LowerArm.*(FRAME.(structname).Anatomical.LeftLowerArm.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.RightHand = 0.5.*OPTIONS.ANTHRO.SegmentMass.Hand.*(FRAME.(structname).Anatomical.RightHand.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.LeftHand = 0.5.*OPTIONS.ANTHRO.SegmentMass.Hand.*(FRAME.(structname).Anatomical.LeftHand.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.Head = 0.5.*OPTIONS.ANTHRO.SegmentMass.Head.*(FRAME.(structname).Anatomical.Head.LinV + CorrMat).^2;
                                ENERGY.(structname).Kinetic.Trunk = 0.5.*OPTIONS.ANTHRO.SegmentMass.Trunk.*(FRAME.(structname).Anatomical.Trunk.LinV + CorrMat).^2;
                                IndShort = 1:OPTIONS.ftkratio:size(IGlobal.(structname).RightFoot,3);
                                for iii = 1:length(IndShort)

                                    ENERGY.(structname).Rotational.Trunk(1,iii) = 0.5.*FRAME.(structname).Anatomical.Trunk.V(:,iii)'*IGlobal.(structname).Trunk(:,:,IndShort(iii))*FRAME.(structname).Anatomical.Trunk.V(:,iii);
                                    ENERGY.(structname).Rotational.Head(1,iii) = 0.5.*FRAME.(structname).Anatomical.Head.V(:,iii)'*IGlobal.(structname).Head(:,:,IndShort(iii))*FRAME.(structname).Anatomical.Head.V(:,iii);
                                    ENERGY.(structname).Rotational.RightUpperArm(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightUpperArm.V(:,iii)'*IGlobal.(structname).RightUpperArm(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightUpperArm.V(:,iii);
                                    ENERGY.(structname).Rotational.RightLowerArm(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightLowerArm.V(:,iii)'*IGlobal.(structname).RightLowerArm(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightLowerArm.V(:,iii);
                                    ENERGY.(structname).Rotational.RightHand(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightHand.V(:,iii)'*IGlobal.(structname).RightHand(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightHand.V(:,iii);
                                    ENERGY.(structname).Rotational.RightThigh(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightThigh.V(:,iii)'*IGlobal.(structname).RightThigh(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightThigh.V(:,iii);
                                    ENERGY.(structname).Rotational.RightShank(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightShank.V(:,iii)'*IGlobal.(structname).RightShank(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightShank.V(:,iii);
                                    ENERGY.(structname).Rotational.RightFoot(1,iii) = 0.5.*FRAME.(structname).Anatomical.RightFoot.V(:,iii)'*IGlobal.(structname).RightFoot(:,:,IndShort(iii))*FRAME.(structname).Anatomical.RightFoot.V(:,iii);

                                    ENERGY.(structname).Rotational.LeftUpperArm(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftUpperArm.V(:,iii)'*IGlobal.(structname).LeftUpperArm(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftUpperArm.V(:,iii);
                                    ENERGY.(structname).Rotational.LeftLowerArm(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftLowerArm.V(:,iii)'*IGlobal.(structname).LeftLowerArm(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftLowerArm.V(:,iii);
                                    ENERGY.(structname).Rotational.LeftHand(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftHand.V(:,iii)'*IGlobal.(structname).LeftHand(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftHand.V(:,iii);
                                    ENERGY.(structname).Rotational.LeftThigh(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftThigh.V(:,iii)'*IGlobal.(structname).LeftThigh(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftThigh.V(:,iii);
                                    ENERGY.(structname).Rotational.LeftShank(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftShank.V(:,iii)'*IGlobal.(structname).LeftShank(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftShank.V(:,iii);
                                    ENERGY.(structname).Rotational.LeftFoot(1,iii) = 0.5.*FRAME.(structname).Anatomical.LeftFoot.V(:,iii)'*IGlobal.(structname).LeftFoot(:,:,IndShort(iii))*FRAME.(structname).Anatomical.LeftFoot.V(:,iii);
                                end
                            end
                        end


                        %COM
                        try
                            COM.X.(structname) = MARKERS.(structname).Calc.CoM_MALE(1,:)/1000; %/1000 wg mm zu m
                            COM.Y.(structname) = MARKERS.(structname).Calc.CoM_MALE(2,:)/1000; %/1000 wg mm zu m
                            COM.Z.(structname) = MARKERS.(structname).Calc.CoM_MALE(3,:)/1000; %/1000 wg mm zu m
                            % normalize to stance
                            COM_pm.X(:,i) =   normalize (COM.X.(structname), 0.5);
                            COM_pm.Y(:,i) =   normalize (COM.Y.(structname), 0.5);
                            COM_pm.Z(:,i) =   normalize (COM.Z.(structname), 0.5);
                        catch
                            alf = 2;
                        end



                        try
                            assignin('base', 'gui', gui);
                            assignin('base', 'KINETICS', KINETICS);
                            assignin('base', 'FP', FP);
                        end
                        %Determine contact phases (see Fellin et al.
                        %2010)

                        ConditionsVector = get(gui.ConditionsList, 'String');
                        % Determine TD and Toe Off Events for the Right
                        % Leg
                        if OPTIONS.ExperimentalSetup == 3
                            if (get(gui.AnalyzedLeg, 'Value') == 1)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    [~,indKneePeaksR] = findpeaks(-WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y, 'MinPeakDistance',OPTIONS.FreqKinematics*0.1, 'MinPeakProminence', 3);
                                    [~,indKneePeaksPosR] = findpeaks(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y, 'MinPeakDistance',OPTIONS.FreqKinematics*0.1, 'MinPeakProminence', 3);
                                    NextFlexionPeakR = find(indKneePeaksPosR > indKneePeaksR(2), 1, 'first');
                                    if WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(indKneePeaksPosR(NextFlexionPeakR)) > WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(indKneePeaksPosR(NextFlexionPeakR-1))
                                        startTDR = 3;
                                    else
                                        startTDR = 2;
                                    end
                                    TDR.(structname) =  indKneePeaksR(startTDR:2:end);
                                    TDR_Analog.(structname) = TDR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TDR_EMG.(structname) = TDR_Analog.(structname)+round(0.016*2000);
                                    TOR.(structname) =  indKneePeaksR(startTDR+1:2:end);
                                    TOR_Analog.(structname) = TOR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TOR_EMG.(structname) = TOR_Analog.(structname) + round(0.016*2000);
                                catch
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine right leg TD and TO events']}];
                                end
                            end
                            % Determine TD and Toe Off Events for the Left
                            % Leg
                            if (get(gui.AnalyzedLeg, 'Value') == 2)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    [~,indKneePeaksL] = findpeaks(-WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y, 'MinPeakDistance',OPTIONS.FreqKinematics*0.1, 'MinPeakProminence', 3);
                                    [~,indKneePeaksPosL] = findpeaks(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y, 'MinPeakDistance',OPTIONS.FreqKinematics*0.1, 'MinPeakProminence', 3);
                                    NextFlexionPeakL = find(indKneePeaksPosL > indKneePeaksL(2), 1, 'first');
                                    if WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(indKneePeaksPosL(NextFlexionPeakL)) > WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(indKneePeaksPosL(NextFlexionPeakL-1))
                                        startTDL = 3;
                                    else
                                        startTDL = 2;
                                    end
                                    TDL.(structname) =  indKneePeaksL(startTDL:2:end);
                                    TDL_Analog.(structname) = TDL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TDL_EMG.(structname) = TDL_Analog.(structname)+round(0.016*2000);
                                    TOL.(structname) =  indKneePeaksL(startTDL+1:2:end);
                                    TOL_Analog.(structname) = TOL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TOL_EMG.(structname) = TOL_Analog.(structname) + round(0.016*2000);
                                catch
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine right leg TD and TO events']}];
                                end
                            end
                        end

                        if OPTIONS.ExperimentalSetup == 4
                            if (get(gui.AnalyzedLeg, 'Value') == 1)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    [~,indmaxkneey] = max(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y);
                                    TDR.(structname) = 1;
                                    TDR_Analog.(structname) = TDR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TDR_EMG.(structname) = TDR_Analog.(structname)+round(0.016*2000);
                                    for ka = indmaxkneey:-1:1
                                        if  WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(ka) < 15
                                            TDR.(structname) = ka;
                                            TDR_Analog.(structname) = TDR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDR_EMG.(structname) = TDR_Analog.(structname)+round(0.016*2000);
                                            break
                                        end
                                        if ka == 1
                                            TDR.(structname) = ka;
                                            TDR_Analog.(structname) = TDR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDR_EMG.(structname) = TDR_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                        end
                                    end

                                    TOR.(structname) = length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y);
                                    TOR_Analog.(structname) = TOR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    TOR_EMG.(structname) = TOR_Analog.(structname)+round(0.016*2000);
                                    for ka = indmaxkneey:length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y)
                                        if  WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(ka) < 15
                                            TOR.(structname) = ka;
                                            TOR_Analog.(structname) = TOR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOR_EMG.(structname) = TOR_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                            break
                                        end
                                        if ka == length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y)
                                            TOR.(structname) = ka;
                                            TOR_Analog.(structname) = TOR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOR_EMG.(structname) = TOR_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                        end
                                    end
                                catch
                                    runi = runi - 1;
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine right leg TD and TO events']}];
                                end
                            end
                            if (get(gui.AnalyzedLeg, 'Value') == 2)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    [~,indmaxkneey] = max(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y);
                                    for ka = indmaxkneey:-1:1
                                        if  WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(ka) < 15
                                            TDL.(structname) = ka;
                                            TDL_Analog.(structname) = TDL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDL_EMG.(structname) = TDL_Analog.(structname)+round(0.016*2000);
                                            break
                                        end
                                        if ka == 1
                                            TDL.(structname) = ka;
                                            TDL_Analog.(structname) = TDL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDL_EMG.(structname) = TDL_Analog.(structname)+round(0.016*2000);
                                        end
                                    end
                                    for ka = indmaxkneey:length(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y)
                                        if  WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(ka) < 15
                                            TOL.(structname) = ka;
                                            TOL_Analog.(structname) = TOL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOL_EMG.(structname) = TOL_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                            break
                                        end
                                        if ka == length(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y)
                                            TOL.(structname) = ka;
                                            TOL_Analog.(structname) = TOL.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOL_EMG.(structname) = TOL_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                        end
                                    end
                                catch
                                    runi = runi - 1;
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine left leg TD and TO events']}];
                                end
                            end
                        end


                        if OPTIONS.ExperimentalSetup == 5
                            if (get(gui.AnalyzedLeg, 'Value') == 1)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    runrtd = 0;
                                    VHEEL = getderivateCOMVEL3point(MARKERS.(structname).Opti.calc_back_right.data(1,:));
                                    for ka = 20:length(VHEEL)-10
                                        if  (VHEEL(ka-1) > 0) &&   (sum(VHEEL(ka:ka+9) < 0) == 10)
                                            runrtd = runrtd+1;
                                            TDR.(structname)(runrtd) = ka;
                                            TDR_Analog.(structname)(runrtd) = TDR.(structname)(runrtd).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDR_EMG.(structname)(runrtd) = TDR_Analog.(structname)(runrtd)+round(0.016*2000);
                                        end
                                    end

                                    runrto = 0;
                                    for ka = TDR.(structname)(1):length(VHEEL)-10
                                        if  (VHEEL(ka-1) < 0) &&   (sum(VHEEL(ka:ka+9) > 0) == 10)
                                            runrto = runrto+1;
                                            TOR.(structname)(runrto) = ka;
                                            TOR_Analog.(structname)(runrto) = TOR.(structname)(runrto).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOR_EMG.(structname)(runrto) = TOR_Analog.(structname)(runrto)+round(0.016*2000);
                                        end
                                    end
                                catch
                                    runi = runi - 1;
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine right leg TD and TO events']}];
                                end
                            end
                            if (get(gui.AnalyzedLeg, 'Value') == 2)  ||  (get(gui.AnalyzedLeg, 'Value') == 3)
                                try
                                    runltd = 0;
                                    VHEEL = getderivateCOMVEL3point(MARKERS.(structname).Opti.calc_back_left.data(1,:));
                                    for ka = 20:length(VHEEL)-10
                                        if  (VHEEL(ka-1) > 0) &&   (sum(VHEEL(ka:ka+9) < 0) == 10)
                                            runltd = runltd+1;
                                            TDL.(structname)(runltd) = ka;
                                            TDL_Analog.(structname)(runltd) = TDL.(structname)(runltd).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TDL_EMG.(structname)(runltd) = TDL_Analog.(structname)(runltd)+round(0.016*2000);
                                        end
                                    end

                                    runlto = 0;
                                    for ka = TDL.(structname)(1):length(VHEEL)-10
                                        if  (VHEEL(ka-1) < 0) &&   (sum(VHEEL(ka:ka+9) > 0) == 10)
                                            runlto = runlto+1;
                                            TOL.(structname)(runlto) = ka;
                                            TOL_Analog.(structname)(runlto) = TOL.(structname)(runlto).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                            TOL_EMG.(structname)(runlto) = TOL_Analog.(structname)(runlto)+round(0.016*2000);
                                        end
                                    end
                                catch
                                    runi = runi - 1;
                                    data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine left leg TD and TO events']}];
                                end
                            end
                        end




                        if OPTIONS.ExperimentalSetup == 9

                            %                                 try
                            EV = loadevents([pathname, filename{i}]);
                            runrtd = 0;
                            runrto = 0;
                            runltd = 0;
                            runlto = 0;

                            for ka = 1:length(EV.Labels)
                                if  (strcmp(EV.Labels{ka}, 'Event'))
                                    IsGeneral(ka) = 1;
                                end
                            end

                            if sum(IsGeneral) == length(EV.Labels)
                                for ka = 1:length(EV.Labels)
                                    if mod(ka, 2) ~= 0
                                        runrtd = runrtd+1;
                                        TDR.(structname)(runrtd) = EV.Frame(ka);
                                        TDR_Analog.(structname)(runrtd) = TDR.(structname)(runrtd).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    else
                                        runrto = runrto+1;
                                        TOR.(structname)(runrto) = EV.Frame(ka);
                                        TOR_Analog.(structname)(runrto) = TOR.(structname)(runrto).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                    end
                                end
                            else

                                for ka = 1:length(EV.Labels)
                                    if  (strcmp(EV.Labels{ka}, 'Foot Strike') && strcmp(EV.Contexts{ka}, 'Right')) || (strcmp(EV.Labels{ka}, 'Start'))
                                        runrtd = runrtd+1;
                                        TDR.(structname)(runrtd) = EV.Frame(ka);
                                        TDR_Analog.(structname)(runrtd) = TDR.(structname)(runrtd).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                        %                                             TDR_EMG.(structname)(runrtd) = TDR_Analog.(structname)(runrtd)+round(0.016*2000);
                                    elseif  (strcmp(EV.Labels{ka}, 'Foot Off') && strcmp(EV.Contexts{ka}, 'Right')) || (strcmp(EV.Labels{ka}, 'Stop'))
                                        runrto = runrto+1;
                                        TOR.(structname)(runrto) = EV.Frame(ka);
                                        TOR_Analog.(structname)(runrto) = TOR.(structname)(runrto).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                        %                                             TOR_EMG.(structname)(runrto) = TOR_Analog.(structname)(runrto)+round(0.016*2000);
                                    elseif  (strcmp(EV.Labels{ka}, 'Foot Strike') && strcmp(EV.Contexts{ka}, 'Left'))
                                        runltd = runltd+1;
                                        TDL.(structname)(runltd) = EV.Frame(ka);
                                        TDL_Analog.(structname)(runltd) = TDL.(structname)(runltd).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                        %                                             TDR_EMG.(structname)(runrld) = TDL_Analog.(structname)(runltd)+round(0.016*2000);
                                    elseif  (strcmp(EV.Labels{ka}, 'Foot Off') && strcmp(EV.Contexts{ka}, 'Left'))
                                        runlto = runlto+1;
                                        TOL.(structname)(runlto) = EV.Frame(ka);
                                        TOL_Analog.(structname)(runrto) = TOL.(structname)(runlto).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                        %                                             TOR_EMG.(structname)(runrto) = TOR_Analog.(structname)(runrto)+round(0.016*2000);
                                    end


                                end

                                if (strcmp(EV.Labels{1}, 'Start'))
                                    TDL.(structname) = TDR.(structname);
                                    TDL_Analog.(structname) = TDR_Analog.(structname);
                                    TOL.(structname) = TOR.(structname);
                                    TOL_Analog.(structname) = TOR_Analog.(structname);
                                end
                            end
                        end
                        if OPTIONS.ExperimentalSetup == 10

                            try
                                xmlfile = dir([pathname, '*.xml']);
                                Fzebris = readinzebrisforce([pathname,xmlfile(1).name]);
                                Fzebris = Fzebris(OPTIONS.start:end);
                                [~, indFpeaks] = findpeaks(Fzebris, 'MinPeakHeight', 800, 'MinPeakDist', 0.2*OPTIONS.FreqKinematics);
                                runpoi = 1;
                                runpoi2 = 1;
                                for ifp = 1:length(indFpeaks)
                                    for jfp = indFpeaks(ifp):-1:1
                                        if (Fzebris(jfp)<20) && (jfp < length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y))
                                            poi(runpoi) = jfp;
                                            KW(runpoi) = WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(jfp);
                                            runpoi = runpoi+1;
                                            break
                                        end
                                    end
                                    if exist('poi', 'var')
                                        for jfp = indFpeaks(ifp):length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y)
                                            if (jfp > poi(1)) && (Fzebris(jfp)<20) && (jfp < length(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y))
                                                poi2(runpoi2) = jfp;
                                                runpoi2 = runpoi2 +1;
                                                break
                                            end
                                        end
                                    end

                                end
                                if KW(1) < KW(2)
                                    TDR.(structname) = poi(1:2:end);
                                    TOR.(structname) = poi2(1:2:end);
                                    TDL.(structname) = poi(2:2:end);
                                    TOL.(structname) = poi2(2:2:end);
                                else
                                    TDR.(structname) = poi(2:2:end);
                                    TOR.(structname) = poi2(2:2:end);
                                    TDL.(structname) = poi(1:2:end);
                                    TOL.(structname) = poi2(1:2:end);
                                end

                                TDR_Analog.(structname) = TDR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                TDR_EMG.(structname) = TDR_Analog.(structname)+round(0.016*OPTIONS.freqGRF);
                                TOR_Analog.(structname) = TOR.(structname).*OPTIONS.ftkratio-(OPTIONS.ftkratio-1);
                                TOR_EMG.(structname) = TOR_Analog.(structname)+round(0.016*OPTIONS.freqGRF);


                            catch
                                runi = runi - 1;
                                data.errorlog = [data.errorlog; {[pathname, filename{1,i}, ' : Could not determine right leg TD and TO events']}];
                            end

                        end


                        % Write normalized Data in NORMAL struct
                        if OPTIONS.ExperimentalSetup == 9
                            if OPTIONS.AnalyzedLeg == 'B'
                                try
                                    numsteps = min([length(TOL.(structname)), length(TOR.(structname))])
                                catch
                                    try
                                        numsteps = length(TOR.(structname));
                                    catch
                                        numsteps = length(TOL.(structname));
                                    end
                                end
                            elseif OPTIONS.AnalyzedLeg == 'R'
                                numsteps = length(TOR.(structname))
                            elseif OPTIONS.AnalyzedLeg == 'L'
                                numsteps = length(TOL.(structname))
                            end
                        else
                            if str2double(get(gui.Nsteps, 'String')) == 0
                                numsteps = min([length(CONTACT.(structname).EVENTS_R), length(CONTACT.(structname).EVENTS_L)])-1;
                            else
                                numsteps = str2double(get(gui.Nsteps, 'String'));
                            end
                        end
                        for ns = 1:numsteps
                            if (OPTIONS.ExperimentalSetup == 3) || (OPTIONS.ExperimentalSetup == 4) || (OPTIONS.ExperimentalSetup == 5) || (OPTIONS.ExperimentalSetup == 9)  || (OPTIONS.ExperimentalSetup == 10)
                                try
                                    ContactR.(structname).data = TDR.(structname)(ns):TOR.(structname)(ns);
                                end
                                try
                                    ContactL.(structname).data = TDL.(structname)(ns):TOL.(structname)(ns);
                                end
                            elseif (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7) || (OPTIONS.ExperimentalSetup == 8)
                                if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 8)
                                    if (OPTIONS.AnalyzedLeg == 'R') || (OPTIONS.AnalyzedLeg == 'B')
                                        ContactR.(structname).data = CONTACT.(structname).EVENTS_R_vid(1,ns):CONTACT.(structname).EVENTS_R_vid(2,ns);
                                        ContactR_analog.(structname).data = CONTACT.(structname).EVENTS_R(1,ns):CONTACT.(structname).EVENTS_R(2,ns);
                                    elseif (OPTIONS.AnalyzedLeg == 'L') || (OPTIONS.AnalyzedLeg == 'B')
                                        ContactL.(structname).data = CONTACT.(structname).EVENTS_L_vid(1,ns):CONTACT.(structname).EVENTS_L_vid(2,ns);
                                        ContactL_analog.(structname).data = CONTACT.(structname).EVENTS_L(1,ns):CONTACT.(structname).EVENTS_L(2,ns);
                                    end
                                elseif (OPTIONS.ExperimentalSetup == 7)
                                    try
                                        if (OPTIONS.AnalyzedLeg == 'R') || (OPTIONS.AnalyzedLeg == 'B')
                                            ContactR_analog.(structname).data = CONTACT.(structname);
                                            ContactR.(structname).data = ceil(ContactR_analog.(structname).data./OPTIONS.ftkratio);
                                            ContactR.(structname).data = ContactR.(structname).data(1:OPTIONS.ftkratio:end);
                                        elseif (OPTIONS.AnalyzedLeg == 'L') || (OPTIONS.AnalyzedLeg == 'B')
                                            ContactL_analog.(structname).data = CONTACT.(structname);
                                            ContactL.(structname).data = ceil(ContactL_analog.(structname).data./OPTIONS.ftkratio);
                                            ContactL.(structname).data = ContactL.(structname).data(1:OPTIONS.ftkratio:end);
                                        end
                                    end
                                end
                                %
                            else
                                ContactR.(structname).data = 1:nframes.(structname);
                                ContactL.(structname).data = 1:nframes.(structname);
                            end
                            try
                                NORMAL.HEADER(1,ns+(runi-1)*numsteps) = filename(1,i);
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Z(ContactR.(structname).data), 0.5)';

                                NORMAL.R.ANGU_VEL.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Ankle.AngV(1,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Ankle.AngV(2,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Ankle.AngV(3,(ContactR.(structname).data))* 180/pi ,0.5);

                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Z(ContactR.(structname).data), 0.5)';

                                NORMAL.R.ANGU_VEL.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Knee.AngV(1,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Knee.AngV(2,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Knee.AngV(3,(ContactR.(structname).data))* 180/pi ,0.5);


                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Z(ContactR.(structname).data), 0.5)';

                                NORMAL.R.ANGU_VEL.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Hip.AngV(1,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Hip.AngV(2,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_Hip.AngV(3,(ContactR.(structname).data))* 180/pi ,0.5);


                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Z(ContactR.(structname).data), 0.5)';

                                NORMAL.R.ANGU_VEL.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_MPJ.AngV(1,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_MPJ.AngV(2,(ContactR.(structname).data))* 180/pi ,0.5);
                                NORMAL.R.ANGU_VEL.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize (JOINT.(structname).Right_MPJ.AngV(3,(ContactR.(structname).data))* 180/pi ,0.5);

                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_SHOULDER.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_SHOULDER.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_SHOULDER.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Shoulder.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_ELBOW.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_ELBOW.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_ELBOW.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Elbow.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_WRIST.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_WRIST.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_WRIST.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Wrist.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_FOREFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_FOREFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_FOREFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_REARFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_REARFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_REARFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_FOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_FOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_FOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_SHANK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_SHANK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_SHANK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_THIGH.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_THIGH.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_THIGH.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.PELVIS.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.PELVIS.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.PELVIS.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.HEAD.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.HEAD.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.HEAD.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.TRUNK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.TRUNK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.TRUNK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_UPPERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_UPPERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_UPPERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_LOWERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_LOWERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_LOWERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Z(ContactR.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.R.ANGLES.RIGHT_HAND.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.X(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_HAND.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Y(ContactR.(structname).data), 0.5)';
                                NORMAL.R.ANGLES.RIGHT_HAND.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Z(ContactR.(structname).data), 0.5)';
                            end




                            try
                                NORMAL.R.MOMENTS.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.MOMENTS.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.MOMENTS.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.MOMENTS.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.MOMENTS.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end

                            try
                                NORMAL.R.POWER.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.POWER.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.POWER.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.R.POWER.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.POWER.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try                                             %   FP.T_Proto1_Dynamic63.FM.Right
                                NORMAL.R.FM.DATA.X(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Right(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.FM.DATA.Y(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Right(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.R.FM.DATA.Z(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Right(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try                                             %   FP.T_Proto1_Dynamic63.FM.Right
                                NORMAL.L.FM.DATA.X(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.FM.DATA.Y(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.FM.DATA.Z(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';

                            end


                            if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7)  ||  (OPTIONS.ExperimentalSetup == 8)
                                try
                                    NORMAL.R.GRF.DATA.X(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                    NORMAL.R.GRF.DATA.Y(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                    NORMAL.R.GRF.DATA.Z(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                end
                            end




                            % Left
                            try
                                NORMAL.L.ANGLES.LEFT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_SHOULDER.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_SHOULDER.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_SHOULDER.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Shoulder.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_ELBOW.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_ELBOW.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_ELBOW.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Elbow.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_WRIST.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_WRIST.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_WRIST.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Wrist.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_FOREFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_FOREFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_FOREFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_REARFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_REARFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_REARFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_FOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_FOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_FOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_SHANK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_SHANK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_SHANK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_THIGH.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_THIGH.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_THIGH.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.PELVIS.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.PELVIS.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.PELVIS.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.HEAD.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.HEAD.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.HEAD.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.TRUNK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.TRUNK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.TRUNK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_UPPERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_UPPERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_UPPERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_LOWERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_LOWERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_LOWERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Z(ContactL.(structname).data), 0.5)';
                            end
                            try
                                NORMAL.L.ANGLES.LEFT_HAND.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.X(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_HAND.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Y(ContactL.(structname).data), 0.5)';
                                NORMAL.L.ANGLES.LEFT_HAND.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Z(ContactL.(structname).data), 0.5)';
                            end

                            try
                                NORMAL.L.MOMENTS.LEFT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.L.MOMENTS.LEFT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.L.MOMENTS.LEFT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.L.MOMENTS.LEFT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.MOMENTS.LEFT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end

                            try
                                NORMAL.L.POWER.LEFT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.L.POWER.LEFT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try
                                NORMAL.L.POWER.LEFT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end
                            try %ÄÄ
                                NORMAL.L.POWER.LEFT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.POWER.LEFT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            end

                            try
                                NORMAL.L.FM.DATA.X(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.FM.DATA.Y(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                NORMAL.L.FM.DATA.Z(:,ns+(runi-1)*numsteps)=   normalize(FP.(structname).FM.Left(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                            catch

                                aaa= 2;
                            end


                            if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7) || (OPTIONS.ExperimentalSetup == 8)
                                try
                                    NORMAL.L.GRF.DATA.X(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                    NORMAL.L.GRF.DATA.Y(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                    NORMAL.L.GRF.DATA.Z(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
                                end
                            end
                            if (OPTIONS.ExperimentalSetup == 10)  ||  (OPTIONS.ExperimentalSetup == 9) ||  (OPTIONS.ExperimentalSetup == 3)
                                try
                                    CONTACT.R.(structname){ns} = TDR.(structname)(ns):TOR.(structname)(ns);
                                end
                                try
                                    CONTACT.L.(structname){ns} = TDL.(structname)(ns):TOL.(structname)(ns);
                                end
                            end
                            if (OPTIONS.ExperimentalSetup == 4)
                                try
                                    CONTACT.R.(structname){ns} = ContactR.(structname).data;
                                end
                                try
                                    CONTACT.L.(structname){ns} = ContactL.(structname).data;
                                end
                            end

                        end
                        if (OPTIONS.ExperimentalSetup == 10)  ||  (OPTIONS.ExperimentalSetup == 9) ||  (OPTIONS.ExperimentalSetup == 3)
                            try
                                PARAMETERS.R = get_parameters_from_NORMAL(NORMAL.R, 'R', CONTACT.R, OPTIONS);
                            end
                            try
                                PARAMETERS.L = get_parameters_from_NORMAL(NORMAL.L, 'L', CONTACT.L, OPTIONS);
                            end
                        else
                            try
                                PARAMETERS.R = get_parameters_from_NORMAL(NORMAL.R, 'R', CONTACT, OPTIONS);
                            end
                            try
                                PARAMETERS.L = get_parameters_from_NORMAL(NORMAL.L, 'L', CONTACT, OPTIONS);
                            end
                        end

                        %hier muss ich dann speichern
                    end %Comparison to ref specifier
                end %loop through individual c3d files i
                ustr = strfind(pathname, '\');
                spath = pathname(1:ustr(end-1));
                sname = pathname(ustr(end-1)+1:end-1);
                assignin('base','data', data);
                try
                    if get(gui.SaveAnalogData, 'Value')
                        if (OPTIONS.ExperimentalSetup == 6) ||  (OPTIONS.ExperimentalSetup == 7) ||  (OPTIONS.ExperimentalSetup == 8)
                            save([spath, sname, '.mat'], 'OPTIONS', 'pathname', 'FP','KINETICS','WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS',   'R', 'NORMAL','JOINT', 'LABELS', 'ANALOG', 'PARAMETERS', 'CONTACT');
                        elseif (OPTIONS.ExperimentalSetup == 1)
                            save([spath, sname, '.mat'], 'OPTIONS', 'ANALOG', 'pathname', 'WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS',   'R', 'NORMAL','JOINT', 'LABELS');
                        else
                            save([spath, sname, '.mat'], 'OPTIONS', 'pathname', 'WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS',   'R', 'NORMAL','JOINT', 'LABELS', 'ANALOG', 'PARAMETERS','TDR', 'TOR','TDR_Analog','TDR_EMG','TOR_Analog','TOR_EMG', 'CONTACT');
                        end
                    else
                        if (OPTIONS.ExperimentalSetup == 6) ||  (OPTIONS.ExperimentalSetup == 7) ||  (OPTIONS.ExperimentalSetup == 8)
                            save([spath, sname, '.mat'], 'OPTIONS', 'pathname', 'FP','KINETICS','WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS', 'PARAMETERS',  'R', 'NORMAL','JOINT', 'LABELS', 'CONTACT');%, 'ENERGY','BELTVELOCITY');
                            %%'PARAMETERS' Patrick Mai TODO
                            %%%%%%%  save([spath, sname, '.mat'],'COM_pm','-append')

                        elseif (OPTIONS.ExperimentalSetup == 1)
                            save([spath, sname, '.mat'], 'OPTIONS', 'pathname', 'WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS',   'R', 'NORMAL','JOINT', 'LABELS');
                        else

                            save([spath, sname, '.mat'], 'OPTIONS', 'pathname', 'WINKEL', 'MARKERS', 'FRAME',...
                                'REFFRAME', 'REFMARKERS',   'R', 'NORMAL','JOINT', 'LABELS', 'PARAMETERS', 'CONTACT');


                        end
                    end
                catch
                    alf = 2;
                end
                clearvars -except  data gui ConditionFolders FRAMEWORK OPTIONS  REFFRAME REFMARKERS  pathname filename n_subjects kinetics
            end








        end

        disp ('done')
    end %mainmodel



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [FRAMEWORK, n_subjects] = get_file_framework(top_folder)
        %This function gets you the file framework. The idea is that you can use
        %this framewrok to loop through all the data from your study. This allows
        %you to start data analysis by one click and afterwords the model takes the
        %data by itself, if the data is arranged in the correct way inside the
        %folder structure (framework)


        folders = dir(top_folder);
        n_dir = 1;
        size_framework = size(folders,1) - 2;

        for d = 3:size_framework+2
            if folders(d).isdir
                FRAMEWORK(n_dir).pathname = cellstr([char(top_folder),'\', folders(d).name, '\']);  %#ok<AGROW>
                C3ds = dir([char(FRAMEWORK(n_dir).pathname),'*.mat']);
                C3ds = C3ds(arrayfun(@(x) ~strcmp(x.name(1),'.'),C3ds));
                try

                    CSVs = dir([char(FRAMEWORK(n_dir).pathname),'*.csv']);
                    CSVs = CSVs(arrayfun(@(x) ~strcmp(x.name(1),'.'),CSVs));
                    if ~isempty(CSVs)
                        FRAMEWORK(n_dir).anthro = CSVs.name; %#ok<AGROW>
                    end
                catch
                    data.errorlog = [data.errorlog; {[char(FRAMEWORK(n_dir).pathname), ' : Could not find anthro csv file']}];
                end
                for e = 1:size(C3ds,1)
                    FRAMEWORK(n_dir).filename(e) = cellstr(C3ds(e).name);
                end
                n_dir = n_dir+1;
                clear C3ds CSVs
            end
        end
        n_subjects = n_dir - 1;
    end %get_file_framework


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [ANTHRO, mass, RunningSpeed] = getANTHRO_GUI(anthrofile, method, REFFRAME)
        % Determines anthropometric infromation based on Zatziorsky and Seluyanov
        % 1983
        % Input information needs to be stored in the same folder as the dynamic
        % andreference c3d files. In MoTrack this is normally automatically created
        % using the MoTrack GUI.
        if (nargin == 2 && sum(strfind(method, 'ZAT1983')))  ||  (nargin == 3)
            try
                A_MEASURES = csvread(anthrofile);
            catch
                A_MEASURES = xlsread(anthrofile);

            end
            X1 = A_MEASURES(2);  % body mass in kg
            mass = X1;
            X2 = A_MEASURES(1);  % body height in cm

            ANTHRO.FootLength = A_MEASURES(3)*10; % foot length in mm

            ANTHRO.Mass = X1; %in kg
            ANTHRO.Height = X2/100; % in m


            ANTHRO.SegmentMass.Foot_old = (-0.829 + 0.0077*X1 + 0.0073*X2) ;
            ANTHRO.SegmentMass.Foot = X1*0.0137;
            ANTHRO.SegmentMass.Shank_old = (-1.592 + 0.0362*X1 + 0.0121*X2);
            ANTHRO.SegmentMass.Shank = X1*0.0433;
            ANTHRO.SegmentMass.Thigh_old = (-2.649 + 0.1463*X1 + 0.0137*X2);
            ANTHRO.SegmentMass.Thigh = X1*0.1416;
            ANTHRO.SegmentMass.Trunk = X1*0.4346;
            ANTHRO.SegmentMass.Head = X1*0.0694;
            ANTHRO.SegmentMass.UpperArm = X1*0.0271;
            ANTHRO.SegmentMass.LowerArm = X1*0.0162;
            ANTHRO.SegmentMass.Hand = X1*0.0061;

            if nargin == 3
                ANTHRO.MoI.Foot.X_old = (-15.48 + 0.144*X1 + 0.088*X2) / 100^2;   %/100 due to conversion from kg*cm^2  auf kg*m^2
                try
                    ANTHRO.MoI.Foot.X = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.124)^2;
                catch
                    ANTHRO.MoI.Foot.X = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.124)^2;
                end
                ANTHRO.MoI.Foot.Y_old = (-100 + 0.480*X1 + 0.626*X2) / 100^2;
                try
                    ANTHRO.MoI.Foot.Y = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.245)^2;
                catch
                    ANTHRO.MoI.Foot.Y = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.245)^2;
                end
                ANTHRO.MoI.Foot.Z_old = (-97.09 + 0.414*X1 + 0.614*X2) / 100^2;
                try
                    ANTHRO.MoI.Foot.Z = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.257)^2;
                catch
                    ANTHRO.MoI.Foot.Z = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.257)^2;
                end
                ANTHRO.MoI.Shank.X_old = (-1105 + 4.59*X1 + 6.63*X2) / 100^2;
                try
                    ANTHRO.MoI.Shank.X = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.251)^2;
                catch
                    ANTHRO.MoI.Shank.X = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.251)^2;
                end
                ANTHRO.MoI.Shank.Y_old = (-1152 + 4.594*X1 + 6.815*X2) / 100^2;
                try
                    ANTHRO.MoI.Shank.Y = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.246)^2;
                catch
                    ANTHRO.MoI.Shank.Y = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.246)^2;
                end
                ANTHRO.MoI.Shank.Z_old = (-70.5 + 1.134*X1 + 0.3*X2) / 100^2;
                try
                    ANTHRO.MoI.Shank.Z = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.102)^2;
                catch
                    ANTHRO.MoI.Shank.Z = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.102)^2;
                end

                ANTHRO.MoI.Thigh.X_old = (-3557 + 31.7*X1 + 18.61*X2) / 100^2;
                try
                    ANTHRO.MoI.Thigh.X = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.329)^2;
                catch
                    ANTHRO.MoI.Thigh.X = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.329)^2;
                end
                ANTHRO.MoI.Thigh.Y_old = (-3690 + 32.02*X1 + 19.24*X2) / 100^2;
                try
                    ANTHRO.MoI.Thigh.Y = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.329)^2;
                catch
                    ANTHRO.MoI.Thigh.Y = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.329)^2;
                end
                ANTHRO.MoI.Thigh.Z_old = (-13.5 + 11.3*X1 + -2.28*X2) / 100^2;
                try
                    ANTHRO.MoI.Thigh.Z = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.149)^2;
                catch
                    ANTHRO.MoI.Thigh.Z = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.149)^2;
                end
                try
                    ANTHRO.MoI.Trunk.X = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.372)^2;
                    ANTHRO.MoI.Trunk.Y = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.347)^2;
                    ANTHRO.MoI.Trunk.Z = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.191)^2;
                end
                try
                    ANTHRO.MoI.Head.X = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.303)^2;
                    ANTHRO.MoI.Head.Y = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.315)^2;
                    ANTHRO.MoI.Head.Z = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.261)^2;
                end
                try
                    ANTHRO.MoI.UpperArm.X = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.285)^2;
                    ANTHRO.MoI.UpperArm.Y = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.269)^2;
                    ANTHRO.MoI.UpperArm.Z = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.158)^2;
                end
                try
                    ANTHRO.MoI.LowerArm.X = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.276)^2;
                    ANTHRO.MoI.LowerArm.Y = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.265)^2;
                    ANTHRO.MoI.LowerArm.Z = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.121)^2;
                end
                try
                    ANTHRO.MoI.Hand.X = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.628)^2;
                    ANTHRO.MoI.Hand.Y = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.513)^2;
                    ANTHRO.MoI.Hand.Z = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.401)^2;
                end
            end
        end

        if size(A_MEASURES, 1) > 3
            RunningSpeed = A_MEASURES(4);
        else
            RunningSpeed = NaN;
        end
    end %getANTHRO_GUI



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ind_reftrial = get_reftrial(filename, ref_identifier)
        % finds the index of the reftrial that includes the reference identifier
        % specified in the OPTIONS struct

        n_trials = length(filename);

        for h = 1:n_trials
            if n_trials == 1
                filename = cellstr(filename);
            end
            if strfind(char(filename(1,h)), ref_identifier) > 0
                ind_reftrial = h;
                disp(['Referenzdatei Stand ist: ',char(filename(1,h))]);
                %                 disp
            end
        end
    end %ind_reftrial

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [REFFRAME, MARKERS, WEIGHT] = get_refinfo_GUI(ref_file, OPTIONS)
        % Function to extract the neccesary information from a static
        % reference trial.

        % Get Marker information
        % get marker trajectories and further information from the c3d file

        try
            [MARKERS.Raw, LABELS.Exist, ~, ~, ~, OPTIONS.FreqKinematics, OPTIONS.ftkratio] = getlabeledmarkers_GUI_mat(ref_file);
            alf = 2;
            % filter marker coordinates
            ExistentMarkers = LABELS.Exist;
            [b,a] = butter(OPTIONS.FilterOrder/2, OPTIONS.CutOffMarkers/(OPTIONS.FreqKinematics/2));
            for t = 1:length(ExistentMarkers)
                MARKERS.Filt.(char(ExistentMarkers(t,1))) = markersfilt(MARKERS.Raw.(char(ExistentMarkers(t,1))), b, a);
            end
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems reading in marker data']}];
        end


        %% Determine subjects wheight


        WEIGHT = OPTIONS.mass*9.81;


        %% Determine Technical and Anatomical Reference Frames for each Segment

        % Right leg %%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Right forefoot
        try
            [FRAME.Technical.RightForefoot.O, FRAME.Technical.RightForefoot.R] = get_technical_frame_GUI(MARKERS.Filt.toe_right.data, MARKERS.Filt.forfoot_lat_right.data, MARKERS.Filt.forfoot_med_right.data);
            [FRAME.Anatomical.RightForefoot.O, FRAME.Anatomical.RightForefoot.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightForefoot_regular');
            for u = 1:size(FRAME.Technical.RightForefoot.R, 3)
                FRAME.Technical_to_Anatomical.RightForefoot.R(:,:,u) = FRAME.Technical.RightForefoot.R(:,:,u)'*FRAME.Anatomical.RightForefoot.R;
                FRAME.Technical_to_Anatomical.RightForefoot.O(:,u) = FRAME.Technical.RightForefoot.R(:,:,u)'*(FRAME.Anatomical.RightForefoot.O - FRAME.Technical.RightForefoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightForefoot.R = Rmean(FRAME.Technical_to_Anatomical.RightForefoot.R);
            REFFRAME.Technical_to_Anatomical.RightForefoot.O = Vmean(FRAME.Technical_to_Anatomical.RightForefoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Forefoot Segment in Static Reference']}];
        end

        % Right rearfoot
        try
            [FRAME.Technical.RightRearfoot.O, FRAME.Technical.RightRearfoot.R] = get_technical_frame_GUI(MARKERS.Filt.calc_back_right.data, MARKERS.Filt.calc_med_right.data, MARKERS.Filt.calc_lat_right.data);
            [FRAME.Anatomical.RightRearfoot.O, FRAME.Anatomical.RightRearfoot.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightRearfoot_regular');
            for u = 1:size(FRAME.Technical.RightRearfoot.R, 3)
                FRAME.Technical_to_Anatomical.RightRearfoot.R(:,:,u) = FRAME.Technical.RightRearfoot.R(:,:,u)'*FRAME.Anatomical.RightRearfoot.R;
                FRAME.Technical_to_Anatomical.RightRearfoot.O(:,u) = FRAME.Technical.RightRearfoot.R(:,:,u)'*(FRAME.Anatomical.RightRearfoot.O - FRAME.Technical.RightRearfoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightRearfoot.R = Rmean(FRAME.Technical_to_Anatomical.RightRearfoot.R);
            REFFRAME.Technical_to_Anatomical.RightRearfoot.O = Vmean(FRAME.Technical_to_Anatomical.RightRearfoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Rearfoot Segment in Static Reference']}];
        end

        % Right foot
        try
            [FRAME.Technical.RightFoot.O, FRAME.Technical.RightFoot.R] = get_technical_frame_GUI(MARKERS.Filt.calc_back_right.data, MARKERS.Filt.forfoot_lat_right.data, MARKERS.Filt.forfoot_med_right.data);
            [FRAME.Anatomical.RightFoot.O, FRAME.Anatomical.RightFoot.R, FRAME.Anatomical.RightFoot.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightFoot_regular');
            for u = 1:size(FRAME.Technical.RightFoot.R, 3)
                FRAME.Technical_to_Anatomical.RightFoot.R(:,:,u) = FRAME.Technical.RightFoot.R(:,:,u)'*FRAME.Anatomical.RightFoot.R;
                FRAME.Technical_to_Anatomical.RightFoot.O(:,u) = FRAME.Technical.RightFoot.R(:,:,u)'*(FRAME.Anatomical.RightFoot.O - FRAME.Technical.RightFoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightFoot.R = Rmean(FRAME.Technical_to_Anatomical.RightFoot.R);
            REFFRAME.Technical_to_Anatomical.RightFoot.O = Vmean(FRAME.Technical_to_Anatomical.RightFoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Foot Segment in Static Reference']}];
        end

        % Right shank
        try
            [FRAME.Technical.RightShank.O, FRAME.Technical.RightShank.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_tibia_right_1.data, MARKERS.Filt.cluster_tibia_right_2.data, MARKERS.Filt.cluster_tibia_right_3.data, MARKERS.Filt.cluster_tibia_right_4.data);
            [FRAME.Anatomical.RightShank.O, FRAME.Anatomical.RightShank.R, FRAME.Anatomical.RightShank.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightShank_regular');
            for u = 1:size(FRAME.Technical.RightShank.R, 3)
                FRAME.Technical_to_Anatomical.RightShank.R(:,:,u) = FRAME.Technical.RightShank.R(:,:,u)'*FRAME.Anatomical.RightShank.R;
                FRAME.Technical_to_Anatomical.RightShank.O(:,u) = FRAME.Technical.RightShank.R(:,:,u)'*(FRAME.Anatomical.RightShank.O - FRAME.Technical.RightShank.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightShank.R = Rmean(FRAME.Technical_to_Anatomical.RightShank.R);
            REFFRAME.Technical_to_Anatomical.RightShank.O = Vmean(FRAME.Technical_to_Anatomical.RightShank.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Shank Segment in Static Reference']}];
        end

        % Right pelvis
        try
            [FRAME.Technical.RightPelvis.O, FRAME.Technical.RightPelvis.R] = get_technical_frame_GUI(MARKERS.Filt.SIAS_right.data, MARKERS.Filt.SIAS_left.data, MARKERS.Filt.SIPS_right.data, MARKERS.Filt.SIPS_left.data);
            [FRAME.Anatomical.RightPelvis.O, FRAME.Anatomical.RightPelvis.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightPelvis_regular');
            for u = 1:size(FRAME.Technical.RightPelvis.R, 3)
                FRAME.Technical_to_Anatomical.RightPelvis.R(:,:,u) = FRAME.Technical.RightPelvis.R(:,:,u)'*FRAME.Anatomical.RightPelvis.R;
                FRAME.Technical_to_Anatomical.RightPelvis.O(:,u) = FRAME.Technical.RightPelvis.R(:,:,u)'*(FRAME.Anatomical.RightPelvis.O - FRAME.Technical.RightPelvis.O(:,u));
                MARKERS.Filt.hip_joint_center_right.data(:,u) = FRAME.Anatomical.RightPelvis.O;
            end
            REFFRAME.Technical_to_Anatomical.RightPelvis.R = Rmean(FRAME.Technical_to_Anatomical.RightPelvis.R);
            REFFRAME.Technical_to_Anatomical.RightPelvis.O = Vmean(FRAME.Technical_to_Anatomical.RightPelvis.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis Segment in Static Reference']}];
        end

        % Right thigh
        try
            [FRAME.Technical.RightThigh.O, FRAME.Technical.RightThigh.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_femur_right_1.data, MARKERS.Filt.cluster_femur_right_2.data, MARKERS.Filt.cluster_femur_right_3.data, MARKERS.Filt.cluster_femur_right_4.data);
            [FRAME.Anatomical.RightThigh.O, FRAME.Anatomical.RightThigh.R, FRAME.Anatomical.RightThigh.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightThigh_regular');
            for u = 1:size(FRAME.Technical.RightThigh.R, 3)
                FRAME.Technical_to_Anatomical.RightThigh.R(:,:,u) = FRAME.Technical.RightThigh.R(:,:,u)'*FRAME.Anatomical.RightThigh.R;
                FRAME.Technical_to_Anatomical.RightThigh.O(:,u) = FRAME.Technical.RightThigh.R(:,:,u)'*(FRAME.Anatomical.RightThigh.O - FRAME.Technical.RightThigh.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightThigh.R = Rmean(FRAME.Technical_to_Anatomical.RightThigh.R);
            REFFRAME.Technical_to_Anatomical.RightThigh.O = Vmean(FRAME.Technical_to_Anatomical.RightThigh.O);
        catch
            %             data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Thigh Segment in Static Reference']}];
        end

        % Right Upper Extremity
        try
            [FRAME.Technical.RightUpperArm.O, FRAME.Technical.RightUpperArm.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_upperarm_right_1.data, MARKERS.Filt.cluster_upperarm_right_2.data, MARKERS.Filt.cluster_upperarm_right_3.data);
            [FRAME.Anatomical.RightUpperArm.O, FRAME.Anatomical.RightUpperArm.R, FRAME.Anatomical.RightUpperArm.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightUpperArm_regular');
            for u = 1:size(FRAME.Technical.RightUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.RightUpperArm.R(:,:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*FRAME.Anatomical.RightUpperArm.R;
                FRAME.Technical_to_Anatomical.RightUpperArm.O(:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*(FRAME.Anatomical.RightUpperArm.O - FRAME.Technical.RightUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightUpperArm.R = Rmean(FRAME.Technical_to_Anatomical.RightUpperArm.R);
            REFFRAME.Technical_to_Anatomical.RightUpperArm.O = Vmean(FRAME.Technical_to_Anatomical.RightUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file,  ' : Problems constructing Right UpperArm Segment in Static Reference']}];
        end

        % Left leg %%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Left forefoot
        try
            [FRAME.Technical.LeftForefoot.O, FRAME.Technical.LeftForefoot.R] = get_technical_frame_GUI(MARKERS.Filt.toe_left.data, MARKERS.Filt.forefoot_lat_left.data, MARKERS.Filt.forefoot_med_left.data);
            [FRAME.Anatomical.LeftForefoot.O, FRAME.Anatomical.LeftForefoot.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftForefoot_regular');
            for u = 1:size(FRAME.Technical.LeftForefoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftForefoot.R(:,:,u) = FRAME.Technical.LeftForefoot.R(:,:,u)'*FRAME.Anatomical.LeftForefoot.R;
                FRAME.Technical_to_Anatomical.LeftForefoot.O(:,u) = FRAME.Technical.LeftForefoot.R(:,:,u)'*(FRAME.Anatomical.LeftForefoot.O - FRAME.Technical.LeftForefoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftForefoot.R = Rmean(FRAME.Technical_to_Anatomical.LeftForefoot.R);
            REFFRAME.Technical_to_Anatomical.LeftForefoot.O = Vmean(FRAME.Technical_to_Anatomical.LeftForefoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Forefoot Segment in Static Reference']}];
        end

        % Left rearfoot
        try
            [FRAME.Technical.LeftRearfoot.O, FRAME.Technical.LeftRearfoot.R] = get_technical_frame_GUI(MARKERS.Filt.calc_back_left.data, MARKERS.Filt.calc_med_left.data, MARKERS.Filt.calc_lat_left.data);
            [FRAME.Anatomical.LeftRearfoot.O, FRAME.Anatomical.LeftRearfoot.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftRearfoot_regular');
            for u = 1:size(FRAME.Technical.LeftRearfoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftRearfoot.R(:,:,u) = FRAME.Technical.LeftRearfoot.R(:,:,u)'*FRAME.Anatomical.LeftRearfoot.R;
                FRAME.Technical_to_Anatomical.LeftRearfoot.O(:,u) = FRAME.Technical.LeftRearfoot.R(:,:,u)'*(FRAME.Anatomical.LeftRearfoot.O - FRAME.Technical.LeftRearfoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftRearfoot.R = Rmean(FRAME.Technical_to_Anatomical.LeftRearfoot.R);
            REFFRAME.Technical_to_Anatomical.LeftRearfoot.O = Vmean(FRAME.Technical_to_Anatomical.LeftRearfoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Rearfoot Segment in Static Reference']}];
        end

        % Left foot
        try
            [FRAME.Technical.LeftFoot.O, FRAME.Technical.LeftFoot.R] = get_technical_frame_GUI(MARKERS.Filt.calc_back_left.data, MARKERS.Filt.forefoot_lat_left.data, MARKERS.Filt.forefoot_med_left.data);
            [FRAME.Anatomical.LeftFoot.O, FRAME.Anatomical.LeftFoot.R, FRAME.Anatomical.LeftFoot.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftFoot_regular');
            for u = 1:size(FRAME.Technical.LeftFoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftFoot.R(:,:,u) = FRAME.Technical.LeftFoot.R(:,:,u)'*FRAME.Anatomical.LeftFoot.R;
                FRAME.Technical_to_Anatomical.LeftFoot.O(:,u) = FRAME.Technical.LeftFoot.R(:,:,u)'*(FRAME.Anatomical.LeftFoot.O - FRAME.Technical.LeftFoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftFoot.R = Rmean(FRAME.Technical_to_Anatomical.LeftFoot.R);
            REFFRAME.Technical_to_Anatomical.LeftFoot.O = Vmean(FRAME.Technical_to_Anatomical.LeftFoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Foot Segment in Static Reference']}];
        end

        % Left shank
        try
            [FRAME.Technical.LeftShank.O, FRAME.Technical.LeftShank.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_tibia_left_1.data, MARKERS.Filt.cluster_tibia_left_2.data, MARKERS.Filt.cluster_tibia_left_3.data, MARKERS.Filt.cluster_tibia_left_4.data);
            [FRAME.Anatomical.LeftShank.O, FRAME.Anatomical.LeftShank.R, FRAME.Anatomical.LeftShank.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftShank_regular');
            for u = 1:size(FRAME.Technical.LeftShank.R, 3)
                FRAME.Technical_to_Anatomical.LeftShank.R(:,:,u) = FRAME.Technical.LeftShank.R(:,:,u)'*FRAME.Anatomical.LeftShank.R;
                FRAME.Technical_to_Anatomical.LeftShank.O(:,u) = FRAME.Technical.LeftShank.R(:,:,u)'*(FRAME.Anatomical.LeftShank.O - FRAME.Technical.LeftShank.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftShank.R = Rmean(FRAME.Technical_to_Anatomical.LeftShank.R);
            REFFRAME.Technical_to_Anatomical.LeftShank.O = Vmean(FRAME.Technical_to_Anatomical.LeftShank.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Shank Segment in Static Reference']}];
        end
        % Left pelvis
        try
            [FRAME.Technical.LeftPelvis.O, FRAME.Technical.LeftPelvis.R] = get_technical_frame_GUI(MARKERS.Filt.SIAS_right.data, MARKERS.Filt.SIAS_left.data, MARKERS.Filt.SIPS_right.data, MARKERS.Filt.SIPS_left.data);
            [FRAME.Anatomical.LeftPelvis.O, FRAME.Anatomical.LeftPelvis.R, ~] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftPelvis_regular');
            for u = 1:size(FRAME.Technical.LeftPelvis.R, 3)
                FRAME.Technical_to_Anatomical.LeftPelvis.R(:,:,u) = FRAME.Technical.LeftPelvis.R(:,:,u)'*FRAME.Anatomical.LeftPelvis.R;
                FRAME.Technical_to_Anatomical.LeftPelvis.O(:,u) = FRAME.Technical.LeftPelvis.R(:,:,u)'*(FRAME.Anatomical.LeftPelvis.O - FRAME.Technical.LeftPelvis.O(:,u));
                MARKERS.Filt.hip_joint_center_left.data(:,u) = FRAME.Anatomical.LeftPelvis.O;
            end
            REFFRAME.Technical_to_Anatomical.LeftPelvis.R = Rmean(FRAME.Technical_to_Anatomical.LeftPelvis.R);
            REFFRAME.Technical_to_Anatomical.LeftPelvis.O = Vmean(FRAME.Technical_to_Anatomical.LeftPelvis.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis Segment in Static Reference']}];
        end

        % Left thigh
        try
            [FRAME.Technical.LeftThigh.O, FRAME.Technical.LeftThigh.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_femur_left_1.data, MARKERS.Filt.cluster_femur_left_2.data, MARKERS.Filt.cluster_femur_left_3.data, MARKERS.Filt.cluster_femur_left_4.data);
            [FRAME.Anatomical.LeftThigh.O, FRAME.Anatomical.LeftThigh.R, FRAME.Anatomical.LeftThigh.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftThigh_regular');
            for u = 1:size(FRAME.Technical.LeftThigh.R, 3)
                FRAME.Technical_to_Anatomical.LeftThigh.R(:,:,u) = FRAME.Technical.LeftThigh.R(:,:,u)'*FRAME.Anatomical.LeftThigh.R;
                FRAME.Technical_to_Anatomical.LeftThigh.O(:,u) = FRAME.Technical.LeftThigh.R(:,:,u)'*(FRAME.Anatomical.LeftThigh.O - FRAME.Technical.LeftThigh.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftThigh.R = Rmean(FRAME.Technical_to_Anatomical.LeftThigh.R);
            REFFRAME.Technical_to_Anatomical.LeftThigh.O = Vmean(FRAME.Technical_to_Anatomical.LeftThigh.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Thigh Segment in Static Reference']}];
        end
        % Head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
            [FRAME.Technical.Head.O, FRAME.Technical.Head.R] = get_technical_frame_GUI(MARKERS.Filt.head_front_right.data, MARKERS.Filt.head_front_left.data, MARKERS.Filt.head_back_right.data, MARKERS.Filt.head_back_left.data);
            [FRAME.Anatomical.Head.O, FRAME.Anatomical.Head.R, FRAME.Anatomical.Head.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'Head_regular');
            for u = 1:size(FRAME.Technical.Head.R, 3)
                FRAME.Technical_to_Anatomical.Head.R(:,:,u) = FRAME.Technical.Head.R(:,:,u)'*FRAME.Anatomical.Head.R;
                FRAME.Technical_to_Anatomical.Head.O(:,u) = FRAME.Technical.Head.R(:,:,u)'*(FRAME.Anatomical.Head.O - FRAME.Technical.Head.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.Head.R = Rmean(FRAME.Technical_to_Anatomical.Head.R);
            REFFRAME.Technical_to_Anatomical.Head.O = Vmean(FRAME.Technical_to_Anatomical.Head.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Head Segment in Static Reference']}];
        end

        % Right arm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Right upper arm
        try
            [FRAME.Technical.RightUpperArm.O, FRAME.Technical.RightUpperArm.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_upperarm_right_1.data, MARKERS.Filt.cluster_upperarm_right_2.data, MARKERS.Filt.cluster_upperarm_right_3.data);
            [FRAME.Anatomical.RightUpperArm.O, FRAME.Anatomical.RightUpperArm.R, FRAME.Anatomical.RightUpperArm.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightUpperArm_regular');
            for u = 1:size(FRAME.Technical.RightUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.RightUpperArm.R(:,:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*FRAME.Anatomical.RightUpperArm.R;
                FRAME.Technical_to_Anatomical.RightUpperArm.O(:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*(FRAME.Anatomical.RightUpperArm.O - FRAME.Technical.RightUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightUpperArm.R = Rmean(FRAME.Technical_to_Anatomical.RightUpperArm.R);
            REFFRAME.Technical_to_Anatomical.RightUpperArm.O = Vmean(FRAME.Technical_to_Anatomical.RightUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Upperarm Segment in Static Reference']}];
        end

        % Right lower arm
        try
            [FRAME.Technical.RightLowerArm.O, FRAME.Technical.RightLowerArm.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_lowerarm_right_1.data, MARKERS.Filt.cluster_lowerarm_right_2.data, MARKERS.Filt.cluster_lowerarm_right_3.data);
            [FRAME.Anatomical.RightLowerArm.O, FRAME.Anatomical.RightLowerArm.R, FRAME.Anatomical.RightLowerArm.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightLowerArm_regular');
            for u = 1:size(FRAME.Technical.RightLowerArm.R, 3)
                FRAME.Technical_to_Anatomical.RightLowerArm.R(:,:,u) = FRAME.Technical.RightLowerArm.R(:,:,u)'*FRAME.Anatomical.RightLowerArm.R;
                FRAME.Technical_to_Anatomical.RightLowerArm.O(:,u) = FRAME.Technical.RightLowerArm.R(:,:,u)'*(FRAME.Anatomical.RightLowerArm.O - FRAME.Technical.RightLowerArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightLowerArm.R = Rmean(FRAME.Technical_to_Anatomical.RightLowerArm.R);
            REFFRAME.Technical_to_Anatomical.RightLowerArm.O = Vmean(FRAME.Technical_to_Anatomical.RightLowerArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Lowerarm Segment in Static Reference']}];
        end

        % Right hand
        try
            [FRAME.Technical.RightHand.O, FRAME.Technical.RightHand.R] = get_technical_frame_GUI(MARKERS.Filt.hand_med_right.data, MARKERS.Filt.hand_lat_right.data, MARKERS.Filt.hand_top_right.data);
            [FRAME.Anatomical.RightHand.O, FRAME.Anatomical.RightHand.R, FRAME.Anatomical.RightHand.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'RightHand_regular');
            for u = 1:size(FRAME.Technical.RightHand.R, 3)
                FRAME.Technical_to_Anatomical.RightHand.R(:,:,u) = FRAME.Technical.RightHand.R(:,:,u)'*FRAME.Anatomical.RightHand.R;
                FRAME.Technical_to_Anatomical.RightHand.O(:,u) = FRAME.Technical.RightHand.R(:,:,u)'*(FRAME.Anatomical.RightHand.O - FRAME.Technical.RightHand.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightHand.R = Rmean(FRAME.Technical_to_Anatomical.RightHand.R);
            REFFRAME.Technical_to_Anatomical.RightHand.O = Vmean(FRAME.Technical_to_Anatomical.RightHand.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Hand Segment in Static Reference']}];
        end

        % Left arm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Left upper arm
        try
            [FRAME.Technical.LeftUpperArm.O, FRAME.Technical.LeftUpperArm.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_upperarm_left_1.data, MARKERS.Filt.cluster_upperarm_left_2.data, MARKERS.Filt.cluster_upperarm_left_3.data);
            [FRAME.Anatomical.LeftUpperArm.O, FRAME.Anatomical.LeftUpperArm.R, FRAME.Anatomical.LeftUpperArm.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftUpperArm_regular');
            for u = 1:size(FRAME.Technical.LeftUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.LeftUpperArm.R(:,:,u) = FRAME.Technical.LeftUpperArm.R(:,:,u)'*FRAME.Anatomical.LeftUpperArm.R;
                FRAME.Technical_to_Anatomical.LeftUpperArm.O(:,u) = FRAME.Technical.LeftUpperArm.R(:,:,u)'*(FRAME.Anatomical.LeftUpperArm.O - FRAME.Technical.LeftUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftUpperArm.R = Rmean(FRAME.Technical_to_Anatomical.LeftUpperArm.R);
            REFFRAME.Technical_to_Anatomical.LeftUpperArm.O = Vmean(FRAME.Technical_to_Anatomical.LeftUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Upperarm Segment in Static Reference']}];
        end
        % Left lower arm
        try
            [FRAME.Technical.LeftLowerArm.O, FRAME.Technical.LeftLowerArm.R] = get_technical_frame_GUI(MARKERS.Filt.cluster_lowerarm_left_1.data, MARKERS.Filt.cluster_lowerarm_left_2.data, MARKERS.Filt.cluster_lowerarm_left_3.data);
            [FRAME.Anatomical.LeftLowerArm.O, FRAME.Anatomical.LeftLowerArm.R, FRAME.Anatomical.LeftLowerArm.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftLowerArm_regular');
            for u = 1:size(FRAME.Technical.LeftLowerArm.R, 3)
                FRAME.Technical_to_Anatomical.LeftLowerArm.R(:,:,u) = FRAME.Technical.LeftLowerArm.R(:,:,u)'*FRAME.Anatomical.LeftLowerArm.R;
                FRAME.Technical_to_Anatomical.LeftLowerArm.O(:,u) = FRAME.Technical.LeftLowerArm.R(:,:,u)'*(FRAME.Anatomical.LeftLowerArm.O - FRAME.Technical.LeftLowerArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftLowerArm.R = Rmean(FRAME.Technical_to_Anatomical.LeftLowerArm.R);
            REFFRAME.Technical_to_Anatomical.LeftLowerArm.O = Vmean(FRAME.Technical_to_Anatomical.LeftLowerArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Lowerarm Segment in Static Reference']}];
        end

        % Left hand
        try
            [FRAME.Technical.LeftHand.O, FRAME.Technical.LeftHand.R] = get_technical_frame_GUI(MARKERS.Filt.hand_med_left.data, MARKERS.Filt.hand_lat_left.data, MARKERS.Filt.hand_top_left.data);
            [FRAME.Anatomical.LeftHand.O, FRAME.Anatomical.LeftHand.R, FRAME.Anatomical.LeftHand.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'LeftHand_regular');
            for u = 1:size(FRAME.Technical.LeftHand.R, 3)
                FRAME.Technical_to_Anatomical.LeftHand.R(:,:,u) = FRAME.Technical.LeftHand.R(:,:,u)'*FRAME.Anatomical.LeftHand.R;
                FRAME.Technical_to_Anatomical.LeftHand.O(:,u) = FRAME.Technical.LeftHand.R(:,:,u)'*(FRAME.Anatomical.LeftHand.O - FRAME.Technical.LeftHand.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftHand.R = Rmean(FRAME.Technical_to_Anatomical.LeftHand.R);
            REFFRAME.Technical_to_Anatomical.LeftHand.O = Vmean(FRAME.Technical_to_Anatomical.LeftHand.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Hand Segment in Static Reference']}];
        end

        % Trunk
        try
            [FRAME.Technical.Trunk.O, FRAME.Technical.Trunk.R] = get_technical_frame_GUI(MARKERS.Filt.clav.data, MARKERS.Filt.C_7.data, MARKERS.Filt.sternum.data);
            [FRAME.Anatomical.Trunk.O, FRAME.Anatomical.Trunk.R, FRAME.Anatomical.Trunk.Length] = getanaframe_GUI(MARKERS.Filt, OPTIONS, 'Trunk_regular');
            for u = 1:size(FRAME.Technical.Trunk.R, 3)
                FRAME.Technical_to_Anatomical.Trunk.R(:,:,u) = FRAME.Technical.Trunk.R(:,:,u)'*FRAME.Anatomical.Trunk.R;
                FRAME.Technical_to_Anatomical.Trunk.O(:,u) = FRAME.Technical.Trunk.R(:,:,u)'*(FRAME.Anatomical.Trunk.O - FRAME.Technical.Trunk.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.Trunk.R = Rmean(FRAME.Technical_to_Anatomical.Trunk.R);
            REFFRAME.Technical_to_Anatomical.Trunk.O = Vmean(FRAME.Technical_to_Anatomical.Trunk.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk Segment in Static Reference']}];
        end

        REFFRAME.Anatomical = FRAME.Anatomical;

        %% Determining rotation matrices between adjacent coordinate systems
        try
            REFFRAME.Joint.Pelvis_to_Trunk = getR(FRAME.Anatomical.RightPelvis.R, FRAME.Anatomical.Trunk.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis to Trunk Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_Head = getR(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.Head.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Head Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_RightUpperArm = getR(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.RightUpperArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Right UpperArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_UpperArm_to_LowerArm = getR(FRAME.Anatomical.RightUpperArm.R, FRAME.Anatomical.RightLowerArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right UpperArm to LowerArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_LowerArm_to_Hand = getR(FRAME.Anatomical.RightLowerArm.R, FRAME.Anatomical.RightHand.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right LowerArm to Hand Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_LeftUpperArm = getR(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.LeftUpperArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Left UpperArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_UpperArm_to_LowerArm = getR(FRAME.Anatomical.LeftUpperArm.R, FRAME.Anatomical.LeftLowerArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left UpperArm to LowerArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_LowerArm_to_Hand = getR(FRAME.Anatomical.LeftLowerArm.R, FRAME.Anatomical.LeftHand.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left LowerArm to Hand Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Pelvis_to_Thigh = getR(FRAME.Anatomical.RightPelvis.R, FRAME.Anatomical.RightThigh.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Pelvis to Thigh Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Thigh_to_Shank = getR(FRAME.Anatomical.RightThigh.R, FRAME.Anatomical.RightShank.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Thigh to Shank Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Shank_to_Rearfoot = getR(FRAME.Anatomical.RightShank.R, FRAME.Anatomical.RightRearfoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Shank to Rearfoot Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Rearfoot_to_Forefoot = getR(FRAME.Anatomical.RightRearfoot.R, FRAME.Anatomical.RightForefoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Rearfoot to Forefoot Rotation Matrix in Static Reference']}];
        end

        try
            REFFRAME.Joint.Left_Pelvis_to_Thigh = getR(FRAME.Anatomical.LeftPelvis.R, FRAME.Anatomical.LeftThigh.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Pelvis to Thigh Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Thigh_to_Shank = getR(FRAME.Anatomical.LeftThigh.R, FRAME.Anatomical.LeftShank.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Thigh to Shank Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Shank_to_Rearfoot = getR(FRAME.Anatomical.LeftShank.R, FRAME.Anatomical.LeftRearfoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Shank to Rearfoot Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Rearfoot_to_Forefoot = getR(FRAME.Anatomical.LeftRearfoot.R, FRAME.Anatomical.LeftForefoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Rearfoot to Forefoot Rotation Matrix in Static Reference']}];
        end


        %% Describing joint centers in their respenctive segment coordinate systems
        try
            MARKERS.Derived.RightMPJCinForefoot = FRAME.Anatomical.RightFoot.R' * (FRAME.Anatomical.RightFoot.O - FRAME.Anatomical.RightFoot.O);
            MARKERS.Derived.RightAnkleJCinShank = FRAME.Anatomical.RightShank.R' * ((mean(MARKERS.Filt.mal_lat_right.data,2) + mean(MARKERS.Filt.mal_med_right.data,2))./2 - FRAME.Anatomical.RightShank.O);
            MARKERS.Derived.RightKneeJCinThigh = FRAME.Anatomical.RightThigh.R' * ((mean(MARKERS.Filt.epi_lat_right.data,2) + mean(MARKERS.Filt.epi_med_right.data,2))./2 - FRAME.Anatomical.RightThigh.O);
            MARKERS.Derived.RightHipJCinPelvis = FRAME.Anatomical.RightPelvis.R' * (mean(FRAME.Anatomical.RightPelvis.O,2) - FRAME.Anatomical.RightPelvis.O);
            MARKERS.Derived.RightHipJCinThigh = FRAME.Anatomical.RightThigh.R' * (mean(FRAME.Anatomical.RightPelvis.O,2) - FRAME.Anatomical.RightThigh.O);

            MARKERS.Derived.RightShoulderJCinTrunk = FRAME.Anatomical.Trunk.R' * (mean([MARKERS.Filt.acrom_right.data(1:2,:);MARKERS.Filt.shoulder_right.data(3,:)],2) - FRAME.Anatomical.Trunk.O);
            MARKERS.Derived.RightElbowJCinUpperArm = FRAME.Anatomical.RightUpperArm.R' * (mean((MARKERS.Filt.elbow_lat_right.data + MARKERS.Filt.elbow_med_right.data)./2, 2) - FRAME.Anatomical.RightUpperArm.O);
            MARKERS.Derived.RightWristJCinLowerArm = FRAME.Anatomical.RightLowerArm.R' * (mean((MARKERS.Filt.hand_lat_right.data + MARKERS.Filt.hand_med_right.data)./2, 2) - FRAME.Anatomical.RightLowerArm.O);


        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Leg Joint Centers in Local Coordinate Systems']}];
        end
        try
            MARKERS.Derived.LeftMPJCinForefoot = FRAME.Anatomical.LeftFoot.R' * (FRAME.Anatomical.LeftFoot.O - FRAME.Anatomical.LeftFoot.O);
            MARKERS.Derived.LeftAnkleJCinShank = FRAME.Anatomical.LeftShank.R' * ((mean(MARKERS.Filt.mal_lat_left.data,2) + mean(MARKERS.Filt.mal_med_left.data,2))./2 - FRAME.Anatomical.LeftShank.O);
            MARKERS.Derived.LeftKneeJCinThigh = FRAME.Anatomical.LeftThigh.R' * ((mean(MARKERS.Filt.epi_lat_left.data,2) + mean(MARKERS.Filt.epi_med_left.data,2))./2 - FRAME.Anatomical.LeftThigh.O);
            MARKERS.Derived.LeftHipJCinPelvis = FRAME.Anatomical.LeftPelvis.R' * (mean(FRAME.Anatomical.LeftPelvis.O,2) - FRAME.Anatomical.LeftPelvis.O);
            MARKERS.Derived.LeftHipJCinThigh = FRAME.Anatomical.LeftThigh.R' * (mean(FRAME.Anatomical.LeftPelvis.O,2) - FRAME.Anatomical.LeftThigh.O);

            MARKERS.Derived.LeftShoulderJCinTrunk = FRAME.Anatomical.Trunk.R' * (mean([MARKERS.Filt.acrom_left.data(1:2,:);MARKERS.Filt.shoulder_left.data(3,:)],2) - FRAME.Anatomical.Trunk.O);
            MARKERS.Derived.LeftElbowJCinUpperArm = FRAME.Anatomical.LeftUpperArm.R' * (mean((MARKERS.Filt.elbow_lat_left.data + MARKERS.Filt.elbow_med_left.data)./2, 2) - FRAME.Anatomical.LeftUpperArm.O);
            MARKERS.Derived.LeftWristJCinLowerArm = FRAME.Anatomical.LeftLowerArm.R' * (mean((MARKERS.Filt.hand_lat_left.data + MARKERS.Filt.hand_med_left.data)./2, 2) - FRAME.Anatomical.LeftLowerArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Leg Joint Centers in Local Coordinate Systems']}];
        end

        try
            MARKERS.Derived.NeckJCinTrunk = FRAME.Anatomical.Trunk.R' * (mean([(MARKERS.Filt.C_7.data(1,:) + MARKERS.Filt.clav.data(1,:))./2; MARKERS.Filt.clav.data(2:3,:)], 2) - FRAME.Anatomical.Trunk.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Neck Joint Center in Local Coordinate System']}];
        end




    end %get_refinfo_GUI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changes certain expression in strings which Matlab doesn't like :-)
    function Y = correctumlaut(string)
        % Finds and changes German umlauts
        for i = 1:length(string)
            if strcmp(string(i), 'ä')
                string(i) = 'a';
            elseif strcmp(string(i), '-')
                string(i) = '_';
            elseif strcmp(string(i), 'ö')
                string(i) = 'o';
            elseif strcmp(string(i), 'ü')
                string(i) = 'u';
            elseif strcmp(string(i), 'ß')
                string(i) = 's';
            elseif strcmp(string(i), '.')
                string(i) = '_';
            end
        end

        Y = string;
    end %correctumlaut

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI(Pfad)
        % Reads in labeled c3d trajectories from c3d file (using c3d server
        % functionality)

        %% Open C3D Files using C3D Server
        M = c3dserver;
        openc3d(M,0,Pfad);
        freq = M.GetVideoFrameRate; %XXX.FrameRate

        ftkratio = M.GetAnalogVideoRatio; %XXX.Force.Frequency/XXX.FrameRate


        start = M.GetVideoFrame(0); %XXX.StartFrame
        ende = M.GetVideoFrame(1);  %XXX.Frames
        nframes = ende-start+1; %XXX.Frames

        index1 = M.GetParameterIndex('POINT', 'LABELS');
        n_labels = M.GetParameterLength(index1);
        run = 1;
        for i = 0:n_labels-1
            if ~isempty(M.GetParameterValue(index1,i))
                label = deleteblank(M.GetParameterValue(index1,i)); %
                sternlabel = strfind(label, '*');

                if isempty(sternlabel)
                    Labels(run,1) = cellstr(label); %#ok<AGROW>
                    run = run+1;
                    for j = 0:2
                        Markers.(label).data(j+1,:) = cell2mat(M.GetPointDataEx(i,j,start,ende,'1'));
                    end
                end
            end
            clear label sternlabel
        end

        %% Checking for Gaps
        for k = 1:length(Labels)
            for l = 1:ende-start+1
                if sum(Markers.(char(Labels(k,1))).data(1:3,l)) == 0
                    Gaps.(char(Labels(k,1))).frames(1,l) = 1;
                else
                    Gaps.(char(Labels(k,1))).frames(1,l) = 0;
                end
            end
            Gaps.exist = 0;
            if sum(Gaps.(char(Labels(k,1))).frames(1,:)) > 0
                Gaps.(char(Labels(k,1))).exist = 1;
                Gaps.exist = 1;
            else
                Gaps.(char(Labels(k,1))).exist = 0;
            end
        end
        closec3d(M);
    end %getlabeledmarkers_GUI

    function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI_mat(Pfad)
        %         tmpName = split(Pfad, '\');
        close all
        mainStruct = [];
        mainStruct = load(Pfad);
        name = string(fieldnames(mainStruct));

        freq = mainStruct.(name).FrameRate;

        try
            ftkratio = mainStruct.(name).Force.Frequency/mainStruct.(name).FrameRate;
        catch
            % ploy(r,x)
            ftkratio = 2000/mainStruct.(name).FrameRate;
        end
        start = mainStruct.(name).StartFrame;

        %end umschreiben in frames die genommen werden von dem File
        %(berechnen)
        ende = start + mainStruct.(name).Frames - 1;
        nframes = mainStruct.(name).Frames;

        n_labels = mainStruct.(name).Trajectories.Labeled.Count;

        Labels = mainStruct.(name).Trajectories.Labeled.Labels';

        for n = 1:length(Labels)
            rotated_data = rotate_marker_90_z(squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :)));
            Markers.(Labels{n}).data =rotated_data ; % squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
            %Markers.(Labels{n}).data =squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
            Markers.(Labels{n}).data(1,:) =Markers.(Labels{n}).data(1,:) +500 ;
            Markers.(Labels{n}).data (2,:) = Markers.(Labels{n}).data (2,:)+300;
            % figure(100)
            % temp = mean( Markers.(Labels{n}).data,2);
            % if strcmp((Labels{n}), 'epi_med_right')
            % 
            %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % elseif strcmp((Labels{n}), 'mal_med_right')
            %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % elseif strcmp((Labels{n}), 'toe_right')
            %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % 
            % elseif strcmp((Labels{n}), 'SIPS_right')
            %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % 
            % else
            %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100)
            % 
            % end
            % hold on
            % Plot the x-axis (from origin to [1, 0, 0])
            % plot3([0 5], [0 0], [0 0], 'r', 'LineWidth', 2); % x-axis in red
            % hold on; % Hold the plot for additional plotting
            % 
            % Plot the y-axis (from origin to [0, 1, 0])
            % plot3([0 0], [0 5], [0 0], 'g', 'LineWidth', 2); % y-axis in green
            % 
            % Plot the z-axis (from origin to [0, 0, 1])
            % plot3([0 0], [0 0], [0 5], 'b', 'LineWidth', 2); % z-axis in blue
            % 
            % Label the axes
            % text(1, 0, 0, 'X', 'FontSize', 12, 'Color', 'r'); % X-axis label
            % text(0, 1, 0, 'Y', 'FontSize', 12, 'Color', 'g'); % Y-axis label
            % text(0, 0, 1, 'Z', 'FontSize', 12, 'Color', 'b'); % Z-axis label
            % axis equal
        end
        alf = 2;
        Gaps = 0;
    end

    function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI_mat_DYNAMIC(Pfad)
        %         tmpName = split(Pfad, '\');
        close all
        mainStruct = [];
        mainStruct = load(Pfad);
        name = string(fieldnames(mainStruct));

        freq = mainStruct.(name).FrameRate;

        try
            ftkratio = mainStruct.(name).Force.Frequency/mainStruct.(name).FrameRate;
        catch
            % ploy(r,x)
            ftkratio = 2000/mainStruct.(name).FrameRate;
        end
        start = mainStruct.(name).StartFrame;

        %end umschreiben in frames die genommen werden von dem File
        %(berechnen)
        ende = start + mainStruct.(name).Frames - 1;
        nframes = mainStruct.(name).Frames;

        n_labels = mainStruct.(name).Trajectories.Labeled.Count;

        Labels = mainStruct.(name).Trajectories.Labeled.Labels';

        for n = 1:length(Labels)
            % rotated_data = rotate_marker_90_z(squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :)));
            % Markers.(Labels{n}).data =rotated_data ; % squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
            Markers.(Labels{n}).data =squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
  
            % % % figure(100)
            % % % temp = mean( Markers.(Labels{n}).data,2);
            % % % if strcmp((Labels{n}), 'epi_med_right')
            % % % 
            % % %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % % % elseif strcmp((Labels{n}), 'mal_med_right')
            % % %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % % % elseif strcmp((Labels{n}), 'toe_right')
            % % %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % % % 
            % % % elseif strcmp((Labels{n}), 'SIPS_right')
            % % %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100, 'filled')
            % % % 
            % % % else
            % % %     scatter3 (temp(1)/100, temp(2)/100, temp(3)/100)
            % % % 
            % % % end
            % % % hold on
            % % % % Plot the x-axis (from origin to [1, 0, 0])
            % % % plot3([0 5], [0 0], [0 0], 'r', 'LineWidth', 2); % x-axis in red
            % % % hold on; % Hold the plot for additional plotting
            % % % 
            % % % % Plot the y-axis (from origin to [0, 1, 0])
            % % % plot3([0 0], [0 5], [0 0], 'g', 'LineWidth', 2); % y-axis in green
            % % % 
            % % % % Plot the z-axis (from origin to [0, 0, 1])
            % % % plot3([0 0], [0 0], [0 5], 'b', 'LineWidth', 2); % z-axis in blue
            % % % 
            % % % % Label the axes
            % % % text(1, 0, 0, 'X', 'FontSize', 12, 'Color', 'r'); % X-axis label
            % % % text(0, 1, 0, 'Y', 'FontSize', 12, 'Color', 'g'); % Y-axis label
            % % % text(0, 0, 1, 'Z', 'FontSize', 12, 'Color', 'b'); % Z-axis label
            % % % axis equal
        end
        alf = 2;
        Gaps = 0;
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function MARKERS_FILT = markersfilt(RAW, b, a, range)
        % Filters raw 3D trajectory data
        if nargin == 3
            for j = 1:3
                RAW.data(j,:) = fillmissing(RAW.data(j,:),'nearest');
                MARKERS_FILT.data(j,:) = zeros (1,  length (RAW.data(j,:)));
                MARKERS_FILT.data(j,:) = filtfilt(b,a,double(RAW.data(j,:)));
            end
        else
            for j = 1:3
                MARKERS_FILT.data(j,:) = filtfilt(b,a,double(RAW.data(j,range)));
            end
        end
    end %markersfilt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Trial_opti] = SVDopti(Trial_raw,Ref)
        % Optimizes marker trajectories to better comply with rigid body
        % assumptions.

        %____________________________________________________________________
        %% Segment mit 3 Markern
        if size(Ref,2)==3

            %%
            Trial=Trial_raw;


            %% Allg. Paper der Methode: Söderkvist 1993, J. Biomech, s. 1473 bis 1477

            % Technical-Frame und Barrycenter für Trial erstellen
            oTrial(:,1,:)=(Trial(:,1,:)+Trial(:,2,:)+Trial(:,3,:))/3;
            y=repmat(oTrial,1,size(Trial,2));
            tech_Trial= Trial-y;

            % Technical-Frame und Barrycenter für Ref erstellen und Mittelwerte dieser
            oRef(:,1,:)=(Ref(:,1,:)+Ref(:,2,:)+Ref(:,3,:))/3;
            y2=repmat(oRef,1,size(Ref,2));
            tech_Refh= Ref-y2;
            oRefh(:,:)=oRef(:,1,:);
            oRefm=mean(oRefh,2);
            tech_Ref=mean(tech_Refh,3);



            % Cross-Dispersionsmatrix: Arun 1987, IEEE TRANSACTIONS ON PATTERN ANALYSIS
            % AND MACHINE INTELLIGENCE, s. 698 - 700

            for i=1:size(Trial,3)
                G(:,:,i)=tech_Trial(:,:,i)*tech_Ref'; %#ok<AGROW>
            end
            clear i


            % Singulärwertzerlegung % Optimal nach Hanson and Norris (1981, 363) in
            % SIAM J. Sci. Stat. comput.
            for i=1:size(Trial,3)

                [U,~,V] = svd(G(:,:,i));
                v=[1 1 (det(U'*V))'];
                R(:,:,i)=U*(diag(v))*V'; %#ok<AGROW>

                d(:,i)=oTrial(:,1,i)-R(:,:,i)*(oRefm); %#ok<AGROW>
                clear U  V v

                %Globale Variable des Trials optimiert rekonstruieren
                Vektor_1(:,i)=R(:,:,i)*Ref(:,1)+d(:,i); %#ok<AGROW>
                Vektor_2(:,i)=R(:,:,i)*Ref(:,2)+d(:,i); %#ok<AGROW>
                Vektor_3(:,i)=R(:,:,i)*Ref(:,3)+d(:,i); %#ok<AGROW>
            end
            clear G U S V i v

            %% Output der Funktion
            Trial_opti(:,1,:)=Vektor_1;
            Trial_opti(:,2,:)=Vektor_2;
            Trial_opti(:,3,:)=Vektor_3;

            clear G U S V i v


            %% gefilterter Trial für Plot Aufbereitet
            vek1(:,:)=Trial_raw(:,1,:);
            vek2(:,:)=Trial_raw(:,2,:);
            vek3(:,:)=Trial_raw(:,3,:);


            %%
            clear G U S V i v Test_a Test_b A B r R1h R1hs R2h R2hs R3h R3hs
            clear tech_Refh y y2 yy yyy oRefh
        end




        %____________________________________________________________________
        %% Segment mit 4 Markern


        if size(Ref,2)==4

            %%
            Trial=Trial_raw;


            %% Allg. Paper der Methode: Söderkvist 1993, J. Biomech, s. 1473 bis 1477

            % Technical-Frame und Barrycenter für Trial erstellen
            oTrial(:,1,:)=(Trial(:,1,:)+Trial(:,2,:)+Trial(:,3,:)+Trial(:,4,:))/4;
            y=repmat(oTrial,1,size(Trial,2));
            tech_Trial= Trial-y;

            % Technical-Frame und Barrycenter für Ref erstellen und Mittelwerte dieser
            oRef(:,1,:)=(Ref(:,1,:)+Ref(:,2,:)+Ref(:,3,:)+Ref(:,4,:))/4;
            y2=repmat(oRef,1,size(Ref,2));
            tech_Refh= Ref-y2;
            oRefh(:,:)=oRef(:,1,:);
            oRefm=mean(oRefh,2);
            tech_Ref=mean(tech_Refh,3);



            % Cross-Dispersionsmatrix: Arun 1987, IEEE TRANSACTIONS ON PATTERN ANALYSIS
            % AND MACHINE INTELLIGENCE, s. 698 - 700

            for i=1:size(Trial,3)
                G(:,:,i)=tech_Trial(:,:,i)*tech_Ref';
            end
            clear i


            % Singulärwertzerlegung % Optimal nach Hanson and Norris (1981, 363) in
            % SIAM J. Sci. Stat. comput.
            for i=1:size(Trial,3)

                [U,~,V] = svd(G(:,:,i));
                v=[1 1 (det(U'*V))'];
                R(:,:,i)=U*(diag(v))*V';

                d(:,i)=oTrial(:,1,i)-R(:,:,i)*(oRefm);
                clear U  V v

                %Globale Variable des Trials optimiert rekonstruieren
                Vektor_1(:,i)=R(:,:,i)*Ref(:,1)+d(:,i);
                Vektor_2(:,i)=R(:,:,i)*Ref(:,2)+d(:,i);
                Vektor_3(:,i)=R(:,:,i)*Ref(:,3)+d(:,i);
                Vektor_4(:,i)=R(:,:,i)*Ref(:,4)+d(:,i); %#ok<AGROW>
            end
            clear G U S V i v

            %% Output der Funktion
            Trial_opti(:,1,:)=Vektor_1;
            Trial_opti(:,2,:)=Vektor_2;
            Trial_opti(:,3,:)=Vektor_3;
            Trial_opti(:,4,:)=Vektor_4;

            clear G U S V i v


            %% gefilterter Trial für Plot Aufbereitet
            vek1(:,:)=Trial_raw(:,1,:); %#ok<NASGU>
            vek2(:,:)=Trial_raw(:,2,:); %#ok<NASGU>
            vek3(:,:)=Trial_raw(:,3,:); %#ok<NASGU>
            vek4(:,:)=Trial_raw(:,4,:); %#ok<NASGU>



            %%
            clear G U S V i v Test_a Test_b A B r R1h R1hs R2h R2hs R3h R3hs
            clear tech_Refh y y2 yy yyy oRefh

        end

    end %SVDopti



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Y1, Y2, Y3, Y4] = vorne(V)
        % Function to rearrange Data Matrizes
        Y1 = zeros(3,size(V,3));
        Y2 = zeros(3,size(V,3));
        Y3 = zeros(3,size(V,3));
        Y4 = zeros(3,size(V,3));
        if size(V,2) == 1
            for i = 1:size(V,3)
                Y1(:,i) = V(:,1,i);

            end
        end


        if size(V,2) == 3
            for i = 1:size(V,3)
                Y1(:,i) = V(:,1,i);
                Y2(:,i) = V(:,2,i);
                Y3(:,i) = V(:,3,i);
            end
        end

        if size(V,2) == 4
            for i = 1:size(V,3)
                Y1(:,i) = V(:,1,i);
                Y2(:,i) = V(:,2,i);
                Y3(:,i) = V(:,3,i);
                Y4(:,i) = V(:,4,i);
            end
        end
    end %vorne

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Y = hinten(P1, P2, P3, P4)
        % Function to rearrange Data Matrizes
        if nargin == 3
            for i = 1:size(P1,2)
                Y(:,1,i) = P1(:,i);
                Y(:,2,i) = P2(:,i);
                Y(:,3,i) = P3(:,i);
            end
        end

        if nargin == 4
            for i = 1:size(P1,2)
                Y(:,1,i) = P1(:,i);
                Y(:,2,i) = P2(:,i);
                Y(:,3,i) = P3(:,i);
                Y(:,4,i) = P4(:,i);
            end
        end
    end %hinten

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [O,R] = get_technical_frame_GUI(P1, P2, P3, P4)
        % Function to determine a technical coordinate system (with origin
        % O and rotation matrix R) from clusters of three or four markers
        if nargin == 3
            [~, y] = size(P1);
            O = zeros(3,y);


            for i = 1:y
                O(:,i) = (P1(:,i) + P2(:,i) + P3(:,i)) / 3;
            end




            Help1 = zeros(3,1,y);
            X = zeros(3,1,y);
            Y = zeros(3,1,y);
            Z = zeros(3,1,y);
            for i = 1:y


                X(:,i) = P2(:,i) - P1(:,i);
                Help1(:,i) = P3(:,i) - P1(:,i);
                Z(:,i) = cross(X(:,i), Help1(:,i));
                Y(:,i) = cross(Z(:,i), X(:,i));
                X(:,i) = X(:,i) / norm(X(:,i));
                Y(:,i) = Y(:,i) / norm(Y(:,i));
                Z(:,i) = Z(:,i) / norm(Z(:,i));
            end

            R = [X,Y,Z];

        else
            [~, y] = size(P1);
            O = zeros(3,y);


            for i = 1:y
                O(:,i) = (P1(:,i) + P2(:,i) + P3(:,i) + P4(:,i)) / 4;
            end




            Help1 = zeros(3,1,y);
            X = zeros(3,1,y);
            Y = zeros(3,1,y);
            Z = zeros(3,1,y);
            for i = 1:y


                Z(:,i) = ((P1(:,i) + P2(:,i)) / 2) - O(:,i);
                Help1(:,i) = ((P2(:,i) + P4(:,i)) / 2) - O(:,i);
                X(:,i) = cross(Help1(:,i), Z(:,i));
                Y(:,i) = cross(Z(:,i), X(:,i));
                X(:,i) = X(:,i) / norm(X(:,i));
                Y(:,i) = Y(:,i) / norm(Y(:,i));
                Z(:,i) = Z(:,i) / norm(Z(:,i));
            end

            R = [X,Y,Z];
        end
    end %get_technical_frame_GUI


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [V, ACC, LinV, LinACC, Theta] = getsegmentderivatives(R,O,freq)
        % Determines linear velocity and acceleration and the skew
        % symmetric matrix Theta from a coordinate system (defined by
        % origin O and rotation matrix R)
        Rpunkt = getderivateM3point(R)./(1/freq);
        Theta = getTheta(Rpunkt, R);
        V(1,:) =  Theta(3,2,:);
        V(2,:) =  Theta(1,3,:);
        V(3,:) =  Theta(2,1,:);
        ACC = zeros(3,length(O));
        for o = 1:3
            ACC(o,:) = getderivativesvel(V(o,:))./(1/freq);
        end
        LinV = getderivateCOMVEL3point(O)./(1/freq) / 1000;
        LinACC = getderivateCOMACC3point(LinV)./(1/freq);
    end %getsegmentderivatives

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function R = getR_ref_norm(R1, R2, R_REF, reftostatic)
        % Determines the rotation matrix between two segments, either with
        % reference to a static trial or not
        [x, y, z] = size(R1);
        R = zeros(x,y,z);
        if reftostatic
            for i = 1:z
                R(:,:,i) = (R1(:,:,i)'*R2(:,:,i)) * R_REF(:,:,1)';
            end
        else
            for i = 1:z
                R(:,:,i) = R1(:,:,i)'*R2(:,:,i);
            end
        end
    end %getR_ref_norm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Matrix = getderivateM3point(M)
        % Performs numerical differentiation of a vector or matrix using
        % the 3 point method
        Matrix = zeros(size(M,1), size(M,2), size(M,3));
        if ndims(M) == 2 %#ok<ISMAT>
            for j = 1:size(M,1)
                for k = 2:size(M,2)-1
                    Matrix(j,k) = (M(j,k+1) - M(j,k-1)) / 2;
                end
            end
            Matrix(:,size(M,2)) = Matrix(:,size(M,2)-1);

        elseif ndims(M) == 3
            for i = 2:size(M,3)-1
                for j = 1:size(M,1)
                    for k = 1:size(M,2)
                        Matrix(j,k,i) = ((M(j,k,i+1) - M(j,k,i-1)) / 2);
                    end
                end
            end
            Matrix(:,:,size(M,3)) = Matrix(:,:,size(M,3)-1);
        end
    end %getderivateM3point


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Theta = getTheta(Rpunkt, R)
        % Determines the skew symmetric matrix theta from which te angular
        % velocity of a coordinate system can be determined
        Theta = zeros(3,3,size(Rpunkt,3));
        for i = 1:size(Rpunkt,3)
            Theta(:,:,i) = Rpunkt(:,:,i)*R(:,:,i)';
        end
    end %getTheta


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Winkel = getwinkel(R)
        % Determines three Cardan Angles from a rotation matrix R using a
        % yxz order of rotation.
        Y_yxz = zeros(1,size(R,3));
        X_yxz = zeros(1,size(R,3));
        Z_yxz = zeros(1,size(R,3));
        for i=1:size(R,3)
            %YXZ
            Y_yxz(:,i)=atan2( R(1,3,i),R(3,3,i));
            X_yxz(:,i)=atan2(-R(2,3,i),sqrt((R(1,3,i)^2)+(R(3,3,i)^2)));
            Z_yxz(:,i)=atan2(R(2,1,i), R(2,2,i));
        end

        Winkel.X = X_yxz;
        Winkel.Y = Y_yxz;
        Winkel.Z = Z_yxz;
    end % getwinkel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function y = normalize(VEK, interv)
        % Performs time normalization if an input vector (VEK). Data points
        % are normalized from 0 to 100% in intervals given by interv
        t_mod=0:100/(length(VEK)-1):100;
        t_nor=0:interv:100;
        y=interp1(t_mod, VEK, t_nor,'pchip');

    end %normalize

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function OUT = getAllAnalogChannels(FileName)
        % Funtion to extract all analog channels from a c3d file
        M = c3dserver;
        openc3d(M,0,FileName);
        start = M.GetVideoFrame(0);
        ende = M.GetVideoFrame(1);
        index2 = M.GetParameterIndex('ANALOG', 'LABELS');
        n_channels = M.GetParameterLength(index2);
        for w = 1:n_channels
            ChName = deleteblank(correctumlaut(M.GetParameterValue(index2,w-1)));
            OUT.(ChName)(1,:) = cell2mat(M.GetAnalogDataEx(w-1,start,ende,'1',0,0,'1'));
        end
        closec3d(M);

    end %getAllAnalogChannels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function OUT = get_parameters_from_NORMAL(NORMAL, leg, CONTACT, OPTIONS)
        % Determines standard parameters from the NORMAL struct
        fnames = fieldnames(CONTACT);
        if (OPTIONS.ExperimentalSetup == 9) || (OPTIONS.ExperimentalSetup == 10)
            OUT.ContactTime = [];
            for dd = 1:length(fnames)
                for ee = 1:length(CONTACT.(fnames{dd}))
                    OUT.ContactTime = [OUT.ContactTime, length(CONTACT.(fnames{dd}){ee})/OPTIONS.FreqKinematics];
                end
            end
            L = OUT.ContactTime.*OPTIONS.FreqKinematics;
        else
            for dd = 1:length(fnames)
                OUT.ContactTime(dd) = length(CONTACT.(fnames{dd}))/OPTIONS.freqGRF;
            end
            L = OUT.ContactTime.*OPTIONS.freqGRF;
        end



        level1 = fieldnames(NORMAL);
        for j = 1:length(level1)
            level2{j} = fieldnames(NORMAL.(char(level1(j))));

        end
        for k = 1:length(level2)
            for l = 1:length(level2{k})
                level3{k,l} = fieldnames(NORMAL.(char(level1(k))).(char(level2{k}(l))));
            end
        end
        assignin('base', 'level1', level1);
        assignin('base', 'level2', level2);
        assignin('base', 'level3', level3);


        for i = 1:length(level1)
            for j = 1:length(level2{i})
                for k = 1:length(level3{i,j})
                    if strcmp(char(level1(i)), 'ANGLES')  ||  strcmp(char(level1(i)), 'MOMENTS')  ||  strcmp(char(level1(i)), 'POWER')  ||  strcmp(char(level1(i)), 'GRF')
                        if (k == 2) || (leg == 'R')
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','TD']) = NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1,:);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','TO']) = NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(end,:);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX']) = max(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN']) = min(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX1']) = max(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1:100,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN1']) = min(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1:100,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX2']) = max(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(101:201,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN2']) = min(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(101:201,:),[],1);
                        else
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','TD']) = -NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1,:);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','TO']) = -NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(end,:);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX']) = max(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN']) = min(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX1']) = max(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1:100,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN1']) = min(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(1:100,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MAX2']) = max(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(101:201,:),[],1);
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MIN2']) = min(-NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(101:201,:),[],1);
                        end
                    end




                    %                     for l = 1:size(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))), 2)
                    %
                    %                         D = interp1(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(:,l), 1:201/L(l):201);
                    %                         if (OPTIONS.ExperimentalSetup == 9) || (OPTIONS.ExperimentalSetup == 10)
                    %                             OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_NET'])(1,l) = getlast(integrate_p(D, OPTIONS.FreqKinematics, 1, length(D)));
                    %                             M = find0(D, OPTIONS.FreqKinematics, 1, length(D));
                    %                             [OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_POS'])(1,l), OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_NEG'])(1,l), ~] = integrate_sw(D, OPTIONS.FreqKinematics, 1, length(D), M);
                    %                         else
                    %                             OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_NET'])(1,l) = getlast(integrate_p(D, OPTIONS.freqGRF, 1, length(D)));
                    %                             M = find0(D, OPTIONS.freqGRF, 1, length(D));
                    %                             [OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_POS'])(1,l), OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','INT_NEG'])(1,l), ~] = integrate_sw(D, OPTIONS.freqGRF, 1, length(D), M);
                    %                         end
                    %                         clear D M
                    %                     end


                    for l = 1:size(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k))), 2)
                        [OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN0_10'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN10_20'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN20_30'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN30_40'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN40_50'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN50_60'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN60_70'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN70_80'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN80_90'])(1,l),...
                            OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN90_100'])(1,l)] = get10percentintervals(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(:,l)');
                        OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN5_95'])(1,l) = mean(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(10:190,l));
                        OUT.([char(level1(i)),'_',char(level2{i}(j)),'_',char(level3{i,j}(k)),'_','MEAN50_100'])(1,l) = mean(NORMAL.(char(level1(i))).(char(level2{i}(j))).(char(level3{i,j}(k)))(100:201,l));
                    end






                end
            end
        end
    end %get_parameters_from_NORMAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Y = deleteblank(string)
        % Removes empty spaces from a sring
        leer = char(32);
        j = 1;
        for i = 1:length(string)
            if string(i) ~= leer;
                Y(j) = string(i);
                j=j+1;
            end
        end
    end %deleteblank

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [O, R, SLength] = getanaframe_GUI(MARKERS, OPTIONS, segment)
        switch segment
            % Determines anatomoical frames in a static measurement for
            % each body segment
            %%%%%%%%%%%%%%%%%%%%%%%%%% Right Leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'RightFoot_regular'
                [~, y] = size(MARKERS.calc_back_right.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = MARKERS.calc_back_right.data(:,i) + ([1;0;0])*0.4415*OPTIONS.ANTHRO.FootLength     +    ([1;0;0])*20 ; %Center of mass from Zatziorsky;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = OPTIONS.ANTHRO.FootLength./1000;
            case 'RightForefoot_regular'
                [~, y] = size(MARKERS.toe_right.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(1,i) = MARKERS.forfoot_med_right.data(1,i);
                    O_allframes(3,i) = MARKERS.forfoot_med_right.data(3,i);
                    O_allframes(2,i) = (MARKERS.forfoot_med_right.data(2,i) + MARKERS.forfoot_lat_right.data(2,i)) / 2;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = 0;
            case 'RightRearfoot_regular'
                [~, y] = size(MARKERS.calc_back_right.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = (MARKERS.calc_back_right.data(:,i) + MARKERS.calc_med_right.data(:,i) + MARKERS.calc_lat_right.data(:,i)) / 3;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = 0;
            case 'RightFoot_regular'
                [~, y] = size(MARKERS.calc_back_right.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = MARKERS.calc_back_right.data(:,i) + [1;0;0].*OPTIONS.ANTHRO.FootLength;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = OPTIONS.ANTHRO.FootLength./1000;
            case 'RightShank_regular'
                [~, y] = size(MARKERS.mal_med_right.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);
                MidPointAnkle = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    MidPointKnee(:,i) = (MARKERS.epi_med_right.data(:,i) + MARKERS.epi_lat_right.data(:,i)) / 2;
                    MidPointAnkle(:,i) = (MARKERS.mal_med_right.data(:,i) + MARKERS.mal_lat_right.data(:,i)) / 2;
                    O_allframes(:,i) = MidPointKnee(:,i) + ((MidPointAnkle(:,i)-MidPointKnee(:,i))*0.4395); %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y


                    Z(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                    Zo(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;

            case 'RightPelvis_regular'
                % This time R is initially determined; O comes subsequently
                [~, y] = size(MARKERS.SIAS_right.data);

                MPASI = zeros(3,1,y);
                MPPSI = zeros(3,1,y);
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    MPASI(:,i) = (MARKERS.SIAS_left.data(:,i) + MARKERS.SIAS_right.data(:,i))/2;
                    MPPSI(:,i) = (MARKERS.SIPS_left.data(:,i) + MARKERS.SIPS_right.data(:,i))/2;
                    Y(:,i) = MARKERS.SIAS_left.data(:,i) - MARKERS.SIAS_right.data(:,i);
                    Help1(:,i) = MPASI(:,i) - MPPSI(:,i);
                    Z(:,i) = cross(Help1(:,i), Y(:,i));
                    X(:,i) = cross(Y(:,i), Z(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end


                R = Rmean([X,Y,Z]);
                SLength = 0;


                % Bestimmung des mittleren Abstandes zwischen LASI und RASI Marker
                % bzw. zwischen RASI und RPSI Marker
                DIST.ASIS = getdistance(MARKERS.SIAS_left.data, MARKERS.SIAS_right.data);
                DIST.RASI_RPSI = getdistance(MARKERS.SIAS_right.data, MARKERS.SIPS_right.data);
                DIST.LASI_LPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);

                % Ermittlung des Hüftgelenkmittelpunkts im loaklen
                % Hüftkoordinatensystem (Ursprung RASI) nach Seidel (1995) (X und Y
                % Koordinate)  bzw. Bell (1989) (Z - Koordinate)
                POS.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
                POS.hip.pelvis.lokal(2,1) = DIST.ASIS.mean*0.14;
                POS.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;

                % Transformieren in globales Koordinatensystem
                O_allframes = zeros(3,y);
                for u = 1:y
                    O_allframes(:,u) = R*POS.hip.pelvis.lokal + MARKERS.SIAS_right.data(:,u);
                end

                O = mean(O_allframes,2);

            case 'RightThigh_regular'
                [~, y] = size(MARKERS.cluster_femur_right_1.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    MidPointKnee(:,i) = (MARKERS.epi_med_right.data(:,i) + MARKERS.epi_lat_right.data(:,i)) / 2;
                    O_allframes(:,i) = MARKERS.hip_joint_center_right.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_right.data(:,i))*0.4095; %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    Z(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                    Zo(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;



            case 'RightThigh_Orthese'
                [~, y] = size(MARKERS.cluster_femur_right_1.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    KneeVec(:,i) = MARKERS.epi_med_right.data(:,i) - MARKERS.epi_lat_right.data(:,i);
                    lKneeVec(i) = norm(KneeVec(:,i));
                    KneeVecNorm(:,i) = KneeVec(:,i)./lKneeVec(i);
                    multi = linspace(0,lKneeVec(i), lKneeVec(i)*10);
                    for mm = 1:length(multi)
                        KneeVecMult(:,mm) = MARKERS.epi_lat_right.data(:,i) + KneeVecNorm(:,i).*multi(mm);
                        DistPat(mm) = norm(KneeVecMult(:,mm) - MARKERS.pat_right.data(:,i));
                    end
                    [closDist, indClosDist] = min(DistPat);
                    mSize = 13;
                    cols = [0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.8 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4; 0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.8 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4];
                    %                     figure
                    %
                    %
                    %                     for mm = 1:length(multi)
                    %                         plot3(KneeVecMult(1,mm),KneeVecMult(2,mm),KneeVecMult(3,mm),'o', 'Color', [0.7 0.7 0.7]);
                    %                         hold on
                    %                     end
                    %                     plot3(MARKERS.epi_med_right.data(1,i),MARKERS.epi_med_right.data(2,i),MARKERS.epi_med_right.data(3,i),'ko');
                    %                     hold on
                    %                     plot3(MARKERS.epi_lat_right.data(1,i),MARKERS.epi_lat_right.data(2,i),MARKERS.epi_lat_right.data(3,i),'ko');
                    %
                    %                     plot3(MARKERS.pat_right.data(1,i),MARKERS.pat_right.data(2,i),MARKERS.pat_right.data(3,i),'bo');
                    %
                    %                     plot3(KneeVecMult(1,indClosDist),KneeVecMult(2,indClosDist),KneeVecMult(3,indClosDist),'ro');
                    %                     plot3([KneeVecMult(1,indClosDist) MARKERS.pat_right.data(1,i)], [KneeVecMult(2,indClosDist) MARKERS.pat_right.data(2,i)], [KneeVecMult(3,indClosDist) MARKERS.pat_right.data(3,i)], 'r-');
                    %                     axis equal

                    MidPointKnee(:,i) = KneeVecMult(:,indClosDist);

                    clear KneeVecMult closDist indClosDist DistPat  multi
                    O_allframes(:,i) = MARKERS.hip_joint_center_right.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_right.data(:,i))*0.4095; %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    Z(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                    Zo(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;

                %%%%%%%%%%%%%%%%%%%%%%%%%% Left Leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'LeftFoot_regular'
                [~, y] = size(MARKERS.calc_back_left.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = MARKERS.calc_back_left.data(:,i) + ([1;0;0])*0.4415*OPTIONS.ANTHRO.FootLength     +    ([1;0;0])*20 ; %Center of mass from Zatziorsky;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = OPTIONS.ANTHRO.FootLength./1000;

            case 'LeftForefoot_regular'
                [~, y] = size(MARKERS.toe_left.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(1,i) = MARKERS.forefoot_med_left.data(1,i);
                    O_allframes(3,i) = MARKERS.forefoot_med_left.data(3,i);
                    O_allframes(2,i) = (MARKERS.forefoot_med_left.data(2,i) + MARKERS.forefoot_lat_left.data(2,i)) / 2;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = 0;

            case 'LeftRearfoot_regular'
                [~, y] = size(MARKERS.calc_back_left.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = (MARKERS.calc_back_left.data(:,i) + MARKERS.calc_med_left.data(:,i) + MARKERS.calc_lat_left.data(:,i)) / 3;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = 0;

            case 'LeftFoot_regular'
                [~, y] = size(MARKERS.calc_back_right.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = MARKERS.calc_back_left.data(:,i) + [1;0;0].*OPTIONS.ANTHRO.FootLength;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = OPTIONS.ANTHRO.FootLength./1000;

            case 'LeftShank_regular'
                [~, y] = size(MARKERS.mal_med_left.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);
                MidPointAnkle = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    MidPointKnee(:,i) = (MARKERS.epi_med_left.data(:,i) + MARKERS.epi_lat_left.data(:,i)) / 2;
                    MidPointAnkle(:,i) = (MARKERS.mal_med_left.data(:,i) + MARKERS.mal_lat_left.data(:,i)) / 2;
                    O_allframes(:,i) = MidPointKnee(:,i) + ((MidPointAnkle(:,i)-MidPointKnee(:,i))*0.4395); %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y


                    Z(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                    Zo(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;

            case 'LeftPelvis_regular'
                % This time R is initially determined; O comes subsequently
                [~, y] = size(MARKERS.SIAS_left.data);

                MPASI = zeros(3,1,y);
                MPPSI = zeros(3,1,y);
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    MPASI(:,i) = (MARKERS.SIAS_left.data(:,i) + MARKERS.SIAS_right.data(:,i))/2;
                    MPPSI(:,i) = (MARKERS.SIPS_left.data(:,i) + MARKERS.SIPS_right.data(:,i))/2;
                    Y(:,i) = MARKERS.SIAS_left.data(:,i) - MARKERS.SIAS_right.data(:,i);
                    Help1(:,i) = MPASI(:,i) - MPPSI(:,i);
                    Z(:,i) = cross(Help1(:,i), Y(:,i));
                    X(:,i) = cross(Y(:,i), Z(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end


                R = Rmean([X,Y,Z]);
                SLength = 0;


                % Bestimmung des mittleren Abstandes zwischen LASI und RASI Marker
                % bzw. zwischen RASI und RPSI Marker
                DIST.ASIS = getdistance(MARKERS.SIAS_left.data, MARKERS.SIAS_right.data);
                DIST.RASI_RPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);
                DIST.LASI_LPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);

                % Ermittlung des Hüftgelenkmittelpunkts im loaklen
                % Hüftkoordinatensystem (Ursprung RASI) nach Seidel (1995) (X und Y
                % Koordinate)  bzw. Bell (1989) (Z - Koordinate)
                POS.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
                POS.hip.pelvis.lokal(2,1) = -DIST.ASIS.mean*0.14; %Minus weil linke Seite
                POS.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;

                % Transformieren in globales Koordinatensystem
                O_allframes = zeros(3,y);
                for u = 1:y
                    O_allframes(:,u) = R*POS.hip.pelvis.lokal + MARKERS.SIAS_left.data(:,u);
                end

                O = mean(O_allframes,2);

            case 'LeftThigh_regular'
                [~, y] = size(MARKERS.cluster_femur_left_1.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    MidPointKnee(:,i) = (MARKERS.epi_med_left.data(:,i) + MARKERS.epi_lat_left.data(:,i)) / 2;
                    O_allframes(:,i) = MARKERS.hip_joint_center_left.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_left.data(:,i))*0.4095; %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    Z(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                    Zo(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;
            case 'LeftThigh_Orthese'
                [~, y] = size(MARKERS.cluster_femur_left_1.data);
                O_allframes = zeros(3,y);
                MidPointKnee = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    KneeVec(:,i) = MARKERS.epi_med_left.data(:,i) - MARKERS.epi_lat_left.data(:,i);
                    lKneeVec(i) = norm(KneeVec(:,i));
                    KneeVecNorm(:,i) = KneeVec(:,i)./lKneeVec(i);
                    multi = linspace(0,lKneeVec(i), lKneeVec(i)*10);
                    for mm = 1:length(multi)
                        KneeVecMult(:,mm) = MARKERS.epi_lat_left.data(:,i) + KneeVecNorm(:,i).*multi(mm);
                        DistPat(mm) = norm(KneeVecMult(:,mm) - MARKERS.pat_left.data(:,i));
                    end
                    [closDist, indClosDist] = min(DistPat);
                    mSize = 13;
                    cols = [0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.8 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4; 0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.8 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4];
                    %                     figure
                    %
                    %
                    %                     for mm = 1:length(multi)
                    %                         plot3(KneeVecMult(1,mm),KneeVecMult(2,mm),KneeVecMult(3,mm),'o', 'Color', [0.7 0.7 0.7]);
                    %                         hold on
                    %                     end
                    %                     plot3(MARKERS.epi_med_right.data(1,i),MARKERS.epi_med_right.data(2,i),MARKERS.epi_med_right.data(3,i),'ko');
                    %                     hold on
                    %                     plot3(MARKERS.epi_lat_right.data(1,i),MARKERS.epi_lat_right.data(2,i),MARKERS.epi_lat_right.data(3,i),'ko');
                    %
                    %                     plot3(MARKERS.pat_right.data(1,i),MARKERS.pat_right.data(2,i),MARKERS.pat_right.data(3,i),'bo');
                    %
                    %                     plot3(KneeVecMult(1,indClosDist),KneeVecMult(2,indClosDist),KneeVecMult(3,indClosDist),'ro');
                    %                     plot3([KneeVecMult(1,indClosDist) MARKERS.pat_right.data(1,i)], [KneeVecMult(2,indClosDist) MARKERS.pat_right.data(2,i)], [KneeVecMult(3,indClosDist) MARKERS.pat_right.data(3,i)], 'r-');
                    %                     axis equal

                    MidPointKnee(:,i) = KneeVecMult(:,indClosDist);

                    clear KneeVecMult closDist indClosDist DistPat  multi
                    O_allframes(:,i) = MARKERS.hip_joint_center_left.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_left.data(:,i))*0.4095; %Center of mass after deLeva 1996;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    Z(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                    Zo(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;
                %%%%%%%%%%%%%%%%% Head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'Head_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    O_allframes(:,i) = (MARKERS.ear_right.data(:,i) + MARKERS.ear_left.data(:,i)) / 2;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                R = eye(3,3);
                SLength = OPTIONS.ANTHRO.Height*0.1395;

            case 'RightUpperArm_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                ShoulderCenter = zeros(3,y);
                ElbowCenter = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    ShoulderCenter(1,i) = MARKERS.acrom_right.data(1,i);
                    ShoulderCenter(2,i) = MARKERS.acrom_right.data(2,i);
                    ShoulderCenter(3,i) = MARKERS.shoulder_right.data(3,i);
                    ElbowCenter(:,i) = (MARKERS.elbow_lat_right.data(:,i) + MARKERS.elbow_med_right.data(:,i)) / 2;
                    O_allframes(:,i) = ShoulderCenter(:,i) + (ElbowCenter(:,i) - ShoulderCenter(:,i)).*0.5772;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  ShoulderCenter(:,1) - ElbowCenter(:,1);
                for i = 1:y
                    Z(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                    Zo(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;

            case 'RightLowerArm_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                WristCenter = zeros(3,y);
                ElbowCenter = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    WristCenter(:,i) = (MARKERS.hand_lat_right.data(:,i) + MARKERS.hand_med_right.data(:,i)) / 2;
                    ElbowCenter(:,i) = (MARKERS.elbow_lat_right.data(:,i) + MARKERS.elbow_med_right.data(:,i)) / 2;
                    O_allframes(:,i) = ElbowCenter(:,i) + (WristCenter(:,i) - ElbowCenter(:,i)).*0.4574;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  ElbowCenter(:,1) - WristCenter(:,1);
                for i = 1:y
                    Z(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                    Zo(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;


            case 'RightHand_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                WristCenter = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    WristCenter(:,i) = (MARKERS.hand_lat_right.data(:,i) + MARKERS.hand_med_right.data(:,i)) / 2;
                    O_allframes(:,i) = WristCenter(:,i) + (MARKERS.hand_top_right.data(:,i) - WristCenter(:,i)).*0.79;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  WristCenter(:,1) - MARKERS.hand_top_right.data(:,1);
                for i = 1:y
                    Z(:,i) = WristCenter(:,i) - MARKERS.hand_top_right.data(:,i);
                    Zo(:,i) = WristCenter(:,i) - MARKERS.hand_top_right.data(:,i);
                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;


            case 'LeftUpperArm_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                ShoulderCenter = zeros(3,y);
                ElbowCenter = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    ShoulderCenter(1,i) = MARKERS.acrom_left.data(1,i);
                    ShoulderCenter(2,i) = MARKERS.acrom_left.data(2,i);
                    ShoulderCenter(3,i) = MARKERS.shoulder_left.data(3,i);
                    ElbowCenter(:,i) = (MARKERS.elbow_lat_left.data(:,i) + MARKERS.elbow_med_left.data(:,i)) / 2;
                    O_allframes(:,i) = ShoulderCenter(:,i) + (ElbowCenter(:,i) - ShoulderCenter(:,i)).*0.5772;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  ShoulderCenter(:,1) - ElbowCenter(:,1);
                for i = 1:y
                    Z(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                    Zo(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);

                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end

                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);
                SLength = norm(mean(Zo, 2))./1000;

            case 'LeftLowerArm_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                WristCenter = zeros(3,y);
                ElbowCenter = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    WristCenter(:,i) = (MARKERS.hand_lat_left.data(:,i) + MARKERS.hand_med_left.data(:,i)) / 2;
                    ElbowCenter(:,i) = (MARKERS.elbow_lat_left.data(:,i) + MARKERS.elbow_med_left.data(:,i)) / 2;
                    O_allframes(:,i) = ElbowCenter(:,i) + (WristCenter(:,i) - ElbowCenter(:,i)).*0.4574;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  ElbowCenter(:,1) - WristCenter(:,1);
                for i = 1:y
                    Z(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                    Zo(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;


            case 'LeftHand_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                WristCenter = zeros(3,y);

                % Determine origin of anatomical reference frame
                for i = 1:y
                    WristCenter(:,i) = (MARKERS.hand_lat_left.data(:,i) + MARKERS.hand_med_left.data(:,i)) / 2;
                    O_allframes(:,i) = WristCenter(:,i) + (MARKERS.hand_top_left.data(:,i) - WristCenter(:,i)).*0.79;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                Vtest =  WristCenter(:,1) - MARKERS.hand_top_left.data(:,1);
                for i = 1:y
                    Z(:,i) = WristCenter(:,i) - MARKERS.hand_top_left.data(:,i);
                    Zo(:,i) = WristCenter(:,i) - MARKERS.hand_top_left.data(:,i);
                    if Vtest(3,1) > norm(Vtest(:,1))*0.5
                        Help1(:,i) = [0;1;0];
                        X(:,i) = cross(Help1(:,i), Z(:,i));
                        Y(:,i) = cross(Z(:,i), X(:,i));
                    else
                        Help1(:,i) = [1;0;0];
                        Y(:,i) = cross(Z(:,i),Help1(:,i));
                        X(:,i) = cross(Y(:,i), Z(:,i));
                    end
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;


            case 'Trunk_regular'
                [~, y] = size(MARKERS.head_front_left.data);
                O_allframes = zeros(3,y);
                NeckCenter = zeros(3,y);
                HipsCenter = zeros(3,y);
                TopRefPoint = zeros(3,y);
                % Determine origin of anatomical reference frame
                for i = 1:y
                    NeckCenter(:,i) = (MARKERS.C_7.data(:,i) + MARKERS.clav.data(:,i)) / 2;
                    HipsCenter(:,i) = (MARKERS.hip_joint_center_left.data(:,i) + MARKERS.hip_joint_center_right.data(:,i)) / 2;
                    TopRefPoint(1,i) = NeckCenter(1,i);
                    TopRefPoint(2:3,i) = MARKERS.clav.data(2:3,i);
                    O_allframes(:,i) = HipsCenter(:,i) + (TopRefPoint(:,i) - HipsCenter(:,i)).*0.5514;
                end
                O = mean(O_allframes, 2);
                % Determine coordinate system (rotation matrix R) for segment
                Help1 = zeros(3,1,y);
                X = zeros(3,1,y);
                Y = zeros(3,1,y);
                Z = zeros(3,1,y);
                for i = 1:y
                    Z(:,i) = TopRefPoint(:,i) - HipsCenter(:,i);
                    Zo(:,i) = TopRefPoint(:,i) - HipsCenter(:,i);
                    Help1(:,i) = [0;1;0];
                    X(:,i) = cross(Help1(:,i), Z(:,i));
                    Y(:,i) = cross(Z(:,i), X(:,i));
                    X(:,i) = X(:,i) / norm(X(:,i));
                    Y(:,i) = Y(:,i) / norm(Y(:,i));
                    Z(:,i) = Z(:,i) / norm(Z(:,i));
                end

                R = Rmean([X,Y,Z]);

                SLength = norm(mean(Zo, 2))./1000;

        end
    end %getanaframe_GUI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Rout = Rmean(R)
        % Determines the mean of a rotationmatrix over time
        for i = 1:3
            for j = 1:3
                Rout(i,j) = mean(R(i,j,:));
            end
        end
    end %Rmean

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Rout = Vmean(R)
        % Determines mean of a matrix along the second dimension
        for j = 1:3
            Rout(j,1) = mean(R(j,:));
        end
    end %Vmean


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Vel = getderivativesvel(V)
        %         % Determines the derivative of a vetor using quintic spline
        %         % interpolation
        %
        %         for i = 1:length(V)-5
        %             POL(:,i) = polyfit([1:6],V(1,i:i+5), 5);
        %             KO(:,i+2) = POL(:,i);
        %         end
        %         KO(:,1) = KO(:,3);
        %         KO(:,2) = KO(:,3);
        %         KO(:,length(V)-3:length(V)) = V(length(V)-4);
        %
        %
        %         for t = 1:length(KO)
        %             KO_V(1,t) = KO(1,t)*5;
        %             KO_V(2,t) = KO(2,t)*4;
        %             KO_V(3,t) = KO(3,t)*3;
        %             KO_V(4,t) = KO(4,t)*2;
        %             KO_V(5,t) = KO(5,t)*1;
        %         end
        %
        %
        %
        %         for j = 1:length(KO)
        %             Vel(1,j) = polyval(KO_V(1:5,j),3);
        %
        %         end
        Vel = gradient(V);
    end % getderivativesvel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Matrix = getderivateCOMVEL3point(M)
        % Determines the first derivative of along the second or third
        % dimension of a matrix.
        if ndims(M) == 3
            for i = 2:size(M,3)-1
                for j = 1:size(M,1)
                    for k = 1:size(M,2)
                        Matrix2(j,k,i) = ((M(j,k,i+1) - M(j,k,i-1)) / 2);
                    end
                end
            end
            for i = 1:length(Matrix2)
                Matrix(:,i) = Matrix2(:,1,i);
            end
            Matrix(:,size(M,3)) = 0;
        end

        if ndims(M) == 2
            for j = 1:size(M,1)
                for k = 2:size(M,2)-1
                    Matrix(j,k) = (M(j,k+1) - M(j,k-1)) / 2;
                end
            end
            Matrix(:,size(M,2)) = Matrix(:,end-1);
            Matrix(:,1) = Matrix(:,2);
        end
    end % getderivateCOMVEL3point

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Matrix = getderivateCOMACC3point(M)
        % Determines the first derivative of along the second or third
        % dimension of a matrix.
        if ndims(M) == 3
            for i = 3:size(M,3)-2
                for j = 1:size(M,1)
                    for k = 1:size(M,2)
                        Matrix2(j,k,i) = ((M(j,k,i+1) - M(j,k,i-1)) / 2);
                    end
                end
            end
            for i = 1:length(Matrix2)
                Matrix(:,i) = Matrix2(:,1,i);
            end
            Matrix(:,size(M,3)-1:size(M,3)) = 0;
        end

        if ndims(M) == 2
            for j = 1:size(M,1)
                for k = 3:size(M,2)-2
                    Matrix(j,k) = (M(j,k+1) - M(j,k-1)) / 2;
                end
            end
            Matrix(:,size(M,2)-1:size(M,2)) = 0;
        end
    end % getderivateCOMACC3point

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function DIST = getdistance(V1, V2)
        % Determines the distance between 2 points in 3D space

        for t = 1:length(V1)
            DIST.vector(:,t) = V1(:,t) - V2(:,t);
            DIST.scalar(1,t) = v3dlaenge(DIST.vector(:,t));
        end
        DIST.mean = mean(DIST.scalar);
        DIST.std = std(DIST.scalar);
    end % getdistance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function y = v3dlaenge(V)

        % Determines the norm of a vector
        if size(V,1) == 3
            y = sqrt(V(1,1)^2 + V(2,1)^2 + V(3,1)^2);
        end

        if size(V,1) == 2
            y = sqrt(V(1,1)^2 + V(2,1)^2)
        end
    end %v3dlaenge

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function R = getR(R1, R2)
        %Determines the rotation matrix between to coordinate systems
        [x, y, z] = size(R1);
        for i = 1:z
            R(:,:,i) = R1(:,:,i)'*R2(:,:,i);
        end
    end %getR

    function OUT = loadevents(File)

        M = c3dserver;
        openc3d(M,0,File);
        start = M.GetVideoFrame(0);
        ende = M.GetVideoFrame(1);
        fRate = M.GetVideoFrameRate;
        IND_ADDED_MARKER = M.AddMarker;
        index2 = M.GetParameterIndex('EVENT', 'LABELS');
        index3 = M.GetParameterIndex('EVENT', 'CONTEXTS');
        index4 = M.GetParameterIndex('EVENT', 'TIMES');
        nLength = M.GetParameterLength(index2);
        nLength2 = M.GetParameterLength(index4);
        for i = 1:nLength
            OUT.Labels{i} = M.GetParameterValue(index2, i-1);
            OUT.Contexts{i} = M.GetParameterValue(index3, i-1);
        end
        run = 1;
        for i = 2:2:nLength2
            OUT.Frame(run) = M.GetParameterValue(index4, i-1);
            OUT.Frame(run) = (round(OUT.Frame(run).*fRate)+1) - start + 1;;
            run = run+1;
        end

        closec3d(M);
    end %loadevents

    function [KINETICS, LL] = InverseDynamik_Hof(FRAME, OPTIONS, FP, MARKERS)


        %% Vorgehensweise wie in Hof 1992 beschrieben
        %1. Gechwindigkeiten, Beschleunigungen und Rotationsmatrizen auf mit
        %reaktionskräften auf eine Länge bringen --> interpolieren
        for j = 1:3
            for k = 1:3

                try
                    FRAME.RightFoot.Theta_long(j,k,:) = fit(FRAME.RightFoot.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightRearfoot.Theta_long(j,k,:) = fit(FRAME.RightRearfoot.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightShank.Theta_long(j,k,:) = fit(FRAME.RightShank.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightThigh.Theta_long(j,k,:) = fit(FRAME.RightThigh.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.Trunk.Theta_long(j,k,:) = fit(FRAME.Trunk.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.Head.Theta_long(j,k,:) = fit(FRAME.Head.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightUpperArm.Theta_long(j,k,:) = fit(FRAME.RightUpperArm.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightLowerArm.Theta_long(j,k,:) = fit(FRAME.RightLowerArm.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightHand.Theta_long(j,k,:) = fit(FRAME.RightHand.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftUpperArm.Theta_long(j,k,:) = fit(FRAME.LeftUpperArm.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftLowerArm.Theta_long(j,k,:) = fit(FRAME.LeftLowerArm.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftHand.Theta_long(j,k,:) = fit(FRAME.LeftHand.Theta(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftFoot.Theta_long(j,k,:) = fit(FRAME.LeftFoot.Theta(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftShank.Theta_long(j,k,:) = fit(FRAME.LeftShank.Theta(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftThigh.Theta_long(j,k,:) = fit(FRAME.LeftThigh.Theta(j,k,:), FP.COP.Left(j,:));
                end

                %
                try
                    FRAME.RightFoot.R_long(j,k,:) = fit(FRAME.RightFoot.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightRearfoot.R_long(j,k,:) = fit(FRAME.RightRearfoot.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightShank.R_long(j,k,:) = fit(FRAME.RightShank.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightThigh.R_long(j,k,:) = fit(FRAME.RightThigh.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightPelvis.R_long(j,k,:) = fit(FRAME.RightPelvis.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.Trunk.R_long(j,k,:) = fit(FRAME.Trunk.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.Head.R_long(j,k,:) = fit(FRAME.Head.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightUpperArm.R_long(j,k,:) = fit(FRAME.RightUpperArm.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightLowerArm.R_long(j,k,:) = fit(FRAME.RightLowerArm.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.RightHand.R_long(j,k,:) = fit(FRAME.RightHand.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftUpperArm.R_long(j,k,:) = fit(FRAME.LeftUpperArm.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftLowerArm.R_long(j,k,:) = fit(FRAME.LeftLowerArm.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftHand.R_long(j,k,:) = fit(FRAME.LeftHand.R(j,k,:), FP.COP.Right(j,:));
                end
                try
                    FRAME.LeftFoot.R_long(j,k,:) = fit(FRAME.LeftFoot.R(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftRearfoot.R_long(j,k,:) = fit(FRAME.LeftRearfoot.R(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftShank.R_long(j,k,:) = fit(FRAME.LeftShank.R(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftThigh.R_long(j,k,:) = fit(FRAME.LeftThigh.R(j,k,:), FP.COP.Left(j,:));
                end
                try
                    FRAME.LeftPelvis.R_long(j,k,:) = fit(FRAME.LeftPelvis.R(j,k,:), FP.COP.Left(j,:));
                end
            end

            %
            try
                FRAME.RightFoot.O_long(j,:) = fit(FRAME.RightFoot.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightRearfoot.O_long(j,:) = fit(FRAME.RightRearfoot.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightForefoot.O_long(j,:) = fit(FRAME.RightForefoot.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightShank.O_long(j,:) = fit(FRAME.RightShank.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightThigh.O_long(j,:) = fit(FRAME.RightThigh.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Trunk.O_long(j,:) = fit(FRAME.Trunk.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Head.O_long(j,:) = fit(FRAME.Head.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightUpperArm.O_long(j,:) = fit(FRAME.RightUpperArm.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightLowerArm.O_long(j,:) = fit(FRAME.RightLowerArm.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightHand.O_long(j,:) = fit(FRAME.RightHand.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftUpperArm.O_long(j,:) = fit(FRAME.LeftUpperArm.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftLowerArm.O_long(j,:) = fit(FRAME.LeftLowerArm.O(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftHand.O_long(j,:) = fit(FRAME.LeftHand.O(j,:), FP.COP.Right(j,:));
            end

            try
                FRAME.LeftFoot.O_long(j,:) = fit(FRAME.LeftFoot.O(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftShank.O_long(j,:) = fit(FRAME.LeftShank.O(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftThigh.O_long(j,:) = fit(FRAME.LeftThigh.O(j,:), FP.COP.Left(j,:));
            end

            %
            try
                FRAME.RightFoot.V_long(j,:) = fit(FRAME.RightFoot.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightShank.V_long(j,:) = fit(FRAME.RightShank.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightThigh.V_long(j,:) = fit(FRAME.RightThigh.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Trunk.V_long(j,:) = fit(FRAME.Trunk.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Head.V_long(j,:) = fit(FRAME.Head.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightUpperArm.V_long(j,:) = fit(FRAME.RightUpperArm.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightLowerArm.V_long(j,:) = fit(FRAME.RightLowerArm.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightHand.V_long(j,:) = fit(FRAME.RightHand.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftUpperArm.V_long(j,:) = fit(FRAME.LeftUpperArm.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftLowerArm.V_long(j,:) = fit(FRAME.LeftLowerArm.V(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftHand.V_long(j,:) = fit(FRAME.LeftHand.V(j,:), FP.COP.Right(j,:));
            end

            try
                FRAME.LeftFoot.V_long(j,:) = fit(FRAME.LeftFoot.V(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftShank.V_long(j,:) = fit(FRAME.LeftShank.V(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftThigh.V_long(j,:) = fit(FRAME.LeftThigh.V(j,:), FP.COP.Left(j,:));
            end

            %
            try
                FRAME.RightFoot.ACC_long(j,:) = fit(FRAME.RightFoot.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightShank.ACC_long(j,:) = fit(FRAME.RightShank.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightThigh.ACC_long(j,:) = fit(FRAME.RightThigh.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Trunk.ACC_long(j,:) = fit(FRAME.Trunk.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Head.ACC_long(j,:) = fit(FRAME.Head.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightUpperArm.ACC_long(j,:) = fit(FRAME.RightUpperArm.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightLowerArm.ACC_long(j,:) = fit(FRAME.RightLowerArm.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightHand.ACC_long(j,:) = fit(FRAME.RightHand.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftUpperArm.ACC_long(j,:) = fit(FRAME.LeftUpperArm.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftLowerArm.ACC_long(j,:) = fit(FRAME.LeftLowerArm.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftHand.ACC_long(j,:) = fit(FRAME.LeftHand.ACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftFoot.ACC_long(j,:) = fit(FRAME.LeftFoot.ACC(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftShank.ACC_long(j,:) = fit(FRAME.LeftShank.ACC(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftThigh.ACC_long(j,:) = fit(FRAME.LeftThigh.ACC(j,:), FP.COP.Left(j,:));
            end

            %
            try
                FRAME.RightFoot.LinACC_long(j,:) = fit(FRAME.RightFoot.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightShank.LinACC_long(j,:) = fit(FRAME.RightShank.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightThigh.LinACC_long(j,:) = fit(FRAME.RightThigh.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Trunk.LinACC_long(j,:) = fit(FRAME.Trunk.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.Head.LinACC_long(j,:) = fit(FRAME.Head.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightUpperArm.LinACC_long(j,:) = fit(FRAME.RightUpperArm.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightLowerArm.LinACC_long(j,:) = fit(FRAME.RightLowerArm.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.RightHand.LinACC_long(j,:) = fit(FRAME.RightHand.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftUpperArm.LinACC_long(j,:) = fit(FRAME.LeftUpperArm.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftLowerArm.LinACC_long(j,:) = fit(FRAME.LeftLowerArm.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftHand.LinACC_long(j,:) = fit(FRAME.LeftHand.LinACC(j,:), FP.COP.Right(j,:));
            end
            try
                FRAME.LeftFoot.LinACC_long(j,:) = fit(FRAME.LeftFoot.LinACC(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftShank.LinACC_long(j,:) = fit(FRAME.LeftShank.LinACC(j,:), FP.COP.Left(j,:));
            end
            try
                FRAME.LeftThigh.LinACC_long(j,:) = fit(FRAME.LeftThigh.LinACC(j,:), FP.COP.Left(j,:));
            end

            try
                MARKERS.Derived.RightAnkleJC_long(j,:) = fit(MARKERS.Derived.RightAnkleJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.RightMPJC_long(j,:) = fit(MARKERS.Derived.RightMPJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftMPJC_long(j,:) = fit(MARKERS.Derived.LeftMPJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftAnkleJC_long(j,:) = fit(MARKERS.Derived.LeftAnkleJC(j,:), FP.COP.Left(j,:));
            end
            try
                MARKERS.Derived.RightKneeJC_long(j,:) = fit(MARKERS.Derived.RightKneeJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftKneeJC_long(j,:) = fit(MARKERS.Derived.LeftKneeJC(j,:), FP.COP.Left(j,:));
            end
            try
                MARKERS.Derived.RightHipJC_long(j,:) = fit(MARKERS.Derived.RightHipJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftHipJC_long(j,:) = fit(MARKERS.Derived.LeftHipJC(j,:), FP.COP.Left(j,:));
            end
            try
                MARKERS.Derived.RightShoulderJC_long(j,:) = fit(MARKERS.Derived.RightShoulderJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.RightElbowJC_long(j,:) = fit(MARKERS.Derived.RightElbowJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.RightWristJC_long(j,:) = fit(MARKERS.Derived.RightWristJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftShoulderJC_long(j,:) = fit(MARKERS.Derived.LeftShoulderJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftElbowJC_long(j,:) = fit(MARKERS.Derived.LeftElbowJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.LeftWristJC_long(j,:) = fit(MARKERS.Derived.LeftWristJC(j,:), FP.COP.Right(j,:));
            end
            try
                MARKERS.Derived.NeckJC_long(j,:) = fit(MARKERS.Derived.NeckJC(j,:), FP.COP.Right(j,:));
            end
        end






        %2. Lösen der Bewegungsgleichungen für das rechte Sprunggelenk
        try
            Wheight.Foot = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Foot, 1, length(FP.COP.Right));
            MA.RightFoot = repmat(OPTIONS.ANTHRO.SegmentMass.Foot,3,length(FP.COP.Right)) .* FRAME.RightFoot.LinACC_long;

            KINETICS.RightAnkle.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightAnkleJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
            KINETICS.RightAnkle.Term2 = cross((FRAME.RightFoot.O_long  - MARKERS.Derived.RightAnkleJC_long), Wheight.Foot)./1000; %wg Nmm zu Nm
            KINETICS.RightAnkle.Term3 = cross((FRAME.RightFoot.O_long - MARKERS.Derived.RightAnkleJC_long), MA.RightFoot)./1000; %wg Nmm zu Nm

            I.Foot = repmat([OPTIONS.ANTHRO.MoI.Foot.X;OPTIONS.ANTHRO.MoI.Foot.Y;OPTIONS.ANTHRO.MoI.Foot.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightFoot.R_long,3)
                LL.RightFoot(:,:,kk)=FRAME.RightFoot.R_long(:,:,kk)*I.Foot*FRAME.RightFoot.R_long(:,:,kk)';
                KINETICS.RightAnkle.Term4(:,kk)=(LL.RightFoot(:,:,kk)*FRAME.RightFoot.ACC_long(:,kk))+(FRAME.RightFoot.Theta_long(:,:,kk)*LL.RightFoot(:,:,kk)*FRAME.RightFoot.V_long(:,kk));
            end


            KINETICS.RightAnkle.Moment = -FP.FM.Right - KINETICS.RightAnkle.Term1 - KINETICS.RightAnkle.Term2 + KINETICS.RightAnkle.Term3 + KINETICS.RightAnkle.Term4;
            for f = 1:length(KINETICS.RightAnkle.Moment)
                KINETICS.RightAnkleMomentInProximal(:,f) = FRAME.RightShank.R_long(:,:,f)' * KINETICS.RightAnkle.Moment(:,f);
            end
        end

        %2b. Lösen der Bewgungsgleichungen für das rechte MTP Gelenk
        try


            KINETICS.RightMPJ.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightMPJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm



            KINETICS.RightMPJ.Moment = -FP.FM.Right - KINETICS.RightMPJ.Term1;
            for f = 1:length(KINETICS.RightMPJ.Moment)
                KINETICS.RightMPJMomentInProximal(:,f) = FRAME.RightRearfoot.R_long(:,:,f)' * KINETICS.RightMPJ.Moment(:,f);
            end
            %     [~,indrmpjmmax] = max(KINETICS.RightMPJMomentInProximal(2,:));
            %     for g = indrmpjmmax:-1:1
            %        if  KINETICS.RightMPJMomentInProximal(2,g) < 0
            %            KINETICS.RightMPJMomentInProximal(:,1:g) = 0;
            %            break
            %        end
            %     end
            isnegMPJR = find(KINETICS.RightMPJMomentInProximal(2,:) <= 0);
            KINETICS.RightMPJMomentInProximal(:,isnegMPJR) = 0;
            KINETICS.RightMPJMomentInProximal(1,:) = 0;
            KINETICS.RightMPJMomentInProximal(3,:) = 0;

        end

        %3. Lösen der Bewgungsgleichungen für das linke Sprunggelenk
        try
            Wheight.Foot = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Foot, 1, length(FP.COP.Right));
            MA.LeftFoot = repmat(OPTIONS.ANTHRO.SegmentMass.Foot,3,length(FP.COP.Left)) .* FRAME.LeftFoot.LinACC_long;

            KINETICS.LeftAnkle.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftAnkleJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
            KINETICS.LeftAnkle.Term2 = cross((FRAME.LeftFoot.O_long  - MARKERS.Derived.LeftAnkleJC_long), Wheight.Foot)./1000; %wg Nmm zu Nm
            KINETICS.LeftAnkle.Term3 = cross((FRAME.LeftFoot.O_long - MARKERS.Derived.LeftAnkleJC_long), MA.LeftFoot)./1000; %wg Nmm zu Nm

            I.Foot = repmat([OPTIONS.ANTHRO.MoI.Foot.X;OPTIONS.ANTHRO.MoI.Foot.Y;OPTIONS.ANTHRO.MoI.Foot.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftFoot.R_long,3)
                LL.LeftFoot(:,:,kk)=FRAME.LeftFoot.R_long(:,:,kk)*I.Foot*FRAME.LeftFoot.R_long(:,:,kk)';
                KINETICS.LeftAnkle.Term4(:,kk)=(LL.LeftFoot(:,:,kk)*FRAME.LeftFoot.ACC_long(:,kk))+(FRAME.LeftFoot.Theta_long(:,:,kk)*LL.LeftFoot(:,:,kk)*FRAME.LeftFoot.V_long(:,kk));
            end


            KINETICS.LeftAnkle.Moment = -FP.FM.Left - KINETICS.LeftAnkle.Term1 - KINETICS.LeftAnkle.Term2 + KINETICS.LeftAnkle.Term3 + KINETICS.LeftAnkle.Term4;
            for f = 1:length(KINETICS.LeftAnkle.Moment)
                KINETICS.LeftAnkleMomentInProximal(:,f) = FRAME.LeftShank.R_long(:,:,f)' * KINETICS.LeftAnkle.Moment(:,f);
            end
            KINETICS.LeftAnkleMomentInProximal(1,:) = -KINETICS.LeftAnkleMomentInProximal(1,:);
            KINETICS.LeftAnkleMomentInProximal(3,:) = -KINETICS.LeftAnkleMomentInProximal(3,:);
        end
        %3b. Lösen der Bewgungsgleichungen für das linke MTP Gelenk
        try


            KINETICS.LeftMPJ.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftMPJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm



            KINETICS.LeftMPJ.Moment = -FP.FM.Left - KINETICS.LeftMPJ.Term1;
            for f = 1:length(KINETICS.LeftMPJ.Moment)
                KINETICS.LeftMPJMomentInProximal(:,f) = FRAME.LeftRearfoot.R_long(:,:,f)' * KINETICS.LeftMPJ.Moment(:,f);
            end
            KINETICS.LeftMPJMomentInProximal(1,:) = -KINETICS.LeftMPJMomentInProximal(1,:);
            KINETICS.LeftMPJMomentInProximal(3,:) = -KINETICS.LeftMPJMomentInProximal(3,:);

            isnegMPJL = find(KINETICS.LeftMPJMomentInProximal(2,:) <= 0);
            KINETICS.LeftMPJMomentInProximal(:,isnegMPJL) = 0;
            KINETICS.LeftMPJMomentInProximal(1,:) = 0;
            KINETICS.LeftMPJMomentInProximal(3,:) = 0;
        end
        %4. Lösen der Bewgungsgleichungen für das rechte Kniegelenk
        try
            Wheight.Shank = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Shank, 1, length(FP.COP.Right));
            MA.RightShank = repmat(OPTIONS.ANTHRO.SegmentMass.Shank,3,length(FP.COP.Right)) .* FRAME.RightShank.LinACC_long;

            KINETICS.RightKnee.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightKneeJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
            KINETICS.RightKnee.Term2 = cross((FRAME.RightShank.O_long  - MARKERS.Derived.RightKneeJC_long), Wheight.Shank)./1000; %wg Nmm zu Nm
            KINETICS.RightKnee.Term3 = cross((FRAME.RightShank.O_long - MARKERS.Derived.RightKneeJC_long), MA.RightShank)./1000; %wg Nmm zu Nm

            I.Shank = repmat([OPTIONS.ANTHRO.MoI.Shank.X;OPTIONS.ANTHRO.MoI.Shank.Y;OPTIONS.ANTHRO.MoI.Shank.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightShank.R_long,3)
                LL.RightShank(:,:,kk)=FRAME.RightShank.R_long(:,:,kk)*I.Shank*FRAME.RightShank.R_long(:,:,kk)';
                KINETICS.RightKnee.Term4(:,kk)=(LL.RightShank(:,:,kk)*FRAME.RightShank.ACC_long(:,kk))+(FRAME.RightShank.Theta_long(:,:,kk)*LL.RightShank(:,:,kk)*FRAME.RightShank.V_long(:,kk));
            end


            KINETICS.RightKnee.Moment = -FP.FM.Right - KINETICS.RightKnee.Term1 - (KINETICS.RightKnee.Term2 + KINETICS.RightAnkle.Term2) + (KINETICS.RightKnee.Term3 + KINETICS.RightAnkle.Term3) + (KINETICS.RightKnee.Term4 + KINETICS.RightAnkle.Term4);
            for f = 1:length(KINETICS.RightKnee.Moment)
                KINETICS.RightKneeMomentInProximal(:,f) = FRAME.RightThigh.R_long(:,:,f)' * KINETICS.RightKnee.Moment(:,f);
            end

        end


        %5. Lösen der Bewgungsgleichungen für das linke Kniegelenk
        try
            Wheight.Shank = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Shank, 1, length(FP.COP.Right));
            MA.LeftShank = repmat(OPTIONS.ANTHRO.SegmentMass.Shank,3,length(FP.COP.Left)) .* FRAME.LeftShank.LinACC_long;

            KINETICS.LeftKnee.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftKneeJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
            KINETICS.LeftKnee.Term2 = cross((FRAME.LeftShank.O_long  - MARKERS.Derived.LeftKneeJC_long), Wheight.Shank)./1000; %wg Nmm zu Nm
            KINETICS.LeftKnee.Term3 = cross((FRAME.LeftShank.O_long - MARKERS.Derived.LeftKneeJC_long), MA.LeftShank)./1000; %wg Nmm zu Nm

            I.Shank = repmat([OPTIONS.ANTHRO.MoI.Shank.X;OPTIONS.ANTHRO.MoI.Shank.Y;OPTIONS.ANTHRO.MoI.Shank.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftShank.R_long,3)
                LL.LeftShank(:,:,kk)=FRAME.LeftShank.R_long(:,:,kk)*I.Shank*FRAME.LeftShank.R_long(:,:,kk)';
                KINETICS.LeftKnee.Term4(:,kk)=(LL.LeftShank(:,:,kk)*FRAME.LeftShank.ACC_long(:,kk))+(FRAME.LeftShank.Theta_long(:,:,kk)*LL.LeftShank(:,:,kk)*FRAME.LeftShank.V_long(:,kk));
            end


            KINETICS.LeftKnee.Moment = -FP.FM.Left - KINETICS.LeftKnee.Term1 - (KINETICS.LeftKnee.Term2 + KINETICS.LeftAnkle.Term2) + (KINETICS.LeftKnee.Term3 + KINETICS.LeftAnkle.Term3) + (KINETICS.LeftKnee.Term4 + KINETICS.LeftAnkle.Term4);
            for f = 1:length(KINETICS.LeftKnee.Moment)
                KINETICS.LeftKneeMomentInProximal(:,f) = FRAME.LeftThigh.R_long(:,:,f)' * KINETICS.LeftKnee.Moment(:,f);
            end
            KINETICS.LeftKneeMomentInProximal(1,:) = -KINETICS.LeftKneeMomentInProximal(1,:);
            KINETICS.LeftKneeMomentInProximal(3,:) = -KINETICS.LeftKneeMomentInProximal(3,:);
        end
        %6. Lösen der Bewgungsgleichungen für das rechte Hüftgelenk
        try
            Wheight.Thigh = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Thigh, 1, length(FP.COP.Right));
            MA.RightThigh = repmat(OPTIONS.ANTHRO.SegmentMass.Thigh,3,length(FP.COP.Right)) .* FRAME.RightThigh.LinACC_long;

            KINETICS.RightHip.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightHipJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
            KINETICS.RightHip.Term2 = cross((FRAME.RightThigh.O_long  - MARKERS.Derived.RightHipJC_long), Wheight.Thigh)./1000; %wg Nmm zu Nm
            KINETICS.RightHip.Term3 = cross((FRAME.RightThigh.O_long - MARKERS.Derived.RightHipJC_long), MA.RightThigh)./1000; %wg Nmm zu Nm

            I.Thigh = repmat([OPTIONS.ANTHRO.MoI.Thigh.X;OPTIONS.ANTHRO.MoI.Thigh.Y;OPTIONS.ANTHRO.MoI.Thigh.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightThigh.R_long,3)
                LL.RightThigh(:,:,kk)=FRAME.RightThigh.R_long(:,:,kk)*I.Thigh*FRAME.RightThigh.R_long(:,:,kk)';
                KINETICS.RightHip.Term4(:,kk)=(LL.RightThigh(:,:,kk)*FRAME.RightThigh.ACC_long(:,kk))+(FRAME.RightThigh.Theta_long(:,:,kk)*LL.RightThigh(:,:,kk)*FRAME.RightThigh.V_long(:,kk));
            end


            KINETICS.RightHip.Moment = -FP.FM.Right - KINETICS.RightHip.Term1 - (KINETICS.RightHip.Term2 + KINETICS.RightKnee.Term2 + KINETICS.RightAnkle.Term2) + (KINETICS.RightHip.Term3 + KINETICS.RightKnee.Term3 + KINETICS.RightAnkle.Term3) + (KINETICS.RightHip.Term4 + KINETICS.RightKnee.Term4 + KINETICS.RightAnkle.Term4);
            for f = 1:length(KINETICS.RightHip.Moment)
                KINETICS.RightHipMomentInProximal(:,f) = FRAME.RightPelvis.R_long(:,:,f)' * KINETICS.RightHip.Moment(:,f);
            end
        end
        %7. Lösen der Bewgungsgleichungen für das linke Hüftgelenk
        try
            Wheight.Thigh = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Thigh, 1, length(FP.COP.Right));
            MA.LeftThigh = repmat(OPTIONS.ANTHRO.SegmentMass.Thigh,3,length(FP.COP.Left)) .* FRAME.LeftThigh.LinACC_long;

            KINETICS.LeftHip.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftHipJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
            KINETICS.LeftHip.Term2 = cross((FRAME.LeftThigh.O_long  - MARKERS.Derived.LeftHipJC_long), Wheight.Thigh)./1000; %wg Nmm zu Nm
            KINETICS.LeftHip.Term3 = cross((FRAME.LeftThigh.O_long - MARKERS.Derived.LeftHipJC_long), MA.LeftThigh)./1000; %wg Nmm zu Nm

            I.Thigh = repmat([OPTIONS.ANTHRO.MoI.Thigh.X;OPTIONS.ANTHRO.MoI.Thigh.Y;OPTIONS.ANTHRO.MoI.Thigh.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftThigh.R_long,3)
                LL.LeftThigh(:,:,kk)=FRAME.LeftThigh.R_long(:,:,kk)*I.Thigh*FRAME.LeftThigh.R_long(:,:,kk)';
                KINETICS.LeftHip.Term4(:,kk)=(LL.LeftThigh(:,:,kk)*FRAME.LeftThigh.ACC_long(:,kk))+(FRAME.LeftThigh.Theta_long(:,:,kk)*LL.LeftThigh(:,:,kk)*FRAME.LeftThigh.V_long(:,kk));
            end


            KINETICS.LeftHip.Moment = -FP.FM.Left - KINETICS.LeftHip.Term1 - (KINETICS.LeftHip.Term2 + KINETICS.LeftKnee.Term2 + KINETICS.LeftAnkle.Term2) + (KINETICS.LeftHip.Term3 + KINETICS.LeftKnee.Term3 + KINETICS.LeftAnkle.Term3) + (KINETICS.LeftHip.Term4 + KINETICS.LeftKnee.Term4 + KINETICS.LeftAnkle.Term4);
            for f = 1:length(KINETICS.LeftHip.Moment)
                KINETICS.LeftHipMomentInProximal(:,f) = FRAME.LeftPelvis.R_long(:,:,f)' * KINETICS.LeftHip.Moment(:,f);
            end
            KINETICS.LeftHipMomentInProximal(1,:) = -KINETICS.LeftHipMomentInProximal(1,:);
            KINETICS.LeftHipMomentInProximal(3,:) = -KINETICS.LeftHipMomentInProximal(3,:);
        end

        %8. Lösen der Bewgungsgleichungen für das rechte Handgelenk
        try
            Wheight.Hand = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Hand, 1, length(FP.COP.Right));
            MA.RightHand = repmat(OPTIONS.ANTHRO.SegmentMass.Hand,3,length(FP.COP.Right)) .* FRAME.RightHand.LinACC_long;

            KINETICS.RightWrist.Term1 = zeros(3,length(FRAME.RightHand.O_long));
            KINETICS.RightWrist.Term2 = cross((FRAME.RightHand.O_long  - MARKERS.Derived.RightWristJC_long), Wheight.Hand)./1000; %wg Nmm zu Nm
            KINETICS.RightWrist.Term3 = cross((FRAME.RightHand.O_long - MARKERS.Derived.RightWristJC_long), MA.RightHand)./1000; %wg Nmm zu Nm

            I.Hand = repmat([OPTIONS.ANTHRO.MoI.Hand.X;OPTIONS.ANTHRO.MoI.Hand.Y;OPTIONS.ANTHRO.MoI.Hand.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightHand.R_long,3)
                LL.RightHand(:,:,kk)=FRAME.RightHand.R_long(:,:,kk)*I.Hand*FRAME.RightHand.R_long(:,:,kk)';
                KINETICS.RightWrist.Term4(:,kk)=(LL.RightHand(:,:,kk)*FRAME.RightHand.ACC_long(:,kk))+(FRAME.RightHand.Theta_long(:,:,kk)*LL.RightHand(:,:,kk)*FRAME.RightHand.V_long(:,kk));
            end


            KINETICS.RightWrist.Moment = KINETICS.RightWrist.Term1 - (KINETICS.RightWrist.Term2) + (KINETICS.RightWrist.Term3) + (KINETICS.RightWrist.Term4);
            for f = 1:length(KINETICS.RightWrist.Moment)
                KINETICS.RightWristMomentInProximal(:,f) = FRAME.RightLowerArm.R_long(:,:,f)' * KINETICS.RightWrist.Moment(:,f);
            end
        end

        %9. Lösen der Bewgungsgleichungen für das rechte Ellbogengelenk
        try
            Wheight.LowerArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.LowerArm, 1, length(FP.COP.Right));
            MA.RightLowerArm = repmat(OPTIONS.ANTHRO.SegmentMass.LowerArm,3,length(FP.COP.Right)) .* FRAME.RightLowerArm.LinACC_long;

            KINETICS.RightElbow.Term1 = zeros(3,length(FRAME.RightLowerArm.O_long));
            KINETICS.RightElbow.Term2 = cross((FRAME.RightLowerArm.O_long  - MARKERS.Derived.RightElbowJC_long), Wheight.LowerArm)./1000; %wg Nmm zu Nm
            KINETICS.RightElbow.Term3 = cross((FRAME.RightLowerArm.O_long - MARKERS.Derived.RightElbowJC_long), MA.RightLowerArm)./1000; %wg Nmm zu Nm

            I.LowerArm = repmat([OPTIONS.ANTHRO.MoI.LowerArm.X;OPTIONS.ANTHRO.MoI.LowerArm.Y;OPTIONS.ANTHRO.MoI.LowerArm.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightLowerArm.R_long,3)
                LL.RightLowerArm(:,:,kk)=FRAME.RightLowerArm.R_long(:,:,kk)*I.LowerArm*FRAME.RightLowerArm.R_long(:,:,kk)';
                KINETICS.RightElbow.Term4(:,kk)=(LL.RightLowerArm(:,:,kk)*FRAME.RightLowerArm.ACC_long(:,kk))+(FRAME.RightLowerArm.Theta_long(:,:,kk)*LL.RightLowerArm(:,:,kk)*FRAME.RightLowerArm.V_long(:,kk));
            end


            KINETICS.RightElbow.Moment = KINETICS.RightWrist.Term1 - (KINETICS.RightWrist.Term2 + KINETICS.RightElbow.Term2) + (KINETICS.RightWrist.Term3 + KINETICS.RightElbow.Term3) + (KINETICS.RightWrist.Term4 + KINETICS.RightElbow.Term4);
            for f = 1:length(KINETICS.RightElbow.Moment)
                KINETICS.RightElbowMomentInProximal(:,f) = FRAME.RightUpperArm.R_long(:,:,f)' * KINETICS.RightElbow.Moment(:,f);
            end
        end


        %10. Lösen der Bewgungsgleichungen für das rechte Schultergelenk
        try
            Wheight.UpperArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.UpperArm, 1, length(FP.COP.Right));
            MA.RightUpperArm = repmat(OPTIONS.ANTHRO.SegmentMass.UpperArm,3,length(FP.COP.Right)) .* FRAME.RightUpperArm.LinACC_long;

            KINETICS.RightShoulder.Term1 = zeros(3,length(FRAME.RightThigh.O_long));
            KINETICS.RightShoulder.Term2 = cross((FRAME.RightUpperArm.O_long  - MARKERS.Derived.RightShoulderJC_long), Wheight.UpperArm)./1000; %wg Nmm zu Nm
            KINETICS.RightShoulder.Term3 = cross((FRAME.RightUpperArm.O_long - MARKERS.Derived.RightShoulderJC_long), MA.RightUpperArm)./1000; %wg Nmm zu Nm

            I.UpperArm = repmat([OPTIONS.ANTHRO.MoI.UpperArm.X;OPTIONS.ANTHRO.MoI.UpperArm.Y;OPTIONS.ANTHRO.MoI.UpperArm.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.RightUpperArm.R_long,3)
                LL.RightUpperArm(:,:,kk)=FRAME.RightUpperArm.R_long(:,:,kk)*I.UpperArm*FRAME.RightUpperArm.R_long(:,:,kk)';
                KINETICS.RightShoulder.Term4(:,kk)=(LL.RightUpperArm(:,:,kk)*FRAME.RightUpperArm.ACC_long(:,kk))+(FRAME.RightUpperArm.Theta_long(:,:,kk)*LL.RightUpperArm(:,:,kk)*FRAME.RightUpperArm.V_long(:,kk));
            end


            KINETICS.RightShoulder.Moment = KINETICS.RightShoulder.Term1 - (KINETICS.RightWrist.Term2 + KINETICS.RightElbow.Term2 + KINETICS.RightShoulder.Term2) + (KINETICS.RightWrist.Term3 + KINETICS.RightElbow.Term3 + KINETICS.RightShoulder.Term3) + (KINETICS.RightWrist.Term4 + KINETICS.RightElbow.Term4 + KINETICS.RightShoulder.Term4);
            for f = 1:length(KINETICS.RightShoulder.Moment)
                KINETICS.RightShoulderMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.RightShoulder.Moment(:,f);
            end
        end


        %11. Lösen der Bewgungsgleichungen für das linke Handgelenk
        try
            Wheight.Hand = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Hand, 1, length(FP.COP.Left));
            MA.LeftHand = repmat(OPTIONS.ANTHRO.SegmentMass.Hand,3,length(FP.COP.Left)) .* FRAME.LeftHand.LinACC_long;

            KINETICS.LeftWrist.Term1 = zeros(3,length(FRAME.LeftHand.O_long));
            KINETICS.LeftWrist.Term2 = cross((FRAME.LeftHand.O_long  - MARKERS.Derived.LeftWristJC_long), Wheight.Hand)./1000; %wg Nmm zu Nm
            KINETICS.LeftWrist.Term3 = cross((FRAME.LeftHand.O_long - MARKERS.Derived.LeftWristJC_long), MA.LeftHand)./1000; %wg Nmm zu Nm

            I.Hand = repmat([OPTIONS.ANTHRO.MoI.Hand.X;OPTIONS.ANTHRO.MoI.Hand.Y;OPTIONS.ANTHRO.MoI.Hand.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftHand.R_long,3)
                LL.LeftHand(:,:,kk)=FRAME.LeftHand.R_long(:,:,kk)*I.Hand*FRAME.LeftHand.R_long(:,:,kk)';
                KINETICS.LeftWrist.Term4(:,kk)=(LL.LeftHand(:,:,kk)*FRAME.LeftHand.ACC_long(:,kk))+(FRAME.LeftHand.Theta_long(:,:,kk)*LL.LeftHand(:,:,kk)*FRAME.LeftHand.V_long(:,kk));
            end


            KINETICS.LeftWrist.Moment = KINETICS.LeftWrist.Term1 - (KINETICS.LeftWrist.Term2) + (KINETICS.LeftWrist.Term3) + (KINETICS.LeftWrist.Term4);
            for f = 1:length(KINETICS.LeftWrist.Moment)
                KINETICS.LeftWristMomentInProximal(:,f) = FRAME.LeftLowerArm.R_long(:,:,f)' * KINETICS.LeftWrist.Moment(:,f);
            end
        end

        %12. Lösen der Bewgungsgleichungen für das linke Ellbogengelenk
        try
            Wheight.LowerArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.LowerArm, 1, length(FP.COP.Left));
            MA.LeftLowerArm = repmat(OPTIONS.ANTHRO.SegmentMass.LowerArm,3,length(FP.COP.Left)) .* FRAME.LeftLowerArm.LinACC_long;

            KINETICS.LeftElbow.Term1 = zeros(3,length(FRAME.LeftLowerArm.O_long));
            KINETICS.LeftElbow.Term2 = cross((FRAME.LeftLowerArm.O_long  - MARKERS.Derived.LeftElbowJC_long), Wheight.LowerArm)./1000; %wg Nmm zu Nm
            KINETICS.LeftElbow.Term3 = cross((FRAME.LeftLowerArm.O_long - MARKERS.Derived.LeftElbowJC_long), MA.LeftLowerArm)./1000; %wg Nmm zu Nm

            I.LowerArm = repmat([OPTIONS.ANTHRO.MoI.LowerArm.X;OPTIONS.ANTHRO.MoI.LowerArm.Y;OPTIONS.ANTHRO.MoI.LowerArm.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftLowerArm.R_long,3)
                LL.LeftLowerArm(:,:,kk)=FRAME.LeftLowerArm.R_long(:,:,kk)*I.LowerArm*FRAME.LeftLowerArm.R_long(:,:,kk)';
                KINETICS.LeftElbow.Term4(:,kk)=(LL.LeftLowerArm(:,:,kk)*FRAME.LeftLowerArm.ACC_long(:,kk))+(FRAME.LeftLowerArm.Theta_long(:,:,kk)*LL.LeftLowerArm(:,:,kk)*FRAME.LeftLowerArm.V_long(:,kk));
            end


            KINETICS.LeftElbow.Moment = KINETICS.LeftWrist.Term1 - (KINETICS.LeftWrist.Term2 + KINETICS.LeftElbow.Term2) + (KINETICS.LeftWrist.Term3 + KINETICS.LeftElbow.Term3) + (KINETICS.LeftWrist.Term4 + KINETICS.LeftElbow.Term4);
            for f = 1:length(KINETICS.LeftElbow.Moment)
                KINETICS.LeftElbowMomentInProximal(:,f) = FRAME.LeftUpperArm.R_long(:,:,f)' * KINETICS.LeftElbow.Moment(:,f);
            end
        end


        %13. Lösen der Bewgungsgleichungen für das linke Schultergelenk
        try
            Wheight.UpperArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.UpperArm, 1, length(FP.COP.Left));
            MA.LeftUpperArm = repmat(OPTIONS.ANTHRO.SegmentMass.UpperArm,3,length(FP.COP.Left)) .* FRAME.LeftUpperArm.LinACC_long;

            KINETICS.LeftShoulder.Term1 = zeros(3,length(FRAME.LeftThigh.O_long));
            KINETICS.LeftShoulder.Term2 = cross((FRAME.LeftUpperArm.O_long  - MARKERS.Derived.LeftShoulderJC_long), Wheight.UpperArm)./1000; %wg Nmm zu Nm
            KINETICS.LeftShoulder.Term3 = cross((FRAME.LeftUpperArm.O_long - MARKERS.Derived.LeftShoulderJC_long), MA.LeftUpperArm)./1000; %wg Nmm zu Nm

            I.UpperArm = repmat([OPTIONS.ANTHRO.MoI.UpperArm.X;OPTIONS.ANTHRO.MoI.UpperArm.Y;OPTIONS.ANTHRO.MoI.UpperArm.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.LeftUpperArm.R_long,3)
                LL.LeftUpperArm(:,:,kk)=FRAME.LeftUpperArm.R_long(:,:,kk)*I.UpperArm*FRAME.LeftUpperArm.R_long(:,:,kk)';
                KINETICS.LeftShoulder.Term4(:,kk)=(LL.LeftUpperArm(:,:,kk)*FRAME.LeftUpperArm.ACC_long(:,kk))+(FRAME.LeftUpperArm.Theta_long(:,:,kk)*LL.LeftUpperArm(:,:,kk)*FRAME.LeftUpperArm.V_long(:,kk));
            end


            KINETICS.LeftShoulder.Moment = KINETICS.LeftShoulder.Term1 - (KINETICS.LeftWrist.Term2 + KINETICS.LeftElbow.Term2 + KINETICS.LeftShoulder.Term2) + (KINETICS.LeftWrist.Term3 + KINETICS.LeftElbow.Term3 + KINETICS.LeftShoulder.Term3) + (KINETICS.LeftWrist.Term4 + KINETICS.LeftElbow.Term4 + KINETICS.LeftShoulder.Term4);
            for f = 1:length(KINETICS.LeftShoulder.Moment)
                KINETICS.LeftShoulderMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.LeftShoulder.Moment(:,f);
            end
        end

        %14. Lösen der Bewgungsgleichungen für das Nackengelenk
        try
            Wheight.Head = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Head, 1, length(FP.COP.Left));
            MA.Head = repmat(OPTIONS.ANTHRO.SegmentMass.Head,3,length(FP.COP.Left)) .* FRAME.Head.LinACC_long;

            KINETICS.Neck.Term1 = zeros(3,length(FRAME.Head.O_long));
            KINETICS.Neck.Term2 = cross((FRAME.Head.O_long  - MARKERS.Derived.NeckJC_long), Wheight.Head)./1000; %wg Nmm zu Nm
            KINETICS.Neck.Term3 = cross((FRAME.Head.O_long - MARKERS.Derived.NeckJC_long), MA.Head)./1000; %wg Nmm zu Nm

            I.Head = repmat([OPTIONS.ANTHRO.MoI.Head.X;OPTIONS.ANTHRO.MoI.Head.Y;OPTIONS.ANTHRO.MoI.Head.Z],1,3).*eye(3,3);
            I.Trunk = repmat([OPTIONS.ANTHRO.MoI.Trunk.X;OPTIONS.ANTHRO.MoI.Trunk.Y;OPTIONS.ANTHRO.MoI.Trunk.Z],1,3).*eye(3,3);
            for kk=1:size(FRAME.Head.R_long,3)
                LL.Head(:,:,kk)=FRAME.Head.R_long(:,:,kk)*I.Head*FRAME.Head.R_long(:,:,kk)';
                LL.Trunk(:,:,kk)=FRAME.Trunk.R_long(:,:,kk)*I.Trunk*FRAME.Trunk.R_long(:,:,kk)';
                KINETICS.Neck.Term4(:,kk)=(LL.Head(:,:,kk)*FRAME.Head.ACC_long(:,kk))+(FRAME.Head.Theta_long(:,:,kk)*LL.Head(:,:,kk)*FRAME.Head.V_long(:,kk));
            end


            KINETICS.Neck.Moment = KINETICS.Neck.Term1 - (KINETICS.Neck.Term2) + (KINETICS.Neck.Term3) + (KINETICS.Neck.Term4);
            for f = 1:length(KINETICS.Neck.Moment)
                KINETICS.NeckMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.Neck.Moment(:,f);
            end
        end
    end


    function R = rotZ_sw(rang)

        R = [cosd(rang) -sind(rang) 0; sind(rang) cosd(rang) 0; 0 0 1];
    end % rotZ_sw


%     function Velocity = getBeltVelocity(d3dFile, APLimits, LeftMLLimits, RightMLLimits, VerticalLimits)
%
%
%             UpperVelocityLimit = 6; % In m/s kann durch Ausreißerkontrolle geschehen..wird automatisch bestimmt
%             % Defining the control volume
%             xUpperLimit = APLimits(2); % Front of the treadmill
%             xLowerLimit = APLimits(1); % Back of the treadmill
%             yLSLL = LeftMLLimits(1); % Left belt side - Left limit
%             yLSRL = LeftMLLimits(2); % Left belt side - Right limit
%             yRSLL = RightMLLimits(1); % Right belt side - Left limit
%             yRSRL = RightMLLimits(2); % Right belt side - Right limit
%             zUpperLimit = VerticalLimits(2); % Above the belt
%             zLowerLimit = VerticalLimits(1); % Below the belt
%             %Acquiring data
%             acq = btkReadAcquisition(d3dFile);
%             markers = btkGetMarkers(acq);
%             frameRate = btkGetPointFrequency(acq);
%             raw = markers;
%             fieldName = fieldnames(markers)'; % Acquiring the marker names
%             %Overall loop - looping through all markers
%
%             for i = 1:length(fieldName)
%                 if fieldName{i}(1) == 'C'
%                     % Identify if marker is in the control volume
%                     % Looping through all timeframes
%                     for j = 1:length(markers.(fieldName{i}))
%                         % Display x markers location as NaN if not in control volume
%                         if (markers.(fieldName{i})(j,1) < xLowerLimit) || (markers.(fieldName{i})(j,1) > xUpperLimit) || (markers.(fieldName{i})(j,1) == 0)
%
%                             markers.(fieldName{i})(j,1) = NaN;
%                             % Display y markers location as NaN if not in control volume
%                         elseif(markers.(fieldName{i})(j,2) > yLSLL) || (markers.(fieldName{i})(j,2) < yRSRL)
%                             markers.(fieldName{i})(j,1) = NaN;
%                         elseif (markers.(fieldName{i})(j,2) > yLSRL) && (markers.(fieldName{i})(j,2) < yRSLL)
%                             markers.(fieldName{i})(j,1) = NaN;
%                             % Display z markers location as NaN if not in control volume
%                         elseif (markers.(fieldName{i})(j,3) < zLowerLimit) || (markers.(fieldName{i})(j,3) > zUpperLimit)
%                             markers.(fieldName{i})(j,1) = NaN;
%                         end
%                     end
%                     % Calculating velocity for each marker at each
%                     %timeframe
%                     %Identifying if the marker appears for at least 6 consecutive timeframes
%                     aveDist = zeros(length(markers.(fieldName{i})));
%                     for j = 1:length(markers.(fieldName{i}))-5
%                         if ~isnan(markers.(fieldName{i})(j,1))...
%                                 && ~isnan(markers.(fieldName{i})(j+1,1))...
%                                 && ~isnan(markers.(fieldName{i})(j+2,1))...
%                                 && ~isnan(markers.(fieldName{i})(j+3,1))...
%                                 && ~isnan(markers.(fieldName{i})(j+4,1))...
%                                 && ~isnan(markers.(fieldName{i})(j+5,1))...
%                                 %                     && (aveDist(j+1) == 0)
%
%                             % Calculating the absolute difference between marker positions in
%                             % x-direction at three timestamps and calculating the average
%                             %distance.
%                             k = 0;
%                             while k <= 3
%                                 absDiff1 = abs(markers.(fieldName{i})(j+1+k,1) - markers.(fieldName{i})(j+k,1));
%                                 absDiff2 = abs(markers.(fieldName{i})(j+2+k,1) - markers.(fieldName{i})(j+1+k,1));
%                                 aveDist(j+1+k) = (absDiff1 + absDiff2) / 2;
%                                 k = k + 1;
%                             end
%                             % Calculating the instantaneous velocity with the known
%                             % framerate for each marker at each timeframe.
%                             velocity.(fieldName{i})(1,1) = NaN;
%                             velocity.(fieldName{i})(j+1,1) = aveDist(j+1) / (1000/frameRate);
%                             % Filter out velocity outliers that are due to marker
%                             %jumps.
%                             if velocity.(fieldName{i})(j+1,1) >= UpperVelocityLimit
%                                 velocity.(fieldName{i})(j+1,1) = NaN;
%                             end
%                         else
%                             velocity.(fieldName{i})(1,1) = NaN;
%                             velocity.(fieldName{i})(j+1,1) = NaN;
%                         end
%                     end
%                 end
%             end
%             %Creating the output velocity vector
%             %Creating a vector of zeros
%             velocitySum = zeros(length(velocity.(fieldName{i})),1);
%             velocitySum(:,2) = 0; % Creating a column of ones
%             % Summing up the velocities if more than one velocity for any
%             % timeframe is available
%             for i = 1:length(fieldName)
%                 if fieldName{i}(1) == 'C'
%                     for j = 1:length(velocity.(fieldName{i}))
%                         % Execute the following command only if a number is inside.
%                         if isnan(velocity.(fieldName{i})(j,1)) == 0
%                             % Adding Up the velocities at each timeframe
%                             velocitySum(j,1) = velocitySum(j,1) + velocity.(fieldName{i})(j,1);
%                             % Counting how many velocities were added
%                             velocitySum(j,2) = velocitySum(j,2) + 1;
%                         end
%                     end
%                 end
%             end
%             % Calculating the average velocity
%             aveVelocity = velocitySum(:,1) ./ velocitySum(:,2);
%
%             MarkerData.AverageVelocity = aveVelocity;
%             %Output the data
%             % plot(aveVelocity)
%             % title('Belt Velocity')
%             % xlabel('Time Frame')
%             % ylabel('Velocity [m/s]')
%             % set(gca, 'LineWidth', 1.5);
%             % box off
%             % Filter Velocity
%             [b,a] = butter(2, 15/(frameRate/2), 'low');
%             aveVelocityFilt(2:length(aveVelocity)) = filtfilt(b,a,aveVelocity(2:end));
%             aveVelocityFilt(1) = aveVelocityFilt(2);
%             % hold on
%             % plot(aveVelocityFilt, 'g')
%
%             Velocity = aveVelocityFilt;
%         end %getBeltVelocity

    function V = removeEndpointNaNs(Vin)
        iNan = isnan(Vin);
        V = Vin;
        V(iNan-1:end) = V(iNan-1);
    end %removeEndpointNaNs
end % EOF