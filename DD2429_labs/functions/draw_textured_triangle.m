% handle = draw_textured_triangle( points3d, points2d, img, textureSize )
%
% Draws a textured triangle in 3D.
%
% points3d      3x3 matrix. Each column represents the 3d coordinates for
%               one of the vertices of the triangle.
%
% points2d      2x3 matrix. Each column represents the 2d coordinates for
%               one of the vertices of the triangle in the texture.
%
% img           The image used for the texture. Can be color or gray-scale.
%
% textureSize   The texture covering each triangle is resampled to a square
%               image with this size.

% function handle = draw_textured_triangle( points3d, points2d, img, textureSize )
% 
% [H,W,CHANNELS] = size( img );
% 
% outputPoints = [1 W 1;
%                 H H 1];
%             
% tform = maketform( 'affine', points2d', outputPoints' );
% 
% triTexture = imtransform( img, tform, 'bicubic', ...
%                          'xdata', [1 W], 'ydata', [1 H], 'size', ...
%                          textureSize*[1 1] );
% 
% % Vertex indices used to create 2-by-2 surface coordinates:
% indices = [3 3;
%            1 2];
% 
% x = points3d(1,:);
% y = points3d(2,:);
% z = points3d(3,:);
% 
% X = x(indices);
% Y = y(indices);        
% Z = z(indices);        
% 
% handle = surf( X, Y, Z, triTexture, 'FaceColor', 'texturemap', 'EdgeColor', 'none' );
% 
% if CHANNELS==1
%     colormap('Gray')
% end
% 
% end




function hSurface = draw_textured_triangle( points3d, points2d, img, textureSize )
O=points2d(:,1);
A=points2d(:,2);
B=points2d(:,3);
C=B-A+O;


img=img';
[nRows,nCols,nPages] = size(img);
inputCorners = [O'; ...        %# Corner coordinates of input space
                A'; ...
                B'; ...
                C'];
outputCorners = [1 nRows; ...      %# Corner coordinates of output space
                 nCols nRows; ...
                 nCols 1; ...
                 textureSize*[1 1]];
tform = maketform('projective',...  %# Make the transformation structure
                  inputCorners,...
                  outputCorners);
triTexture = imtransform(img,tform,'bicubic',...  %# Transform the image
                         'xdata',[1 nCols],...
                         'ydata',[1 nRows],...
                         'size',[nRows nCols]);
                     
indices = [3 3; 1 2];  %# Index used to create 2-by-2 surface coordinates
x = points3d(1,:);
y = points3d(2,:);
z = points3d(3,:);

X = x(indices);
Y = y(indices);        
Z = z(indices);  



hSurface = surf(X,Y,Z,triTexture,...          %# Plot texture-mapped surface
                'FaceColor','texturemap',...
                'EdgeColor','none');
if nPages==1
    colormap('Gray')
end
end
                


