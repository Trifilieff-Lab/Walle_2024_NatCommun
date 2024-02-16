function [t,x,y]=getBonsaiData(bonsai_path, video_freq_Hz)
    vt = readtable(bonsai_path, 'ReadVariableNames', true);
    x = vt.X;y = vt.Y;
    vt_samples_num = length(x);
    t = (1:vt_samples_num)/video_freq_Hz;
end