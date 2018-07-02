function [borderMask] = detect_red_color(frame)
% Color detection based on HSV color space
% Input:
% frame - Current frame
%
% Output:
% borderMask - Noisy BW image. Red is marked by logic '1' 
% (represented as white), other colors are logic '0' (black).

%% Preparing HSV channels

% Read global parameters
global  Static

% HSV transform
HSV = rgb2hsv(frame); 

% Substituting seperated channels
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

%% HSV chart explains different values
%
% <<C:\Users\User\OneDrive - Technion\Msc\Thesis\ODVS_based_Object_Tracking\Images\HSV chart.JPG>>
% 

%% Mask HSV channels
%
% Filter non red colors
Hfilter = ((H<=Static.Hthresh(1)) | (H>=Static.Hthresh(2)));

% Filter non-colorful (B&W) color
Sfilter = ((S>=Static.Sthresh));

% Filter dark & bright color
Vfilter = ((V>=Static.Vthresh(1)) & (V<=Static.Vthresh(2)));

% Multiply logic arrays to sum filters' effects
borderMask = Hfilter .* Sfilter .* Vfilter;

%% DISPLAY

% figure('name','Red enhancement - HSV masks');
% subplot(2,3,1)
% imshow(frame)
% title('Original frame - RGB channels')
% 
% subplot(2,3,4)
% imshow(Hfilter)
% title('Hue mask - Non red color masked')
% subplot(2,3,5)
% imshow(Sfilter)
% title('Saturation mask - Non Saturated color masked')
% subplot(2,3,6)
% imshow(Vfilter)
% title('Value mask - Extreme high & low Value masked')
% 
% subplot(2,3,2)
% imshow(borderMask)
% title('Intersection of all masks')
% 
% frame_red_marked = imoverlay(frame,borderMask,'red');
% subplot(2,3,3);
% imshow(frame_red_marked);
% title('Border marked on frame');

end