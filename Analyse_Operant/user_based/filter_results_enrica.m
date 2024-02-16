%% CLEAR AND INITIALIZE
clear;close all;clc;tic;

%% DEFINE THE STRUCTURE THAT WILL HOLD ALL THE PARAMETERS
params = [];

%% DEFINE INPUTS AND OUTPUTS
%% DEFINE INPUTS AND OUTPUTS
params.data_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Data\RWD_Enrica\cohort1';
params.analysis_folder = 'E:\NAS_SD\SuiviClient\Triffilieff\2023\Analyses\RWD_Enrica\cohort1';
params.figure.folder = params.analysis_folder;
                                                                                                                                                                      
results_folder = [params.analysis_folder filesep 'RESULTS'];
load([results_folder filesep 'RESULTS.mat']);

s = size(as.metadata);
b=1:size(as.metadata,1);as.metadata.('LINE_NUM')= b';

all_columns = {'eventname','mouse','date'};
i_column=1;
fig_name=['_']

filter_on_columns(as,as.metadata,all_columns,i_column, results_folder, fig_name)
%     cmd = sprintf("categories = unique(as.metadata.%s)",filterSet{iFilter});eval(cmd);
%     fprintf('here')


function [m_dff, m_transients] =  filter_on_columns(as,metadata,all_columns,i_column, results_folder, fig_name)
    m_dff=[];m_transients=[];
    if i_column<=size(all_columns,2)
        cat=[];
        cmd = sprintf("cat = unique(metadata.%s);",all_columns{i_column});eval(cmd)
        nCat = size(cat,1);
        m_dff_all = nan(nCat,size(as.PSTH.dff_matrix,2));
        m_transients_all = nan(nCat,size(as.PSTH.transients_matrix,2));
        for iCat=1:nCat
            [m_dff, m_transients] = filter_categories(as,metadata,all_columns,i_column,cat{iCat}, results_folder, [fig_name '-' cat{iCat}]);
            m_dff_all(iCat,:)=m_dff;
            m_transients_all(iCat,:)=m_transients;
        end
        fprintf('All Categories of %s have been done\n',print_cell_array(all_columns(i_column:end)))
        [m_dff, m_transients] = make_the_plot(m_dff_all, m_transients_all,results_folder, fig_name);
        fprintf('here')
    end
end

function [m_dff, m_transients] = filter_categories(as,metadata,all_columns,i_column,category, results_folder, fig_name)
    m_dff=[];m_transients=[];
    cmd=sprintf('selected_rows = find(metadata.%s==category);',all_columns{i_column});
    eval(cmd)
    n_rows = size(selected_rows,1);
    fprintf('%d rows selected for %s==%s\n',n_rows,all_columns{i_column},category);
    metadata = metadata(selected_rows,:);
    
    if i_column<size(all_columns,2)
        [m_dff, m_transients] =  filter_on_columns(as,metadata,all_columns,i_column+1, results_folder, fig_name);
    else
        dff_matrix = as.PSTH.dff_matrix(metadata.LINE_NUM,:);
        transients_matrix = as.PSTH.transients_matrix(metadata.LINE_NUM,:);
        [m_dff, m_transients] = make_the_plot(dff_matrix, transients_matrix, results_folder, fig_name);
    end
end

function str_=print_cell_array(cell_array)
     s=size(cell_array,2);str_=[];
     for i=1:s, str_ = [str_ '/' cell_array{i}];end
end

function [m_dff, m_transients] = make_the_plot(dff_matrix, transients_matrix,results_folder, fig_name)

    fig=figure('name',fig_name);
    subplot(2,2,1)
    hold on
    title('dff')
    imagesc(dff_matrix)
    colorbar
    subplot(2,2,2)
    hold on
    title('transients')
    imagesc(transients_matrix)
    colorbar
    subplot(2,2,3)
    hold on
    title('dff')
    m_dff=mean(dff_matrix);
    std_dff=std(dff_matrix,0,1);
    plot(m_dff,'k')
    plot(m_dff+std_dff,'k:')
    plot(m_dff-std_dff,'k:')
    subplot(2,2,4)
    hold on
    title('transients')
    m_transients=mean(transients_matrix);
    std_transients=std(transients_matrix,0,1);
    plot(m_transients,'k')
    plot(m_transients+std_transients,'k:')
    plot(m_transients-std_transients,'k:')
    f = [results_folder filesep fig_name '.png'];
    print(fig,f, '-dpng');
    fprintf('%s DONE\n',fig_name)
    close(fig);
    
end







