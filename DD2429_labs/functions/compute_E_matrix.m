% function E = compute_E_matrix( points1, points2, K1, K2 );
%
% Method:   Calculate the E matrix between two views from
%           point correspondences: points2^T * E * points1 = 0
%           we use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,a,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * E * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
% Output:   E is a 3x3 matrix with the singular values (a,a,0).

function E = compute_E_matrix( points2d, K )
% 
% %------------------------------

points2d(:,:,1)=K(:,:,1)\points2d(:,:,1);
points2d(:,:,2)=K(:,:,2)\points2d(:,:,2);

normalized_points2d=zeros(size(points2d));
norm_mat = compute_normalization_matrices( points2d );
normalized_points2d(:,:,1)=norm_mat(:,:,1)*points2d(:,:,1);
normalized_points2d(:,:,2)=norm_mat(:,:,2)*points2d(:,:,2);


Q=zeros(size(points2d,2),9);
for i=1:size(points2d,2)
    Q(i,:)=kron(normalized_points2d(:,i,2).',normalized_points2d(:,i,1).');
end
[~,~,V]=svd(Q);
e = V(:,end);
E=reshape(e,3,3)';

E=norm_mat(:,:,2)'*E*norm_mat(:,:,1);

[U,S,V]=svd(E);
S_correct=(S(1,1)+S(2,2))/2;
S=diag([S_correct,S_correct,0]);
E=U*S*V';
    
end


