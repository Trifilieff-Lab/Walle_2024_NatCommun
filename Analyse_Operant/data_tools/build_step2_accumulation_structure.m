function as = build_step2_accumulation_structure(params, step1)

    % estimate sampling frequency to transform time values into array indices values
    t = step1.time;
    sfreq = round(1/median(diff(t)));
    
    as.sfreq = sfreq;
    
    %% signal will be cut in time_windows surrounding each event
    % the limits of each time_window has been defined at the beginning of
    % the function in two variables which are : before_msec and after_msec
    
    as.PEATS.before_idx = ceil((params.PEATS.before_msec/1000)*sfreq);
    as.PEATS.after_idx = ceil((params.PEATS.after_msec/1000)*sfreq);  
    as.PEATS.size_idx = abs(as.PEATS.before_idx) + abs(as.PEATS.after_idx);
    as.PEATS.before_msec = params.PEATS.before_msec;
    as.PEATS.after_msec = params.PEATS.after_msec;
    as.PEATS.x = linspace(as.PEATS.before_msec,as.PEATS.after_msec,as.PEATS.size_idx);     
    
    as.PEATS.matrix  = nan(1,as.PEATS.size_idx);
    as.PEATS.matrix_nc = as.PEATS.size_idx;
    as.PEATS.auc = nan(1,1);
    

end