% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

index=~isnan(points1)&~isnan(points2);
points1(:,~any(index))=[];
points2(:,~any(index))=[];

sz=size(points1,2);

alpha=[points1(1:2,:)',ones(sz,1),zeros(sz,3),-bsxfun(@times,points2(1,:),points1)'];
beta=[zeros(sz,3),points1(1:2,:)',ones(sz,1),-bsxfun(@times,points2(2,:),points1)'];
Q = [alpha; beta];

[~,~,V] = svd(Q);
h = V(:,end);

H=reshape(h,3,3)';
end
