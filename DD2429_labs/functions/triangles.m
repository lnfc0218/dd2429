function triangles(tri,U,V)
ind1=[1,2];
ind2=[2,3];
ind3=[1,3];
hold on
for i=1:size(tri,1) 
    x=U(tri(i,:));
    y=V(tri(i,:));
    line(x(ind1),y(ind1));
    line(x(ind2),y(ind2));
    line(x(ind3),y(ind3));
end



end