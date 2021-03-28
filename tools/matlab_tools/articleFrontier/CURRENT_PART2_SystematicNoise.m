%% DATA LOADING
%extract_repeat = [1,5,6,7,10];
extract_repeat = [1,5,6,7,10];
gaitData=load_data('1.3',1:10);

% Extract combinaisonStudy
combinaisonStudy = load_systematicCombinaisonStudy(extract_repeat);
% Extract sensorNoiseStudy
folder='articleFrontier';
subfolder='noiseSensorStudy';
study='noiseSensorStudy';

sensorNoiseRawData = {};
sensorNoiseData = struct;
sensorNoiseData.p_stableUntil = [];
tic
for i=1:9
    for j=1:5
        sensorNoiseRawData{i,j} = extract_rawSystematic(folder,subfolder,study,['_param' num2str(i) '_noiseSqrtMax0.002'],['_repeat' num2str(j)]); 
        sensorNoiseData.p_stableUntil(i,j) = sensorNoiseRawData{i,j}.p_stableUntil;
    end
end
toc
%% PLOT1 : Noise sensitivity & Feedback sensititivity
hFig = figure;
subplot(1,2,1);
boxplot(100*sqrt(1-combinaisonStudy.cpgData.STABLE_UNTIL(extract_repeat,:))','Orientation',1,'boxstyle','filled','outliersize',8,'symbol','o')
title('Feedback sensitivity');
set(gca,'xtick',1:5)
set(gca,'xticklabel',gaitData.energy.order_inv(extract_repeat));

subplot(1,2,2);
boxplot(100*sqrt(0.002-sensorNoiseData.p_stableUntil(extract_repeat,:))','Orientation',1,'boxstyle','filled','outliersize',8,'symbol','o')
title('Noise sensitivity');
ylabel('noise level [%]');
set(gca,'xtick',1:9)
set(gca,'xticklabel',gaitData.energy.order_inv(extract_repeat));

format_boxplot(hFig);