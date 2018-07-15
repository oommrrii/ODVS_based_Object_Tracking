%% File names

global Path LoadVideoName SaveVideoName

Path = "C:\Users\User\OneDrive - Technion\Msc\Thesis\Experiments"; % adds the folder of the raw data to the path
LoadVideoName = '2nd_experiment\Video cut\Experiment02_ODVS_a_short.avi'; % Name of a video file
SaveVideoName = Path + "\2nd_experiment\manipulated data\MyTrackingResults_Experiment02_ODVS_a.avi"; % Name of video results file

% Transfer strings to char vectors
Path = char(Path);
SaveVideoName = char(SaveVideoName);
%% Static parameters
%%
global Static
Static = ...
    struct('brightness', 0.5,...    % <1 brighter; >1 darker; a 1-by-3 vector, applies a unique gamma to each color channel
    'Hthresh', [0.10 0.85],...      % [Minimum Maximum] Hue channel threshold
    'Sthresh', [0.4],...            % [Minimum] Saturation channel threshold
    'Vthresh', [0.43 0.60],...        % [Minimum Maximum] Value channel threshold
    'seTable',...                   % Create morphological structuring element for table detection
    [strel('disk',28)
    strel('disk',8)],...
    'seRobot',...                   % Create morphological structuring element for robot detection
    [strel('disk',3)
    strel('disk',15)],...
    'maxNoiseSize',[40, 15],...     % Minimum object area [table, robot] (number of conected pixels)
    'f',0,...                       % Camera's sampling rate (initialized as zero and decleared at 'video.m')
    'S',5.991,...                   % Confidence level of 95%. Dereived from Chi-square distribution for 2DOF
    'ellipseScale',5);              % Scale error ellipse for display reassons
%% Dynamic parameters
% Video object to be used by video function
%%
global detectObj;
global Dynamic
Dynamic = ...
    struct('cam_moves',logical(true),...% '1' If the camera moves; '0' if static
    'tableMask',ones(3));               % Stores the last derived table mask

% Create System objects for foreground detection and blob analysis

% Connected groups of foreground pixels are likely to correspond to moving
% objects.  The blob analysis System object is used to find such groups
% (called 'blobs' or 'connected components'), and compute their
% characteristics, such as area, centroid, and the bounding box.

detectObj.blobAnalyser = vision.BlobAnalysis('AreaOutputPort', false,...
    'CentroidOutputPort', true, ...
    'BoundingBoxOutputPort', true, ...
    'MajorAxisLengthOutputPort', true,...
    'MinorAxisLengthOutputPort', true,...
    'OrientationOutputPort', true,...
    'MinimumBlobArea', 40, 'MaximumBlobArea', 3000);