function [tableMask] = detect_table(frame, borderMask)
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
% Remove small noise objects from binary image. removes all connected
% components that have fewer than minArea pixels.
bw_UnNoised = bwareaopen(borderMask, Static.maxNoiseSize(1));

%% Complete the scattered border shape
% Dilate (wider) image using large size structural element (disk shape).
% Used for enlarging shape bounderies and connecting shape parts into
% continouos circle shape.
bw_dilate = imdilate(bw_UnNoised, Static.seTable(1)); 

%% Non-maximum suprression - similiar algorithm
% Thining line made of connected components. performed iteretivly untill
% converged.
bw_thin = bwmorph(bw_dilate, 'thin',inf); 

%% Thicken the border
% Dilate (wider) image using small size structural element (disk shape).
bw_dilate_small = imdilate(bw_thin,Static.seTable(2));

%% Mask background outside of the table border from the inner edge of the border
% Image inverse (###O###O### => OOO#OOO#OOO)
bw_inv = imcomplement(bw_dilate_small);

% Fill the circle to a complete disk (###O###O### => ###OOOOO###)
bw_fill = imfill(bw_dilate_small,'holes');

% Mask background, outside of the border
% Combine '1' pixels from the image inverse and the filled image
% (OOO#OOO#OOO * ###OOOOO### => ####OOO####)
tableMask = bw_fill.*bw_inv;


%% Display

% figure('name','Detect table - Morphological steps');
% subplot(2,5,1); imshow(borderMask); title('Non red masked');
% subplot(2,5,2); imshow(bw_UnNoised); title('Border denoised');
% subplot(2,5,3); imshow(bw_dilate); title({'Border dilate';'using big structural element'});
% subplot(2,5,4); imshow(bw_thin); title({'Thin border';'using "Thinning Methodologies-';'A Comprehensive Survey"'});
% subplot(2,5,5); imshow(bw_dilate_small); title({'Border dilate';'using small structural element'});
% %
% frame_red_marked = imoverlay(frame,bw_dilate_small,'red');
% subplot(2,5,6); imshow(frame_red_marked); title('Border marked on frame');
% 
% subplot(2,5,7); imshow(bw_inv); title('Border inverse');
% subplot(2,5,8); imshow(bw_fill); title('Border fill');
% subplot(2,5,9); imshow(tableMask); title('Table mask')
% 
% frame_table_marked = immultiply(frame,repmat(logical(tableMask),[1 1 3]));
% subplot(2,5,10); imshow(frame_table_marked); title('Table background masked on frame');
end
