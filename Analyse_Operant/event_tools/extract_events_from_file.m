function data = extract_events_from_file(filepath, data, rc)

    [path_,name,ext] = fileparts(filepath);
 
    n = size(rc,2);
    for i=1:n
        tmp = rc{i};
        if strcmp(tmp{1},'EventFile')          
            e = readtable([path_ filesep name tmp{3}]);
            event_times_msec = e.Time_msec(find(strcmp(e.Events, tmp{2})))
            cmd = sprintf('data.%s.%s.on_ts=event_times_msec/1000;',tmp{4},tmp{2});
            eval(cmd);
        end
    end

end

