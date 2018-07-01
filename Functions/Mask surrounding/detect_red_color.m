function [borderMask] = detect_red_color(frame)
% Color detection based on HSV color space
% Input:
% frame - Current frame
%
% Output:
% borderMask - Noisy BW image. Red is marked by logic '1' 
% (represented as white), other colors are logic '0' (black).

% Read global parameters
global Static

% Adjust brightness (<1 brighten for better detection)
%frame_brighten = imadjust(frame, [], [], Static.brightness);
frame_brighten = frame;

% Enhance the red color and mask other colors
frame_red_enhanced = red_enhancement(frame_brighten);

% Observe red channel only
R = frame_red_enhanced(:,:,1);

% Make a logical mask from high red values
borderMask = (R >= Static.Rthresh);

%% DISPLAY

figure('name','Detect red color');
subplot(2,3,1)
imshow(frame)
title('Original frame')
subplot(2,3,2)
imshow(frame_brighten)
title('Brighter frame')
subplot(2,3,3)
imshow(frame_red_enhanced)
title('Enhanced red color & other colors masked')
subplot(2,3,4)
imshow(R)
title('Red channel only')
subplot(2,3,5)
imshow(borderMask)
title('Mask non red colors')

end