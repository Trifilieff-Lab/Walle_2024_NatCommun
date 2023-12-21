%% CLEAR AND INITIALIZE
clear 
close all
clc


source_dir = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataRoman';
dest_dir = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataRoman';

if ~exist(dest_dir)
    mkdir(dest_dir)
end

listing = dir(source_dir);

for i=3:size(listing,1)
    
    f = listing(i).name;
    fprintf('******%s\n',f);
    tmp = split(f,'D');
    info.mouse = tmp(1);
    info.dopamine = tmp(2);
    
    
    if ~exist([dest_dir filesep f])
        mkdir([dest_dir filesep f])
    end
    
    
    listing2 = dir([source_dir filesep f filesep '*.avi']);
    for i=3:size(listing2,1)
            f2 = listing2(i).name;
            disp(f2);
            source_file_avi = [source_dir filesep f filesep f2];
            dest_file_avi =   [dest_dir filesep f filesep f2];
            tmp = split(f2,'.')
            listing3 = dir([source_dir filesep f filesep tmp{1} '*.csv'])
            if size(listing3,1)>0
                f3 = listing3(1).name;
                source_file_csv = [source_dir filesep f filesep f3];
                dest_file_csv =   [dest_dir filesep f filesep tmp{1} '.csv']; 
                
                if ~exist(dest_file_csv)
                    copyfile(source_file_csv, dest_file_csv, 'f'); 
                end
                if ~exist(dest_file_avi)
                    copyfile(source_file_avi, dest_file_avi, 'f'); 
                end
            end
            
            
        
    end
    
    
%     info=parse_filenames(f,'Anna');
%     mouse_dir = [dest_dir filesep info.mouse];
%     if ~exist(mouse_dir)
%         mkdir(mouse_dir)
%     end
%     
%     source_file = [source_dir filesep f];
%     dest_file = [mouse_dir filesep f];
%     copyfile(source_file, dest_file, 'f')
%     
%     tmp = split(f,'.')
%     listing2 = dir([source_dir filesep tmp{1} '*.csv'])
%     
%     
%     f2 = listing2(1).name;
%     source_file = [source_dir filesep f2];
%     dest_file = [mouse_dir filesep tmp{1} '.csv'];
%     copyfile(source_file, dest_file, 'f') 
% 
%     disp('.')
    
    
end



