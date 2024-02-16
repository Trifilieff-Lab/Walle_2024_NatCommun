%% CLEAR AND INITIALIZE
clear 
close all
clc


source_dir = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataAnna\Traitement DOX';
dest_dir = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataAnna\Traitement_DOX_';

if ~exist(dest_dir)
    mkdir(dest_dir)
end

listing = dir([source_dir filesep '*.avi'])
for i=3:size(listing,1)
    f = listing(i).name;
    disp(f);
    info=parse_filenames(f,'Anna');
    mouse_dir = [dest_dir filesep info.mouse];
    if ~exist(mouse_dir)
        mkdir(mouse_dir)
    end
    
    % path du fichier avi
    source_file_avi = [source_dir filesep f];
    dest_file_avi = [mouse_dir filesep f];
  
    %path du fichier avi
    tmp = split(f,'.')
    listing2 = dir([source_dir filesep tmp{1} '*.csv']);
    if size(listing2,1)>0
        f2 = listing2(1).name;
        source_file_csv = [source_dir filesep f2];
        dest_file_csv = [mouse_dir filesep tmp{1} '.csv'];
        if ~exist(dest_file_csv)
            copyfile(source_file_csv, dest_file_csv, 'f'); 
        end
        if ~exist(dest_file_avi)
            copyfile(source_file_avi, dest_file_avi, 'f'); 
        end  
    end

    disp('.')
    
    
end



