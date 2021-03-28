%% SYSTEMATIC
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/systematic/serie2/';
p_bas = [1.0,0.0,1.0,0.0,0.85];

parameters=importdata([folder 'parameters_cpg.txt']);
state=importdata([folder 'parameters_cpg_associated_state.txt']);
s = state.data;
p = parameters.data(:,3:end-1);


%A12 = intersect(find(p(:,1)==p_bas(1)),find(p(:,2)==p_bas(2)));
%A13 = intersect(find(p(:,1)==p_bas(1)),find(p(:,3)==p_bas(3)));
%A14 = intersect(find(p(:,1)==p_bas(1)),find(p(:,4)==p_bas(4)));
%A23 = intersect(find(p(:,2)==p_bas(2)),find(p(:,3)==p_bas(3)));
%A24 = intersect(find(p(:,2)==p_bas(2)),find(p(:,4)==p_bas(4)));
%A34 = intersect(find(p(:,3)==p_bas(3)),find(p(:,4)==p_bas(4)));


% REMOVE FALLED
A12 = intersect(intersect(find(p(:,1)==p_bas(1)),find(p(:,2)==p_bas(2))),find(s(:,end)==0));
A13 = intersect(intersect(find(p(:,1)==p_bas(1)),find(p(:,3)==p_bas(3))),find(s(:,end)==0));
A14 = intersect(intersect(find(p(:,1)==p_bas(1)),find(p(:,4)==p_bas(4))),find(s(:,end)==0));
A23 = intersect(intersect(find(p(:,2)==p_bas(2)),find(p(:,3)==p_bas(3))),find(s(:,end)==0));
A24 = intersect(intersect(find(p(:,2)==p_bas(2)),find(p(:,4)==p_bas(4))),find(s(:,end)==0));
A34 = intersect(intersect(find(p(:,3)==p_bas(3)),find(p(:,4)==p_bas(4))),find(s(:,end)==0));


pA12 = p(A12,[3 4 5]);
pA13 = p(A13,[2 4 5]); %OK
pA14 = p(A14,[2 3 5]);
pA23 = p(A23,[1 4 5]); %OK
pA24 = p(A24,[1 3 5]);
pA34 = p(A34,[1 2 5]); %OK

keep = 4;

%ans = 
%
%    'mean_speed'    'steplength'    'steplength_var'   'double stance support'    'spent_energy'    'distance'    'falled'
%ans = 
%    'amp_change'
%    'offset_change'
%    'amp_change_bas'
%    'offset_change_bas'
limits = {[0.7 1.6],[-0.01,0.01],[0.7 1.6],[-0.01,0.01]};

if(keep == 1)
    %clim = [0.7 1.6]; % serie 2
    clim = [0.6 1.4]; % serie 3
elseif(keep == 3)
    clim = [0 0.2];
elseif(keep == 4)
    clim = [0 0.2];
elseif(keep == 5)
    clim = [0 120];
elseif(keep == 7)
    clim = [0 1];
elseif(keep == 8)
    clim = [1.0 2.2];
else    
    clim = [0 1.3];
end
    
      
s(:,8) = s(:,1)./s(:,2);
sA12 = s(A12,keep);
sA13 = s(A13,keep);
sA14 = s(A14,keep);
sA23 = s(A23,keep);
sA24 = s(A24,keep);
sA34 = s(A34,keep);

screen_size = get(0, 'ScreenSize');

freqUniqu = unique(pA13(:,3));

pos = [ 800 300 100*6 600 ];h= figure;set(h, 'Position', pos);
hold on;
%%%PROB
x=pA12;
z=sA12;
name=['../keep' num2str(keep) '_no12'];
plotSystematic(x,z,freqUniqu,pos,clim,1,h,limits{3},limits{4})

x=pA13;
z=sA13;
name=['../keep' num2str(keep) '_no13'];
plotSystematic(x,z,freqUniqu,pos,clim,2,h,limits{2},limits{4})

x=pA14;
z=sA14;
name=['../keep' num2str(keep) '_no14'];
plotSystematic(x,z,freqUniqu,pos,clim,3,h,limits{2},limits{3})


x=pA23;
z=sA23;
name=['../keep' num2str(keep) '_no23'];
plotSystematic(x,z,freqUniqu,pos,clim,4,h,limits{1},limits{4})

x=pA24;
z=sA24;
name=['../keep' num2str(keep) '_no24'];
plotSystematic(x,z,freqUniqu,pos,clim,5,h,limits{1},limits{3})

x=pA34;
z=sA34;
name=['../keep' num2str(keep) '_no34'];
plotSystematic(x,z,freqUniqu,pos,clim,6,h,limits{1},limits{2})

hold off
%% ONLINE CHANGE
%% serie3
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/cpg_replace/serie3/';
parameters=importdata([folder 'parameters_cpg.txt']);
state=importdata([folder 'parameters_cpg_associated_state.txt']);
p = parameters.data(16:end-1,:);
s = state.data(16:end-1,:);
xy = p(:,[6 7]);
speed = s(:,1);
sl = s(:,2);
ds_dur = s(:,3);
energy = s(:,4);
xlabel_char = '$O_{\mathrm{IN}_{\mathrm{BAS}}}$';
ylabel_char = '$\omega$';
xspace = 2;
yspace = 0.25;

figure

[X,Y,Z] = plot3_new([xy speed],xspace,yspace);

subplot(221);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('speed [m/s]','FontSize',14);
view(2);
colorbar('Location', 'West');
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy energy],xspace,yspace);
subplot(222);
surf(X,Y,10*Z/5.0);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Energy consumption [J/s]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy ds_dur],xspace,yspace);
subplot(223);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Double stance duration per cycle [ms]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy sl],xspace,yspace);
subplot(224);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Cycle length [m]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)



%% serie2
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/cpg_replace/serie2/';
parameters=importdata([folder 'parameters_cpg.txt']);
state=importdata([folder 'parameters_cpg_associated_state.txt']);
p = parameters.data(:,:);
s = state.data(:,:);
xy = p(:,[3 5]);
speed = s(:,1);
sl = s(:,2);
ds_dur = s(:,3);
energy = s(:,4);
xlabel_char = '$A_{\mathrm{IN}_{\mathrm{CPG}}}$';
ylabel_char = '$A_{\mathrm{IN}_{\mathrm{BAS}}}$';


xspace = 2;
yspace = 2;

figure

[X,Y,Z] = plot3_new([xy speed],xspace,yspace);
subplot(221);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Speed [m/s]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy energy],xspace,yspace);
subplot(222);
surf(X,Y,10*Z/5.0);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Energy consumption [J/s]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy ds_dur],xspace,yspace);
subplot(223);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Double stance duration per cycle [ms]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)


[X,Y,Z] = plot3_new([xy sl],xspace,yspace);
subplot(224);
surf(X,Y,Z);
xlabel(xlabel_char,'FontSize',14,'Interpreter','Latex');
ylabel(ylabel_char,'FontSize',14,'Interpreter','Latex');
title('Cycle length [m]','FontSize',14);
view(2);
colorbar('Location', 'West')
xlim([min(xy(:,1)) max(xy(:,1))]);
ylim([min(xy(:,2)) max(xy(:,2))]);
set(gca,'FontSize',14)



%% HUMAN ROBOT COMP
folder = '/home/efx/Development/PHD/LabImmersion/Ted/v2.01/raw_files/';
folder = '/home/efx/Development/PHD/LabImmersion/Ted/v3.4/raw_files/';
i=1;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle',i,folder);
%i=2;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle',i,folder);
%i=3;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle',i,folder);
%i=4;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle',i,folder);
angle = c;
i=1;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque',i,folder);
%i=2;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque',i,folder);
%i=3;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque',i,folder);
%i=4;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque',i,folder);
torque = c;
i=4;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
%i=2;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
%i=3;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
%i=4;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
grf = c;


folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/full_reflex/v2.01/';
i=3;[c(i,1) c(i,2)] = human_robot_comparison('grf','base',folder,2);

%% ROBUSTNESS COMP
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/full_reflex/v2.01/';
i=1;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque','base',folder,i);
i=2;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque','rp',folder,i);
i=3;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque','wg',folder,i);
torque = c;
i=1;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle','base',folder,i);
i=2;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle','rp',folder,i);
i=3;[c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle','wg',folder,i);
angle = c;
i=1;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
i=2;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
i=3;[c(i,1) c(i,2)] = human_robot_comparison('grf',i,folder);
grf = c;

%% FBL FBL-- COMP
clear c torque angle grf;
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/fbl_fbl-/';
exps = {'fbl','fbl--'};
figure;
for i=1:length(exps)
    [c(i,1) c(i,2) c(i,3)] = human_robot_comparison('angle',cell2mat(exps(i)),folder,i);
    angle(i,:) = c(i,:);
end
figure;
for i=1:length(exps)
    [c(i,1) c(i,2) c(i,3)] = human_robot_comparison('torque',cell2mat(exps(i)),folder,i);
    torque(i,:) = c(i,:);
end
figure;
clear c;
for i=1:length(exps)
    [c(i,1) c(i,2)] = human_robot_comparison('grf',cell2mat(exps(i)),folder,i);
    grf(i,:) = c(i,:);
end

%% STAGE PLOT
figure
subplot(131)
clear A B C;
A=importdata('~/Development/PHD/LabImmersion/Ted/v2.02/job_tools/st_base.txt');
B=A.data(:,3:9);
clear C
C(:,1)=B(:,1);
C(:,2)=sum(B(:,[2 3 4]),2);
C(:,3)=sum(B(:,[5]),2);
C(:,4)=sum(B(:,[6]),2);
C(:,5)=sum(B(:,[7]),2);
bar(C,'stacked');
set(gca,'FontSize',14)
title('exp 3');
ylim([0;60]);
xlim([0;150]);
colormap(jet(30))
xlabel('generations')
ylabel('particles')

subplot(132)
clear A B C;
A=importdata('~/Development/PHD/LabImmersion/Ted/v2.02/job_tools/st_rp.txt');
B=A.data(:,3:10);
C(:,1)=B(:,1);
C(:,2)=sum(B(:,[2 3]),2);
C(:,3)=sum(B(:,[4]),2);
C(:,4)=sum(B(:,[5 6 7]),2);
C(:,5)=sum(B(:,[8]),2);
bar(C,'stacked');
set(gca,'FontSize',14)
title('exp 6a');
xlim([0;150]);
ylim([0;50]);
colormap(jet(30))
xlabel('generations')

subplot(133)
clear A B C;
A=importdata('~/Development/PHD/LabImmersion/Ted/v2.02/job_tools/st.txt');
B=A.data(:,3:11);
clear C
C(:,1)=B(:,1);
C(:,2)=sum(B(:,[2 3 4]),2);
C(:,3)=sum(B(:,[5]),2);
C(:,4)=sum(B(:,[6 7 8]),2);
C(:,5)=sum(B(:,[9]),2);
bar(C,'stacked');
set(gca,'FontSize',14)
title('exp 7a');
xlim([0;150]);
ylim([0;50]);
colormap(jet(30))
xlabel('generations')


colormap(jet(10))


%% PLOT ROBUSTNESS FBL vs FBL- vs 3FBL
evaluation;
%close all;



subplot(131)
bar([hip_corr(model_kept,env) knee_corr(model_kept,env) ankle_corr(model_kept,env)]');
set(gca,'xticklabel',{'HIP' 'KNEE' 'ANKLE'})
ylabel('correlation','FontSize',14)
set(gca,'FontSize',14)
title('Joint angles correlation')

subplot(132)
errorb([mForceAmp(:,3) mF(:,3)*100 ]',[vForceAmp(:,3) sF(:,3)*100]');
xlim([0.5 1.5])
ylabel('Force [N]','FontSize',14)
set(gca,'xtick',[])
set(gca,'FontSize',14)
title('Pushing resistance')


subplot(133)
errorb([mForceAmp(:,3) mF(:,3)*100 ]',[vForceAmp(:,3) sF(:,3)*100]');
xlim([1.5 2.5])
ylabel('Slope [%]','FontSize',14)
set(gca,'xtick',[])
set(gca,'FontSize',14)
title('Mean slope change resistance')

legend('FBL','3FBL','FBL-','Orientation','Horizontal')
legend boxoff
set(gca,'FontSize',14)
