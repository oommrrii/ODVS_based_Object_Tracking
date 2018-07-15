%% ODVS based Object Tracking
%% Fixed camera, single target
% All parameters should be change through the file
% 'define_global_parameters.mlx'.

clear all; clc; close all;
%% Initialize algorithm
%%
% Define global parameters
run('define_global_parameters.m');

% Load an offline video
[frame,video_ended] = video('initialize'); % 'initialize'/'next'/'record'/'finalize'

% Obtain measurement (Detect target & Data association)
[measurement,frame] = detect(frame);

% Set prior
[X,P] = initialize_state(measurement);

% Record manipulated frame
video('record',frame);
%% Run state estimation loop
%%
estimation_loop_timer = tic; % Timer
% While video has not ended, run state estimation on each frame
while ~video_ended
    
    % Predict the state before the next sampling
    [X_predicted,P_predicted] = prediction_state(X,P);
    
    % Load next video frame
    [frame,video_ended] = video('next');
    
    % Obtain measurement
    [measurement,frame] = detect(frame);
    
    % Update the state via innovation (using measurement likelihood from prior and taken measurement)
    [X,P] = update_state(measurement,X_predicted,P_predicted);
    
    % Display estimated data
    [frame] = display_estimation(frame,X,P);
    
    % Record manipulated frame
    video('record',frame);
end
elapsed_time = toc(estimation_loop_timer); % Timer [sec]
fprintf('Elapsed time is: %d:%d Minutes',...
    floor(elapsed_time/60),int8(mod(elapsed_time,60))) % Print time [min]
%% Finalize algorithm
%%
% close & save video
video('finalize');

% Compare results
% compare();