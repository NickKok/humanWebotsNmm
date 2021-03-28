%               %
%               %
%               %
%               %
% GET THE DATA  %
%               %
%               %
%               %
%               %
%%%%%%%%%%%%%%%%%

fitnessName=get_systematicFitnessName();
feedbackName=get_feedbackName;
feedbackName{end+1}= 'VAS<-KNEE OPF';
mff = [5 7 9 6];
mlf = [8 11 10 14 13];
gsif = [2 1 3];
gcf = 12;
tlf = 4;
jop = 15;
feedback_order = [mff(end:-1:1) mlf(end:-1:1) gsif(end:-1:1) gcf(end:-1:1) tlf(end:-1:1)];

out=load_data('1.3',1:10);

%% Systematic Study Combinaison


% We extract repeat 1 6 10 that corresponds in term
% of order of CoT to 3 9 1.
% --> we put them in variable with the id corresponding
%     to their number in term of CoT ranking
rawSystematic_3cst=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb1_cst1');
rawSystematic_3cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb1_cpg1');

rawSystematic_9cst=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb6_cst6');
rawSystematic_9cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb6_cpg6');

rawSystematic_1cst=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb10_cst10');
rawSystematic_1cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','combinaisonStudy','_fdb10_cpg10');

%%
expSize = [11,15];
extract_repeat_cst = [1,5,6,7,10];
extract_repeat_cpg = [1,2,3,4,5,6,7,8,9,10];
combinaisonStudy = load_systematicCombinaisonStudy(extract_repeat_cpg, extract_repeat_cst);

%% Systematic Noise study
noiseMuscleStudy = struct;
noiseMuscleStudy.data = struct;
noiseMuscleStudy.data.FALLED = [];
noiseMuscleStudy.data.ENERGY = [];
noiseMuscleStudy.data.STEADY_STATE_REACHEDAT= [];
for i=1:10
    raw = extract_rawSystematic('articleFrontier','noiseMuscleStudy',[num2str(i) '_FDB_0.002MAX_repeat1']);
    noiseMuscleStudy.(['fdb_' num2str(i)]) = raw;
    noiseMuscleStudy.data.FALLED(:,i) = raw.fitness.FALLED;
    noiseMuscleStudy.data.ENERGY(:,i) = raw.fitness.FALLED;
    noiseMuscleStudy.data.STEADY_STATE_REACHEDAT(:,i) = raw.fitness.STEADY_STATE_REACHEDAT;
end
clear raw

%%%%%%%%%%%%%%%%%
%               %
%               %
%               %
%               %
%     PLOT      %
%               %
%               %
%  subpart 1    %
%  fdb sensi.   %
%%%%%%%%%%%%%%%%%

%% Replacement capacity

number = rawSystematic_3cpg.p_number;

CL_cst = [];
CL_cst(2,:) = rawSystematic_3cst.p_stableUntil;
CL_cst(3,:) = rawSystematic_9cst.p_stableUntil;
CL_cst(1,:) = rawSystematic_1cst.p_stableUntil;


CL_cpg = [];
CL_cpg(2,:) = rawSystematic_3cpg.p_stableUntil;
CL_cpg(3,:) = rawSystematic_9cpg.p_stableUntil;
CL_cpg(1,:) = rawSystematic_1cpg.p_stableUntil;


%toKeep = [1:3 5:10 12:14];
%order = feedbackOrderInv(toKeep);
toKeep = 1:13;
order = feedback_order(toKeep);
order = order(end:-1:1);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.03], [0.15 0.1], [0.5 0.03]);
figure
colors = cool(6);
colormap(colors)
subplot(1,2,1);
barh(1-CL_cpg(:,order)')
title('CPG-Fdb');
ylim([0,14])
set(gca, 'box', 'off')
set(gca,'ytick',1:length(toKeep));
set(gca,'yticklabel',feedbackName(order));
subplot(1,2,2);
barh(1-CL_cst(:,order)')
title('Cst-Fdb');
ylim([0,14])
set(gca, 'box', 'off')
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);
legend('CoT(1)','CoT(3)','CoT(9)');
xlabel('replacement sensitivity               ');
set(hFig, 'Position', [1200,00,350,450]);


%% Replacement effect 1
% We group all effect on cst and cpg together and plot the standard
% deviation in a bar plot
std_V_Cpg = reshape(nanstd(combinaisonStudy.cpgData.MEAN_VELOCITY(:,:,:),0,2),10,15);
std_V_Cst = reshape(nanstd(combinaisonStudy.cstData.MEAN_VELOCITY(:,:,:),0,2),10,15);
std_CoT_Cpg = reshape(nanstd(combinaisonStudy.cpgData.CoT(:,:,:),0,2),10,15);
std_CoT_Cst = reshape(nanstd(combinaisonStudy.cstData.CoT(:,:,:),0,2),10,15);
std_SL_Cpg = reshape(nanstd(combinaisonStudy.cpgData.SL(:,:,:),0,2),10,15);
std_SL_Cst = reshape(nanstd(combinaisonStudy.cstData.SL(:,:,:),0,2),10,15);

mean_V_Cpg = reshape(nanmean(combinaisonStudy.cpgData.MEAN_VELOCITY(:,:,:),2),10,15);
mean_V_Cst = reshape(nanmean(combinaisonStudy.cstData.MEAN_VELOCITY(:,:,:),2),10,15);
mean_CoT_Cpg = reshape(nanmean(combinaisonStudy.cpgData.CoT(:,:,:),2),10,15);
mean_CoT_Cst = reshape(nanmean(combinaisonStudy.cstData.CoT(:,:,:),2),10,15);
mean_SL_Cpg = reshape(nanmean(combinaisonStudy.cpgData.SL(:,:,:),2),10,15);
mean_SL_Cst = reshape(nanmean(combinaisonStudy.cstData.SL(:,:,:),2),10,15);



toKeep = [1:3 5:10 12:14];
toKeep = toKeep([3 4 5 6 11]);
elemId=toKeep;

V = [std_V_Cpg(:,elemId)./mean_V_Cpg(:,elemId) std_V_Cst(:,elemId)./mean_V_Cst(:,elemId)];
CoT = [std_CoT_Cpg(:,elemId)./mean_CoT_Cpg(:,elemId) std_CoT_Cst(:,elemId)./mean_CoT_Cst(:,elemId)];
SL = [std_SL_Cpg(:,elemId)./mean_SL_Cpg(:,elemId) std_SL_Cst(:,elemId)./mean_SL_Cst(:,elemId)];



box_width=1.0;
box_style='filled';
group_number=2;
group_size=size(CoT,2)/group_number;
elem = cell(1,group_number*group_size);
group = cell(1,group_number*group_size);


for i=1:group_size
    elem(i:group_size:end)=repmat({num2str(elemId(i))},1,2);
end
groupname={'cp','cs'};
for i=1:group_number
    group(1+(group_size)*(i-1):group_size*i)=groupname(i);
end

clear subplot;
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.1 0.05], [0.1 0.02]);

hFig = figure;
subplot(3,1,1);
boxplot(CoT,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(2)',1,15)','width',box_width,'boxstyle',box_style);
title('CoT variability');

box = findobj(gca,'Tag','Box');
whisker = findobj(gca,'Tag','Whisker');
median = findobj(gca,'Tag','Median');
set(box(:), 'linewidth',8);
set(whisker(:), 'linewidth',4, 'Color', [0.3 0.3 0.3]);
delete(median)
set(gca, 'box', 'off')

set(gca,'xtick',1);
set(gca,'xticklabel',' ');

subplot(3,1,2)
boxplot(V,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(2)',1,15)','width',box_width,'boxstyle',box_style);
title('Velocity variability');

box = findobj(gca,'Tag','Box');
whisker = findobj(gca,'Tag','Whisker');
median = findobj(gca,'Tag','Median');
set(box(:), 'linewidth',8);
set(whisker(:), 'linewidth',4, 'Color', [0.3 0.3 0.3]);
delete(median)
set(gca, 'box', 'off')
set(gca,'xtick',1);
set(gca,'xticklabel',' ');


subplot(3,1,3)
boxplot(SL,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(2)',1,15)','width',box_width,'boxstyle',box_style);
title('Stride Length variability');

box = findobj(gca,'Tag','Box');
whisker = findobj(gca,'Tag','Whisker');
median = findobj(gca,'Tag','Median');
outlier = findobj(gca,'Tag','Outlier');
set(box(:), 'linewidth',8);
set(whisker(:), 'linewidth',4, 'Color', [0.3 0.3 0.3]);
set(outlier(:), 'linewidth',4);
delete(median)
set(gca, 'box', 'off')
%set(gca,'xtick',1);
%set(gca,'xticklabel',' ');

set(hFig, 'Position', [530,00,330,500]);

%% Plot of feedback percentage versus speed stride length
colors = cool(3);
plot(linspace(0,1,11),combinaisonStudy.cstData.MEAN_VELOCITY(1,:,1),'LineWidth',2,'Color',colors(1,:));
hold on;
plot(linspace(0,1,11),combinaisonStudy.cstData.MEAN_VELOCITY(6,:,1),'LineWidth',2,'Color',colors(2,:));
plot(linspace(0,1,11),combinaisonStudy.cstData.MEAN_VELOCITY(10,:,1),'LineWidth',2,'Color',colors(3,:));
%% Replacement effect 2
toKeep = [1:3 5:10 12:14];
clear subplot;
subplot = @(m,n,p) subtightplot (m, n, p, [0.001 0.01], [0.01 0.01], [0.01 0.01]);

number = rawSystematic_3cpg.p_number;

fitnessName = get_systematicFitnessName;

fitnessWithoutFalled = struct;


mean_0 = @(x) sum(x) ./ (sum(x~=0));

ENERGY_cst = [];
ENERGY_cst(2,:,:) = rawSystematic_3cst.fitness_discardFall.ENERGY;
ENERGY_cst(3,:,:) = rawSystematic_9cst.fitness_discardFall.ENERGY;
ENERGY_cst(1,:,:) = rawSystematic_1cst.fitness_discardFall.ENERGY;

ENERGY_cpg = [];
ENERGY_cpg(2,:,:) = rawSystematic_3cpg.fitness_discardFall.ENERGY;
ENERGY_cpg(3,:,:) = rawSystematic_9cpg.fitness_discardFall.ENERGY;
ENERGY_cpg(1,:,:) = rawSystematic_1cpg.fitness_discardFall.ENERGY;

DISTANCE_cst = [];
DISTANCE_cst(2,:,:) = rawSystematic_3cst.fitness_discardFall.DISTANCE;
DISTANCE_cst(3,:,:) = rawSystematic_9cst.fitness_discardFall.DISTANCE;
DISTANCE_cst(1,:,:) = rawSystematic_1cst.fitness_discardFall.DISTANCE;

DISTANCE_cpg = [];
DISTANCE_cpg(2,:,:) = rawSystematic_3cpg.fitness_discardFall.DISTANCE;
DISTANCE_cpg(3,:,:) = rawSystematic_9cpg.fitness_discardFall.DISTANCE;
DISTANCE_cpg(1,:,:) = rawSystematic_1cpg.fitness_discardFall.DISTANCE;



MEAN_VELOCITY_cst = [];
MEAN_VELOCITY_cst(2,:,:) = rawSystematic_3cst.fitness_discardFall.MEAN_VELOCITY;
MEAN_VELOCITY_cst(3,:,:) = rawSystematic_9cst.fitness_discardFall.MEAN_VELOCITY;
MEAN_VELOCITY_cst(1,:,:) = rawSystematic_1cst.fitness_discardFall.MEAN_VELOCITY;

MEAN_VELOCITY_cpg = [];
MEAN_VELOCITY_cpg(2,:,:) = rawSystematic_3cpg.fitness_discardFall.MEAN_VELOCITY;
MEAN_VELOCITY_cpg(3,:,:) = rawSystematic_9cpg.fitness_discardFall.MEAN_VELOCITY;
MEAN_VELOCITY_cpg(1,:,:) = rawSystematic_1cpg.fitness_discardFall.MEAN_VELOCITY;

MEAN_RIGHT_STEP_LENGTH_cst = [];
MEAN_RIGHT_STEP_LENGTH_cst(2,:,:) = rawSystematic_3cst.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
MEAN_RIGHT_STEP_LENGTH_cst(3,:,:) = rawSystematic_9cst.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
MEAN_RIGHT_STEP_LENGTH_cst(1,:,:) = rawSystematic_1cst.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;

MEAN_RIGHT_STEP_LENGTH_cpg = [];
MEAN_RIGHT_STEP_LENGTH_cpg(2,:,:) = rawSystematic_3cpg.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
MEAN_RIGHT_STEP_LENGTH_cpg(3,:,:) = rawSystematic_9cpg.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
MEAN_RIGHT_STEP_LENGTH_cpg(1,:,:) = rawSystematic_1cpg.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;

MEAN_LEFT_STEP_LENGTH_cst = [];
MEAN_LEFT_STEP_LENGTH_cst(2,:,:) = rawSystematic_3cst.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;
MEAN_LEFT_STEP_LENGTH_cst(3,:,:) = rawSystematic_9cst.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;
MEAN_LEFT_STEP_LENGTH_cst(1,:,:) = rawSystematic_1cst.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;

MEAN_LEFT_STEP_LENGTH_cpg = [];
MEAN_LEFT_STEP_LENGTH_cpg(2,:,:) = rawSystematic_3cpg.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;
MEAN_LEFT_STEP_LENGTH_cpg(3,:,:) = rawSystematic_9cpg.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;
MEAN_LEFT_STEP_LENGTH_cpg(1,:,:) = rawSystematic_1cpg.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;


s = size(rawSystematic_3cst.p_values);
s(1,2) = length(feedbackOrderInv(toKeep));

% E_cst=[reshape(ENERGY_cst(1,:,feedbackOrderInv(toKeep)),s) reshape(ENERGY_cst(2,:,feedbackOrderInv(toKeep)),s) reshape(ENERGY_cst(3,:,feedbackOrderInv(toKeep)),s)];
% V_cst=[reshape(MEAN_VELOCITY_cst(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_VELOCITY_cst(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_VELOCITY_cst(3,:,feedbackOrderInv(toKeep)),s)];
% SL_L_cst=[reshape(MEAN_LEFT_STEP_LENGTH_cst(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_LEFT_STEP_LENGTH_cst(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_LEFT_STEP_LENGTH_cst(3,:,feedbackOrderInv(toKeep)),s)];
% SL_R_cst=[reshape(MEAN_RIGHT_STEP_LENGTH_cst(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_RIGHT_STEP_LENGTH_cst(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_RIGHT_STEP_LENGTH_cst(3,:,feedbackOrderInv(toKeep)),s)];
% SL_cst = 0.5*SL_L_cst+0.5*SL_R_cst;
% 
% E_cpg=[reshape(ENERGY_cpg(1,:,feedbackOrderInv(toKeep)),s) reshape(ENERGY_cpg(2,:,feedbackOrderInv(toKeep)),s) reshape(ENERGY_cpg(3,:,feedbackOrderInv(toKeep)),s)];
% V_cpg=[reshape(MEAN_VELOCITY_cpg(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_VELOCITY_cpg(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_VELOCITY_cpg(3,:,feedbackOrderInv(toKeep)),s)];
% SL_L_cpg=[reshape(MEAN_LEFT_STEP_LENGTH_cpg(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_LEFT_STEP_LENGTH_cpg(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_LEFT_STEP_LENGTH_cpg(3,:,feedbackOrderInv(toKeep)),s)];
% SL_R_cpg=[reshape(MEAN_RIGHT_STEP_LENGTH_cpg(1,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_RIGHT_STEP_LENGTH_cpg(2,:,feedbackOrderInv(toKeep)),s) reshape(MEAN_RIGHT_STEP_LENGTH_cpg(3,:,feedbackOrderInv(toKeep)),s)];
% SL_cpg = 0.5*SL_L_cpg+0.5*SL_R_cpg;

E_cst=[reshape(ENERGY_cst(1,:,toKeep),s) reshape(ENERGY_cst(2,:,toKeep),s) reshape(ENERGY_cst(3,:,toKeep),s)];
d_cst=[reshape(DISTANCE_cst(1,:,toKeep),s) reshape(DISTANCE_cst(2,:,toKeep),s) reshape(DISTANCE_cst(3,:,toKeep),s)];
V_cst=[reshape(MEAN_VELOCITY_cst(1,:,toKeep),s) reshape(MEAN_VELOCITY_cst(2,:,toKeep),s) reshape(MEAN_VELOCITY_cst(3,:,toKeep),s)];
SL_L_cst=[reshape(MEAN_LEFT_STEP_LENGTH_cst(1,:,toKeep),s) reshape(MEAN_LEFT_STEP_LENGTH_cst(2,:,toKeep),s) reshape(MEAN_LEFT_STEP_LENGTH_cst(3,:,toKeep),s)];
SL_R_cst=[reshape(MEAN_RIGHT_STEP_LENGTH_cst(1,:,toKeep),s) reshape(MEAN_RIGHT_STEP_LENGTH_cst(2,:,toKeep),s) reshape(MEAN_RIGHT_STEP_LENGTH_cst(3,:,toKeep),s)];

SL_cst = 0.5*SL_L_cst+0.5*SL_R_cst;
CoT_cst = E_cst./d_cst./80;


E_cpg=[reshape(ENERGY_cpg(1,:,toKeep),s) reshape(ENERGY_cpg(2,:,toKeep),s) reshape(ENERGY_cpg(3,:,toKeep),s)];
d_cpg=[reshape(DISTANCE_cpg(1,:,toKeep),s) reshape(DISTANCE_cpg(2,:,toKeep),s) reshape(DISTANCE_cpg(3,:,toKeep),s)];
V_cpg=[reshape(MEAN_VELOCITY_cpg(1,:,toKeep),s) reshape(MEAN_VELOCITY_cpg(2,:,toKeep),s) reshape(MEAN_VELOCITY_cpg(3,:,toKeep),s)];
SL_L_cpg=[reshape(MEAN_LEFT_STEP_LENGTH_cpg(1,:,toKeep),s) reshape(MEAN_LEFT_STEP_LENGTH_cpg(2,:,toKeep),s) reshape(MEAN_LEFT_STEP_LENGTH_cpg(3,:,toKeep),s)];
SL_R_cpg=[reshape(MEAN_RIGHT_STEP_LENGTH_cpg(1,:,toKeep),s) reshape(MEAN_RIGHT_STEP_LENGTH_cpg(2,:,toKeep),s) reshape(MEAN_RIGHT_STEP_LENGTH_cpg(3,:,toKeep),s)];

SL_cpg = 0.5*SL_L_cpg+0.5*SL_R_cpg;
CoT_cpg = E_cpg./d_cpg./80;

box_linewidth=2;
box_width=1.0;
box_style='filled';
group_number=3;
group_size=size(E_cst,2)/group_number;
elem = cell(1,group_number*group_size);
group = zeros(1,group_number*group_size);

elemId=feedbackOrderInv(toKeep);
for i=1:group_size
    elem(i:group_size:end)=repmat({num2str(elemId(i))},1,3);
end
groupname={1,6,10};
for i=1:group_number
    group(1+(group_size)*(i-1):group_size*i)=groupname{i};
end


interspace = 2.7083;
leg_pos = linspace(2,length(toKeep)*(3)+3*(length(toKeep)-1),length(toKeep));
leg = feedbackName(feedbackOrderInv(toKeep));


%% Replacement effect with CST IN
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.1], [0.1 0.1], [0.1 0.1]);
close all
hFig=figure;
subplot(3,1,1);
boxplot(CoT_cst,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style)
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
title('Replacement effect of INsen with INcst');
ylabel('CoT [kgN^{-1}m^{-1}]');
set(gca, 'box', 'off')
set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
subplot(3,1,2);
boxplot(V_cst,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style);
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
ylabel('velocity [ms^{-1}]');
set(gca, 'box', 'off')
set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
subplot(3,1,3);
boxplot(SL_cst,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style);
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
ylabel('stride length [m]');
set(gca, 'box', 'off')
%set(gca,'xtick',linspace(1,length(toKeep)*(3+2.7083),length(toKeep)));


set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
%xticklabel_rotate(leg_pos, 45, leg, 'FontSize',12);
set(hFig, 'Position', [00,00,530,550]);

%% Replacement effect with CPG IN
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.1], [0.1 0.1], [0.1 0.1]);
hFig=figure;
subplot(3,1,1);
boxplot(CoT_cpg,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style)
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
title('Replacement effect of INsen with INcpg');
ylabel('CoT [kgN^{-1}m^{-1}]');
set(gca, 'box', 'off')
set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
subplot(3,1,2);
boxplot(V_cpg,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style);
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
ylabel('velocity [ms^{-1}]');
set(gca, 'box', 'off')
set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
subplot(3,1,3);
boxplot(SL_cpg,{elem,group},'factorgap',[5 2],'labelverbosity','minor','colors',repmat(cool(3)',1,15)','width',box_width,'boxstyle',box_style);
h = findobj(gca,'Tag','Box');
%set(h,'LineWidth',box_linewidth)
ylabel('stride length [m]');
set(gca, 'box', 'off')
set(gca,'xtick',leg_pos);
set(gca,'xticklabel',[' ']);
set(hFig, 'Position', [530,00,530,550]);

%% NOISE STUDY


%% EXAMPLE NOISE
dir = [ config.raw_filedir '/sessionArticleFrontier' ]; % directory where to look for raw files
id = 72; % extraction serie ID
knot = 100; % number of knot for the spline interploation
what1 = config.raw_filename.muscles_activity;
what6 = config.raw_filename.muscles_noise;

disp('Data loading...')
tic
signalRaw_A = extract_rawFile(dir,what1,id); % extract muscles activity
signalRaw_noise = extract_rawFile(dir,what6,id); % extract muscles activity
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
toc


time = signalRaw_A.time;
activity = signalRaw_A.data;
white_noise = signalRaw_noise.data;
plot(time,activity(:,6)*100,'b','LineWidth',2);
hold on;
plot(time,100*white_noise(:,1).*sqrt(0.01*activity(:,6).^2),'mx');
plot(time,100*white_noise(:,1).*sqrt(0.001*activity(:,6).^2),'rx');
title('SOL Muscle Activity');
ylabel('muscle activity [%]');
xlabel('time [s]');
xlim([5 7]);
ylim([-20;100]);
legend('SOL activity','Noise k=0.01','Noise k=0.001');
legend boxoff
set(hFig, 'Position', [530,00,530,350]);