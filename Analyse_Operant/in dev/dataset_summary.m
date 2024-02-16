%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

%% DEFINE THE STRUCTURE THAT WILL HOLD ALL THE PARAMETERS
params = [];

%% DEFINE INPUTS AND OUTPUTS
params.data_folder = 'F:\Data Anna FR1 Doric old\2022-95_Pavlovien_DATA';
params.analysis_folder = 'F:\Analysis Anna FR1 Doric old\2022-95_Pavlovien_DATA';
params.figure.folder = params.analysis_folder;

%% DEFINE THE USER
% This is important is you don't name your files like other experimenters
% In such a case you case create your own parse_filename function to
% extract METADATA from your data filenames
% depending on the user name the main programme will use different
% functions to parse data filenames
params.user = 'Anna_02';

%% THE LINK TO THE FILE THAT CONTAINS ALL METADATA
params.info_table_path = [params.data_folder filesep 'info_table.txt'];

results_folder = [params.analysis_folder filesep 'RESULTS'];

% If you don't want to create it from scratch you ca use the following
if ~exist(params.info_table_path,'file')
    creates_info_table(params.data_folder, params.user, params.info_table_path);
end

filename = params.info_table_path;
opt = detectImportOptions(filename, 'Delimiter','\t');
opt = setvartype(opt, 'MOUSE', 'string');
opt = setvartype(opt, 'FILEPATH', 'string');
t = readtable(filename, opt);
mice = unique(t.MOUSE);


fig=figure()


nR = 2;
nC = 4;

subplot(nR,nC,1);
batch_analysis(@perc_dff_above,params)
title('dff_above')
% legend(mice)

subplot(nR,nC,2);
batch_analysis(@std_iso,params)
title('std iso')
% legend(mice)

subplot(nR,nC,3);
batch_analysis(@transients_rate,params)
title('Transients Fr')
% legend(mice)

subplot(nR,nC,5);
batch_analysis(@lick_num,params)
title('licks')
% legend(mice)

subplot(nR,nC,6);
batch_analysis(@cs_num,params)
title('cs')
% legend(mice)

subplot(nR,nC,7);
batch_analysis(@rt,params)
title('Reaction TIme')
% legend(mice)


subplot(nR,nC,8);
batch_analysis(@leg,params)
title('legend')
legend(mice)

print(fig,[results_folder filesep '00_dataset_summary.png'], '-dpng');

function batch_analysis(analysis_func, params)
    filename = params.info_table_path;
    opt = detectImportOptions(filename, 'Delimiter','\t');
    opt = setvartype(opt, 'MOUSE', 'string');
    opt = setvartype(opt, 'FILEPATH', 'string');
    t = readtable(filename, opt);
    mice = unique(t.MOUSE);
    nMice = max(size(mice));
    for iMouse=1:nMice
        selected_rows = find(t.MOUSE==mice{iMouse});
        paths = t.FILEPATH(selected_rows);
        data2plot = [];
        for iFile=1:max(size(paths))
            %extract the filepath form info_table
            f = paths(iFile); f = f{1};
            %get the filename fomr the absolute filepath
            [filepath,name,ext] = fileparts(f);
            % define the name of the output file from analysis setp #1
            step1_file = [params.analysis_folder filesep name '_step1.mat'];
            load(step1_file);
            data2plot(end+1)=analysis_func(step1_data);
        end
        plot(data2plot,'linewidth',2)
        hold all
    end
end


function res=perc_dff_above(step1_data)
            nSamples = max(size(step1_data.dff));
            res = sum(step1_data.dff>2)/nSamples *100;
end


function res=transients_rate(step1_data)
    res = 1/median(diff(step1_data.transients.time));
end

function res=std_iso(step1_data)
    res = std(step1_data. iso);
end

function res=cs_num(step1_data)
    res = max(size(step1_data.events.cs_ts));
end

function res=lick_num(step1_data)
    res = max(size(step1_data.events.licks_ts));
end

function res=rt(step1_data)
    cs_ts = step1_data.events.cs_ts;
    licks_ts = step1_data.events.licks_ts;
    rt_all=[]
    for i=1:max(size(cs_ts))
            j=find(licks_ts>cs_ts(i),1,'first');
            if ~isempty(j)
                rt_all(end+1)=licks_ts(j)-cs_ts(i);
            end
    end
    res = median(rt_all);
end


function res=leg(step1_data)
    res = 0;
end

