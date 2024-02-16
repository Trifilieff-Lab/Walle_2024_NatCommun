clc
clear

cd 'G:\Fiber_Photometry\GcampD1D2 2022-119 NAc anx Roman\2022-119_PAVLOV_FR_RL\Baseline indiv -2k -05k\RESULTS_PAVLOV_bsl-indiv_-2k-05k-12k_event_group_session' % set le  file directory


A=load('CS_D1cre.mat');  %load le fichier .mat d'un Event/Group (par exemple, si tri en Event/Group/Session)
B=load('CS_D2cre.mat');

%A_mean = mean(A.means);                  %Moyenne des sessions
%A_std = mean(A.stds);                    % Moyenne des std des sessions

A_mean = mean(A.matrix, "omitnan");                % Moyenne des trials
A_std = std(A.matrix, "omitnan");                  % Std sur les trials
A_sem = A_std/sqrt(size(A.matrix,1));    % SEM sur les colonnes de tous les trials de la matrice

%B_mean = mean(B.means);
%B_std = mean(B.stds);

B_mean = mean(B.matrix, "omitnan");
B_std = std(B.matrix, "omitnan");
B_sem = B_std/sqrt(size(B.matrix,1));

A.x_values = A.x_values/1000;
B.x_values = B.x_values/1000;

%subplot(3,1,1)

hold on
plot(A.x_values,A_mean,'Color', [0.6353 0.1412 0.0], 'LineWidth', 1.5, 'DisplayName', 'D1-cre' );
plot(A.x_values,A_mean-A_sem,'LineWidth', 1 , 'Color', [0.6353 0.1412 0.0] , 'LineStyle', ':', 'HandleVisibility', 'off');
plot(A.x_values,A_mean+A_sem,'LineWidth', 1 , 'Color', [0.6353 0.1412 0.0] , 'LineStyle', ':', 'HandleVisibility', 'off');
xA_=[A.x_values fliplr(A.x_values)];
yA_=[A_mean+A_sem, fliplr(A_mean-A_sem)];
patch(xA_,yA_,[0.6353 0.1412 0.0], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off'); %pour avoir le fond coloré entre les SEM

plot(B.x_values,B_mean, 'Color', [0.0 0.4118 0.0], 'LineWidth', 1.5, 'DisplayName', 'D2-cre' );
plot(B.x_values,B_mean-B_sem,'LineWidth', 1 , 'Color', [0.0 0.4118 0.0] , 'LineStyle', ':', 'HandleVisibility', 'off');
plot(B.x_values,B_mean+B_sem,'LineWidth', 1 , 'Color', [0.0 0.4118 0.0] , 'LineStyle', ':', 'HandleVisibility', 'off');
xB_=[B.x_values fliplr(B.x_values)];
yB_=[B_mean+B_sem, fliplr(B_mean-B_sem)];
patch(xB_,yB_,[0.0 0.4118 0.0], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');

xline(0,":r",'CS','LabelOrientation','horizontal','LabelHorizontalAlignment', 'left', HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
%xline(0,":r",'LP Non Renf','LabelOrientation','horizontal','LabelHorizontalAlignment', 'right', HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
%xline(0,":r",'Licking','LabelOrientation','horizontal','LabelHorizontalAlignment', 'right', HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
%xline(0,":r",'Lever Presentation','LabelOrientation','horizontal','LabelHorizontalAlignment', 'right', HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event

yline(0,'-', HandleVisibility='off'); %ligne à y=0
ylabel(['Z-Score of ∆F/F +/- SEM']);
xlabel(['Time from CS onset (s)']); %change label en fonction de l'event
%xlabel(['Time from Licking onset (s)']);
%xlabel(['Time from Lever pressing (s)']);
%xlabel(['Time from Lever pressing (s)']);
xt = get(gca, 'XTick'); 
xlim([-2 2])
legend;

x0 = 5;
y0 = 0;
w = 13;
h = 18; 
set(gcf, 'units', 'centimeters', 'position', [x0, y0, w, h]);

hold off

% subplot (3,1,2)
% 
% hold on
% 
% %title(['Average NAc D1 signals over sessions']);
% title(['Average NAc D1 signals over mice']);
% y = [1 5];
%minAB = min(min(A.means(:)),min(B.means(:)));
%maxAB = max(max(A.means(:)),max(B.means(:)));
% %clims = [-4 14];
% clims = [minAB maxAB];
% %clims = [-4.5 maxAB];
% imagesc(A.x_values,y,A.means, clims);
% %imagesc(A.x_values,y,A.means);
% colormap('turbo');
% %colormap('');
% xlim([-2 2])
% ylim([1 5])
% %xlabel (['Time from CS onset (s)'])
% xlabel (['Time from Licking onset (s)'])
% %xlabel (['Time from Lever pressing (s)'])
% 
% %ylabel('# Sessions (sorted)')
% ylabel('# Mice')
% 
% x0 = 5;
% y0 = 0;
% w = 15;
% h = 8; 
% set(gcf, 'units', 'centimeters', 'position', [x0, y0, w, h]);
% 
% hold off
% 
% subplot(3,1,3)
% 
% hold on
% %title(['Average NAc D2 signals over sessions']);
% title(['Average NAc D2 signals over mice']);
% y = [1 5];
% %clims = [minAB maxAB];
% %clims = [-4 14];
% %clims = [-4.5 maxAB];
% %imagesc(B.x_values,y,B.means, clims);
% imagesc(B.x_values,y,B.means);
% colormap('turbo');
% %colormap('parula');
% xlim([-2 2])
% ylim([1 5])
% xlabel (['Time from Licking onset (s)'])
% %xlabel (['Time from Lever pressing (s)'])
% %xlabel (['Time from CS onset (s)'])
% %ylabel('# Sessions (sorted)')
% ylabel('# Mice')
% 
% x0 = 5;
% y0 = 0;
% w = 15;
% h = 8; 
% set(gcf, 'units', 'centimeters', 'position', [x0, y0, w, h]);
% 
% hold off

% %% AUC

%MeanA_SEM = A_mean - A_sem;
%MeanB_SEM = B_mean - B_sem;
%minAB = min(min(MeanA_SEM(:)),min(MeanB_SEM(:)));
%yy = 1.60142;
yy = 0 ; 
%MeanA = A.means + yy; % sessions
%MeanB = B.means + yy;

MeanA = A.matrix + yy; % trials
MeanB = B.matrix + yy;

%AUC_C1_LPR_CS_I0-200I_all  
AAA = trapz(A.x_values(1 : 21), MeanA(1 : end, 1 : 21), 2);
%AUC_DELTA_LPR_CS_I0-200I_all 
BBB = trapz(A.x_values(1 : 21), MeanB(1 : end, 1 : 21), 2);
%AUC_C1_LPN_CS_I0-200I_all 
CCC = trapz(A.x_values(21 : 41), MeanA(1 : end, 21 : 41), 2);
%AUC_DELTA_LPN_CS_I0-200I_all 
DDD = trapz(A.x_values(21 : 41), MeanB(1 : end, 21 : 41), 2);
%AUC_C1_LPN_CS_I0-200I_all 
EEE = trapz(A.x_values(1 : 41), MeanA(1 : end, 1 : 41), 2);
%AUC_DELTA_LPN_CS_I0-200I_all 
FFF = trapz(A.x_values(1 : 41), MeanB(1 : end, 1 : 41), 2);

%AUC_C1_LPN_CS_I0-200I_all 
GGG = trapz(A.x_values(11 : 21), MeanA(1 : end, 11 : 21), 2);
%AUC_DELTA_LPN_CS_I0-200I_all 
HHH = trapz(A.x_values(11 : 21), MeanB(1 : end, 11 : 21), 2);
%AUC_C1_LPN_CS_I0-200I_all 
III = trapz(A.x_values(21 : 31), MeanA(1 : end, 21 : 31), 2);
%AUC_DELTA_LPN_CS_I0-200I_all 
JJJ = trapz(A.x_values(21 : 31), MeanB(1 : end, 21 : 31), 2);
%AUC_C1_LPN_CS_I0-200I_all 
KKK = trapz(A.x_values(11 : 31), MeanA(1 : end, 11 : 31), 2);
%AUC_DELTA_LPN_CS_I0-200I_all 
LLL = trapz(A.x_values(11 : 31), MeanB(1 : end, 11 : 31), 2);
