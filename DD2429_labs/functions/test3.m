load('mine.mat')
%%
% points2d_gt = click_multi_view( images );
% points3d_gt = reconstruct_point_cloud( cameras, points2d_gt );
% save('../data/data_toyhouse_reconstruction.mat','points3d_gt','points2d_gt');

load('../data/data_toyhouse_reconstruction.mat')
% temp=click_multi_view( images );
% points2d_gt=[points2d_gt,temp];
% points3d_gt = reconstruct_point_cloud( cameras, points2d_gt );
% save('../data/data_toyhouse_reconstruction.mat','points3d_gt','points2d_gt');

p1 = [0 0 0 1]';            % 1 in pictures.
p2 = p1 +  [-10 0  0  0]';  % 2 in pictures.
p3 = p1 +  [0   0  9  0]';  % 3 in pictures.
p4 = p1 +  [0 27  0  0]';  % 5 in pictures.
p5 = p1 + [-5 27 15  0]';  % 11 in pictures.
p6=p1+[0 27 10 0]';
p7=p1+[-5 5 15 0]';
p8=p1+[-10 0 9 0]';
p9=p1+[0 5 10 0]';
p10=p1+[0 5 9 0]';
p11=p1+[-10 5 10 0]';
p12=p1+[0 5 0 0]';
points3d_ground_truth = [p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12];

%%
H = compute_rectification_matrix( points3d_gt, points3d_ground_truth );

% Rectify the points:
points3d = H*points3d;
cameras(:,:,1) = cameras(:,:,1)*inv(H);
cameras(:,:,2) = cameras(:,:,2)*inv(H);
camera_centers = H*camera_centers;
% 
% points3d=bsxfun(@rdivide,points3d,points3d(4,:));
% camera_centers=bsxfun(@rdivide,camera_centers,camera_centers(4,:));

% points3d_ground_truth=points3d_ground_truth(:,1:3);
% points2d_gt=points2d(:,1:3,:)
tri=[1 2 3;
    2 3 8;
    5 7 9;
    5 6 9;
    4 6 9;
    4 9 10;
    4 10 12;
    1 3 12;
    3 10 12;
    7 8 11;
    7 9 11;
    9 10 11;
    3 8 10;
    8 10 11;
    ];

% visualize_reconstruction( points3d, camera_centers, ...
%     points2d( :, :, REFERENCE_VIEW ), images{REFERENCE_VIEW} )


visualize_reconstruction3( points3d_ground_truth, camera_centers, ...
    points2d_gt(:,:,1), images{REFERENCE_VIEW},tri )






