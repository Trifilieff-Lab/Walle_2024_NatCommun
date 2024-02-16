
%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

%% DEFINE THE STRUCTURE THAT WILL HOLD ALL THE PARAMETERS
params = [];

%% DEFINE INPUTS AND OUTPUTS
params.data_folder = 'F:\2022-131\FR1 sans delai\NAC\DATA';
params.analysis_folder = 'F:\2022-131\FR1 sans delai\Analysis';
params.figure.folder = params.analysis_folder;


%%  STEP1  %% %% %% %%

% ENUMERATE EVENTS TRIAL BY TRIAL
params.period_enumeration = 1;

%% DEFINE THE ACQUISITION SYSTEM
params.acquisition_system = 'Doric'; % 'Doric' or 'RWD'
params.behavioral_task = 'FR'; % 'PAVLOV', 'FR' or 'INJECTION'

%% IF DATA WERE RECORDED WITH DIFFERENT SAMPLING RATES
% NOT RECOMMENDED OTHERWISE
params.resample_photometry = 1;
params.photometry_resampling_frequency = 100;

%% TO REMOVE INITIAL EXPONENCIAL PHOTOBLEATCHING DECAY
params.left_trim_dur_sec=60;


%% PERI EVENT AVERAGED TIME SERIES (PEATS)
%% STEP2 %% %% %% %%

% PEATS TIME WINDOW
params.PEATS.before_msec = -2000;
params.PEATS.after_msec  = 5000;
% params.PEATS.bin_size_msec = 100;
% AUC
params.PEATS.measure_AUC = 1;
params.PEATS.AUC_before_msec = 0;
params.PEATS.AUC_after_msec  = 500;


% INDIVIDUAL BASELINE TIME WINDOW
params.PEATS.use_periodic_bl = 1;
params.PEATS.use_individual_bl = 0;
params.PEATS.bl_before_msec = -2000;
params.PEATS.bl_after_msec  = -500;
params.PEATS.apply_zscore = 1;


%% DEFINE FIGURE CREATION
params.figure.savepng = 1;
params.figure.savefig = 1;
params.figure.closefig = 1;

%% CREATE FIGURES TO CHECK INTERMEDIATE STEPS
params.debug.mode = 0;
params.debug.folder = [params.analysis_folder filesep 'debug_figures'];
params.debug.savepng = params.figure.savepng;
params.debug.savefig = params.figure.savefig;
params.debug.closefig = params.figure.closefig;
params.debug.prefix = '';

%% CONFIGURATION OF DIGITAL AND ANALOG INPUTS/OUTPUTS
params.recording_config = get_recording_config(params.acquisition_system,params.behavioral_task);


%% THE LINK TO THE FILE THAT CONTAINS ALL METADATA
params.info_table_path = [params.data_folder filesep 'info_table.txt'];
creates_info_table(params.data_folder, params.acquisition_system, params.info_table_path, @parse_filenames);

% Otherwise create a file like this one using tabulations
% MOUSE	DATE	SESSION	REC	TASK	GROUP	GENDER	FILEPATH
% M1	20221207	01	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221207_sess01_rec1_Pavlovien_M_DELTA_2.csv
% M1	20221208	02	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221208_sess02_rec1_Pavlovien_M_DELTA_2.csv
% M1	20221209	03	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221209_sess03_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221207	01	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221207_sess01_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221208	02	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221208_sess02_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221209	03	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221209_sess03_rec1_Pavlovien_M_DELTA.csv


params.info_table = readtable(params.info_table_path,'Delimiter','\t');

params.info_struct =  parse_filenames();

params.step1_postprocessing_functions = {};


params.step1_postprocessing_functions{end+1} = @resample_data;
if strcmp(params.acquisition_system,'RWD') && strcmp(params.behavioral_task,'FR') 
    params.step1_postprocessing_functions{end+1} = @merge_licks;
end
params.step1_postprocessing_functions{end+1} = @divide_events_into_periods;


%% ALL ANALYSIS DONE BY THIS MAIN FUNCTION
main(params)

%% EXPLAINS THE FORMAT YOU CHOOSE FOR YOUR FILENAMES
%f = '83305_20230307_sess01_rec1_def_nac_1'
function info = parse_filenames(f)
    switch nargin
        case 0
            info=struct('mouse','','date','','session','','rec','','regime','','structure','');
        case 1
            f = split(f,'.');
            f = f{1};
            fields = split(f,'_');
            info.mouse = fields{1};
            info.date = fields{2};
            info.session = fields{3}(5:end);
            info.rec = fields{4}(4:end);
            info.regime = fields{5};
            info.structure = fields{6};
            
    end
end

%% CONFIGURATION OF DIGITAL AND ANALOG INPUTS/OUTPUTS
function recording_config = get_recording_config(system,behavioral_task)

    %% FOR DORIC FR OR PAVLOV
    if strcmp(system,'Doric') && strcmp(behavioral_task,'FR')
        recording_config = {
            {'DIO1','LED405'},...
            {'DIO2','LED470'},...
            {'DIO3','Camera','extract_as_TTL','hardware_events'},...
            {'DIO4','Pulse','extract_as_TTL','hardware_events'},...
            {'AIn1','GCaMP'},...
            {'AIn2','ComplexTTL1','extract_as_ComplexTTL','behavioral_events',{'Licks1','Levers_presentation', 'CS', 'Licks2'},{[0.00,0.05],[0.05,0.15],[0.15,0.25],[0.25,0.35]}},...
            {'AIn3','L2','extract_as_TTL','behavioral_events'},...
            {'AIn4','L1','extract_as_TTL','behavioral_events'},...
            %{'Imetronic_Synchro','AIn2','Lever1',@get_TTL2_from_dat},...
            %{'Imetronic_Event','Lever2',@get_Lever2_from_dat,'behavioral_events'},...
            {'behavioral_periods_starts','Levers_presentation'},...
            {'behavioral_periods_baselines','Levers_presentation', -3000,0}
            };
    end
    
       if strcmp(system,'Doric') && strcmp(behavioral_task,'PAVLOV')
        recording_config = {
            {'DIO1','LED405'},...
            {'DIO2','LED470'},...
            {'DIO3','Camera','extract_as_TTL','hardware_events'},...
            {'DIO4','Pulse','extract_as_TTL','hardware_events'},...
            {'AIn1','GCaMP'},...
            {'AIn2','Licks','extract_as_TTL','behavioral_events'},...
            {'AIn3','CS','extract_as_TTL','behavioral_events'},...
            {'AIn4','US','extract_as_TTL','behavioral_events'},...
            {'behavioral_periods_starts','CS'},...
            {'behavioral_periods_baselines','CS', -23000,-20000}
            };
      end
   
      
    % RWD System  
    if strcmp(system,'RWD') && strcmp(behavioral_task,'FR') 
        recording_config = {
            {'Input1','pulse','extract_as_TTL','hardware_events'},...
            {'Input2','ComplexTTL1','extract_as_ComplexTTL','behavioral_events',{'Licks1','Levers_presentation', 'CS', 'Licks2'},{[0.00,0.05],[0.05,0.15],[0.15,0.25],[0.25,0.35]}},...
            {'Input3','L2_press','extract_as_TTL','behavioral_events'},...
            {'Input4','L1_press','extract_as_TTL','behavioral_events'},...
            {'Imetronic_Synchro','Input2','CS',@get_cs_from_dat},...
            {'Imetronic_Event','FIN_CS',@get_fin_cs_from_dat,'behavioral_events'},...
            {'Imetronic_Event','US',@get_us_from_dat,'behavioral_events'},...
            {'behavioral_periods_starts','Levers_presentation'},...
            {'behavioral_periods_baselines','Levers_presentation', -3000,0}
            };  
    end     


      
    if strcmp(system,'RWD') && strcmp(behavioral_task,'PAVLOV') 
        recording_config = {
            {'Input1','pulse','extract_as_TTL','hardware_events'},...
            {'Input2','lick','extract_as_TTL','behavioral_events'},...
            {'Input3','CS','extract_as_TTL','behavioral_events'},...
            {'Input4','US','extract_as_TTL','behavioral_events'},...
            {'Imetronic_Synchro','Input4','US',@get_TTL4_from_dat},...
            {'Imetronic_Event','FIN_CS',@get_fin_cs_from_dat,'behavioral_events'},...
            {'behavioral_periods_starts','CS'},...
            {'behavioral_periods_baselines','CS', -23000,-20000}
            };     
    end

    
    %% FOR RWD AND INJECTION
    if strcmp(system,'RWD') && strcmp(behavioral_task,'INJECTION') 
        recording_config = {
            {'EventFile','stimA','my_events.txt','behavioral_events'}
            };     
    end    
    
    
end

function lever2 = get_Lever2_from_dat(imetronic_DB)
tmp = imetronic_DB(2).num(2).info;
i=find(diff(tmp(:,6))==1);
lever2 =  tmp(i+1,1);
end

function fin_cs = get_fin_cs_from_dat(imetronic_DB)
    sounds = imetronic_DB(6).num(2).info;
    idx = find(sounds(:,8)>0); %remove trial 0
    sounds = sounds(idx,:);
    idx = find(sounds(:,4)==1);
    sounds_onsets = sounds(idx,1);
    sounds_offsets = [];
    if (idx+1)<=size(sounds,1)
        sounds_offsets = sounds(idx+1,1);
    end
    fin_cs = sounds_offsets;
end

function cs = get_cs_from_dat(imetronic_DB)
    sounds = imetronic_DB(6).num(2).info;
    idx = find(sounds(:,8)>0); %remove trial 0
    sounds = sounds(idx,:);
    idx = find(sounds(:,4)==1);
    sounds_onsets = sounds(idx,1);
    cs = sounds_onsets;
end

function us = get_us_from_dat(imetronic_DB)
    us_info = imetronic_DB(5).num(1).info;
    if size(us_info,1)  
        us = us_info(find(us_info(:,10)==1),1);
    else
       us = []; 
    end
end

function TTL = get_TTL2_from_dat(imetronic_DB)
    tmp = imetronic_DB(15).num(2).info;
    TTL = unique(tmp( find(tmp(:,4)==1) ,1));
end

function TTL = get_TTL4_from_dat(imetronic_DB)
    tmp = imetronic_DB(15).num(4).info;
    TTL =unique( tmp( find( tmp(:,4)==1 ) ,1));
end

function step1_data = resample_data(step1_data, rec_config, params)
    if params.resample_photometry
        time = step1_data.time;
        n = size(time,1);
        original_sfreq = 1/median(diff(time));
        correction_factor = params.photometry_resampling_frequency / original_sfreq;
        x = 1:n;
        xq = 1:1/correction_factor:n;
        time_rs = interp1(x,time,xq,'linear');

        var2interp = {'time', 'iso', 'physio'};
        nVars = size(var2interp,2);
        for iVar=1:nVars
            tmp = interp1(x, step1_data.(var2interp{iVar}),xq,'spline')';
            %             figure()
            %             hold on
            %             plot(x, step1_data.(var2interp{iVar}),'k+--')
            %             plot(xq, tmp,'r.')
            step1_data.(var2interp{iVar})=tmp;
        end

    end
    
end

function step1_data = merge_licks(step1_data, rec_config, params)
    Licks1 = step1_data.behavioral_events.Licks1;
    Licks2 = step1_data.behavioral_events.Licks2;
    f = fieldnames(Licks1);
    for i=1:size(f,1)
        cmd=sprintf('Licks.%s=sort([Licks1.%s; Licks2.%s]);',f{i},f{i},f{i});eval(cmd);
    end
    step1_data.behavioral_events.Licks=Licks;
    step1_data.behavioral_events = rmfield(step1_data.behavioral_events,'Licks1');
    step1_data.behavioral_events = rmfield(step1_data.behavioral_events,'Licks2');
end

function step1_data = divide_events_into_periods(step1_data, rec_config, params)


    n = size(rec_config,2);
    
    % establish period starts based on behavioral_periods_starts in
    % rec_config
    for i=1:n
        tmp = rec_config{i};
        if strcmp(tmp{1},'behavioral_periods_starts')
            cmd = sprintf('starts=step1_data.behavioral_events.%s.on_ts;',tmp{2});eval(cmd);
            m = size(starts,1);
            for j=1:m
                step1_data.behavioral_periods(j).period_start_ts = starts(j);
            end
        end
    end
    
    % establish baseline_periods based on behavioral_periods_baselines in
    % rec_config
    for i=1:n
        tmp = rec_config{i};
        if strcmp(tmp{1},'behavioral_periods_baselines')
            cmd = sprintf('starts=step1_data.behavioral_events.%s.on_ts;', tmp{2});eval(cmd);
            m = size(starts,1);
            for j=1:m
                step1_data.behavioral_periods(j).baseline_start_ts = starts(j) + tmp{3}/1000;
                step1_data.behavioral_periods(j).baseline_stop_ts = starts(j) + tmp{4}/1000;
            end
        end
    end
    
    
    behavioral_event_fields = fieldnames(step1_data.behavioral_events);
    nE = size(behavioral_event_fields,1);
    nP = size(step1_data.behavioral_periods,2);
    
    for iE=1:nE

         step1_data.behavioral_events.(behavioral_event_fields{iE}).id_in_period=[];
         step1_data.behavioral_events.(behavioral_event_fields{iE}).periods=[];
        
        s = step1_data.behavioral_events.(behavioral_event_fields{iE});
        on_ts = s.on_ts;  
        
         nO = size(on_ts,1);
         
         if nO
        
            %determine the period in which each event happens
            periods = discretize(s.on_ts,[step1_data.behavioral_periods.period_start_ts step1_data.time(end)]);   
            step1_data.behavioral_events.(behavioral_event_fields{iE}).periods=periods;

            %determine the occurence of each event within each trial,
            %for ex the third lever press of each trial
            id_in_period = [];
            prev_period = periods(1);
            cur_id = 1;
            id_in_period(end+1)=1;    

            if nO>1
                for iO=2:nO
                    if periods(iO)==prev_period
                        cur_id = cur_id + 1;
                    else
                        cur_id =  1;
                    end
                    id_in_period(iO)=cur_id;
                    prev_period = periods(iO);
                end
            end
            
            step1_data.behavioral_events.(behavioral_event_fields{iE}).id_in_period=id_in_period;

         end
         
    end
    
end

