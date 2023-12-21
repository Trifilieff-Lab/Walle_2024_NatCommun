function creates_info_table(data_folder, system, info_table_path,user_parse_filename_function)
    fid = fopen(info_table_path,'w');
    write_header(fid,user_parse_filename_function);
    switch system
        case 'Doric'
            lookdown_Doric(data_folder, fid,user_parse_filename_function);
        case 'RWD'
            lookdown_RWD(data_folder, fid,user_parse_filename_function);
    end
    fclose(fid);   
end

function write_header(fid,user_parse_filename_function)
    info = user_parse_filename_function();
    fields = fieldnames(info);
    nFields = size(fields,1);
    if ~nFields
        error('please check your parse_filename function');
        quit(0);
    end
    fprintf(fid,'%s',fields{1});     
    for i=2:nFields
        fprintf(fid,'\t');
        fprintf(fid,'%s',fields{i});     
    end
     fprintf(fid,'\tfilepath\n');
end

function write_content(fid,user_parse_filename_function, info_in_path, filepath)
    info=user_parse_filename_function(info_in_path);
    fields = fieldnames(info);
    nFields = size(fields,1);
    if ~nFields
        error('please check your parse_filename function')
        quit(0);
    end
    str_tmp = '%s';
    str_tmp2 = '';
    str_tmp2 = sprintf(',info.%s', fields{1});
    for i=2:nFields
        str_tmp = [str_tmp '\t%s'];
        str_tmp2 = [str_tmp2 sprintf(',info.%s', fields{i})];
    end
      
    str = sprintf('fprintf(fid,''%s''%s);',str_tmp,str_tmp2);
    eval(str);
    fprintf(fid,'\t%s\n',filepath);
end

function lookdown_Doric(data_folder, fid,user_parse_filename_function)
    
    l = dir([data_folder filesep '*']) ;
    n=size(l,1);
    for i=3:n
        if l(i).isdir
            lookdown_Doric([data_folder filesep l(i).name], fid, user_parse_filename_function);
        end
    end
    
    csv_list = dir([data_folder filesep '*.csv']) ;
    n_csv = size(csv_list,1);
    for i_csv=1:n_csv
        write_content(fid,user_parse_filename_function, csv_list(i_csv).name, [data_folder filesep csv_list(i_csv).name]);
    end   

  
end

function lookdown_RWD(data_folder, fid,user_parse_filename_function)
    
    l = dir([data_folder filesep '*']) ;
    n=size(l,1);
    for i=3:n
        if l(i).isdir
            lookdown_RWD([data_folder filesep l(i).name], fid, user_parse_filename_function);
        end
    end
    
    csv_list = dir([data_folder filesep 'Fluorescence.csv']) ;
    if size(csv_list,1)==1
        f=csv_list.folder; 
        f=split(f,filesep);  
        write_content(fid,user_parse_filename_function,f{end-1}, [data_folder filesep 'Fluorescence.csv']);
    end


end




