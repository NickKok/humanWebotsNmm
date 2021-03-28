%% Get Stereotyped shape
config = conf();
dir = [ config.raw_filedir '/sessionArticleFrontier' ]; % directory where to look for raw files
id = 20; % extraction serie ID
knot = 1000; % number of knot for the spline interploation
analysis_MusclesActivity
%% Build model function
mp1 = awo_modelFunc(moto_primitives(:,1));
mp2 = awo_modelFunc(moto_primitives(:,2));
mp3 = awo_modelFunc(moto_primitives(:,3));
%% Differential equation

awo = @(t,y,omega,gamma,model) [omega;100*(model.g(y(1))-y(2))+model.dg(y(1))*omega];
awo3 = @(t,y,omega,gamma,m1,m2,m3,w) [omega;...
    100*(w(1)*m1.g(y(1))+w(2)*m2.g(y(1))+w(3)*m3.g(y(1))-y(2))+...
    (w(1)*m1.dg(y(1))+w(2)*m2.dg(y(1))+w(3)*m3.dg(y(1)))*omega];

w=2.0;
g = 100;


dMP1dt = @(t,y) awo(t,y,w,g,mp1);
dMP2dt = @(t,y) awo(t,y,w,g,mp2);
dMP3dt = @(t,y) awo(t,y,w,g,mp3);

dMP123dt = @(t,y) awo3(t,y,w,g,mp1,mp2,mp3,H(:,1));

tic
disp('Solving motor primitives 1')
[t_mp1,x_mp1] = ode45(dMP1dt, [0 20], [w;0]);
ss_mp1 = spline(t_mp1,x_mp1(:,2));
toc
tic
disp('Solving motor primitives 2')
[t_mp2,x_mp2] = ode45(dMP2dt, [0 20], [w;0]);
ss_mp2 = spline(t_mp2,x_mp2(:,2));
toc
tic
disp('Solving motor primitives 3')
[t_mp3,x_mp3] = ode45(dMP3dt, [0 20], [w;0]);
ss_mp3 = spline(t_mp3,x_mp3(:,2));
toc

tic
disp('Solving motoneuron reconstruction 1')
dMN1dt = @(t,y) H(1,1)*dMP1dt(t,y)+H(2,1)*dMP2dt(t,y)+H(3,1)*dMP3dt(t,y);
[t_mn1,x_mn1] = ode45(dMN1dt, [0 20], [w;0]);
toc
tic
disp('Solving motoneuron reconstruction 2')
[t_mn1_bis,x_mn1_bis] = ode45(dMP123dt, [0 20], [w;0]);
ss_mp3 = spline(t_mp3,x_mp3(:,2));
toc


x_mn1_manual = ppval(ss_mp1,t_mn1)*H(1,1)+ppval(ss_mp2,t_mn1)*H(2,1)+ppval(ss_mp3,t_mn1)*H(3,1);

%% PLOT
plot(t_mn1,x_mn1(:,2));
hold on;
plot(t_mn1_bis,x_mn1_bis(:,2),'r');
plot(t_mn1,x_mn1_manual,'k--');