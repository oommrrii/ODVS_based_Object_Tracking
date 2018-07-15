global vidObj detectObj;

% Create System objects for foreground detection and blob analysis

% The foreground detector is used to segment moving objects from
% the background. It outputs a binary mask, where the pixel value
% of 1 corresponds to the foreground and the value of 0 corresponds
% to the background.
detectObj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 100, 'MinimumBackgroundRatio', 0.3);

% Connected groups of foreground pixels are likely to correspond to moving
% objects.  The blob analysis System object is used to find such groups
% (called 'blobs' or 'connected components'), and compute their
% characteristics, such as area, centroid, and the bounding box.

detectObj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', 40);

% Detect foreground.
mask = detectObj.detector.step(frame);

% Apply morphological operations to remove noise and fill in holes.
mask = imopen(mask, strel('disk', [3]));
mask = imclose(mask, strel('disk', [15]));
mask = imfill(mask, 'holes');

% Perform blob analysis to find connected components.
[~, centroids, bboxes] = detectObj.blobAnalyser.step(mask);

% Draw the objects on the frame.
frame = insertObjectAnnotation(frame, 'rectangle', bboxes,'hi');