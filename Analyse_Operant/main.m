function main(params)

% We will process each file in the info_table one by one
% number of files in the info_table
nFiles = size(params.info_table,1);

if ~nFiles, warning('Please check system and task at the top of your config file!'); end

%% STEP 1
for iFile = 1: nFiles % for each file
    [params, name, f] = init_names(params, iFile);
    % define the name of the output file from analysis setp #1
    step1_file = [params.analysis_folder filesep name '_step1.mat'];
    % if this output file doesn't exist
    if ~exist(step1_file,'file')
        step1_data = analysis_step1(params, f);
        save_step1(params, step1_data);
    end
end


as = NaN;
%% STEP 2
for iFile = 1: nFiles % for each file
    
    [params, name, f] = init_names(params, iFile);
    
    % define the name of the output file from analysis setp #1
    step1_file = [params.analysis_folder filesep name '_step1.mat'];
    
    % load the output file of analysis step #1
    load(step1_file, 'step1_data');
    
    if iFile==1
        metadata = get_PEATS_table(params);
        as = build_step2_accumulation_structure(params, step1_data);
        as.metadata = metadata;
    end
    
    
    
    
    %% HERE we want to give a table copy of info, populate the table with all PSTH TRIAL 1 TO N, SESSION 1 TO N, BULK AND TRANSIENTS
    %% THIS IS WHAt NEED TO BE DONE NEXT TIME
     as=analysis_step2(params, as, step1_data, iFile); % step1_data comes from load(step1_file);
    
end

d = [params.analysis_folder filesep 'RESULTS'];
if ~exist(d,'dir'), mkdir(d); end
save([d filesep 'RESULTS.mat'],'params', 'as');

toc

end


function [params, name, f] = init_names(params, iFile)
%extract the filepath form info_table
f = params.info_table.filepath(iFile);f = f{1};

%get the filename fomr the absolute filepath
[filepath,name,~] = fileparts(f);

if strcmp(params.acquisition_system,'RWD')
    tmp = split(filepath,'\');
    name = tmp{end-1};
end
% use this filename as the prefix for figure names
params.figure.prefix = name;

nFiles = size(params.info_table,1);

fprintf('[%d/%d] %s\n',iFile, nFiles, name);
end



