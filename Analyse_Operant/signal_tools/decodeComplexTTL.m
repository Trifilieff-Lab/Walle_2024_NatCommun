function data= decodeComplexTTL(data, recording_config)
    t = data.time;
    data_fields = fields(data);
    nFields = size(data_fields,1);
    for iField=1:nFields
        if strfind(data_fields{iField},'ComplexTTL')
            n_rec_config=size(recording_config,2);
            for i_rec_config=1:n_rec_config
                if strcmp(data_fields{iField},recording_config{i_rec_config}{2})
                    cmd = sprintf('on_ts = data.%s.on_ts;',data_fields{iField});eval(cmd)
                    cmd = sprintf('off_ts = data.%s.off_ts;',data_fields{iField});eval(cmd)
%                     cmd = sprintf('on_idx = data.%s.on_idx;',data_fields{iField});eval(cmd)
%                     cmd = sprintf('off_idx = data.%s.off_idx;',data_fields{iField});eval(cmd)
                    pulses_durations = off_ts - on_ts;
                    tags_ = recording_config{i_rec_config}{5};
                    limits_ = recording_config{i_rec_config}{6};
                    n_tags = size(tags_,2);
                    for i_tag=1:n_tags
                        lim = limits_(i_tag);
                        lim = lim{1};
                        idx1 = find(pulses_durations>=lim(1));
                        idx2 = find(pulses_durations<=lim(2));
                        idx = intersect(idx1,idx2);
                        event_type=recording_config{i_rec_config}{4};
%                          cmd = sprintf('data.%s.%s.on_idx=on_idx(idx);', event_type, tags_{i_tag});eval(cmd);
%                          cmd = sprintf('data.%s.%s.off_idx=off_idx(idx);', event_type, tags_{i_tag});eval(cmd);
                         cmd = sprintf('data.%s.%s.on_ts=on_ts(idx);', event_type, tags_{i_tag});eval(cmd);
                         cmd = sprintf('data.%s.%s.off_ts=off_ts(idx);', event_type, tags_{i_tag});eval(cmd);                                            
                    end                    
                end
            end
            data= rmfield(data,data_fields{iField});
        end
    end
end


