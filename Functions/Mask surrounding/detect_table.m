function [tableMask_erode] = detect_table(frame, borderMask)
% Function detects table, based on the red border line and morpholigical
% operators.
% Input:
% frame - Current frame
% borderMask - Noisy BW image. Table border is white, other colors are black
%
% Output:
% tableMask - Logical mask of current frame. Only table is visible.

global Static

%% Remove noise

% Dilate (wider) image using small size structural element (disk shape). Used for
% enlarging shape bounderies and connecting shape parts into continouos
% circle shape.
bw_dilate_small = imdilate(borderMask, Static.seTable(3)); 

% Remove small noise objects from binary image. removes all connected
% components that have fewer than minArea pixels.
bw_UnNoised = bwareaopen(bw_dilate_small, Static.minArea(2));

%% Soften the image
% Dilate (wider) image using big size structural element (disk shape)
bw_dilate = imdilate(bw_UnNoised, Static.seTable(1)); 

% Erode (nerower) image using big size structural element (disk shape)
bw_erode = imerode(bw_dilate,Static.seTable(1));

%% Detect the table
% Image inverse (###O###O### => OOO#OOO#OOO)
bw_inv = imcomplement(bw_erode);

% Fill holes (###O###O### => ###OOOOO###)
bw_fill = imfill(bw_erode,'holes');

% % Combine '1' pixels from the image inverse and the filled image
% (OOO#OOO#OOO * ###OOOOO### => ####OOO####)
% tableMask = bw_fill.*bw_inv;

%% Reversing  erode and silation
% Erode (nerower) image using big size structural element (disk shape)
bw_fill_erode = imerode(bw_fill,Static.seTable(1));

% Remove small objects from binary image. removes all connected
% components that have fewer than minArea pixels.
tableMask_UnNoised = bwareaopen(bw_fill_erode, Static.minArea(2));

% Dilate (wider) image using big size structural element (disk shape)
tableMask_dilate = imdilate(tableMask_UnNoised, Static.seTable(1)); 

% Fill holes
tableMask_fill = imfill(tableMask_dilate,'holes');

% The morphological close operation is a dilation followed by an erosion,
% using the same structuring element.
tableMask_close = imclose(tableMask_fill, Static.seTable(1));

% Erode image
tableMask_erode = imerode(tableMask_close,Static.seTable(1));

%% Display

figure('name','Detect table - Morphological steps');
subplot(3,5,1); imshow(borderMask); title('Non red masked');
subplot(3,5,2); imshow(bw_dilate_small); title('Border dilate small');
subplot(3,5,3); imshow(bw_UnNoised); title('Border denoised');
subplot(3,5,4); imshow(bw_dilate); title('Border dilate');
subplot(3,5,5); imshow(bw_erode); title('Border erode');
subplot(3,5,6); imshow(bw_inv); title('Border inverse');
subplot(3,5,7); imshow(bw_fill); title('Border fill');
%         subplot(3,5,8); imshow(tableMask); title('Table mask');
subplot(3,5,9); imshow(bw_fill_erode); title('Table mask erode');
subplot(3,5,10); imshow(tableMask_UnNoised); title('Mask denoised');
subplot(3,5,11); imshow(tableMask_dilate); title('Mask dilate');
subplot(3,5,12); imshow(tableMask_fill); title('Mask fill');
subplot(3,5,13); imshow(tableMask_close); title('Mask dilate and erode');
subplot(3,5,14); imshow(tableMask_erode); title('Mask erode');

frame_red_marked = imoverlay(frame,bw_UnNoised,'red');
figure('name','Detect table - Red marking'); imshow(frame_red_marked); title('Border marked on frame');
end
