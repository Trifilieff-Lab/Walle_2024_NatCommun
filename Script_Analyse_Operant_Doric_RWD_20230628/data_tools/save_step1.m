function save_step1(params, step1_data)
 save([params.figure.folder filesep params.figure.prefix '_step1.mat'],'step1_data', 'params');
end