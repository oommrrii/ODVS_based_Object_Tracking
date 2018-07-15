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
BW = imbinarize(I,0.55);

% Apply morphological operations to remove noise and fill in holes.
BW_open = imopen(BW, Static.seRobot(1));
BW_close = imclose(BW_open, Static.seRobot(2));
mask = imfill(BW_close, 'holes');

% Perform blob analysis to find connected components.
[measurement.centroids, measurement.bboxes, measurement.majorAxis, ...
    measurement.minorAxis, measurement.orientation] = detectObj.blobAnalyser.step(mask);

%% Display detected robots
%
% Create categorical labels based on the image contents.
stringArray = repmat("table",size(mask));
stringArray(mask) = "robot";
categoricalSegmentation = categorical(stringArray);

% Fuse the mask with the original image.
frame = labeloverlay(frame,categoricalSegmentation,'IncludedLabels',"robot",...
    'Colormap','autumn','Transparency',0.7);

% Display different frame manipulations.
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