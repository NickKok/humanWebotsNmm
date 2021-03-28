function [X,Y,Z] = plot3_new(dmap,x,y)
step=unique(sort(abs(dmap(1:end-1,1)-dmap(2:end,1))));
step = step(find(step~=0,1));
rangeX=min(dmap(:,1))-step/x:step/x:max(dmap(:,1))+step/x;

step=unique(sort(abs(dmap(1:end-1,2)-dmap(2:end,2))));
step = step(find(step~=0,1));
rangeY=min(dmap(:,2))-step/y:step/y:max(dmap(:,2))+step/y;


[X,Y]=meshgrid(rangeX,rangeY);
F=TriScatteredInterp(dmap(:,1),dmap(:,2),dmap(:,3));
Z = F(X,Y);


end 