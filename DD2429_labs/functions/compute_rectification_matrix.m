% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( points1, points2 )
num=size(points1,2);

diag_element=points1';
% zero_element=zeros(num,4);
p1=zeros(num,4);
p2=zeros(num,4);
p3=zeros(num,4);
for i=1:num
    p1(i,:)=-points2(1,i).*points1(:,i);
    p2(i,:)=-points2(2,i).*points1(:,i);
    p3(i,:)=-points2(3,i).*points1(:,i);
end

W=blkdiag(diag_element,diag_element,diag_element);
W=[W,[p1;p2;p3]];
[~,~,V] = svd(W);

h=V(:,end);
H = reshape(h,4,4)';
end