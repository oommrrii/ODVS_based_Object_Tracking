function [cropped_frame] = frame_crop(tableMask,masked_frame)
% Crop a rectangular frame arround the mask's true values
% Input:
% tableMask - The logical mask covering the area outside of the table.
% masked_frame - The video frame after background masked was applied.
%
% Output:
% cropped_frame - The video frame after background masked was applied and
% frame was cropped to a minimum rectangle.

% Find the rectangle encompassing the non masked region
[row,col] = find(tableMask);

% Define rectangle for cropping
up = min(row);
down = max(row);
left = min(col);
right = max(col);

% Crop the frame
cropped_frame = masked_frame(up:down,left:right,:);
% cropped_frame = masked_frame(110:749,118:757,:);
end