function [measurement,frame] = detect(frame)
% Detects white robot targets on the table and return their C.M. position
% together with bounding box coordinates.
% Input:
% frame - RGB color frame with table background masked
%
% Output:
% measurement - structure

global detectObj Static;

% Transform RGB frame into Gray scale
I = rgb2gray(frame);
BW = imbinarize(I,0.52);

% Apply morphological operations to remove noise and fill in holes.

% Perform an erosion followed by a dilation using a small disk shape
% structural element to erase small regions which most likely represents
% noise or non accurate detected regions:
BW_open = imopen(BW, Static.seRobot(1));

% Perform a dilation followed by an erosion using a large disk shape
% structural element to connect separated regions and make the regions
% rounder:
BW_close = imclose(BW_open, Static.seRobot(2));

% Fill holes in the BW image to remove noise from detections:
mask = imfill(BW_close, 'holes');

% Perform blob analysis to find connected components within a certain size
% (number of pixels) boundary.
[measurement.centroids, measurement.bboxes, measurement.majorAxis, ...
    measurement.minorAxis, measurement.orientation] = detectObj.blobAnalyser.step(mask);

%% Display detected robots
%
% Create categorical labels based on the image contents. Each pixel
% receives a label.
stringArray = repmat("table",size(mask));
stringArray(mask) = "robot";

% Create categories.
categoricalSegmentation = categorical(stringArray);
% Fuse the mask with the original image.
frame = labeloverlay(frame,categoricalSegmentation,'IncludedLabels',"robot",...
    'Colormap','autumn','Transparency',0.7);

%% Display different frame manipulations.
% figure;
% subplot(2,4,1);
% imshow(I); title('Gray scale frame');
% subplot(2,4,2);
% imshow(mask); title('Robots are white, background is masked');
% subplot(2,4,3);
% imshow(frame); title('RGB frame w. marked robots');
% subplot(2,4,5);
% imshow(BW); title('BW image after gray thresholding');
% subplot(2,4,6);
% imshow(BW_open); title('BW image after morphological open');
% subplot(2,4,7);
% imshow(BW_close); title('BW image after morphological close');
% subplot(2,4,8);
% imshow(mask); title('BW image after holes are filled');
end