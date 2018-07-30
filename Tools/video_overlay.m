clear all; clc; close all;

%% START VIDEO
% Define and load video file names
Path = "C:\Users\User\OneDrive - Technion\Msc\Thesis\Experiments"; % adds the folder of the raw data to the path
LoadVideoName1 = '2nd_experiment\manipulated data\MyTrackingResults_Experiment02_ODVS_a.avi'; % Name of a first video file
LoadVideoName2 = '2nd_experiment\Experiment02_Tracker_a.avi'; % Name of a second video file
SaveVideoName = Path + "\2nd_experiment\Video overlay\Experiment02_ODVS_a_withTracker.avi"; % Name of video results file

% Transfer strings to char vectors
Path = char(Path);
SaveVideoName = char(SaveVideoName);

% Initialize Video I/O
% Create objects for reading a video from a file, drawing the tracked
% objects in each frame, and playing the video.

% Create a video file reader.
vidObj.reader1 = vision.VideoFileReader(LoadVideoName1);
vidObj.reader2 = VideoReader(LoadVideoName2);

% Create a video player, to display the video and the foreground mask.
vidObj.viewer = vision.DeployableVideoPlayer('Size','Custom','CustomSize',[820 600]);

% Video1 frame rate
FrameRate = vidObj.reader1.info.VideoFrameRate;

% Record tracking video
vidObj.writer = vision.VideoFileWriter(SaveVideoName,'FrameRate',...
    FrameRate,'VideoCompressor', 'MJPEG Compressor');

% For choosing a codec for recorded video. 
% write in the command window the folowing line and click 'Enter':
% y = vision.VideoFileWriter;
% write in the command window the folowing line and click 'Tab':
% y.VideoCompressor = '

%% SET PARAMETERS

nFrames = 0;

% Decide which seconds of the first video to add to the record.
t1x = 23; % Start after x seconds
% t1y = 24; % Cut after y seconds

% Transfer time to number of frames
f1x = FrameRate * t1x;
% f1y = FrameRate * t1y;

% Progress video 1 to the starting frame
if (t1x ~= 0)
    while (nFrames < f1x)
        nFrames = nFrames +1;     % Propagate frame counter
        % Read next frame
        frame  = step(vidObj.reader1);
    end
end

% Decide which seconds of the second video to add to the record.
t2x = 12; % Start after x seconds
% t2y = 24; % Cut after y seconds

% Initial second video at the chosen frame
vidObj.reader2.CurrentTime = t2x;

% Choose overlay position
row = 1;
col = 1;

% Choose cropping parameters [xmin ymin width height]
xmin = 68;
width = vidObj.reader2.Width - xmin - 88;


%% FRAMES MANIPULATION
% MAIN LOOP. 
video_calc = tic; % Timer

while ~isDone(vidObj.reader1)  % Run frames until the last one
    nFrames = nFrames +1;     % Propagate frame counter
        
    % Read next frame
    frame  = step(vidObj.reader1);
    if hasFrame(vidObj.reader2)
        frame2 = readFrame(vidObj.reader2);
    end
    
    % Crop second video
    frame2_cropped = imcrop(frame2,[xmin 1 width vidObj.reader2.Height]);%[xmin ymin width height]
%     imshow(frame2_cropped);

    % Resize second video
    frame2_small = imresize(frame2_cropped,0.55);
    
    % Transfering image pixels values from uint8 to single
    frame2_small = im2single(frame2_small);
    
    % Overlay both frames
    frameSize = size(frame2_small);
    frame(row:row+frameSize(1)-1,col:col+frameSize(2)-1,:) = frame2_small;
    
    % View next frame
    step(vidObj.viewer, frame);
    % Record tracking video
    step(vidObj.writer, frame);
    
end
elapsed_time = toc(video_calc) % Timer

%% STOP VIDEO
% Release resources
 release(vidObj.viewer);
 release(vidObj.writer);
