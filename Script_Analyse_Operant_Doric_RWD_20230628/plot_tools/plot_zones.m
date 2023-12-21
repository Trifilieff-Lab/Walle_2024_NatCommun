function plot_zones(frame0,zones)
figure();
title('zones')
hold on
axis off
imagesc(frame0);
n_zones = max(size(zones));
colormap_ = colormap(lines(n_zones));
for i=1:n_zones
    x = zones{i}.x;
    y = zones{i}.y;
    n = length(x);
    for j=1:n-1
        plot([x(j) x(j+1)],[y(j) y(j+1)],'color',colormap_(i,:));
    end  
    plot([x(end) x(1)],[y(end) y(1)],'color',colormap_(i,:));
end

