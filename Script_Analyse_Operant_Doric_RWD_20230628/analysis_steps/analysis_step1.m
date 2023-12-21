function step1_data = analysis_step1(params, f)

switch params.acquisition_system
    case 'Doric'
        %% LOAD DORIC DATA
        step1_data = open_doric(f, params);              
    case 'RWD' 
        step1_data = open_rwd(f, params);    
end   


step1_data.sfreq = 1/mean(diff(step1_data.time));

rc = params.recording_config;

step1_data = decodeComplexTTL(step1_data,  rc);
imetronic_DB = synchronize_imetronic_data(f,  rc, step1_data);
step1_data = extract_imetronic_events(step1_data,  rc, imetronic_DB);
step1_data = extract_events_from_file(f, step1_data, rc);


photo_plots(params, step1_data, 'deinterleaved signals');

%% LEFT TRIM TO REMOVE STRONG PHOTOBLEATCHING AT THE BEGINNING
[step1_data.time, step1_data.iso, step1_data.physio] = left_trim_signals(step1_data.time, step1_data.iso, step1_data.physio, params.left_trim_dur_sec);

if isfield(step1_data, 'hardware_events'), step1_data.hardware_events = left_trim_events(step1_data.hardware_events, step1_data.time, params.left_trim_dur_sec); end
if isfield(step1_data, 'behavioral_events'), step1_data.behavioral_events = left_trim_events(step1_data.behavioral_events, step1_data.time, params.left_trim_dur_sec); end

%% FIT ISO
step1_data.fit_iso = fit_iso(step1_data.iso, step1_data.physio);
photo_plots(params, step1_data, 'fit iso');

%% PROCESS DFF
step1_data.dff = calculate_dff(step1_data.time, step1_data.fit_iso, step1_data.physio)*100.0;

%photo_plots(data, 'dff_debug');
photo_plots(params, step1_data, 'dff');

%% EXTRACT TRANSIENTS
% data.transients = get_transients(data.time, data.dff, params.debug);
% photo_plots(params, data, 'transients');

if isfield(params,'step1_postprocessing_functions')
    n = size(params.step1_postprocessing_functions,2);
    for i=1:n
        step1_data = params.step1_postprocessing_functions{i}(step1_data, rc, params);
    end    
end




