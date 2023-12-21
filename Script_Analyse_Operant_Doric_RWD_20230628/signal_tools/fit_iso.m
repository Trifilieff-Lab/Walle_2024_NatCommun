function fit_ = fit_iso(iso, physio)
        %% fit iso to fluo gcamp (fit sig1 to sig2)
        N=1; % polynomial coef for linear
        idx1 = find(isnan(iso)==1);
        idx2 = find(isnan(physio)==1);
        iso_tmp = iso;
        physio_tmp = physio;  
        iso_tmp(union(idx1,idx2))=[];
        physio_tmp(union(idx1,idx2))=[];
        P = polyfit(iso_tmp, physio_tmp, N);
        fit_ = iso*P(1)+P(2);
end