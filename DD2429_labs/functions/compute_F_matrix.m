% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )

norm_mat=compute_normalization_matrices(points2d);
points2d(:,:,1)=norm_mat(:,:,1)*points2d(:,:,1);
points2d(:,:,2)=norm_mat(:,:,2)*points2d(:,:,2);

Q=zeros(size(points2d,2),9);
for i=1:size(points2d,2)
    Q(i,:)=kron(points2d(:,i,2).',points2d(:,i,1).');
end
[~,~,V]=svd(Q);
f = V(:,end);
F=reshape(f,3,3)';

F=norm_mat(:,:,2)'*F*norm_mat(:,:,1);

[U,S,V]=svd(F);
S=diag([S(1,1),S(2,2),0]);
F=U*S*V';
end
