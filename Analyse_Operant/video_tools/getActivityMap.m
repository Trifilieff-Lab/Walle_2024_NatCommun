function [occupancy_map_sec,activity_map] = getActivityMap(x, y, dff_synchronized, bin_size, max_image_size_pix, video_freq_Hz)

    % return an occupancy map in sec, the time spend in each bin
    % (a square of bin_size^2 pixels in the video frame
    occupancy_map = nan(max_image_size_pix/bin_size);
    activity_map = nan(max_image_size_pix/bin_size);

    for i=1:length(x)
        c = floor(x(i)/bin_size+1);
        r = floor(y(i)/bin_size+1);
        if ~isnan(r) && ~isnan(c)
            occupancy_map(r,c) = nansum([occupancy_map(r,c), 1]);
            activity_map(r,c) = nansum([activity_map(r,c), dff_synchronized(i)*100.0]);
        end
    end

    activity_map = activity_map ./ occupancy_map;
    occupancy_map_sec = occupancy_map / video_freq_Hz;
    

end



%% This code was use to test the creation of the occupancy map
% bin_size=25;
% Xedges = 0:bin_size:1200;
% Yedges = 0:bin_size:1200;
% occupancy_map2 = histcounts2(y,x,Xedges,Yedges);
% 
% figure
% subplot(3,1,1)
% hold on
% axis equal
% colorbar
% imagesc(occupancy_map)
% subplot(3,1,2)
% hold on
% axis equal
% colorbar
% imagesc(occupancy_map2)
% subplot(3,1,3)
% hold on
% axis equal
% colorbar
% imagesc(occupancy_map2 - occupancy_map)




