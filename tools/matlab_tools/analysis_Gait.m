%% Init
%
config = conf();
dir = [config.raw_filedir '/sessionArticlFrontier' ]; % directory where to look for raw files
id = 30; % extraction serie ID
knot = 1000;
tic
disp('Data loading...')
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
stance_percentage = extract_stancePercentage(footFall);
winterData = extract_winterData();
toc

%% Joint torque
toKeep = 1:3;
what = config.raw_filename.joints_force;
data = extract_rawFile(dir,what,id);
out = signal_analysis(data,footFall,toKeep,knot);
stdCycle = reshape(out.signalStd(:,1,:),3,knot)';
varCycle = reshape(out.signalVar(:,1,:),3,knot)';
meanCycle = reshape(out.signalMean(:,1,:),3,knot)';
meanCycle(:,2) = meanCycle(:,2)*-1;

%w='slow_walking__n19';
%w='fast_walking__n17';
w='normal_walking__n19';
meanCycle_winter = winterData.torque.(w).data(:,2:2:6);
stdCycle_winter = winterData.torque.(w).data(:,3:2:7);
stancePercentage_winter = winterData.stance_percentage.(w);

stdCycle_winter=change_length(stdCycle_winter,1000);
meanCycle_winter=change_length(meanCycle_winter,1000);

%meanCycle_winter=change_stancePercentage(meanCycle_winter,stancePercentage_winter,stance_percentage);
%stdCycle_winter=change_stancePercentage(stdCycle_winter,stancePercentage_winter,stance_percentage);

diag(corr(meanCycle_winter,meanCycle))

hFig=figure;
plot_meanSignal(meanCycle_winter,stdCycle_winter,data.legend.one_side,{'Color','k'},{'subplot',[3,1], 'ylim',[-1.2, 2]})
h=plot_meanSignal(meanCycle/80,stdCycle/80,data.legend.one_side,{'LineStyle','-'},{'subplot',[3,1], 'returnSubplotHandler',[2,1]});
ylabel(h,'Torque (N m kg^{-1})');
set(hFig, 'Position', [0,0,380,500])
%% Joint angle
toKeep = 1:3;
what = config.raw_filename.joints_angle;
data = extract_rawFile(dir,what,id);
out = signal_analysis(data,footFall,toKeep,knot);
stdCycle = reshape(out.signalStd(:,1,:),3,knot)';
varCycle = reshape(out.signalVar(:,1,:),3,knot)';
meanCycle = reshape(out.signalMean(:,1,:),3,knot)';
meanCycle(:,1) = meanCycle(:,1)*-1;
meanCycle(:,3) = meanCycle(:,3)*-1;

%w='slow_walking__n19';
%w='fast_walking__n17';
w='normal_walking__n19';
meanCycle_winter = winterData.angle.(w).data(:,2:2:6);
stdCycle_winter = winterData.angle.(w).data(:,3:2:7);
stancePercentage_winter = winterData.stance_percentage.(w);

stdCycle_winter=change_length(stdCycle_winter,1000);
meanCycle_winter=change_length(meanCycle_winter,1000);

%meanCycle_winter=change_stancePercentage(meanCycle_winter,stancePercentage_winter,stance_percentage);
%stdCycle_winter=change_stancePercentage(stdCycle_winter,stancePercentage_winter,stance_percentage);

diag(corr(meanCycle_winter,meanCycle))

hFig=figure;
plot_meanSignal(meanCycle_winter,stdCycle_winter,data.legend.one_side,{'Color','k'},{'subplot',[3,1], 'ylim',[]})
h=plot_meanSignal(meanCycle*180/pi,stdCycle*180/pi,data.legend.one_side,{'LineStyle','-'},{'subplot',[3,1], 'returnSubplotHandler',[2,1]});
ylabel(h,'Angle (\circ)');
set(hFig, 'Position', [0,0,380,500])
%figure
%plot_meanSignal(meanCycle*180/pi,stdCycle*180/pi,data.legend.one_side,{},{'stancePercentage',stance_percentage})
%ylabel('Angle (degree)');


%% GRF
toKeep = 1:2;
what = config.raw_filename.grf;
data = extract_rawFile(dir,what,id);
data.legend.one_side=data.textdata;
out = signal_analysis(data,footFall,toKeep,knot);
stdCycle = reshape(out.signalStd(:,1,:),2,knot)';
varCycle = reshape(out.signalVar(:,1,:),2,knot)';
meanCycle = reshape(out.signalMean(:,1,:),2,knot)';
meanCycle(:,[2,1]) = meanCycle(:,[1,2]);
meanCycle(:,2) = meanCycle(:,2)*-1;
meanCycle = filtfilt(0.2*ones(1,5),1,meanCycle);
%w='slow_walking__n19';
%w='fast_walking__n17';
w='normal_walking__n19';
meanCycle_winter = winterData.grf.(w).data(:,2:2:4);
stdCycle_winter = winterData.grf.(w).data(:,3:2:5);
stancePercentage_winter = winterData.stance_percentage.(w);

stdCycle_winter=change_length(stdCycle_winter,1000);
meanCycle_winter=change_length(meanCycle_winter,1000);

meanCycle_winter=change_stancePercentage(meanCycle_winter,stancePercentage_winter,stance_percentage);
stdCycle_winter=change_stancePercentage(stdCycle_winter,stancePercentage_winter,stance_percentage);

diag(corr(meanCycle_winter,meanCycle))

hFig=figure;
plot_meanSignal(meanCycle_winter,stdCycle_winter,data.legend.one_side,{'Color','k'},{'subplot',[2,1], 'ylim',[]})
h=plot_meanSignal(meanCycle/80,stdCycle/80,data.legend.one_side,{'LineStyle','-'},{'subplot',[2,1], 'returnSubplotHandler',[2,1]});
ylabel(h,'N/kg');
set(hFig, 'Position', [0,0,380,500])
%figure
%plot_meanSignal(meanCycle*180/pi,stdCycle*180/pi,data.legend.one_side,{},{'stancePercentage',stance_percentage})
%ylabel('Angle (degree)');

%%TODO
%% Muscle activities
toKeep = 1:7;
what = config.raw_filename.muscles_activity;
data = extract_rawFile(dir,what,id);
out = signal_analysis(data,footFall,toKeep,knot);
stdCycle = reshape(out.signalStd(:,1,:),7,knot)';
varCycle = reshape(out.signalVar(:,1,:),7,knot)';
meanCycle = reshape(out.signalMean(:,1,:),7,knot)';
hFig=figure;
h=plot_meanSignal(100*meanCycle,100*stdCycle,data.legend.one_side,{'LineStyle','-','Color','b'},{'subplot',[7,1], 'returnSubplotHandler',[4,1],'ylim',[0,100],'area',{'EdgeColor','k','FaceColor','k'}});
%plot_meanSignal(100*meanCycle,100*stdCycle,data.legend.one_side,{'LineStyle','-','Color','b'},{'subplot',[4,2], 'returnSubplotHandler',[2,1],'ylim',[0,100]});
ylabel(h,'Muscle activity (%)')
set(hFig, 'Position', [0,0,380,800])

%% WINTER DATA
grf = extract_winterData('grf');
stance_percentage = find(diff(grf.fast_walking__n17.data(:,2)~=0)==-1);
angle = extract_winterData('angle');
torque = extract_winterData('torque');
figure
plot_meanSignal(grf.fast_walking__n17.data(:,2:2:4),grf.fast_walking__n17.data(:,3:2:5),66,grf.fast_walking__n17.legend_name(2:2:4))
figure
plot_meanSignal(angle.fast_walking__n17.data(:,2:2:6),angle.fast_walking__n17.data(:,3:2:7),60,angle.fast_walking__n17.legend_name(2:2:6))