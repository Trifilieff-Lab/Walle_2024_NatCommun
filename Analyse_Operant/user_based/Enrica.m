

%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

%% DEFINE THE STRUCTURE THAT WILL HOLD ALL THE PARAMETERS
params = [];

%% DEFINE INPUTS AND OUTPUTS
params.data_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Data\RWD_Enrica\cohort1';
params.analysis_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Analyses\RWD_Enrica\cohort1';
params.figure.folder = params.analysis_folder;


%% DEFINE THE ACQUISITION SYSTEM
params.acquisition_system = 'RWD'; % 'Doric' or 'RWD'
params.behavioral_task = 'PAVLOV'; % 'PAVLOV' or 'FR'


%% CONFIGURATION OF DIGITAL AND ANALOG INPUTS/OUTPUTS
params.recording_config = get_recording_config(params.acquisition_system,params.behavioral_task);


%% THE LINK TO THE FILE THAT CONTAINS ALL METADATA
params.info_table_path = [params.data_folder filesep 'info_table.txt'];

% If you don't want to create it from scratch you ca use the following
if ~exist(params.info_table_path,'file')
    creates_info_table(params.data_folder, params.acquisition_system, params.info_table_path, @parse_filenames);
end

% Otherwise create a file like this one using tabulations
% MOUSE	DATE	SESSION	REC	TASK	GROUP	GENDER	FILEPATH
% M1	20221207	01	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221207_sess01_rec1_Pavlovien_M_DELTA_2.csv
% M1	20221208	02	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221208_sess02_rec1_Pavlovien_M_DELTA_2.csv
% M1	20221209	03	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M1_20221209_sess03_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221207	01	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221207_sess01_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221208	02	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221208_sess02_rec1_Pavlovien_M_DELTA_2.csv
% M2	20221209	03	1	Pavlovien	DELTA	M	E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\20221115\data\M2_20221209_sess03_rec1_Pavlovien_M_DELTA.csv


params.info_table = readtable(params.info_table_path,'Delimiter','\t');

%% STEP1 ANALYSIS PARAMETERS, DATA EXTRACTION FROM RAW DATA FILES
params.left_trim_dur_sec = 15;

params.figure.savepng = 1;
params.figure.savefig = 1;
params.figure.closefig = 1;

params.debug.mode = 0;
params.debug.folder = [params.analysis_folder filesep 'debug_figures'];
params.debug.savepng = params.figure.savepng;
params.debug.savefig = params.figure.savefig;
params.debug.closefig = params.figure.closefig;
params.debug.prefix = '';





%% STEP2 ANALYSIS PARAMETERS
params.PSTH.before_msec = -2000;
params.PSTH.after_msec  = 5000;
params.PSTH.baseline_period_start_msec = -2000;
params.PSTH.baseline_period_stop_msec = -1500;
params.PSTH.transient_histo_bin_size_msec = 500;
params.PSTH.transient_histo_edges_msec = params.PSTH.before_msec:params.PSTH.transient_histo_bin_size_msec:params.PSTH.after_msec;

params.info_struct =  parse_filenames();

if strcmp(params.acquisition_system,'RWD') && strcmp(params.behavioral_task,'FR') 
    params.step1_clean_function = @clean_step1
end


main(params)


%% EXPLAINS THE FORMAT YOU CHOOSE FOR YOUR FILENAMES
%f = 'm1_pavlov_20221010_chow_ctrl'
function info = parse_filenames(f)
    switch nargin
        case 0
            info=struct('mouse','','task','','date','','regime','','traitment','');
        case 1
            f = split(f,'.');
            f = f{1};
            fields = split(f,'_');
            info.mouse = fields{1};
            info.task = fields{2};
            info.date = fields{3};
            info.regime = fields{4};
            info.traitment = fields{5};
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
            {'DIO4','ComplexTTL1','extract_as_ComplexTTL','behavioral_events',{'FIN_CS', 'CS', 'US', 'Levers_presentation', 'Trial_Start'},{[0.05,0.15],[0.15,0.25],[0.25,0.35],[0.35,0.45],[0.45,0.55]}},...
            {'AIn1','GCaMP'},...
            {'AIn2','Lever1','extract_as_TTL','behavioral_events'},...
            {'AIn3','Licks','extract_as_TTL','behavioral_events'},...
            {'AIn4','AIn4'},...
             {'Imetronic_Synchro','AIn2','Lever1',@get_TTL2_from_dat},...
            {'Imetronic_Event','Lever2',@get_Lever2_from_dat,'behavioral_events'}
            };
    end
    
      if strcmp(system,'Doric') && strcmp(behavioral_task,'PAVLOV')
        recording_config = {
            {'DIO1','LED405'},...
            {'DIO2','LED470'},...
            {'DIO3','Camera','extract_as_TTL','hardware_events'},...
            {'DIO4','ComplexTTL1','extract_as_ComplexTTL','behavioral_events',{'FIN_CS', 'CS', 'US'},{[0.05,0.15],[0.15,0.25],[0.25,0.35]}},...
            {'AIn1','GCaMP'},...
            {'AIn2','AIn2'},...
            {'AIn3','Licks','extract_as_TTL','behavioral_events'},...
            {'AIn4','AIn4'}
            };
      end
   
    
    if strcmp(system,'RWD') && strcmp(behavioral_task,'PAVLOV') 
        recording_config = {
            {'Input1','pulse','extract_as_TTL','hardware_events'},...
            {'Input2','lick','extract_as_TTL','behavioral_events'},...
            {'Input3','CS','extract_as_TTL','behavioral_events'},...
            {'Input4','US','extract_as_TTL','behavioral_events'},...
            {'Imetronic_Synchro','Input4','US',@get_TTL4_from_dat},...
            {'Imetronic_Event','FIN_CS',@get_fin_cs_from_dat,'behavioral_events'}
            };     
    end
    
    if strcmp(system,'RWD') && strcmp(behavioral_task,'FR') 
        recording_config = {
            {'Input1','pulse','extract_as_TTL','hardware_events'},...
            {'Input2','ComplexTTL1','extract_as_ComplexTTL','behavioral_events',{'Licks1','Levers_presentation', 'CS', 'Licks2'},{[0.00,0.05],[0.05,0.15],[0.15,0.25],[0.25,0.35]}},...
            {'Input3','L2_press','extract_as_TTL','behavioral_events'},...
            {'Input4','L1_press','extract_as_TTL','behavioral_events'},...
            {'Imetronic_Synchro','Input4','L1_press',@get_TTL4_from_dat},...
            {'Imetronic_Event','FIN_CS',@get_fin_cs_from_dat,'behavioral_events'},...
            {'Imetronic_Event','US',@get_us_from_dat,'behavioral_events'}
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
    idx = find(sounds(:,4)==1)
    sounds_onsets = sounds(idx,1);
    sounds_offsets = []
    if (idx+1)<=size(sounds,1)
        sounds_offsets = sounds(idx+1,1);
    end
    fin_cs = sounds_offsets;
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

function step1_data=clean_step1(step1_data)
    licks1=step1_data.behavioral_events.Licks1;
    licks2=step1_data.behavioral_events.Licks2;
    f = fieldnames(licks1);
    for i=1:size(f,1)
        cmd=sprintf('licks.%s=sort([licks1.%s; licks2.%s])',f{i},f{i},f{i});eval(cmd)
    end
    step1_data.behavioral_events.licks=licks;
    step1_data.behavioral_events = rmfield(step1_data.behavioral_events,'Licks1');
    step1_data.behavioral_events = rmfield(step1_data.behavioral_events,'Licks2');
end

