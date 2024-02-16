filepath = "F:\Data Lola PAVLOV Doric\M_58665\58665_20221117_sess03_rec1_def_nac.csv"
  
  
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

figure()
hold on
% plot(data(1:1000:end,1),data(1:1000:end,10),'r*-')
% plot(data(1:1000:end,1),data(1:1000:end,11),'b*-')
plot(data(1:12000,10),'r*-')
plot(data(1:12000,11),'b*-')
figure()
hold on
plot(data(1:12000,1),data(1:12000,6),'r*-')