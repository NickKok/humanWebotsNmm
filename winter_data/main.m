
data = importdata('winterdata_angle.csv');
C = data.data(:,1);



X = data.data(:,[2,4,6]);
R = 3*sqrt(sqrt(Xsdt(:,1).*Xsdt(:,1)+Xsdt(:,2).*Xsdt(:,2)+Xsdt(:,3).*Xsdt(:,3)));
Xsdt = data.data(:,[3,5,7]);
normalVec = diff(X);

title('Slow Walking [Winter Data]');
ss = tubeplot([X(:,1) X(:,2) X(:,3)]',R,20,0.01);
ss.EdgeColor = 'none';
ss.FaceAlpha = 0.2;
xlabel('Hip [deg]');
ylabel('Knee [deg]');
zlabel('Ankle [deg]');

hold on;

pp = plot3(X(:,1),X(:,2),X(:,3));
pp.LineWidth = 4;