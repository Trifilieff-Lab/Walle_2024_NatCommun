function data = define_behavioral_periods(data, r)
    n = size(r,2);
    
    for i=1:n
        tmp = r{i};
        if strcmp(tmp{1},'behavioral_periods_starts')
            cmd = sprintf('starts=data.behavioral_events.%s.on_ts;',tmp{2});eval(cmd);
            m = size(starts,1);
            for j=1:m
                data.behavioral_periods(j).period_start_ts = starts(j);
            end
        end
    end
    
    for i=1:n
        tmp = r{i};
        if strcmp(tmp{1},'behavioral_periods_baselines')
            cmd = sprintf('starts=data.behavioral_events.%s.on_ts;', tmp{2});eval(cmd);
            m = size(starts,1);
            for j=1:m
                data.behavioral_periods(j).baseline_start_ts = starts(j) + tmp{3}/1000;
                data.behavioral_periods(j).baseline_stop_ts = starts(j) + tmp{4}/1000;
            end
        end
    end

    
end