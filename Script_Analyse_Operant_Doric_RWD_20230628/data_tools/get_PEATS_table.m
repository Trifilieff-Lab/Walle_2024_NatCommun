function res_table =get_PEATS_table(params)

    [~, c_info] = size(params.info_table);

    varTypes = [""];
    varNames={};

    
    for i=1:c_info
        varTypes(i)="string";
        varNames{i}= params.info_table.Properties.VariableNames{i};
    end
    varNum = c_info;
    
    varTypes(end+1)="string"; varNames{end+1}= 'eventname';
    varTypes(end+1)="double"; varNames{end+1}= 'eventnum';
    varNum = varNum +2;
    
    if params.period_enumeration
        varTypes(end+1)="double"; varNames{end+1}= 'periodnum';
        varTypes(end+1)="double"; varNames{end+1}= 'eventinperiodnum';
        varNum = varNum +2;
    end

    
    sz = [1 varNum];    
    res_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

end