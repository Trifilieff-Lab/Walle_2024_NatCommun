function info=parse_filename(f,user)

    if strcmp(user,'Anna_01')
        info = parse_anna_01_filenames(f);
    end
    
    if strcmp(user,'Anna_02')
        info = parse_anna_02_filenames(f);
    end
    
    if strcmp(user,'Roman')
        info = parse_roman_filenames(f);
    end
    
    if strcmp(user,'Lola_01')
        info = parse_lola_01_filenames(f);
    end
    
    
end


function info = parse_anna_01_filenames(f)
f = split(f,'.');
f = f{1};
%f = 'Msp446_20210721_sess9_rec2_SWE_8.csv'
fields = split(f,'_');
info.prefix = f;
info.mouse = fields{1};
info.date = fields{2};
info.session = fields{3}(5:end);
info.rec = fields{4}(4:end);
info.maze_conf = fields{5};
end

function info = parse_anna_02_filenames(f)
f = split(f,'.');
f = f{1};
%f = 'M1_20221207_ses01_rec1_Pavlovien_M_DELTA_2.csv'
fields = split(f,'_');
info.prefix = f;
info.mouse = fields{1};
info.date = fields{2};
info.session = fields{3}(5:end);
info.rec = fields{4}(4:end);
info.beh_task = fields{5};
info.gender = fields{6};
info.group = fields{7};

end

function info = parse_roman_filenames(f)
%f = '45269T2_20_08_21_0.csv'
f = split(f,'.');
f = f{1};
fields = split(f,'_');
info.prefix = f;
tmp = fields{1};
info.day = fields{2};
info.month = fields{3};
info.year = fields{4};
fields = split(tmp,'T');
info.mouse = fields{1};
info.trial = fields{2};
end

function info = parse_lola_01_filenames(f)
f = split(f,'.');
f = f{1};
%f = '52353_20221115_sess01_rec1_def_nac.csv'
fields = split(f,'_');
info.prefix = f;
info.mouse = fields{1};
info.date = fields{2};
info.session = fields{3}(5:end);
info.rec = fields{4}(4:end);
info.tag1 = fields{5};
info.tag2 = fields{6};

end




