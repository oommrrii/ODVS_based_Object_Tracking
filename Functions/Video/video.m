function [frame,video_ended] = video(option,frame_for_record)
%This function manipulates the input and output video
% Input:
% option - receives 'initialize'/'next'/'record'/'finalize' to order
% the correct operations for the different requiered video states.
% frame_for_record - the manipulated frame which needs to be recorded.
%
% Output:
% frame - current frame at the reader.
% video_ended - flags '0'/'1' if it's the last frame at the reader.

% Use global video object
global vidObj;

%% DEFINE VIDEO LOCATION & FILE NAME
global Path LoadVideoName SaveVideoName Static
addpath(genpath(Path)); % adds a folder to the path

%% MANIPULATE VIDEO
switch option
    case 'initialize'
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the tracked
        % objects in each frame, and playing the video.
        
        % Create a video file reader.
        vidObj.reader = vision.VideoFileReader(LoadVideoName);
        
        % Create a video player, to display the video and the foreground mask.
        % vidObj.viewer = vision.DeployableVideoPlayer('Size','Custom','CustomSize',[820 600]);
        % vidObj.videoPlayer = vision.VideoPlayer('Position', [300, 20, 900, 800]);
        
        % initialize camera's sampling rate parameter
        Static.f = vidObj.reader.info.VideoFrameRate;
        
        % Record tracking video
        vidObj.writer = vision.VideoFileWriter(SaveVideoName,...
            'FrameRate',Static.f,'VideoCompressor', 'MJPEG Compressor');
        
        % For choosing a different codec for recorded video,
        % write in the command window the folowing line and click 'Tab':
        % vision.VideoFileWriter.VideoCompressor = '
        
        % Read first frame
        frame = step(vidObj.reader);
        
        % Check if reader is at the last frame
        video_ended = isDone(vidObj.reader);
        
        % Mask noise from surrounding
        [frame] = mask_surrounding(frame);
        
    case 'next'
        % Advances the video reader
        
        % Read next frame
        frame = step(vidObj.reader);
        
        % Check if reader is at the last frame
        video_ended = isDone(vidObj.reader);
        
        % Mask noise from surrounding
        [frame] = mask_surrounding(frame);
        
    case 'record'
        % Record tracking video
        step(vidObj.writer, frame_for_record);
        
    case 'finalize'
        % STOP VIDEO
        % Release resources
        release(vidObj.reader);
        %release(vidObj.viewer);
        %release(vidObj.videoPlayer);
        release(vidObj.writer);
end
end