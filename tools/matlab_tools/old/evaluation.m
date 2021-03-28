%% EVALUATION (FULL REFLEX) FBL and FBL+
folder = '../../global_job/evaluation/data/';
%folder = '../../global_job/evaluation/data/v2.02/fblfbl-/';
SERIE = 1;

models = struct;
models.fba = 1;
models.fbam = 2;
models.cpgfbam = 3;
%models_name = {'fba','fbap'};
models_name = {'fba','fbam','cpgfbam'};
model_kept = [1,2,3];
environments_name = {'base', 'rp','wg'};
environments.base = 1;
environments.rp = 2;
%environments.rp_eval = 3;
environments.wg = 3;

model_number = length(models_name);
env_number = length(environments_name);

tempc = jet(13);
env_colors = [tempc(4,:); tempc(7,:);tempc(9,:)];
%% extracting correlation
%%%%%%%%%%%%%%%%%%%%%%%%
d = importdata([folder 'base.txt']);
dh =  importdata([folder 'header_base.txt']);
%d = importdata(['./evaluation/data/base_' int2str(SERIE) '.txt']);
%dh =  importdata(['./evaluation/data/header_base_' int2str(SERIE) '.txt']);

data = d.data;
head = dh;
info = d.textdata;

dist = zeros(length(models_name),length(environments_name));
hip_corr = zeros(length(models_name),length(environments_name));
knee_corr = zeros(length(models_name),length(environments_name));
ankle_corr = zeros(length(models_name),length(environments_name));
corrs = zeros(length(models_name),length(environments_name),3);
energy = zeros(length(models_name),length(environments_name));

repeat = zeros(length(models_name),length(environments_name));
for i=1:size(data,1)
    model_num = eval(['models.' cell2mat(info(i,2))]);
    env_num = eval(['environments.' cell2mat(info(i,1))]);
    repeat(model_num,env_num) = repeat(model_num,env_num)+1;
    
    dist(model_num,env_num) = dist(model_num,env_num)+data(i,1);
    hip_corr(model_num,env_num) = hip_corr(model_num,env_num)+data(i,2);
    
    knee_corr(model_num,env_num) = knee_corr(model_num,env_num)+data(i,3);
    ankle_corr(model_num,env_num) = ankle_corr(model_num,env_num)+data(i,4);
    corrs(model_num,env_num,:) = reshape(corrs(model_num,env_num,:),1,3) + data(i,2:4);
    energy(model_num,env_num) = energy(model_num,env_num)+data(i,5);
end

dist = dist./repeat;
hip_corr = hip_corr./repeat;

knee_corr = knee_corr./repeat;
ankle_corr = ankle_corr./repeat;

corrs(:,:,1) = reshape(reshape(corrs(:,:,1)./repeat,model_number,env_number),model_number,env_number,1);
corrs(:,:,2) = reshape(reshape(corrs(:,:,2)./repeat,model_number,env_number),model_number,env_number,1);
corrs(:,:,3) = reshape(reshape(corrs(:,:,3)./repeat,model_number,env_number),model_number,env_number,1);
energy = energy./repeat;


% figure;
% subplot(131);
% colormap(env_colors);
% bar(hip_corr);
% set(gca,'xticklabel',models_name);
% legend('base','rp','wg');
% xlabel('models');
% ylabel('correlation');
% title('hip')
% subplot(132);
% bar(knee_corr);
% set(gca,'xticklabel',models_name);
% legend('base','rp','wg');
% xlabel('models');
% ylabel('correlation');
% title('knee')
% subplot(133);
% bar(ankle_corr);
% set(gca,'xticklabel',models_name);
% legend('base','rp','wg');
% xlabel('models');
% ylabel('correlation');
% title('ankle')

fA = figure;
f1 = subplot(131);
set(gca,'FontSize',16)
env = environments.base;
colormap(gray(3))
bar([hip_corr(model_kept,env) knee_corr(model_kept,env) ankle_corr(model_kept,env)]);
ylim([0,1]);
xlim([1-1./3-0.01,2+1./3])
set(gca,'xticklabel',models_name(model_kept));
%legend('hip','knee','ankle');
title('base');
ylabel('correlation');
f2 = subplot(132);
set(gca,'FontSize',16)
env = environments.rp;
bar([hip_corr(model_kept,env) knee_corr(model_kept,env) ankle_corr(model_kept,env)]);
ylim([0,1]);
xlim([1-1./3-0.01,2+1./3])
set(gca,'xticklabel',models_name(model_kept));
legend('hip','knee','ankle');
xlabel('models');
%xlabel('models');
%ylabel('correlation');
title('rp');
f3 = subplot(133);
set(gca,'FontSize',16)
env = environments.wg;
bar([hip_corr(model_kept,env) knee_corr(model_kept,env) ankle_corr(model_kept,env)]);
ylim([0,1]);
xlim([1-1./3-0.01,2+1./3])
set(gca,'xticklabel',models_name(model_kept));
%legend('hip','knee','ankle');
%xlabel('models');
%ylabel('correlation');
title('wg');
%f4 = subplot(143);
%env = environments.rp_eval;
%bar([hip_corr(model_kept,env) knee_corr(model_kept,env) ankle_corr(model_kept,env)]);
%ylim([0,1]);
%xlim([1-1./3-0.01,2+1./3])
%set(gca,'xticklabel',models_name(model_kept));
%legend('hip','knee','ankle');
%xlabel('models');
%ylabel('correlation');
%title('rp_{eval}');

set(f1, 'color', env_colors(1,:))
set(f2, 'color', env_colors(2,:))
set(f3, 'color', env_colors(3,:))
%set(f4, 'color', env_colors(4,:))

clear dist
%% extracting force
%%%%%%%%%%%%%%%%%%%%%%%%
d = importdata(['../../global_job/evaluation/data/force.txt']);
dh =  importdata(['../../global_job/evaluation/data/header_force.txt']);
%d = importdata(['../../current/evaluation/data/force.txt']);
%dh =  importdata(['../../current/evaluation/data/header_force.txt']);
%d = importdata(['./evaluation/data/force_' int2str(SERIE) '.txt']);
%dh =  importdata(['./evaluation/data/header_force_' int2str(SERIE) '.txt']);

data = d.data;
head = dh;
info = d.textdata;

repeat = zeros(length(models_name),length(environments_name));

for i=1:size(data,1)
    model_num = eval(['models.' cell2mat(info(i,2))]);
    
    env_num = eval(['environments.' cell2mat(info(i,1))]);
    repeat(model_num,env_num) = repeat(model_num,env_num)+1;
    
    rep = repeat(model_num, env_num);
    dist(model_num,env_num).val(rep) = data(i,1);
    forceVec(model_num,env_num).val(:,rep) = data(i,2:3);
    forceAmp(model_num,env_num).val(rep) = sqrt(data(i,2)*data(i,2)+data(i,3)*data(i,3));
    forcePos(model_num,env_num).val(rep) = data(i,4);
    falled(model_num,env_num).val(rep) = ~data(i,5);
    
end
%forceAmp = forceAmp./repeat;
%forcePos = forcePos./repeat;
for m=1:length(models_name)
    for e=1:length(environments_name)
        mDist(m,e) = mean(dist(m,e).val);
        vDist(m,e) = std(dist(m,e).val);
        
        mForceAmp(m,e) = mean(forceAmp(m,e).val);
        vForceAmp(m,e) = std(forceAmp(m,e).val);
    end
end
fB = figure;
set(gca,'FontSize',16)
errorb(mForceAmp,vForceAmp);
colormap(env_colors);
set(gca,'xticklabel',models_name(model_kept));
legend(environments_name);
xlabel('models');
ylabel('Force [N]');
xlim([1-1./3-0.02,2+1./3+0.02])

%% extracting slope
%%%%%%%%%%%%%%%%%%%%%%%%
d = importdata(['../../global_job/evaluation/data/distance.txt']);
dh =  importdata(['../../global_job/evaluation/data/header_distance.txt']);
%d = importdata(['./evaluation/data/distance_' int2str(SERIE) '.txt']);
%dh =  importdata(['./evaluation/data/header_distance_' int2str(SERIE) '.txt']);

repeat_number = 5;
repeat = zeros(length(models_name),length(environments_name));
wg_1 = [0 0; importdata('../../v2.01/webots/worlds/wg_1.wbt.data')];
wg_2 = [0 0; importdata('../../v2.01/webots/worlds/wg_2.wbt.data')];
wg_3 = [0 0; importdata('../../v2.01/webots/worlds/wg_3.wbt.data')];
wg_4 = [0 0; importdata('../../v2.01/webots/worlds/wg_4.wbt.data')];
wg_5 = [0 0; importdata('../../v2.01/webots/worlds/wg_5.wbt.data')];

%usage slope(distance, wavy_ground), returns the slope
getSlope = @(x,y) y(find(y(:,1) >= x,1)-1,2);


data = d.data;
head = dh;
info = d.textdata;

repeat = zeros(length(models_name),length(environments_name));

for i=1:size(data,1)
    model_num = eval(['models.' cell2mat(info(i,2))]);
    env_num = eval(['environments.' cell2mat(info(i,1))]);
    
    repeat(model_num,env_num) = repeat(model_num,env_num)+1;
    
    rep = repeat(model_num, env_num);
    
    world = cell2mat(info(i,3));
    world = world(1:4);
    slopes(model_num,env_num).val(rep) = getSlope(data(i,1),eval(world));
    %slopes(model_num,env_num).val(rep) = data(i,1);
end
for m=1:length(models_name)
    for e=1:length(environments_name)
        mSlopes(m,e) = mean(slopes(m,e).val);
        vSlopes(m,e) = std(slopes(m,e).val);
    end
end
fC = figure;
set(gca,'FontSize',16)
mF = mSlopes;
sF = vSlopes;
errorb(100*mF,100*sF);
colormap(env_colors);
set(gca,'xticklabel',models_name(model_kept));
legend(environments_name);
xlabel('models');
ylabel('Slope [%]');
xlim([1-1./3-0.02,2+1./3+0.02])
