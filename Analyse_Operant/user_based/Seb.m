

%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

%% DEFINE THE STRUCTURE THAT WILL HOLD ALL THE PARAMETERS
params = [];

%% DEFINE INPUTS AND OUTPUTS
params.data_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Data\RWD_TestForLola';
params.analysis_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Analyses\RWD_TestForLola';
params.figure.folder = params.analysis_folder;


%% DEFINE THE ACQUISITION SYSTEM
params.acquisition_system = 'RWD'; % 'Doric' or 'RWD'
params.behavioral_task = 'INJECTION'; % 'PAVLOV' or 'FR'


%% CONFIGURATION OF DIGITAL AND ANALOG INPUTS/OUTPUTS
params.recording_config = get_recording_config(params.acquisition_system,params.behavioral_task);


%% THE LINK TO THE FILE THAT CONTAINS ALL METADATA
params.info_table_path = [params.data_folder filesep 'info_table1.txt'];

% If you don't want to create it from scratch you ca use the following
% if ~exist(params.info_table_path,'file')
creates_info_table(params.data_folder, params.acquisition_system, params.info_table_path, @parse_filenames);
% end

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
%f = '52353_20221115_sess01_rec1_def_nac'
function info = parse_filenames(f)
    switch nargin
        case 0
            info=struct('mouse','','date','');
        case 1
            f = split(f,'.');
            f = f{1};
            fields = split(f,'_');
            info.mouse = fields{1};
            info.date = fields{2};   
    end
end


%% CONFIGURATION OF DIGITAL AND ANALOG INPUTS/OUTPUTS
function recording_config = get_recording_config(system,behavioral_task)

    %% FOR RWD AND INJECTION
    if strcmp(system,'RWD') && strcmp(behavioral_task,'INJECTION') 
        recording_config = {
            {'EventFile','stimA','my_events.txt','behavioral_events'}
            };     
    end

    
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

