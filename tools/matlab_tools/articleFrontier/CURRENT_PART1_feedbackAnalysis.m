%% DATA LOADING
exp_1_0=load_data('1.0',1:8);
exp_1_3=load_data('1.3',1:10);
exp_1_6=load_data('1.6',1:8);
exp_wavy=load_data('wavy2',1:10);
% feedback order
mff = [5 7 9 6];
mlf = [8 11 10 14 13];
gsif = [2 1 3];
gcf = 12;
tlf = 4;
jop = 15;

%% Feedback SNR : group by feedback
feedbackName = exp_1_0.feedbackName;
fdbMean = exp_1_0.feedback.mean;
fdbAmp = exp_1_0.feedback.amplitude;
m1_0=mean(log(10*(fdbMean'./fdbAmp')+1),2);
s1_0=std(log(10*(fdbMean'./fdbAmp')+1),0,2);

feedbackName = exp_1_3.feedbackName;
fdbMean = exp_1_3.feedback.mean;
fdbAmp = exp_1_3.feedback.amplitude;
m1_3=mean(log(10*(fdbMean'./fdbAmp')+1),2);
s1_3=std(log(10*(fdbMean'./fdbAmp')+1),0,2);

feedbackName = exp_1_6.feedbackName;
fdbMean = exp_1_6.feedback.mean;
fdbAmp = exp_1_6.feedback.amplitude;
m1_6=mean(log(10*(fdbMean'./fdbAmp')+1),2);
s1_6=std(log(10*(fdbMean'./fdbAmp')+1),0,2);


groups = {[mff mlf gsif,gcf]};

clear subplot
clf
subgroups = 3;
m = [m1_0, m1_3, m1_6];
s = [s1_0, s1_3, s1_6];

for i=1:length(groups)
    subplot(length(groups),1,i);
    barh(m(groups{i},:));
    hold on;
    mean_pos = 1:length(groups{i});
    pos = [mean_pos-0.22; mean_pos; mean_pos+0.22]';
    herrorbar(m(groups{i},:),pos,s(groups{i},:));
    set(gca,'ytick',1:length(groups{i}));
    set(gca,'yticklabel',feedbackName(groups{i}));
end



%% DATA LOADING
%extract_repeat = [1,5,6,7,10];
extract_repeat_cst = 1:10;
extract_repeat_cpg = 1:10;
gaitData=load_data('wavy2',1:10);

% Extract combinaisonStudy
combinaisonStudy = load_systematicCombinaisonStudy(extract_repeat_cpg, extract_repeat_cst,'_wavy2');
% Extract sensorNoiseStudy
folder='articleFrontier';
subfolder='noiseSensorStudy_wavy2';
study='noiseSensorStudy';



sensorNoiseRawData = cell(10,5);
sensorNoiseData = struct;
sensorNoiseData.p_stableUntil = zeros(10,5);
sensorNoiseData.p_stableMax = zeros(10,5);
disp('loading sensorNoise Systematic Study data');
for j=1:1
    tic
    for i=1:10
        %sensorNoiseRawData{i,j} = extract_rawSystematic(folder,subfolder,study,['_param' num2str(i) '_noiseSqrtMax0.002'],['_repeat' num2str(j)]); 
        sensorNoiseRawData{i,j} = extract_rawSystematic(folder,subfolder,study,['_fdb' num2str(i) ''],['']); 
        sensorNoiseData.p_stableUntil(i,j) = sensorNoiseRawData{i,j}.p_stableUntil;
        sensorNoiseData.p_stableMax(i,j) = sensorNoiseRawData{i,j}.p_stableMax;
        
    end
    toc
end
% Extract muscleNoiseStudy
folder='articleFrontier';
subfolder='noiseMuscleStudy_wavy2';
study='noiseMuscleStudy';

%muscleNoise =load_systematicNoise(folder,subfolder,study,'noiseSqrtMax0.002');
%muscleNoise =load_systematicNoise(folder,subfolder,study,'noiseMax0.05','repeat',1:10,'paramSet',1:10);
muscleNoise =load_systematicNoise(folder,subfolder,study,'','repeat',1,'paramSet',1:10,'noRepeat',true);

folder='articleFrontier';
subfolder='noiseSensorStudy_wavy2';
study='noiseSensorStudy';
sensorNoise = load_systematicNoise(folder,subfolder,study,'','repeat',1,'paramSet',1:10,'noRepeat',true);

%% TABLE1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise resistance & Rep number  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keep = gaitData.feedback.order(1:end-1);
numberNotReplacable=sum(combinaisonStudy.cpgData.STABLE_UNTIL(:,keep) ~= 1.0,2);
numberNotReplacable(gaitData.energy.order)

meanNoiseSen = sqrt(mean(sensorNoiseData.p_stableUntil,2))*100;
meanNoiseMus = mean(muscleNoise.Data.p_stableUntil,2)*100;

%[gaitData.energy.order_inv' numberNotReplacable meanNoiseSen meanNoiseMus]

order = gaitData.energy.order;
[(1:10)' numberNotReplacable(order) meanNoiseSen(order) meanNoiseMus(order)]

[~,order]=sort(meanNoiseMus);
[gaitData.energy.order_inv(order)' gaitData.golden_ratio.order_inv(order)' numberNotReplacable(order) meanNoiseSen(order) meanNoiseMus(order)]



%% PLOT1 : BOXPLOT 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise & Feedback sensititivity %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keep = gaitData.feedback.order(1:end-1);
toExtract = extract_repeat_cpg(1:end);
hFig = figure;
subplot(1,3,1);
%bar(mean(100*sqrt(1-combinaisonStudy.cpgData.STABLE_UNTIL(toExtract,:))'));
boxplot(100*sqrt(1-combinaisonStudy.cpgData.STABLE_UNTIL(toExtract,:))','Orientation',1,'boxstyle','filled','outliersize',8,'symbol','o')
title('Feedback sensitivity');
ylabel('sensitivity [%]')
set(gca,'xtick',1:length(toExtract))
set(gca,'xticklabel',gaitData.energy.order_inv(toExtract));

subplot(1,3,2);
boxplot(100*sqrt(sensorNoiseData.p_stableUntil(toExtract,:))','Orientation',1,'boxstyle','filled','outliersize',8,'symbol','o')
%bar(mean(100*sqrt(sensorNoiseData.p_stableUntil(toExtract,:))'));

ylabel('noise sensor level [%]');
set(gca,'xtick',1:length(toExtract))
set(gca,'xticklabel',gaitData.energy.order_inv(toExtract));

subplot(1,3,3);
boxplot(100*muscleNoise.Data.p_stableUntil(toExtract,:)','Orientation',1,'boxstyle','filled','outliersize',8,'symbol','o')
%bar(mean(100*sqrt(sensorNoiseData.p_stableUntil(toExtract,:))'));

ylabel('noise muscle level [%]');
set(gca,'xtick',1:length(toExtract))
set(gca,'xticklabel',gaitData.energy.order_inv(toExtract));

format_boxplot(hFig);
set(hFig, 'Position', [530,00,500,200]);

[~,feedbackSensitivty] = sort(mean(100*sqrt(1-combinaisonStudy.cpgData.STABLE_UNTIL(toExtract,:))'),2,'descend');
[~,noiseResistance] = sort(mean(100*sqrt(sensorNoiseData.p_stableUntil(toExtract,:))'));
%% PLOT2 : BARPLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback sensititivity (cpg) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig = figure;
toExtract = extract_repeat_cpg(gaitData.energy.order([2,3,6,8,4,1,10]));
for i=1:length(toExtract)
    repeat = toExtract(i);
    subplot(5,2,i);


    keep = gaitData.feedback.order(1:end-1);
    keepName = gaitData.feedbackName(keep);
    stableLimit = combinaisonStudy.cpgData.STABLE_UNTIL(repeat,keep);
    notFFStable = find(stableLimit ~= 1);
    noFFStables(i) = length(notFFStable);
    barh(100*sqrt(1-stableLimit(notFFStable)))
    shading flat
    colormap([0.4,0.4,0.4])
    xlabel(['CoT(' num2str(gaitData.energy.order_inv(repeat)) ')']);
    set(gca,'yticklabel',keepName(notFFStable));
    ylim([0 4])
    xlim([0 100]);

end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback sensititivity (cst) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig = figure;
toExtract = extract_repeat_cpg(gaitData.energy.order(1:10));
for i=1:length(toExtract)
    repeat = toExtract(i);
    subplot(5,2,i);


    keep = gaitData.feedback.order(1:end-1);
    keepName = gaitData.feedbackName(keep);
    stableLimit = combinaisonStudy.cstData.STABLE_UNTIL(repeat,keep);
    notFFStable = find(stableLimit ~= 1);
    
    noFFStables(i) = length(notFFStable);

    barh(100*sqrt(1-stableLimit(notFFStable)))
    shading flat
    colormap([0.4,0.4,0.4])
    xlabel(['CoT(' num2str(gaitData.energy.order_inv(repeat)) ')']);
    set(gca,'yticklabel',keepName(notFFStable));
    %ylim([0 4])
    xlim([0 100]);

end

%% PLOT3A : BOXPLOT SPEED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback replacement effects %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);
group = repmat(gaitData.feedbackName(toKeep),2,1)
%group = repmat(gaitData.feedbackName(toKeep),2,1)
cst1 = combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_VELOCITY(:,toKeep);
cst10 = combinaisonStudy.raw.cst_10.fitness_discardFall.MEAN_VELOCITY(:,toKeep);
cpg1 = combinaisonStudy.raw.cpg_3.fitness_discardFall.MEAN_VELOCITY(:,toKeep);
cpg10 = combinaisonStudy.raw.cpg_10.fitness_discardFall.MEAN_VELOCITY(:,toKeep);
clear subplot;
subplot(1,2,1);
boxplot([cst1 cst1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('speed [m/s]')
xlim([0.9 1.4]);
subplot(1,2,2);
boxplot([cpg1 cpg1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('speed [m/s]')
xlim([0.9 1.4]);
format_boxplot(hFig);
set(hFig, 'Position', [0,0,800,400]);
%% PLOT3B : BOXPLOT STEPLENGTH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback replacement effects %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);

cst1 = combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH(:,toKeep);
cst10 = combinaisonStudy.raw.cst_10.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH(:,toKeep);
cpg1 = combinaisonStudy.raw.cpg_3.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH(:,toKeep);
cpg10 = combinaisonStudy.raw.cpg_10.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH(:,toKeep);
clear subplot;
subplot(1,2,1);
boxplot([cst1 cst1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('stride length [m]')
xlim([0.9 1.4]);
subplot(1,2,2);
boxplot([cpg1 cpg1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('stride length [m]')
xlim([0.9 1.4]);
format_boxplot(hFig);
set(hFig, 'Position', [0,0,800,400]);


%% PLOT3C : BOXPLOT CoT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback replacement effects %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);

cst1_d = combinaisonStudy.raw.cst_3.fitness_discardFall.DISTANCE(:,toKeep);
cst10_d = combinaisonStudy.raw.cst_10.fitness_discardFall.DISTANCE(:,toKeep);
cpg1_d = combinaisonStudy.raw.cpg_3.fitness_discardFall.DISTANCE(:,toKeep);
cpg10_d = combinaisonStudy.raw.cpg_10.fitness_discardFall.DISTANCE(:,toKeep);

cst1 = combinaisonStudy.raw.cst_3.fitness_discardFall.ENERGY(:,toKeep);
cst10 = combinaisonStudy.raw.cst_10.fitness_discardFall.ENERGY(:,toKeep);
cpg1 = combinaisonStudy.raw.cpg_3.fitness_discardFall.ENERGY(:,toKeep);
cpg10 = combinaisonStudy.raw.cpg_10.fitness_discardFall.ENERGY(:,toKeep);

cst1 = cst1./cst1_d/80;
cst10 = cst10./cst10_d/80;
cpg1 = cpg1./cpg1_d/80;
cpg10 = cpg10./cpg10_d/80;

clear subplot;
subplot(1,2,1);
boxplot([cst1 cst1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('CoT [Nkg^{-1}]')
xlim([2.4 3.2]);
subplot(1,2,2);
boxplot([cpg1 cpg1],group, 'Orientation',0,'boxstyle','filled','outliersize',8,'symbol','o')
xlabel('CoT [Nkg^{-1}]')
xlim([2.4 3.2]);
format_boxplot(hFig);
set(hFig, 'Position', [0,0,800,400]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Feedback replacement effects %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1=figure;
h2=figure;
%% PLOT4A : PLOT SPEED VERSUS COMBINATION %%
cst_1_v = combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_VELOCITY;
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);
x = linspace(0,100,11);
[~,I]=sort(nanstd(cst_1_v(:,toKeep)),2,'descend');
plot(x,cst_1_v(:,toKeep(I(1:2))),'--','LineWidth',2);
hold on;
plot(x,cst_1_v(:,toKeep(I(1:2))),'o','LineWidth',2);
xlabel('IN_{cst} [%]');
ylabel('speed [ms^{-1}]');
legend(gaitData.feedbackName(toKeep(I(1:2))))
set(h1, 'Position', [0,1000,450,400]);

% xbig = linspace(0,100,1000);
% y1=cst_1_v(:,toKeep(I(1)));
% p1 = polyfit(x(1:5),y1(1:5)',1);
% plot(xbig(1:500),polyval(p1,xbig(1:500)),'Color',colors(1,:),'LineWidth',2)
% y2=cst_1_v(:,toKeep(I(2)));
% p2 = polyfit(x(1:9),y2(1:9)',2);
% plot(xbig(1:800),polyval(p2,xbig(1:800)),'Color',colors(2,:),'LineWidth',2)
% 
% plot(x,cst_1_v(:,toKeep(I(1))),'o','LineWidth',2, 'Color',colors(1,:));
% plot(x,cst_1_v(:,toKeep(I(2))),'o','LineWidth',2, 'Color',colors(2,:));
%% PLOT4A : PLOT SPEED VERSUS COMBINATION %%
cst_1_v = (combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_LEFT_STANCE_DURATION + ...
          combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_LEFT_SWING_DURATION);
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);
x = linspace(0,100,11);
[~,I]=sort(nanstd(cst_1_v(:,toKeep)),2,'descend');
plot(x,cst_1_v(:,toKeep(I(1:2))),'--','LineWidth',2);
hold on;
plot(x,cst_1_v(:,toKeep(I(1:2))),'o','LineWidth',2);
xlabel('IN_{cst} [%]');
ylabel('step duration [s]');
legend(gaitData.feedbackName(toKeep(I(1:2))))
set(h1, 'Position', [0,1000,450,400]);

%% PLOT4A : PLOT STRIDE LENGTH VERSUS COMBINATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Feedback replacement effects %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colors = lines(5);
cst_1_s = combinaisonStudy.raw.cst_3.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;
toKeep = gaitData.feedback.order([1,2,3,4,5,6,7,8,9]);
x = linspace(0,100,11);
[~,I]=sort(nanstd(cst_1_v(:,toKeep)),2,'descend');
plot(x,cst_1_s(:,toKeep(I(1:2))),'--','LineWidth',2);
hold on;
plot(x,cst_1_s(:,toKeep(I(1:2))),'o','LineWidth',2);
xlabel('IN_{cst} [%]');
ylabel('stride length [m]');
legend([gaitData.feedbackName(toKeep(I(1:2)))])
set(h1, 'Position', [0,1000,450,400]);

% FIT
% xbig = linspace(0,100,1000);
% y1=cst_1_s(:,toKeep(I(1)));
% p1 = polyfit(x(1:5),y1(1:5)',1);
% plot(xbig(1:400),polyval(p1,xbig(1:400)),'Color',colors(1,:),'LineWidth',2)
% y2=cst_1_s(:,toKeep(I(2)));
% p2 = polyfit(x(1:9),y2(1:9)',2);
% plot(xbig(1:800),polyval(p2,xbig(1:800)),'Color',colors(2,:),'LineWidth',2)
% 
% plot(x,cst_1_s(:,toKeep(I(1))),'o','LineWidth',2, 'Color',colors(1,:));
% plot(x,cst_1_s(:,toKeep(I(2))),'o','LineWidth',2, 'Color',colors(2,:));


%% Systematic STUDY HYBRID Gait
folder = 'articleFrontier_wavy2';
subfolder = 'hybridStudy2_wavy2';
study = 'hybridStudy2';

raw_hybridA=extract_rawSystematicRecursive(folder,subfolder,study,'_fdb3_cpg3_hybridA','');
raw_hybridB=extract_rawSystematicRecursive(folder,subfolder,study,['_fdb3_cpg3_hybridB'],'');
raw_fblMinA=extract_rawSystematicRecursive(folder,subfolder,study,['_fdb3_cpg3_fblMinA'],'');
raw_fblMinB=extract_rawSystematicRecursive(folder,subfolder,study,['_fdb3_cpg3_fblMinB'],'');

%% Systematic STUDY HYBRID 4
folder = 'articleFrontier_wavy2';
subfolder = 'hybridStudy4_wavy2';
study = 'hybridStudy4';
suffix = '_fdb3_cpg3_3FBL_';
load = {
    'oscAnkle'
    'oscAnkle1'
    'oscAnkle2'
    'oscHip'
    'oscKnee'
    'oscBiArt'
    };

data = struct;
for i=1:length(load)
    prefix = cell2mat(load(i));
    data.(prefix) = extract_rawSystematicRecursive(folder,subfolder,study,[suffix prefix],'');
end


%% Systematic STUDY HYBRID 5
folder = 'articleFrontier_wavy2';
subfolder = 'hybridStudy5_wavy2';
study = 'hybridStudy5';
suffix = '_fdb3_cpg3_3FBL_';
load = {
    'mincpg1'
    'minfdb1'
    'oscAnkle'
    'oscAnkle1'
    'oscAnkle2'
    'oscHip'
    'oscKnee'
    'oscBiArt'
    };

data = struct;
for i=1:length(load)
    prefix = cell2mat(load(i));
    data.(prefix) = extract_rawSystematicRecursive(folder,subfolder,study,[suffix prefix],'');
end


%% Systematic STUDY HYBRID 6
folder = 'articleFrontier_wavy2';
subfolder = 'hybridStudy6_wavy2';
study = 'hybridStudy6';
suffix = '_fdb3_cpg3_3FBL_';

load.all = {
    'minfdb1'
    'mincpg1'
    'oscAnkle12'
    'oscAnkle13'
    'oscAnkle14'
    'oscAnkle1'
    'oscAnkle2'
    'oscAnkle'
    'oscBiArt'
    'oscHip12'
    'oscHip13'
    'oscHip1'
%    'oscHip2'
    'oscHip22'
    'oscHip23'
    'oscHip'
    'oscKnee'

    };
load.ankle = {
    'oscAnkle12'
    'oscAnkle13'
    'oscAnkle14'
    'oscAnkle1'
    'oscAnkle2'
    'oscAnkle'
    };


load.hip = {
    'oscHip12'
    'oscHip13'
    'oscHip1'
    'oscHip22'
    'oscHip23'
    'oscHip'
    };

load.knee = {
    'oscKnee'
    };


load.biart = {
    'oscBiArt'
    };

load.min = {
    'mincpg1'
    'minfdb1'
    };


data = struct;

toload = fieldnames(load);

for j=1:length(toload)
    prefix = cell2mat(toload(j));

    for i=1:length(load.(prefix))
        prefix2 = cell2mat(load.(prefix)(i));
        data.(prefix).(prefix2) = extract_rawSystematicRecursive(folder,subfolder,study,[suffix prefix2],'');
    end
    
end

%%
clear subplot
order = [
     7     5     2     3     4     6      8     15    14    11     9    10    12    13
     ];

figure
what = data_hyb6.all;
f = fieldnames(data.all);
subplot(1,3,1)
barh_hybridStudy(what,'speed','color',[0,1,0],'dim','x','order',order);
barh_hybridStudy(what,'speed','color',[1,0,0],'dim','y','order',order);
set(gca,'ytick',[1:length(order)]);
set(gca,'yticklabel',f(order));
xlabel('Speed')

subplot(1,3,2)
barh_hybridStudy(what,'stride','color',[0,1,0],'dim','x','order',order);
barh_hybridStudy(what,'stride','color',[1,0,0],'dim','y','order',order);
xlabel('Stride')
set(gca,'yticklabel',{});

subplot(1,3,3)
barh_hybridStudy(what,'cot','color',[0,1,0],'dim','x','order',order);
barh_hybridStudy(what,'cot','color',[1,0,0],'dim','y','order',order);
xlabel('CoT')
set(gca,'yticklabel',{});

h = get(gca,'Children');
legend([h(7), h(3)],'\omega','A')

%% Heatmap all
%data=data_hyb5;
what = data.all;
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05]);
figure
f = fieldnames(what);
for i=1:length(f)
    subplot(5,4,i)
    name = cell2mat(f(i));
    out = what.(name);
    d = out.fit.speedMean;
    d(abs(d-out.fit.speedInst) > 0.15) = nan;
    d(abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3) = nan;
    imagesc_hybridStudy(out,d);
    axis off
    colorbar
    title(name)
end
xlabel('CPG Amplitude')
ylabel('CPG Frequency')

%% Heatmap selected
%data=data_hyb5;
what = data.all;

clear subplot
figure
f = fieldnames(what);
tokeep=[5,12,13,15];
j=0;
for i=tokeep
    j=j+1
    subplot(2,2,j)
    name = cell2mat(f(i));
    out = what.(name);
    d = out.fit.speedMean;
    d(abs(d-out.fit.speedInst) > 0.15) = nan;
    d(abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3) = nan;
    imagesc_hybridStudy(out,d);
    %axis off
    colorbar
    title(name)
end
xlabel('CPG Amplitude')
ylabel('CPG Frequency')
set(gcf, 'Position', [0,1000,650,500]);


%% SURF
out=what.oscHip22;
d=out.fit.speedMean;
toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
d(toRemove) = nan;
toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
d(toRemove) = nan;
z=imagesc_hybridStudy(out,d,'plot',0);
figure
surf(z)
%% PLOT



subplot(221)
out = raw_fblMinA;
imagesc_hybridStudy(out,out.fitness);
caxis([0.9,1.6]);
title('fblMin A')

subplot(222)
out = raw_fblMinB;
imagesc_hybridStudy(out,out.fitness_notFalled(:,2));
caxis([0.9,1.5]);
title('fblMin B')

subplot(223)
out = raw_hybridA;
imagesc_hybridStudy(out,out.fitness_notFalled(:,2));
caxis([0.9,1.5]);
title('hybrid A')

subplot(224)
out = raw_hybridB;
imagesc_hybridStudy(out,out.fitness_notFalled(:,2));
caxis([0.9,1.5]);
title('hybrid B')


xlabel('CPG Amplitude')
ylabel('CPG Frequency')
    
%% PLOT best direction for the 16 models
what = data.all;
applyToGivenRow = @(func, matrix) @(row) func(matrix(row, :));
applyToRows = @(func, matrix) arrayfun(applyToGivenRow(func, matrix), 1:size(matrix,1))';

amp=barh_hybridStudy(what,'speed','color',[0,1,0],'dim','x','order',1:16,'plot',0);
freq=barh_hybridStudy(what,'speed','color',[0,1,0],'dim','y','order',1:16,'plot',0);


m=(applyToRows(@max,[amp.diff freq.diff]));

ampBest=find(amp.diff==m);
freqBest=find(freq.diff==m);


f = fieldnames(data.all);


%% plot all

for j=1:length(ampBest)
i=ampBest(j);
out=what.(cell2mat(f(i)));
x=unique(out.p_values(:,1));
y=unique(out.p_values(:,2));

d=out.fit.speedMean;
toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
d(toRemove) = nan;
toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
d(toRemove) = nan;
z=imagesc_hybridStudy(out,d,'plot',0);
subplot(4,4,i)
plot(x,z(amp.pos(i),:,:),'o-')
axis tight
title(f(i));
end
for k=1:length(freqBest)
i=freqBest(k);
out=what.(cell2mat(f(i)));
x=unique(out.p_values(:,1));
y=unique(out.p_values(:,2));


d=out.fit.speedMean;
toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
d(toRemove) = nan;
toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
d(toRemove) = nan;
z=imagesc_hybridStudy(out,d,'plot',0);
subplot(4,4,i)
plot(y,z(:,freq.pos(i),:),'o-r')
axis tight
title(f(i));
end

%% plot selected
clear subplot
figure
%tokeep=[2,5,6,11,12,13,14,15];
tokeep=[2,5,12,13,15];
%tokeep=[5,12,13,15];

for j=1:length(tokeep)
    i=tokeep(j);
    out=what.(cell2mat(f(i)));
    %d=out.fit.speedMean;
    d=out.fit.cycleLength;
    %d=out.fit.stanceDuration+out.fit.swingDuration;
    toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
    d(toRemove) = nan;
    toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
    d(toRemove) = nan;
    z=imagesc_hybridStudy(out,d,'plot',0);
    subplot(1,4,j)
    x=unique(out.p_values(:,1));
    y=unique(out.p_values(:,2));
    
    if(find(ampBest==tokeep(j)))
        plot(x,z(amp.pos(i),:,:),'o-')
        legend(['\omega=' num2str(y(amp.pos(i)))]);
    else
        plot(y,z(:,freq.pos(i),:),'o-r')
        legend(['A=' num2str(y(freq.pos(i)))]);
    end
    
    set(gcf, 'Position', [0,1000,850,200]);
    legend boxoff
    axis tight
    title(f(i));
end

%% plot selected Hip
colors=jet(6);
tokeep=[2,11,12,13,14,15];
group=[1,1,1,2,2,2];
for j=1:length(tokeep)
    i=tokeep(j);
    out=what.(cell2mat(f(i)));
    d=out.fit.speedMean;
    toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
    d(toRemove) = nan;
    toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
    d(toRemove) = nan;
    z=imagesc_hybridStudy(out,d,'plot',0);
    subplot(1,2,group(j))
    x=unique(out.p_values(:,1));
    y=unique(out.p_values(:,2));
    
    if(find(ampBest==tokeep(j)))
        plot(x,z(amp.pos(i),:,:),'o-','Color',colors(j,:),'Linewidth',2)
        hold on;
        legs{j} = [cell2mat(f(i)) ', \omega=' num2str(y(amp.pos(i)))];
        
    else
        plot(y,z(:,freq.pos(i),:),'o-','Color',colors(j,:),'Linewidth',2)
        hold on;
        legs{j} = [cell2mat(f(i)) ', A=' num2str(y(freq.pos(i)))];
        
    end

    axis tight
    title(f(i));
end

subplot(1,2,1)
legend(legs(1:3));

subplot(1,2,2)
legend(legs(4:end));

%%%%%%%%%
%% PCA %%
%%%%%%%%%
kept = exp_wavy.energy.order(1:6);
muscle_feedbacks = squeeze(exp_wavy.feedback.signals(:,:,[5,6,7,8,9,10,11,13,14]));
for i=1:10
[COEFF, SCORE, LATENT] = pca(squeeze(muscle_feedbacks(i,:,:))');
latent(i,:) = LATENT;
coeff(i,:,:) = COEFF;
score(i,:,:) = SCORE;
end

for i=1:10
information(i,:) = cumsum(latent(i,:))./sum(latent(i,:));
end

%%
subplot_shadedSignals(coeff(kept,:,1:4),{'PCA 1','PCA 2','PCA 3','PCA 4','e','f','g','h'})

figure


boxplot(information)
ylabel('Explained variance [%]')
xlabel('Number of PCA Component');