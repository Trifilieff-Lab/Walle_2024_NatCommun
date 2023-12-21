function photo_plots(params, data, plotname)

    if strcmp(plotname,'deinterleaved signals')
        fig=figure();
        title('deinterleaved s')
        hold on
        plot(data.time,data.iso,'m')
        plot(data.time,data.physio,'b')
        legend({'iso', 'physio'})
        smart_save_figures(fig, params.figure, 'deinterleaved_s')
    end
    
    if strcmp(plotname,'fit iso')
        fig=figure();
        title('Isosbestic Fit')
        hold on
        plot(data.time,data.fit_iso,'m')
        plot(data.time,data.physio,'b')
        legend({'iso (fit)', 'physio'})
        smart_save_figures(fig, params.figure, 'fit_iso')
    end
    
    if strcmp(plotname,'dff_debug')
        plot_dff_debug(data.time, data.iso, data.fit_iso, data.physio, data.dff, data.output)
    end
    
    if strcmp(plotname,'dff')
        fig=figure();
        title('DFF')
        hold on
        plot(data.time,data.dff,'g')
        legend({'dff'})
        smart_save_figures(fig, params.figure, 'dff')
    end    
 
    if strcmp(plotname,'transients')
        fig=figure();
        title('Transients')
        hold on
        plot_transients(data.transients,data.time, data.dff,'dff',0)
        smart_save_figures(fig, params.figure, 'transients');
    end    
     
end


function plot_dff_debug(t, iso, iso_fit, physio, dff, output)
fig=figure();
subplot(2,1,1)
title('raw')
hold on
plot(t,(iso))
plot(t,(iso_fit))
plot(t,(physio))
legend('iso','iso_fit','physio');
subplot(2,1,2)
title('dff')
hold on
plot(t,norm_01(physio))
plot(t,dff)
legend('physio','dff');
smart_save_figures(fig, output, 'dff_debug')
end


function sig = norm_01(sig)
    sig = sig - min(sig);
    sig = sig / max(sig);
end





