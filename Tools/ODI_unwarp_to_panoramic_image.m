clc; clear all; close all;
%% Define file and folder (change as needed)
Path = "C:\Users\User\OneDrive - Technion\Msc\Thesis\Experiments\ODVS calibration"; % adds the folder of the raw data to the path
LoadImageName = 'cal1.jpg'; % Name of OmniDirectional Image file

%% Load
addpath(genpath(Path)); % adds a folder to the path
ODI = imread(LoadImageName);

%% Parameters (change as needed)
H_pn = 3600; % (Horizontal) Width of the panoramic image.
V_pn = 430; % (Vertical) Height of the panoramic image.
r_pixel = 432; % Radius of ODI.
u0 = 682; % Horizontal coordinate of the center of the ODI
v0 = 507; % Vertical coordinate of the center of the ODI

%% Equations: f(u_pn, v_pn) 
% (u_pn, v_pn) - Coordinates of a pixel in the panoramic image.
lookup_table = zeros(H_pn,V_pn,2);
for u_pn=1:H_pn
    for v_pn=1:V_pn
        A = (1-v_pn/V_pn)*r_pixel;
        B = -2*pi()*u_pn/H_pn;
        % (u,v) - Coordinates of a pixel in the original ODI.
    	u = round(A*cos(B)); 
        v = round(A*sin(B));
        lookup_table(u_pn, v_pn, :) = [u;v];
    end
end      

%% Transform ODI to Panoramic image
Panoramic = uint8(zeros(V_pn,H_pn));
for u_pn=1:H_pn
    for v_pn=1:V_pn
        % Adding translation of axes orign to the center of the ODI.
        u = u0 + lookup_table(u_pn, v_pn, 1);
        v = v0 - lookup_table(u_pn, v_pn, 2);
        Panoramic(v_pn, u_pn) = ODI(v,u);
    end
end
imarray = horzcat(ODI,zeros(size(ODI,1),size(Panoramic,2)-size(ODI,2)));
imarray = vertcat(imarray,Panoramic);
imshow(imarray)
