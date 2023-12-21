function  imetronic_DB= synchronize_imetronic_data(filepath, recording_config, data)

    [filepath_,name,ext] = fileparts(filepath);
    filelist = dir([filepath_ filesep '*.dat']);

    if  ~length(filelist)
        imetronic_DB = []
        return
    end   

    
    imetronic_path = [filepath_ filesep filelist(1).name];

    if  ~exist(imetronic_path, 'file')
        imetronic_DB = []
        return
    end

    imetronic_rawdata = load_imetronic_rawdata(imetronic_path);
    imetronic_DB = parse_imetronic_data(imetronic_rawdata);
    r = recording_config;
    n = size(r,2);
    

    for i=1:n
        tmp = r{i};
        if strcmp(tmp{1},'Imetronic_Synchro')
            cmd = sprintf('photo_synchro=data.behavioral_events.%s.on_ts;',tmp{3});eval(cmd);
            tmp_func =  tmp{4};
            ime_synchro = tmp_func(imetronic_DB);
            if size(ime_synchro,1)~=size(photo_synchro,1), warning('imetronic synchro is not perfect');end
            s=size(ime_synchro);

            i1=1;
            prev_time=0;
            for j=1:s
                % on cherche l'élément de synchro dans le fichier imetronic
                i2 = find(imetronic_rawdata(:,1)==ime_synchro(j),1,'last');
                prev_time = imetronic_rawdata(i2,1);
                % on corrige les ts imetronik avec le premier élément de synchro rwd
                imetronic_rawdata(i1:i2,1) = imetronic_rawdata(i1:i2,1) - imetronic_rawdata(i2,1);
                imetronic_rawdata(i1:i2,1) = imetronic_rawdata(i1:i2,1) + (photo_synchro(j)*1000.0) ; 
                i1 = i2 + 1;
            end
            i1=i2;
            imetronic_rawdata(i1,1) = 0;
            imetronic_rawdata(i1+1:end,1) = imetronic_rawdata(i1+1:end,1) - prev_time;
            imetronic_rawdata(i1:end,1) = imetronic_rawdata(i1:end,1) + (photo_synchro(end)*1000.0);
            imetronic_DB = parse_imetronic_data(imetronic_rawdata);
        end
    end

end

