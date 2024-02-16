function goto(dir_shortcut)

code_path = 'C:\Users\apetitbon\Documents\MATLAB\20230628';

try, params = evalin('base','params');end

if exist('params')
    data_path = params.data_folder;
    analysis_path = params.analysis_folder;
else
    data_path = 'E:\NAS_SD\SuiviClient\Triffilieff\2023';
    analysis_path = 'E:\NAS_SD\SuiviClient\Triffilieff\2023';
end

switch dir_shortcut
    case 'code'
        cd(code_path)
    case 'data'
        cd(data_path)
    case 'analysis'
        cd(analysis_path)
end

end