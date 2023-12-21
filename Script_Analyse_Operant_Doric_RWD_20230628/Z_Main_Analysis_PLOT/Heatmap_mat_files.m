clc
clear

cd 'G:\Fiber_Photometry\2022-123_D2CRE_D2GLUN2B_mPFC\2022-123_ANALYSIS_Script-V2\FR_Basline_indiv_-3k-05k--13k\2022-123_D2CRE_D2GLUN2B_mPFC_FR1-RL1_1secLPCS_ANALYSIS\RESULTS' 


A=load('L1_press_IL3.mat');  %load le fichier .mat d'un Event/Group (par exemple, si tri en Event/Group/Session)
B=load('L1_press_Scr.mat');

subplot (2,1,2)
hold on
title(['Average mPFc D2 signals over sessions : IL3 POOL']);
y = [1 6];
%y = [2 13];
minAB = min(min(A.means(:)),min(B.means(:)));
maxAB = max(max(A.means(:)),max(B.means(:)));
%clims = [-0.5 4];
clims = [minAB maxAB];
%clims = [-4.5 maxAB];
imagesc(A.x_values,y,A.means, clims);
%imagesc(A.x_values,y,A.means);
colormap('turbo');
%colormap('');
xlim([-3000 13000])
ylim([1 6])
%ylim([2 13])
xlabel (['Time from CS (ms)'])
ylabel('# Sessions (sorted)')


hold off



subplot(2,1,1)

hold on

title(['Average mPFc D2 signals over sessions : Scr POOL']);
y = [1 6];
%y = [2 13];
clims = [minAB maxAB];
%clims = [-0.5 4];
%clims = [-4.5 maxAB];
imagesc(B.x_values,y,B.means, clims);
%imagesc(B.x_values,y,B.means);
colormap('turbo');
%colormap('parula');
xlim([-3000 13000])
ylim([1 6])
%ylim([2 13])
xlabel (['Time from CS (ms)'])
ylabel('# Sessions (sorted)')



hold off