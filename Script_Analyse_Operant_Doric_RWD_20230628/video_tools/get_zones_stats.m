function stats = get_zones_stats(x, y, dff_synchronized, video_freq_Hz, frame0, zones, debug_mode)

    n_zones = max(size(zones));
    n_pos = length(x);
    
    in_zones = nan(n_pos,n_zones);

   stats = [];
    
    for i_zone=1:n_zones
        xz = zones{i_zone}.x;
        yz = zones{i_zone}.y;
        in_zones(:,i_zone) = inpolygon(x,y,xz,yz);
        stats(i_zone).time_sec = sum(in_zones(:,i_zone))/video_freq_Hz;
        stats(i_zone).dff_mean = mean(dff_synchronized(logical(in_zones(:,i_zone))));
        stats(i_zone).dff_std = std(dff_synchronized(logical(in_zones(:,i_zone))));
    end
 
    if debug_mode
       
        figure()

        hold on
        axis off
        imagesc(frame0);

        colormap_ = colormap(lines(n_zones));

        plot(x,y,'color',[0.5 0.5 0.5]);

        for i_zone=1:n_zones
            x_ = zones{i_zone}.x;
            y_ = zones{i_zone}.y;
            n = length(x_);
            for j=1:n-1
                plot([x_(j) x_(j+1)],[y_(j) y_(j+1)],'color',colormap_(i_zone,:));
            end
            plot([x_(end) x_(1)],[y_(end) y_(1)],'color',colormap_(i_zone,:));

            in_idx = find(in_zones(:,i_zone)==1);
            plot(x(in_idx),y(in_idx),'Marker','.','MarkerFaceColor',colormap_(i_zone,:),'LineStyle','none');
            text(mean(x_)-50,mean(y_),sprintf('Zone #%d',i_zone),'color','k')
%             text(mean(x_)-50,mean(y_),sprintf('dur=%2.2f, dff=%2.2f',stats(i_zone).time_sec,stats(i_zone).dff_mean),'color','w')

        end
        
    end
   
    
end

