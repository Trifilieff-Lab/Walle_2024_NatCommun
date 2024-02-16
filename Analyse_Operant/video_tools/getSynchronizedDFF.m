function [dff_synchronized, t_synchronized] = getSynchronizedDFF(s, debug_mode)
    frame_times =s.dio3.raising_times;
    photo_times = s.dein_signals.time;
    frame_dff = interp1(photo_times,s.dff,frame_times);
    t_synchronized = frame_times;
    dff_synchronized = frame_dff;
    if debug_mode
        figure()
        hold on
        plot(photo_times,s.dff,'r+:')
        plot(frame_times, frame_dff,'g+')
    end

