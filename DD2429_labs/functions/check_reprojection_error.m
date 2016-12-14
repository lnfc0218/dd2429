% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, points3d )

reproj=zeros(size(points2d));
reproj(:,:,1)=cameras(:,:,1)*points3d;
reproj(:,:,2)=cameras(:,:,2)*points3d;
reproj(:,:,1)=bsxfun(@rdivide,reproj(:,:,1),reproj(3,:,1));
reproj(:,:,2)=bsxfun(@rdivide,reproj(:,:,2),reproj(3,:,2));

diff=reproj-points2d;
error=sqrt(sum(diff.^2));
error=reshape(error,[],1);
error_average=mean(error);
error_max=max(error);
end