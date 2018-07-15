clear all; clc; close all;

%% START VIDEO
% Define and load video file names
Path = "C:\Users\User\OneDrive - Technion\Msc\Thesis\Experiments"; % adds the folder of the raw data to the path
LoadVideoName = '2nd_experiment\Experiment02_ODVS_a.avi'; % Name of a video file
SaveVideoName = Path + "\2nd_experiment\Video cut\Experiment02_ODVS_a_short.avi"; % Name of video results file

% Transfer strings to char vectors
Path = char(Path);
SaveVideoName = char(SaveVideoName);

% Initialize Video I/O
% Create objects for reading a video from a file, drawing the tracked
% objects in each frame, and playing the video.

% Create a video file reader.
vidObj.reader = vision.VideoFileReader(LoadVideoName);

% Create a video player, to display the video and the foreground mask.
vidObj.viewer = vision.DeployableVideoPlayer('Size','Custom','CustomSize',[820 600]);

% Record tracking video
vidObj.writer = vision.VideoFileWriter(SaveVideoName,'FrameRate',...
    vidObj.reader.info.VideoFrameRate,'VideoCompressor', 'MJPEG Compressor');

% For choosing a codec for recorded video. 
% write in the command window the folowing line and click 'Enter':
% y = vision.VideoFileWriter;
% write in the command window the folowing line and click 'Tab':
% y.VideoCompressor = '

%% FRAMES MANIPULATION
% MAIN LOOP. Decide how many frames to record.
video_calc = tic; % Timer

x = 30; % Start after x seconds
y = 35; % Cut after y seconds

% Multiply by frame rate
X = round(vidObj.reader.info.VideoFrameRate*x);
Y = round(vidObj.reader.info.VideoFrameRate*y);

nFrames = 0;

%for nFrames = X:Y % Run frames from x seconds until y seconds
while ~isDone(vidObj.reader)  % Run frames until the last one
    nFrames = nFrames +1;     % Propagate frame counter
        
    % Read next frame
    frame  = step(vidObj.reader);
    
    if (nFrames<=Y && nFrames>=X)
        % View next frame
        step(vidObj.viewer, frame);
        % Record tracking video
        step(vidObj.writer, frame);
    end
end
elapsed_time = toc(video_calc) % Timer

%% STOP VIDEO
% Release resources
 release(vidObj.reader);
 release(vidObj.viewer);
 release(vidObj.writer);
