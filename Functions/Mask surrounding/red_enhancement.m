function [RGBgained_redColorMasked] = red_enhancement(frame)
% Red color enhancment based on HSV color space manipulation
% Input:
% frame - Current frame of RGB image.
%
% Output:
% redEnhancedFrame - RGB image of red channel with leveled red colors.

global  Static

% HSV transform
HSV = rgb2hsv(frame); 

% Substituting seperated channels
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

%% Filter HSV channels
%
% Filter non red colors
Hfilter = ((H<=Static.Hthresh(1)) | (H>=Static.Hthresh(2)));

% Filter dark color
Sfilter = ((S>=Static.Sthresh));

% Filter dark & bright color
Vfilter = ((V>=Static.Vthresh(1)) & (V<=Static.Hthresh(2)));

% Multiply logic arrays to sum filters' effects
Filter = Hfilter .* Sfilter .* Vfilter;

%% Gain HSV image
%
% Gaining V channel
Vgained = imadjust(V, [Static.Vthresh(1) Static.Vthresh(2)], [0 1], 1);

% Update V channel in HSV image
HSVgained = HSV; % Initialize gained HSV image
HSVgained(:,:,3) = Vgained;

%% Transform to gained & filtered RGB image
%
% RGB transform
RGBgained = hsv2rgb(HSVgained);

% Masking the non red colors
RGBgained_redColorMasked = RGBgained .* Filter;

%#######################################################################


%% DISPLAY

figure('name','Red enhancement - HSV masks');
subplot(2,3,1)
imshow(Hfilter)
title('Hue mask - Non red color masked')
subplot(2,3,2)
imshow(Sfilter)
title('Saturation mask - Non Saturated color masked')
subplot(2,3,3)
imshow(Vfilter)
title('Value mask - Extreme high & low Value masked')

subplot(2,3,6)
imshow(Filter)
title('Intersection of all masks')
%
%
figure('name','Red enhancement - Gained channels');
subplot(2,3,1)
imshow(frame)
title('RGB')
subplot(2,3,2)
imshow(HSV)
title('HSV')

subplot(2,3,4)
imshow(HSVgained)
title('HSV image w. Value gained')
subplot(2,3,5)
imshow(Filter)
title('Intersection of all masks (HSV channels masks)')
subplot(2,3,6)
imshow(RGBgained_redColorMasked)
title('RGB image masked w. Gained Value')

end