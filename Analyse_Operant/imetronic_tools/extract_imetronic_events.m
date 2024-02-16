function  data= extract_imetronic_events(data, recording_config, imetronic_DB)
    r = recording_config;
    n = size(r,2);
    for i=1:n
        tmp = r{i};
        if strcmp(tmp{1},'Imetronic_Event')
            events = tmp{3}(imetronic_DB);
            cmd = sprintf('data.%s.%s.on_ts=events/1000;',tmp{4},tmp{2});eval(cmd);
        end
    end
end