function rawdata = load_imetronic_rawdata(filepath)
rawdata = dlmread(filepath,'\t',13,0);
