clc
clear

cd 'G:\Fiber_Photometry\2023-62_D1flp-D2cre_D2GLUN2B_mPFC\2023-62_PAVLOV_FR_RL\RESULTS_2023-62_RL1_1sec__bsl_indiv_-3k_-05k'

%A=load('CS_C1.mat');                  %load le fichier .mat d'un Event/Group (par exemple, si tri en Event/Group/Session)
%B=load('CS_DELTA.mat'); %idem pour groupe 2

%A=load('CS_IL3.mat');                 
%B=load('CS_Scr.mat'); 

%A=load('CS_D1cre.mat');                 
%B=load('CS_D2cre.mat');

A=load('L1_press_IL3.mat');                 
B=load('L1_press_Scr.mat'); 

%A=load('L1_press_C1.mat');                 
%B=load('L1_press_DELTA.mat'); 

%A=load('L2_press_C1.mat');                 
%B=load('L2_press_DELTA.mat'); 

%C=load('L2_press_C1.mat');                 
%D=load('L2_press_DELTA.mat'); 

%A=load('L1_press_D1cre.mat');                 
%B=load('L1_press_D2cre.mat'); 

%A=load('Lever1_C1.mat');                 
%B=load('Lever1_DELTA.mat'); 

%A=load('L2_press_IL3.mat');                
%B=load('L2_press_Scr.mat');  

%A=load('Licks_C1.mat');                
%B=load('Licks_DELTA.mat');  

%A=load('Licks_IL3.mat');                
B%=load('Licks_Scr.mat'); 

%A=load('lick_D1cre.mat');                 
%B=load('lick_D2cre.mat');

%A=load('US_C1.mat');                
%B=load('US_DELTA.mat');  

%A=load('Levers_presentation_IL3.mat');                 
%B=load('Levers_presentation_Scr.mat'); 

A_mean = mean(A.means);                  %Moyenne des sessions
A_std = mean(A.stds);                    % Moyenne des std des sessions
A_sem = A_std/sqrt(size(A.matrix,1));    % SEM sur les colonnes de tous les trials de la matrice

B_mean = mean(B.means);
B_std = mean(B.stds);
B_sem = B_std/sqrt(size(B.matrix,1));

% C_mean = mean(C.means);
% C_std = mean(C.stds);
% C_sem = C_std/sqrt(size(C.matrix,1));
% 
% D_mean = mean(D.means);
% D_std = mean(D.stds);
% D_sem = D_std/sqrt(size(D.matrix,1));

hold on

plot(A.x_values,A_mean,'Color', [0.0431 0.4549 0.0470], 'LineWidth', 1.5, 'DisplayName', 'D2R-IL3' );
plot(A.x_values,A_mean-A_sem,'LineWidth', 1 , 'Color', [0.0431 0.4549 0.0470] , 'LineStyle', ':', 'HandleVisibility', 'off');
plot(A.x_values,A_mean+A_sem,'LineWidth', 1 , 'Color', [0.0431 0.4549 0.0470] , 'LineStyle', ':', 'HandleVisibility', 'off');

% plot(A.x_values,A_mean,'Color', [0.04117 0 1], 'LineWidth', 1.5, 'DisplayName', 'GluN1-C1' );
% plot(A.x_values,A_mean-A_sem,'LineWidth', 1 , 'Color', [0.04117 0 1] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(A.x_values,A_mean+A_sem,'LineWidth', 1 , 'Color', [0.04117 0 1] , 'LineStyle', ':', 'HandleVisibility', 'off');

% plot(A.x_values,A_mean,'Color', [1 0.2392 0], 'LineWidth', 1.5, 'DisplayName', 'D1cre' );
% plot(A.x_values,A_mean-A_sem,'LineWidth', 1 , 'Color', [1 0.2392 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(A.x_values,A_mean+A_sem,'LineWidth', 1 , 'Color', [1 0.2392 0] , 'LineStyle', ':', 'HandleVisibility', 'off');

xA_=[A.x_values fliplr(A.x_values)];
yA_=[A_mean+A_sem, fliplr(A_mean-A_sem)];

%patch(xA_,yA_,[0.04117 0 1], 'FaceAlpha',.05, 'Edgecolor', 'none', 'HandleVisibility', 'off'); %pour avoir le fond coloré entre les SEM
patch(xA_,yA_,[0.0431 0.4549 0.0470], 'FaceAlpha',.05, 'Edgecolor', 'none', 'HandleVisibility', 'off');

plot(B.x_values,B_mean, 'Color', [0.4470 0.8941 0.3803], 'LineWidth', 1.5, 'DisplayName', 'D2R-Scr');
plot(B.x_values,B_mean-B_sem,'LineWidth', 1 , 'Color', [0.4470 0.8941 0.3803] , 'LineStyle', ':', 'HandleVisibility', 'off');
plot(B.x_values,B_mean+B_sem,'LineWidth', 1 , 'Color', [0.4470 0.8941 0.3803] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% plot(B.x_values,B_mean, 'Color', [0.6862 0.6862 1], 'LineWidth', 1.5, 'DisplayName', 'GluN1-DELTA');
% plot(B.x_values,B_mean-B_sem,'LineWidth', 1 , 'Color', [0.6862 0.6862 1] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(B.x_values,B_mean+B_sem,'LineWidth', 1 , 'Color', [0.6862 0.6862 1] , 'LineStyle', ':', 'HandleVisibility', 'off');

% plot(B.x_values,B_mean, 'Color', [0 0.5490 0], 'LineWidth', 1.5, 'DisplayName', 'D2cre');
% plot(B.x_values,B_mean-B_sem,'LineWidth', 1 , 'Color', [0 0.5490 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(B.x_values,B_mean+B_sem,'LineWidth', 1 , 'Color', [0 0.5490 0] , 'LineStyle', ':', 'HandleVisibility', 'off');

xB_=[B.x_values fliplr(B.x_values)];
yB_=[B_mean+B_sem, fliplr(B_mean-B_sem)];
%patch(xB_,yB_,[0.6862 0.6862 1], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');
patch(xB_,yB_,[0.4470 0.8941 0.3803], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');


% plot(C.x_values,C_mean,'Color', [0 0 0], 'LineWidth', 1.5, 'DisplayName', 'L2/GluN1-C1', 'LineStyle','--' );
% plot(C.x_values,C_mean-C_sem,'LineWidth', 1 , 'Color', [0 0 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(C.x_values,C_mean+C_sem,'LineWidth', 1 , 'Color', [0 0 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xC_=[C.x_values fliplr(C.x_values)];
% yC_=[C_mean+C_sem, fliplr(C_mean-C_sem)];
% patch(xC_,yC_,[0 0 0], 'FaceAlpha',.03, 'Edgecolor', 'none', 'HandleVisibility', 'off'); 
% 
% 
% 
% plot(D.x_values,D_mean, 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5, 'DisplayName', 'L2/GluN1-DELTA','LineStyle','--');
% plot(D.x_values,D_mean-D_sem,'LineWidth', 1 , 'Color', [0.75 0.75 0.75] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(D.x_values,D_mean+D_sem,'LineWidth', 1 , 'Color', [0.75 0.75 0.75] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xD_=[D.x_values fliplr(D.x_values)];
% yD_=[D_mean+D_sem, fliplr(D_mean-D_sem)];
% patch(xD_,yD_,[0.75 0.75 0.75], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');




%xline([0 3000 10000],":r",{'LP/CS', 'US', 'Fin CS'},'LabelOrientation','horizontal',HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
%xline([0 1000 4000 11000],":r",{'L1 press', 'CS', 'US', 'Fin CS'},'LabelOrientation','horizontal','LabelHorizontalAlignment', 'left',HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
%TTL = xline([0 1000 4000],":r",{'L2 Renforcé', 'CS', 'US'},'LabelOrientation','horizontal','LabelHorizontalAlignment', 'left',HandleVisibility='off',LineWidth=2.5,FontSize=14); %Ligne à 0, change label en fonction de l'event
%xline(0,":r",'Licking onset','LabelOrientation','horizontal',HandleVisibility='off',LineWidth=2.5, FontSize=12); %Ligne à 0, change label en fonction de l'event
xline(0,":r",'Lever press','LabelOrientation','horizontal',HandleVisibility='off',LineWidth=2.5, FontSize=12); %Ligne à 0, change label en fonction de l'event
%TTL.FontWeight = bold;
yline(0,'-', HandleVisibility='off'); %ligne à y=0
ylabel(['Z-Score of ∆F/F +/- SEM'],'FontSize',14, 'FontWeight','bold');
xlabel(["Time from Lever pressing onset (ms)"],"FontSize",14, "FontWeight","bold");
%xlabel(["Time from Licking onset (ms)"],"FontSize",14, "FontWeight","bold"); %change label en fonction de l'event
xt = get(gca, 'XTick');  
%set(xt, 'FontSize', 12);
%xt.FontSize = 12;
xtl = get(gca, 'LineWidth');
xtl = 1;
yt = get(gca, 'YTick');
%set(yt, 'FontSize', 12);
%yt.FontSize = 12;
ytl = get(gca, 'LineWidth');
ytl = 1;
ax = gca;
ax.FontSize =13;
%xlim([-3000 13000]);
xlim([-2000 5000]);
%ylim([-1.3 1.7]);
lgd = legend;
set(lgd, 'FontSize', 13);

hold off

%% Sessions

% clc
% clear
% 
% cd 'G:\Fiber_Photometry\2022-123_D2CRE_D2GLUN2B_mPFC\2022-123_ANALYSIS_Script-V2\FR_Basline_indiv_-2k-05k\2022-123_D2CRE_D2GLUN2B_mPFC_FR1-RL2_1secLPCS_ANALYSIS\RESULTS'
% 
% 
% A1=load('L1_press_IL3_42.mat');                 
% A2=load('L1_press_IL3_54.mat');
% 
% A1_sem = A1.stds/sqrt(size(A1.matrix,1)); 
% A2_sem = A2.stds/sqrt(size(A2.matrix,1)); 
% 
% B1=load('L1_press_Scr_44.mat');                 
% B2=load('L1_press_Scr_56.mat');
% 
% B1_sem = B1.stds/sqrt(size(B1.matrix,1)); 
% B2_sem = B2.stds/sqrt(size(B2.matrix,1));
% 
% subplot(2,1,1)
% 
% hold on
% 
% plot(A1.x_values,A1.means,'Color', [0 0.4705 0], 'LineWidth', 1.5, 'DisplayName', '1st D2R-IL3' );
% plot(A1.x_values,A1.means-A1_sem,'LineWidth', 1 , 'Color', [0 0.4705 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(A1.x_values,A1.means+A1_sem,'LineWidth', 1 , 'Color', [0 0.4705 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xA1_=[A1.x_values fliplr(A1.x_values)];
% yA1_=[A1.means+A1_sem, fliplr(A1.means-A1_sem)];
% patch(xA1_,yA1_,[0 0.4705 0], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');
% 
% 
% plot(A2.x_values,A2.means,'Color', [0 0.7333 0], 'LineWidth', 1.5, 'DisplayName', 'Last D2R-IL3' );
% plot(A2.x_values,A2.means-A2_sem,'LineWidth', 1 , 'Color', [0 0.7333 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(A2.x_values,A2.means+A2_sem,'LineWidth', 1 , 'Color', [0 0.7333 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xA2_=[A2.x_values fliplr(A2.x_values)];
% yA2_=[A2.means+A2_sem, fliplr(A2.means-A2_sem)];
% patch(xA2_,yA2_,[0 0.7333 0], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');
% 
% xline(0,":r",'L1 Renf','LabelOrientation','horizontal',HandleVisibility='off',LineWidth=1.5); 
% yline(0,'-', HandleVisibility='off'); 
% ylabel(['Z-Score of ∆F/F +/- SEM']);
% xlabel(['Time from L1 (ms)']); 
% xt = get(gca, 'XTick');  
% legend;
% 
% hold off
% 
% subplot(2,1,2)
% hold on
% 
% plot(B1.x_values,B1.means,'Color', [0 0 0], 'LineWidth', 1.5, 'DisplayName', '1st D2R-Scr' );
% plot(B1.x_values,B1.means-B1_sem,'LineWidth', 1 , 'Color', [0 0 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(B1.x_values,B1.means+B1_sem,'LineWidth', 1 , 'Color', [0 0 0] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xB1_=[B1.x_values fliplr(B1.x_values)];
% yB1_=[B1.means+B1_sem, fliplr(B1.means-B1_sem)];
% patch(xB1_,yB1_,[0 0 0], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off'); %pour avoir le fond coloré entre les SEM
% 
% 
% plot(B2.x_values,B2.means,'Color', [0.4705 0.4705 0.4705], 'LineWidth', 1.5, 'DisplayName', 'Last D2R-Scr' );
% plot(B2.x_values,B2.means-B2_sem,'LineWidth', 1 , 'Color', [0.4705 0.4705 0.4705] , 'LineStyle', ':', 'HandleVisibility', 'off');
% plot(B2.x_values,B2.means+B2_sem,'LineWidth', 1 , 'Color', [0.4705 0.4705 0.4705] , 'LineStyle', ':', 'HandleVisibility', 'off');
% 
% xB2_=[B2.x_values fliplr(B2.x_values)];
% yB2_=[B2.means+B2_sem, fliplr(B2.means-B2_sem)];
% patch(xB2_,yB2_,[0.4705 0.4705 0.4705], 'FaceAlpha',.1, 'Edgecolor', 'none', 'HandleVisibility', 'off');
% 
% 
% xline(0,":r",'L1 Renf','LabelOrientation','horizontal',HandleVisibility='off',LineWidth=1.5); %Ligne à 0, change label en fonction de l'event
% yline(0,'-', HandleVisibility='off'); %ligne à y=0
% ylabel(['Z-Score of ∆F/F +/- SEM']);
% xlabel(['Time from L1 (ms)']); %change label en fonction de l'event
% xt = get(gca, 'XTick');  
% legend;
% 
% hold off


%% AUC calculation

%AUC_Scr_I0_3000I_sess = trapz(B.x_values(31 : 62), B.means(1 : end, 31 : 62), 2);
%AUC_IL3_I0_3000I_sess = trapz(A.x_values(31 : 62), A.means(1 : end, 31 : 62), 2);

% AUC_Scr_I1000_4000I_all = trapz(B.x_values(31 : 61), B.matrix(1 : end, 31 : 61), 2);
% AUC_IL3_I1000_4000I_all = trapz(A.x_values(31 : 61), A.matrix(1 : end, 31 : 61), 2);

%AUC_Scr_I3000_10000I_all = trapz(B.x_values(61 : 131), B.matrix(1 : end, 61 : 131), 2);
%AUC_IL3_I3000_10000I_all = trapz(A.x_values(61 : 131), A.matrix(1 : end, 61 : 131), 2);

% AUC_Scr_I400_600I_all = trapz(B.x_values(25 : 27), B.matrix(1 : end, 25 : 27), 2);
% AUC_IL3_I400_600I_all = trapz(A.x_values(25 : 27), A.matrix(1 : end, 25 : 27), 2);
