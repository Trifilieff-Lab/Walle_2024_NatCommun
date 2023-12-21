
% videoPath = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataAnna_Baseline\M27322\M27322_20210709_sess4_rec3_SWE.avi';
videoPath = 'E:\NAS_SD\SuiviClient\Triffilieff\AnnaRoman\DataAnna_Baseline\Msp446\Msp446_20210721_sess9_rec2_SWE.avi';

v = VideoReader(videoPath);

nFrames = 100;
beginningOffset_sec = 120;
interFrameGap_sec=0;
duration_sec = v.Duration;


if ~interFrameGap_sec
    interFrameGap_sec = floor((duration_sec - beginningOffset_sec)  / (nFrames+1) );
end

fprintf('\tinterFrame = %2.2f sec',interFrameGap_sec);
v.CurrentTime = 0;
vidFrame = readFrame(v);
vidFrame = mean(vidFrame,3);
imSize=size(vidFrame);
imgBuffer = nan(imSize(1),imSize(2),nFrames);

v.CurrentTime = beginningOffset_sec;

for i=1:nFrames        
    try
    v.CurrentTime  = v.CurrentTime + interFrameGap_sec;
    vidFrame = readFrame(v);
    imgBuffer(:,:,i)=mean(vidFrame,3);
    catch
        warning('getBackGroundSlow try to get more frame than exisiting number');
    end
end
bgMat = nanmedian(imgBuffer,3);
clearvars 'imgBuffer';
bg = mat2gray(bgMat);
imshow(bg)

imwrite(bg,'test.jpg','jpg');
clearvars 'bgImg'





