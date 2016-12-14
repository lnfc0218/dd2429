% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )

cams=zeros(3,4,2);
cams(:,:,1)=K(:,:,1)*[eye(3),zeros(3,1)];

[U,~,V] = svd(E);
t=V(:,end);% t = V(:,end)./sum(V(:,end)); 
cam_centers=[0 0 0 1;t' 1]';

W = [0 -1 0; 1 0 0; 0 0 1];
R1 = U*W*V';
R2 = U*W'*V';

if(-1==det(R1))
    R1=-R1;
end
if(-1==det(R2))
    R2=-R2;
end

%case 1: Kb*R1*(I,t)
cams(:,:,2)=K(:,:,2)*R1*[eye(3),t];
p=reconstruct_point_cloud(cams, points2d );
aligned_p=R1*[eye(3),t]*p;
if (p(3)>0)&&(aligned_p(3)>0)
    return
end
%case 2: Kb*R1*(I,-t)
cams(:,:,2)=K(:,:,2)*R1*[eye(3),-t];
p=reconstruct_point_cloud(cams, points2d );
aligned_p=R1*[eye(3),-t]*p;
if (p(3)>0)&&(aligned_p(3)>0)
    return
end
%case 3: Kb*R2*(I,t)
cams(:,:,2)=K(:,:,2)*R2*[eye(3),t];
p=reconstruct_point_cloud(cams, points2d );
aligned_p=R2*[eye(3),t]*p;
if (p(3)>0)&&(aligned_p(3)>0)
    return
end
%case 4: Kb*R2*(I,-t)
cams(:,:,2)=K(:,:,2)*R2*[eye(3),-t];
p=reconstruct_point_cloud(cams, points2d );
aligned_p=R2*[eye(3),-t]*p;
if (p(3)>0)&&(aligned_p(3)>0)
    return
end
end