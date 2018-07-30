function [masked_frame] = mask_surrounding(frame)
% input/output: frame image/ frame image without table surrounding.

% 1) Detects the table by enhancing the red line encircling the table and 
%    creating a logical image marking it.
% 2) Manipulates the logicaly marked border and creates a mask that covers 
%    the surrounding of the table.
% *) If function decides if it is needed to detect a new table mask or it
%    is possible to use last derived mask.

% 3) Cover the input frame with the table mask and output the masked frame
%    as a clean data for the rest of the algorithm.
% 4) Crop the masked image in order to compute less pixels.
global Dynamic

% If function decides if it is needed to detect a new table mask or not
if Dynamic.cam_moves % If the camera moves
    %% 1
    % Uses HSV transform to detect red color on table border and outputs BW
    % (logic) image.
    borderMask = detect_red_color(frame);
    %% 2
    % Creates a mask that covers the background outside of the red
    % line, that encircles the table.
    tableMask = detect_table(frame,borderMask);
    
    % Save table mask as global
    Dynamic.tableMask = tableMask;
    
    % ############ BECAUSE THIS EXPERIMENT USES A STATIC CAMERA ##########
    Dynamic.cam_moves = 0;
else % If the camera doesn't move
    %% *
    % Use the last derived table mask
    tableMask = Dynamic.tableMask;
end
%% 3
% Multiply the frame with the mask to make all surrounding background black
masked_frame = immultiply(frame,repmat(logical(tableMask),[1 1 3]));

%% 4
% Crop a rectangular frame arround the mask's true values
% cropped_frame = frame_crop(tableMask,masked_frame);

%% DISPLAY
% figure('name','Mask serrounding');
% subplot(1,2,1)
% imshow(frame)
% title('Original frame')
% subplot(1,2,2)
% imshow(masked_frame)
% title('Masked frame')

% figure('name','Mask serrounding');
% imshowpair(frame,masked_frame,'montage');

end