function [ellipse] = error_ellipse(P,X)
% Transform the estimated state covariance matrix to a representative error
% ellipse.
% Input:
% X - state vector of robot.
% P - covariance matrix of the state.
%
% Output:
% ellipse - Ellipse pixels coordinates.

global Static;

% Calculate the eigenvectors and eigenvalues
[eigenvec, eigenval ] = eig(P);

% Sort eigenvalues descending
[d,ind] = sort(diag(eigenval),'descend');

% Get the largest eigenvalue & eigenvector
largest_eigenval = d(1);
largest_eigenvec = eigenvec(:, ind(1));

% Get the smallest eigenvalue & eigenvector
smallest_eigenval = d(2);
smallest_eigenvec = eigenvec(:, ind(2));

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    angle = angle + 2*pi;
end

% Get the 95% confidence interval error ellipse
chisquareRoot_val = sqrt(Static.S); % 2.4477
theta_grid = linspace(0,2*pi);
% Use negative angle because covarriance to ellipse calculation has been
% done in a normal cartezian (x,y) coordinate frame, while image
% presentation is done using a fliped y axis with its origin at the top of
% the image.
phi = -angle;
X0=X(1);
Y0=X(2);
a= sqrt(largest_eigenval*chisquareRoot_val)*Static.ellipseScale;
b= sqrt(smallest_eigenval*chisquareRoot_val)*Static.ellipseScale;

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) -sin(phi); sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = R*[ellipse_x_r;ellipse_y_r];

% Translate ellipse
r_ellipse(1,:) = r_ellipse(1,:) + X0;
r_ellipse(2,:) = r_ellipse(2,:) + Y0;

% Reshape array of pixels
ellipse = reshape(r_ellipse,1,[]);

%% Display

% % Draw the error ellipse
% plot(r_ellipse(1,:),r_ellipse(2,:),'-');
% hold on;
% 
% % Plot the eigenvectors
% quiver(X0, Y0, largest_eigenvec(1)*largest_eigenval, -largest_eigenvec(2)*largest_eigenval, '-m', 'LineWidth',2);
% quiver(X0, Y0, smallest_eigenvec(1)*smallest_eigenval, -smallest_eigenvec(2)*smallest_eigenval, '-g', 'LineWidth',2);
% hold off;
% 
% axis equal;
end
