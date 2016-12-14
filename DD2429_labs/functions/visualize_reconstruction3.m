% function visualize_reconstruction( points3d, camera_centers, ...
%                                    points2d_reference, image_reference )
%
% Visualize a reconstructed model.
%
% Let N be the number of points and C the number of cameras.
%
% points3d          4xN matrix of all 3d points.
%
% camera_centers    4xC array, storing the camera center for each camera.
%
% points2d          3xN array, storing all image points in a reference view.
%
% texture           Image representing the texture of the model. If the
%                   function receives an empty argument, texture=[], then
%                   the model is not drawn with any texture. This is useful
%                   for synthetic data without texture.

function visualize_reconstruction3( points3d, camera_centers, ...
                                   points2d_reference, texture,tri )
step=1;
points3d=points3d(:,1:step:end);
points2d_reference=points2d_reference(:,1:step:end);
% texture=imcomplement(texture);
                               
% Convert homogeneous coordinates to cartesian coordinates:
points3d_cartesian          = homogeneous_to_cartesian( points3d );
camera_centers_cartesian    = homogeneous_to_cartesian( camera_centers );
points2d_cartesian          = homogeneous_to_cartesian( points2d_reference );

X = points3d_cartesian(1,:);
Y = points3d_cartesian(2,:);
Z = points3d_cartesian(3,:);

camx = camera_centers_cartesian(1,:);
camy = camera_centers_cartesian(2,:);
camz = camera_centers_cartesian(3,:);

U = points2d_cartesian(1,:);
V = points2d_cartesian(2,:);
% tri = delaunay(U,V);
figure
imshow(texture',[])
hold on
scatter(U,V)

triangles(tri,U,V)


% Draw points and camera centers:
figure
hold on
plot3( X, Y, Z, '.');
% plot3( camx, camy, camz, 'ro' );
% view(126,20)
axis vis3d
axis equal
grid on

% ------------------------

N=size(points3d,2);

% trisurf(tri,X,Y,Z,ones(N,1));

if ~isempty(texture)
    draw_textured_triangles(tri,X,Y,Z,U,V,texture,32)
end


% view3d rot
drawnow

end

