function [X_new,P_new] = update_state(measurement,X_prior,P_prior)
% Update last state representation using information from the measurement
% (robot detaction) into new state representation.
% Input:
% measurement - structure of variables containing information about the
% detected blob.
% X_prior - Predicted state vector of robot.
% P_prior - Predicted covariance matrix of the state.
%
% Output:
% X_new - new state vector, derived from measurement update.
% P_new - new covariance matrix, derived from measurement update.

% measurement prediction matrix
H = [1 0;
    0 1];

% measurement noise covariance
R = [10 0;
    0 10];

% Measurement likelihood
Z_hat = H*X_prior;
S_hat = H*P_prior*transpose(H) + R;

% Measurement
Z = transpose(measurement.centroids);

% innovation
v = Z - Z_hat;

% Kalman gain
K = P_prior*transpose(H)*inv(S_hat);

% Update
X_new = X_prior + K*v;
P_new = (eye(2) - K*H)*P_prior;
end