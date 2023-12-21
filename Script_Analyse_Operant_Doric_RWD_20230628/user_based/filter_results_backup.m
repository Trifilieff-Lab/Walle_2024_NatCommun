%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

sfreq = 10;

% DEFINE INPUTS AND OUTPUTS
params.analysis_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Analyses\RWD_Anna\Exp1';
results_folder = [params.analysis_folder filesep 'RESULTS'];
load([results_folder filesep 'RESULTS.mat']);

%% OVERWRITE ANALYSIS PARAMETERS
params.figure.folder = params.analysis_folder;

params.use_zscore=1;

if params.use_zscore
    bsl_i1 = params.PSTH.baseline_period_start_idx - params.PSTH.before_idx +1;
    bsl_i2 = params.PSTH.baseline_period_stop_idx  - params.PSTH.before_idx +1;
    as.PSTH.dff_matrix = zscore_matrix(as.PSTH.dff_matrix, bsl_i1, bsl_i2);
end

s = size(as.metadata);
b=1:size(as.metadata,1);
as.metadata.('LINE_NUM')= b';

all_columns = {'eventname','mouse','date'};
i_column=1;
fig_name=['_']

filter_on_columns(as,as.metadata,all_columns,i_column, results_folder, fig_name)
%     cmd = sprintf("categories = unique(as.metadata.%s)",filterSet{iFilter});eval(cmd);
%     fprintf('here')


function m_matrix =  filter_on_columns(as,metadata,all_columns,i_column, results_folder, fig_name)
    m_matrix=[];
    if i_column<=size(all_columns,2)
        cat=[];
        cmd = sprintf("cat = unique(metadata.%s);",all_columns{i_column});eval(cmd)
        for i=1:i_column
            fprintf('\t');
        end
        fprintf('*%s\n',all_columns{i_column})
        nCat = size(cat,1);
        m_matrix_all = nan(nCat,size(as.PSTH.dff_matrix,2));
        for iCat=1:nCat 
            for i=1:i_column
                fprintf('\t');
            end
            fprintf('  **%s',cat{iCat});
            m_matrix  = filter_categories(as,metadata,all_columns,i_column,cat{iCat}, results_folder, [fig_name '-' cat{iCat}]);
            m_matrix_all(iCat,:)=m_matrix;
        end
        fprintf('All Categories of %s have been done\n',print_cell_array(all_columns(i_column:end)))
        m_matrix = make_the_plot(m_matrix_all, results_folder, fig_name, all_columns, i_column);
        fprintf('here')
    end
end

function m_matrix = filter_categories(as,metadata,all_columns,i_column,category, results_folder, fig_name)
    m_matrix=[];
    cmd=sprintf('selected_rows = find(metadata.%s==category);',all_columns{i_column});
    eval(cmd)
    n_rows = size(selected_rows,1);
    fprintf(' (%d rows)\n',n_rows);
    metadata = metadata(selected_rows,:);
    
    if i_column<size(all_columns,2)
        m_matrix =  filter_on_columns(as,metadata,all_columns,i_column+1, results_folder, fig_name);
    else
        dff_matrix = as.PSTH.dff_matrix(metadata.LINE_NUM,:);
        m_matrix = make_the_plot(dff_matrix, results_folder, fig_name, all_columns, i_column);
    end
end

function str_=print_cell_array(cell_array)
     s=size(cell_array,2);str_=[];
     for i=1:s, str_ = [str_ '/' cell_array{i}];end
end

function mean_ = make_the_plot(matrix,results_folder, fig_name, all_columns, i_column);

    stat_struct = matrix_statistics(matrix);

    fig=figure('name',fig_name);
    subplot(3,1,1)
    hold on
    title('dff')
    imagesc(stat_struct.matrix)
    colorbar
    subplot(3,1,2)
    hold on
    title('dff')
    m_=stat_struct.mean;
    std_=stat_struct.std;
    plot(m_,'k')
    plot(m_+std_,'k:')
    plot(m_-std_,'k:')
    f = [results_folder filesep fig_name '.png'];
    print(fig,f, '-dpng');
    fprintf('%s DONE\n',fig_name)
    close(fig);
    
    mean_ = stat_struct.mean;
    
end


function struct = matrix_statistics(matrix)
    struct.matrix = matrix;
    struct.mean = mean(matrix);
    struct.std  = std(matrix);
end

function zscore_ = zscore_matrix(matrix, bsl_i1, bsl_i2)
    bsl_mean = mean(matrix(:,bsl_i1:bsl_i2),2);
    bsl_std = std(matrix(:,bsl_i1:bsl_i2),0,2);
    [r,c]=size(matrix);
    zscore_ = matrix - repmat(bsl_mean,1,c);
    zscore_ = zscore_./repmat(bsl_std,1,c);
end





