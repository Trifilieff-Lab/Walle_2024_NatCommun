
 filepath = 'E:\NAS_SD\SuiviClient\Triffilieff\RevueCodeJulien\DataExemples\Fichiers Doric\M67350_20220802_sess09_rec1_Pavlovien_M_DELTA_2.csv'

%% LOAD DORIC DATA
[header, data] = load_doric_csv(filepath);
raw_signals = doric_csv_to_data_structure(header,data);






function [header, data] = load_doric_csv(filepath)
% This function take a path to a doric csv file and return the headers
% of the columns in header_raw as well as all the data
n_line_header = 2; % In 2021 Doric csv file has two lines of header
fp = fopen(filepath,'r'); % Open the csv file in read mode 'r'
for i=1:n_line_header, tline = fgetl(fp); end  %owerwrite first line, only second line has an inerrest
% Upon closer inspection, it seems that only the second line has interesting info
% We get the column names, removing extra spaces because it is probably more convenient
tline = strrep(tline,' ', ''); %remove spaces
tline = strrep(tline,'--', '/'); % Sometimes this wonderful software replaces '/' with '--' so we try to compensate
header = split(tline,','); % split by coma (csv file) and return the header of each column in an cell array call header
data = dlmread(filepath,',',2,0); % read everything from the 3 line (skip 2) without skipiing columns (0) and place it in a 2D matrix called data
end

function raw_signals = doric_csv_to_data_structure(h,d)
%Based on the Header of the csv file, disscoiate the data into separate
%variables, the advantage is that if the column order changes you can
%still collect your data
raw_signals.time = d(:,find(ismember(h,'Time(s)')));
raw_signals.digitalOut1 = d(:,find(ismember(h,'DI/O-1')));
raw_signals.digitalOut2 = d(:,find(ismember(h,'DI/O-2')));
raw_signals.digitalOut3 = d(:,find(ismember(h,'DI/O-3')));
raw_signals.digitalOut4 = d(:,find(ismember(h,'DI/O-4')));
raw_signals.analogIn1 = d(:,find(ismember(h,'AIn-1')));
raw_signals.analogIn2 = d(:,find(ismember(h,'AIn-2')));
raw_signals.analogIn3 = d(:,find(ismember(h,'AIn-3')));
raw_signals.analogIn4 = d(:,find(ismember(h,'AIn-4')));
end



