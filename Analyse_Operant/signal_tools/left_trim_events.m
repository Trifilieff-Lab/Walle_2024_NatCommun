function events = left_trim_events(events, t, duration_sec)
    fields = fieldnames(events);
    nFields = size(fields,1);
    for iField = 1:nFields
        tmp=[];
        cmd = sprintf('tmp = events.%s.on_ts;',fields{iField});eval(cmd);
        i = find(tmp>duration_sec,1,'first');
        cmd = sprintf('events.%s.on_ts=events.%s.on_ts(i:end);',fields{iField},fields{iField});eval(cmd);
        try
            cmd = sprintf('events.%s.off_ts=events.%s.off_ts(i:end);',fields{iField},fields{iField});eval(cmd);
        end
        try
            cmd = sprintf('events.%s.on_idx=events.%s.on_idx(i:end);',fields{iField},fields{iField});eval(cmd);
        end
        try
            cmd = sprintf('events.%s.off_idx=events.%s.off_idx(i:end);',fields{iField},fields{iField});eval(cmd);
        end
        try
            cmd = sprintf('events.%s.id_in_period=events.%s.id_in_period(i:end);',fields{iField},fields{iField});eval(cmd);
        end
        try
            cmd = sprintf('events.%s.periods=events.%s.periods(i:end);',fields{iField},fields{iField});eval(cmd);
        end
    end    
end

