function [X,P_image] = initialize_state(measurement)
% Transforms information from the measurement (robot detaction) into 
% adequate state representation.
% Input:
% measurement - structure of variables containing information about the
% detected blob.
%
% Output:
% X - initial state vector, derived from coordinates of C.M. of the
% detected robot.
% P_image - initial covariance matrix, derived from the ellipse that has
% the same second-moments as the region of the blob.

global Static

X = transpose(measurement.centroids);

% Substituting the angle between major axis of the robot and x axis of the
% image
a = measurement.orientation;

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(a < 0)
    a = a + 2*pi;
end

% Construct a covariance matrix in the robot's body frame, from the major &
% minor axis of the the ellipse that has the same second-moments as the
% region of the blob.
P_robot = [((measurement.majorAxis/2)^2)/Static.S 0;
    0 ((measurement.minorAxis/2)^2)/Static.S];

% Transforming covariance matrix to the image frame
R_robot2image = [cos(a) -sin(a);
    sin(a) cos(a)];
P_image = [0 0;0 0];%R_robot2image * P_robot;
end