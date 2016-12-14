% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )

%-------------------------
cam=size(points2d,3);
norm_mat=zeros(3,3,cam);

centroid=squeeze(mean(points2d,2,'omitnan'));

index=~isnan(points2d);
for i=1:cam
    P=points2d(:,:,i);
    P(:,~any(index(:,:,i)))=[];
    diff=bsxfun(@minus,P,centroid(:,i));
    distance=mean(sqrt(sum(diff.^2,1)));
    Ntmp=eye(3);
    Ntmp(:,3)=-centroid(:,i);
    Ntmp(3,3)=distance/sqrt(2);
    Ntmp=sqrt(2)/distance*Ntmp;
    norm_mat(:,:,i)=Ntmp;
end

end