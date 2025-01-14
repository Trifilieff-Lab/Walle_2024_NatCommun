function data = open_doric(filepath,params)

%% argument to enable the plot of debug figures
debug = params.debug;
recording_config = params.recording_config;

%% PARAMETERS START
%remove artifacts from chuncks
artifact_th_high = 10; % MAD
artifact_th_low = 1; % MAD
%PARAMETERS STOP

%% LOAD DORIC DATA
[header, raw_data] = load_doric_csv(filepath);
try
    doric_data = doric_csv_to_data_structure(header,raw_data, recording_config);clear raw_data; %data variable is huge, it needs to be cleaned has soon has possible
catch
    warning('Please double check your recording configuration in the user main file that your run at first.')
end

%% REMOVE MISSING VALUES
doric_data = remove_missing_values(doric_data,recording_config);

%% MEASURE SAMPLING FREQUENCY
doric_data = detect_sampling_frequency(doric_data);

%% DETECT LED 405nm and 470nm ACTIVITIES
doric_data = get_photo_pulses(doric_data); %detect LED 405 and 470 on/off
plot_pulses_detection(doric_data, debug); %plot here for debug only
plot_pulses_durations(doric_data, debug); %plot here for debug only

%% DEINTERLEAVED
% we truncate AnlaogIn #1 sig to extract iso and physio signals based on
% median duration
[t_chunks, iso_chunks, physio_chunks] = raw_deinterleaved_signals(doric_data);% using LED on/off info
% TEST PLOTS
plot_raw_deinterleaved_signals(t_chunks, iso_chunks, physio_chunks, debug);

%% REMOVE EXCITATION ARTIFACTS
% because LED are not stable
% those artifacts always happend at the beginning of each chunk
% this is a method to remove them
[iso_artifact_idx] = find_artifact_idx(iso_chunks, artifact_th_high, artifact_th_low);
iso_artifact_id = ceil(prctile(iso_artifact_idx, 95));
[physio_artifact_idx] = find_artifact_idx(physio_chunks, artifact_th_high, artifact_th_low);
physio_artifact_id = ceil(prctile(physio_artifact_idx, 95));
% TEST PLOTS
plot_artifact_idx(iso_chunks, iso_artifact_idx, 'iso', debug);
plot_artifact_idx(physio_chunks, physio_artifact_idx, 'physio', debug);
artifact_id = max([iso_artifact_id, physio_artifact_id]);
[t_chunks, iso_chunks, physio_chunks] = clean_deinterleaved_signals(t_chunks, iso_chunks, physio_chunks, artifact_id);
[t, iso, physio] = avg_deinterleaved_signals(t_chunks, iso_chunks, physio_chunks);


doric_data = extract_all_TTL_info(doric_data,recording_config);

% doric_data= decodeComplexTTL(doric_data, recording_config);
% 
% 
% if isfield(recording_config,'Imetronic_Synchro')
%     imetronic_DB= synchronize_imetronic_data(filepath, recording_config, doric_data);
%     doric_data= extract_imetronic_events(doric_data, recording_config, imetronic_DB);
% end


%% UPDATE STRUCTURE BEFORE RETURNING IT
data.time = t;
data.iso = iso;
data.physio = physio;
data.sfreq = 1/mean(diff(data.time))
try
    data.behavioral_events=doric_data.behavioral_events;
end
try
    data.hardware_events=doric_data.hardware_events;
end

fields_ = fields(doric_data);
for iF=1:length(fields_)
    if strfind(fields_{iF},'ComplexTTL')
        data.(fields_{iF})=doric_data.(fields_{iF});
    end
end


end

%% SUBFUNCTIONS

function [header, data] = load_doric_csv(filepath)
% This function take a path to a doric csv file and return the headers
% of the columns in header_raw as well as all the data
n_line_header = 2; % In 2021 Doric csv file has two lines of header
fp = fopen(filepath,'r'); % Open the csv file in read mode 'r'
for i=1:n_line_header, tline = fgetl(fp); end  %owerwrite first line, only second line has an inerrest
% Upon closer inspection, it seems that only the second line has interesting info
% We get the column names, removing extra spaces because it is probably more convenient
tline = strrep(tline,' ', ''); %remove spaces
tline = strrep(tline,'--', '/'); % Sometimes this wonderful software replaces '/' with '--' so we try to compensate
header = split(tline,','); % split by coma (csv file) and return the header of each column in an cell array call header
data = dlmread(filepath,',',2,0);%[2 0 12000*60 10]); % read everything from the 3 line (skip 2) without skipiing columns (0) and place it in a 2D matrix called data
end

function channel_name = get_channel_name(DoricName,recording_config)
channel_name = 'None';
n=size(recording_config,2);
for i=1:n
    if strcmp(recording_config{i}{1},DoricName)
        channel_name = recording_config{i}{2};
    end
end
if iscell(channel_name)
    channel_name = channel_name{1}
end
end

function doric_data = doric_csv_to_data_structure(h,d,recording_config)
%Based on the Header of the csv file, disscoiate the data into separate
%variables, the advantage is that if the column order changes you can
%still collect your data
doric_data.time = d(:,find(ismember(h,'Time(s)')));
for i=1:4
    channel_name = get_channel_name(sprintf('DIO%d',i),recording_config);
    if ~strcmp(channel_name,'None')
        cmd = sprintf('doric_data.%s = [];',channel_name);eval(cmd);
        cmd = sprintf('doric_data.%s.raw_signal = d(:,find(ismember(h,\''DI/O-%d\'')));',channel_name,i);eval(cmd);
    end
    channel_name = get_channel_name(sprintf('AIn%d',i),recording_config);
    if ~strcmp(channel_name,'None')
        cmd = sprintf('doric_data.%s = [];',channel_name);eval(cmd);
        cmd = sprintf('doric_data.%s.raw_signal = d(:,find(ismember(h,\''AIn-%d\'')));',channel_name,i);eval(cmd);
    end
end
end

function doric_data = remove_missing_values(doric_data,recording_config)
%Sometimes Doric Systems could not save the data and there is a zero in
%the doric_data.AIn1, so we will remove this lines
zero_idx = find(doric_data.GCaMP.raw_signal==0);
s = max(size(zero_idx));
n = max(size(doric_data.GCaMP.raw_signal));
fprintf('%d (%2.2f%%) missing values have been detected\n',s, (s/n)*100.0 );
doric_data.time(zero_idx)=[];
for i=1:4
    channel_name = get_channel_name(sprintf('DIO%d',i),recording_config);
    if ~strcmp(channel_name,'None')
        cmd = sprintf('m = length(doric_data.%s.raw_signal); if m>1, doric_data.%s.raw_signal(zero_idx)=[];end',channel_name,channel_name);eval(cmd);
    end
    channel_name = get_channel_name(sprintf('AIn%d',i),recording_config);
    if ~strcmp(channel_name,'None')    
        cmd = sprintf('m = length(doric_data.%s.raw_signal); if m>1, doric_data.%s.raw_signal(zero_idx)=[];end',channel_name,channel_name);eval(cmd);
    end
end
end

function doric_data = detect_sampling_frequency(doric_data)
dt = diff(doric_data.time);
if (min(dt)==0), fprintf('error in data file, timestamps are duplicated !!!');end
doric_data.sfreq = 1.0/median(dt);
fprintf('Doric file was recorded at %2.2fHz\n',doric_data.sfreq);
end

function [idx_on,idx_off] = detect_digital_pulses(sig)
% In doric csv file, there columns storing the value of the digital I/O,
% these vales are equal to 0 or 1, using the derivative we can easly find
% transition from 0 to 1 or from 1 to 0
d = diff(sig);
idx_on = find(d==1);
idx_off = find(d==-1);
end

function doric_data = get_photo_pulses(doric_data)

%% First we extract the signal controling the 405nm LED (dio1) and the 470nm LED (dio2)
[on1_idx,off1_idx] = detect_digital_pulses(doric_data.LED405.raw_signal);
[on2_idx,off2_idx] = detect_digital_pulses(doric_data.LED470.raw_signal);

%% Ensure that vector have same size (same number of LED completed Pulses Gcamp and ISO)
%if the last iso (405 nm) pulse (digOut1), pulse has been cut in the middle, we remove the
%last on_idx value
if size(off1_idx,1) < size(on1_idx,1), on1_idx(end)=[]; end
%if the last signal (470 nm) pulse (digOut2), pulse has been cut in the middle, we remove the
%last on_idx value
if size(off2_idx,1) < size(on2_idx,1), on2_idx(end)=[]; end

%if the last pulse is an iso pulse we remove it because we start by an
%iso pulse.
if size(on2_idx,1) < size(on1_idx,1), on1_idx(end)=[];off1_idx(end)=[]; end
doric_data.LED405.on_idx = on1_idx;
doric_data.LED405.off_idx = off1_idx;
doric_data.LED470.on_idx = on2_idx;
doric_data.LED470.off_idx = off2_idx;

end

function [on_idx, off_idx] = extract_TTL_events(digital_signal)
m = length(digital_signal);
on_idx=[];off_idx=[];
if m>1
    [on_idx,off_idx] = detect_digital_pulses(digital_signal);
    if size(off_idx,1) < size(on_idx,1)
        on_idx(end)=[];
    end
end
end

function trunc = extract_signal(idx_pulse_on, idx_pulse_off, sig)
% Doric system record a continous AIn1 which contains interleaved
% physio and iso signals. Using LED on and off times (indices here) whe
% can truncate AIn1 in small section corresponding to one led
% only.
min_pulse_width = min(idx_pulse_off-idx_pulse_on);
n_Samples = size(idx_pulse_on,1);
trunc = nan(n_Samples,min_pulse_width);
for i=1:n_Samples
    j = idx_pulse_on(i);
    k = j + min_pulse_width -1;
    trunc(i,:) = sig([j:k]);
end
end

function [t_chunks, sig1_chunks, sig2_chunks] = raw_deinterleaved_signals(doric_data)
%based on the LED states (O or 1) for 405 nm and 470 nm we truncate
%AnalogIn #1 and time vectors
[t,a,i1_on,i1_off,i2_on,i2_off] = expose_raw_signal_values(doric_data);
t_chunks = extract_signal(i1_on, i1_off, t);
sig1_chunks = extract_signal(i1_on, i1_off, a);
sig2_chunks = extract_signal(i2_on, i2_off, a);
end

function [trim_thresholds] = find_artifact_idx(sig, high_th, low_th)
n_Samples = size(sig,2);
abs_diff_sig = abs(diff(sig,1,2));
trim_thresholds = nan(n_Samples,1);
for i=1:n_Samples
    mad_ = mad(abs_diff_sig(i,floor(n_Samples/4):end));
    idx1 = find(abs_diff_sig(i,:)>(high_th*mad_),1,'last');
    idx2 = find(abs_diff_sig(i,idx1:end)<(low_th*mad_),1,'first');
    if ~isempty(idx2) && ~isempty(idx1)
        trim_thresholds(i) = idx2 + idx1;
    else
        trim_thresholds(i) = size(sig,1);
    end
end
end

function [t_chunks, iso_chunks, physio_chunks] = clean_deinterleaved_signals(t_chunks, iso_chunks, physio_chunks, trim_id)
t_chunks = t_chunks(:,trim_id:end);
iso_chunks = iso_chunks(:,trim_id:end);
physio_chunks = physio_chunks(:,trim_id:end);
end

function [t, iso, physio] = avg_deinterleaved_signals(t_chunks, iso_chunks, physio_chunks)
t = mean(t_chunks,2);
iso = mean(iso_chunks,2);
physio = mean(physio_chunks,2);
end

function [t,a,i1_on,i1_off,i2_on,i2_off] = expose_raw_signal_values(doric_data)
% a simple function to acess the element of the raw-signals structure with
% shorter variable names
t = doric_data.time;
a = doric_data.GCaMP.raw_signal;
i1_on = doric_data.LED405.on_idx;
i1_off = doric_data.LED405.off_idx;
i2_on = doric_data.LED470.on_idx;
i2_off = doric_data.LED470.off_idx;
end

function doric_data = extract_all_TTL_info(doric_data, recording_config)
    
    digital_signal=[];
    n=size(recording_config,2);
    t = doric_data.time;
    doric_data.behavioral_events = [];

    for i=1:n
        
        r=recording_config{i};
        
        try
            
            if strcmp(r{3},'extract_as_TTL') || strcmp(r{3},'extract_as_ComplexTTL')
                varname = r{2};
                if iscell(varname), varname=varname{1};end
                cmd = sprintf('digital_signal=doric_data.%s.raw_signal;',varname);eval(cmd);
                if strcmp(r{1}(1),'A'), digital_signal=digital_signal>3.3;end
                [on_idx, off_idx] = extract_TTL_events(digital_signal);

                if strcmp(r{3},'extract_as_TTL')
%                         cmd = sprintf('doric_data.%s.%s.on_idx=on_idx;',r{4},r{2});eval(cmd);
%                         cmd = sprintf('doric_data.%s.%s.off_idx=off_idx;',r{4},r{2});eval(cmd);
                        cmd = sprintf('doric_data.%s.%s.on_ts=t(on_idx);',r{4},r{2});eval(cmd);
                        cmd = sprintf('doric_data.%s.%s.off_ts=t(off_idx);',r{4},r{2});eval(cmd);
                        doric_data= rmfield(doric_data,varname);
                else
%                         cmd = sprintf('doric_data.%s.on_idx=on_idx;',r{2});eval(cmd);
%                         cmd = sprintf('doric_data.%s.off_idx=off_idx;',r{2});eval(cmd);
                        cmd = sprintf('doric_data.%s.on_ts=t(on_idx);',r{2});eval(cmd);
                        cmd = sprintf('doric_data.%s.off_ts=t(off_idx);',r{2});eval(cmd);
                        cmd = sprintf('doric_data.%s=rmfield(doric_data.%s,''raw_signal'');',r{2},r{2});eval(cmd);
                end
            end
        catch 
            r
        end
    end
    clear digital_signal
end



%% DEBUG PLOT FUNCTIONS

function plot_pulses_detection(doric_data, debug)
if debug.mode
    [t,a,i1_on,i1_off,i2_on,i2_off] = expose_raw_signal_values(doric_data);
    fig=figure();
    hold on
    plot(t,a,'k');
    plot(t(i1_on),a(i1_on),'m^');
    plot(t(i1_off),a(i1_on),'mv');
    plot(t(i2_on),a(i1_on),'b^');
    plot(t(i2_off),a(i1_on),'bv');
    smart_save_figures(fig, debug, 'pulses_detection');
end
end

function plot_pulses_durations(doric_data, debug)
if debug.mode
    [t,a,i1_on,i1_off,i2_on,i2_off] = expose_raw_signal_values(doric_data);
    fig=figure();
    subplot(1,2,1)
    title('iso pulses duration')
    hold on
    histogram(i1_off-i1_on,'FaceColor','m')
    pulse1_width = median(i1_off-i1_on);
    subplot(1,2,2)
    title('physio pulses duration')
    hold on
    histogram(i2_off-i2_on,'FaceColor','b')
    pulse2_width = median(i2_off-i2_on);
    smart_save_figures(fig, debug, 'durations')
end
end

function plot_raw_deinterleaved_signals(t_tr, iso_tr, physio_tr, debug)
if debug.mode
    fig=figure();
    subplot(1,2,1)
    title('iso chuncks')
    hold on
    plot(iso_tr','m');
    subplot(1,2,2)
    title('physio chuncks')
    hold on
    plot(physio_tr','b');
    smart_save_figures(fig, debug, 'deinterleaved_chunks')
end
end

function plot_artifact_idx(chuncks, trim_idx, sig_str, debug)
if debug.mode
    abs_diff_chunk = abs(diff(chuncks,1,2));
    fig=figure();
    title(sprintf('trim %s',sig_str))
    hold on
    plot(abs_diff_chunk','m');
    s = size(trim_idx);
    s = s(1);
    for i=1:s
        plot([trim_idx(i) trim_idx(i)],[0 1],'color',[0.5 0.5 0.5]);
    end
    plot([median(trim_idx) median(trim_idx)],[0 1],'color',[1 0 0], 'linewidth',2);
    smart_save_figures(fig, debug, [sig_str '_artifact_idx'])
end
end

function plot_dio_signal(t,sig, i_on, i_off, title_, debug)
if debug.mode
    fig=figure();
    title(title_)
    hold on
    plot(t,sig,'k');
    plot(t(i_on),sig(i_on),'g^');
    plot(t(i_off),sig(i_off),'gv');
    ylim([-1 2]);
    smart_save_figures(fig, debug, title_);
end
end

















