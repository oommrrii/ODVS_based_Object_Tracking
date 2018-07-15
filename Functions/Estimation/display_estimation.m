function [frame] = display_estimation(frame,X,P)
% Update last state representation using information from the measurement
% (robot detaction) into new state representation.
% Input:
% frame - video frame with marked detection of the robot.
% X - state vector of robot.
% P - covariance matrix of the state.
%
% Output:
% frame - video frame with marked estimation parameters.

% Mark C.M.
frame = insertMarker(frame,transpose(X),'plus','color','yellow','size',1);

% Mark an error ellipse
ellipse = error_ellipse(P,X);
frame = insertShape(frame,'Polygon',ellipse,...
    'Color', 'white','Opacity',0.7);

% Add text
text_str = ['Updated position:' newline '(' num2str(X(1),'%0.2f') ',' num2str(X(2),'%0.2f') ')' newline ...
    'Updated covariance:' newline '[' num2str(P(1,1),'%0.2f') ' ' num2str(P(1,2),'%0.2f') newline ...
    num2str(P(2,1),'%0.2f') ' ' num2str(P(2,2),'%0.2f') ']'];

frame = insertText(frame,transpose(X)+[20 12],text_str,'FontSize',18,'BoxColor',...
    [40 0 77],'BoxOpacity',0.4,'TextColor','white');

%% Display

% imshow(frame);

end