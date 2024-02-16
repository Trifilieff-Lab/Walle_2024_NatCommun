xline([0 3000 10000],":r",{'LP/CS', 'US', 'Fin CS'},'LabelOrientation','horizontal',HandleVisibility='off',LineWidth=1.5, FontSize=15);
%xline(0,":r",'Licking onset','LabelOrientation','horizontal',HandleVisibility='off',LineWidth=2.5, FontSize=15);

yline(0,'-', HandleVisibility='off'); 
ylabel(['Z-Score of ∆F/F +/- SEM'],'FontSize',16.5, 'FontWeight','bold');
xlabel(["Time from LP onset (s)"],"FontSize",16.5, "FontWeight","bold"); 
%xlabel(["Time from Licking onset (ms)"],"FontSize",15, "FontWeight","bold"); 
xt = get(gca, 'XTick');  
xtl = get(gca, 'LineWidth');
xtl = 1;
yt = get(gca, 'YTick');
ytl = get(gca, 'LineWidth');
ytl = 1;
ax = gca;
ax.FontSize =16.5;
ax.FontWeight = 'bold';
%xlim([-3000 13000]);
%xlim([-2000 5000]);
xlim([-1.5 -0.1]);
%ylim([-1.3 1.7]);
lgd = legend;
%set(lgd, 'FontSize', 14, 'FontWeight', 'bold');
set(lgd, 'FontSize', 14, 'FontWeight', 'normal');

x0 = 5;
y0 = 0;
%w = 12;
%h = 16.5; 
w = 13;
h = 18; 
set(gcf, 'units', 'centimeters', 'position', [x0, y0, w, h]);

hold off