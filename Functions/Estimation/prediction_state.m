function [X_predicted,P_predicted] = prediction_state(X_prior,P_prior)
% Predict next state representation by updating the time for the motion
% model (robot motion) into a new state representation.
% Input:
% X_prior - Prior state vector of robot.
% P_prior - Prior covariance matrix of the state.
%
% Output:
% X_predicted - predicted state vector, derived from time update.
% P_predicted - predicted covariance matrix, derived from time update.

global Static;

% Time step derived from camera's sampling rate
T = 1/Static.f;

% Process noise covariance matrix
Q = [0.1 0;
    0 0.1];

% Motion model
F = [1 0;
    0 1];

X_predicted = F*X_prior;
P_predicted = F*P_prior*F' + Q;
end