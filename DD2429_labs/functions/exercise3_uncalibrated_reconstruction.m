% Script: uncalibrated_reconstruction.m 
%
% Method: Performs a reconstruction of two 
%         uncalibrated cameras. The Fundametal matrix determines 
%         uniquely both cameras. The point-structure is obtained 
%         by triangulation. The projective reconstruction is 
%         rectified to a metric reconstruction with knowledge 
%         about the 3D object.
%         Finally the result is stored as a VRML model 
% 

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

REFERENCE_VIEW      = 1;
CAMERAS             = 2;
image_names_file    = 'names_images_toyhouse.txt';

SYNTHETIC_DATA      = 1;
REAL_DATA_CLICK     = 2;
REAL_DATA_LOAD      = 3;
VERSION             = SYNTHETIC_DATA;
% VERSION             = REAL_DATA_LOAD;


if VERSION == SYNTHETIC_DATA
    points2d_file = '../data/data_sphere.mat';
    points3d_file = '../data/data_sphere_reconstruction.mat';
else
    points2d_file = '../data/data_toyhouse.mat';
end


%% Load the 2d data

if VERSION == SYNTHETIC_DATA
    
    load( points2d_file );
    images = cell(CAMERAS,1);
    
elseif VERSION == REAL_DATA_CLICK
    
    [images image_names] = load_images_grey( image_names_file, CAMERAS ); 
    points2d = click_multi_view( images );%, CAMERAS , data, 0); % for clicking and displaying data
    save( points2d_file, 'points2d' );
    
elseif VERSION == REAL_DATA_LOAD
        
    [images,image_names] = load_images_grey( image_names_file, CAMERAS ); 
    load( points2d_file );
    
else
    return
end

%% Do projective reconstruction

F = compute_F_matrix( points2d );

[cameras camera_centers] = reconstruct_uncalibrated_stereo_cameras( F );

points3d = reconstruct_point_cloud( cameras, points2d );

[error_average error_max] = check_reprojection_error( points2d, cameras, points3d );
fprintf( '\n\nThe reprojection error: points2d = cameras * points3d is: \n' );
fprintf( 'Average error: %5.2fpixel; Maximum error: %5.2fpixel \n', error_average, error_max ); 


%% Rectify the projective reconstruction to a metric reconstruction

if VERSION == SYNTHETIC_DATA
    
    load( points3d_file ); % Load points3d_synthetic
    indices = [1 13 25 37 48];
    points3d_ground_truth = points3d_synthetic( :, indices );
    
else 

    % Manually provide the ground truth 3D coordinates for some points
    % in order to rectify:
      p1 = [0 0 0 1]';            % 1 in pictures.
      p2 = p1 +  [0  10  0  0]';  % 2 in pictures.
      p3 = p1 +  [0   0  9  0]';  % 3 in pictures.
      p4 = p1 +  [10  5 15  0]';  % 4 in pictures.
      p5 = p1 +  [27  0  0  0]';  % 5 in pictures.
      p6 = p1 +  [0  10  9  0]';  % 6 in pictures.
      p7 = p1 +  [10  0  9  0]';  % 7 in pictures.
      p11 = p1 + [27  5 15  0]';  % 11 in pictures.
      points3d_ground_truth = [p1 p2 p3 p5 p11];

      indices=1:5;
      points3d(:,indices)
      points3d_ground_truth(:,indices)

      figure(4);
      plot3(points3d_ground_truth(1,:),points3d_ground_truth(2,:),points3d_ground_truth(3,:),'xb')
      axis([-1 30 -1 15 0 20])
      xlabel('x'); ylabel('y'); zlabel('z');

%       model_synthetic_points = [1,2,3,5,11];
%       model_synthetic = [];  
%       for hi1 = 1:length(model_synthetic_points)
%          hd1 = model_synthetic_points(1,hi1); 
%          model_synthetic = [model_synthetic, model_sim(:,hi1)];
%       end
end

H = compute_rectification_matrix( points3d(:,indices), points3d_ground_truth );

% Rectify the points:

%------------------------------
points3d = H*points3d;
cameras(:,:,1) = cameras(:,:,1)*inv(H);
cameras(:,:,2) = cameras(:,:,2)*inv(H);
camera_centers = H*camera_centers;

points3d=bsxfun(@rdivide,points3d,points3d(4,:));
camera_centers=bsxfun(@rdivide,camera_centers,camera_centers(4,:));

% test3
visualize_reconstruction( points3d, camera_centers, ...
    points2d( :, :, REFERENCE_VIEW ), images{REFERENCE_VIEW} )

