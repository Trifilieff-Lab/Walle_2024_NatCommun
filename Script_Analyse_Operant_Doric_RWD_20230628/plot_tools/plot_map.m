function plot_map(map, title_str, colormap_, colorbar_label_str, empty_pix_color)

    f = figure();
    title(title_str)
    axis equal
    axis off
    hold on
    

    % rescale data to be between 0 and 1 for the colormap
    normed_map = map;
    
    % creation of the correct colorbar
    map_min = min(map,[], 'all');
    map_max = max(map,[], 'all');
    map_middle = (map_max + map_min)/2;
    TickLabels={sprintf('%2.2f',map_min),sprintf('%2.2f',map_middle),sprintf('%2.2f',map_max)};
    Ticks=linspace(0,1,numel(TickLabels)+1);
    Ticks=Ticks(2:end)-diff(Ticks)/2;    
    h=colorbar;
    h.Label.String = colorbar_label_str;
    h.TickLabels=TickLabels;
    h.Ticks=Ticks;
    
    % creation of the colormap
    if isempty(colormap_)
        colormap_ = parula(1024);
    end
    colormap(colormap_);

    
    %Fill empty pixels with a specific color
    no_empty_color = false;
    if isempty(empty_pix_color)
        no_empty_color = true;
    end
    
    % data transformation into colormap indices
    min_ = min(normed_map, [], 'all');
    normed_map = normed_map - min_;
    max_ = max(normed_map, [], 'all');
    normed_map = normed_map/max_;
    normed_map = normed_map * (max(size(colormap_))-1);
    normed_map = ceil(normed_map);

    [r,c] = size(normed_map);
    for i=1:r
        for j=1:c
            if isnan(normed_map(j,i))
                if no_empty_color
                    rectangle('Position',[i-0.5 j-0.5 1 1],'facecolor','none', 'edgecolor', 'none');
                else
                    rectangle('Position',[i-0.5 j-0.5 1 1],'facecolor',empty_pix_color, 'edgecolor', 'none');
                end
            else
                rectangle('Position',[i-0.5 j-0.5 1 1],'facecolor',colormap_(normed_map(j,i)+1,:), 'edgecolor', 'none');
            end
        end
    end

end


