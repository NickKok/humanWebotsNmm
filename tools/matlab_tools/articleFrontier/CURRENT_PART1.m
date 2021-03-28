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
%%
CoT = out.energy.CoT;
e_order = out.energy.order;
% Feedback
feedback_order = out.feedback.order;
feedbackName = out.feedbackName;
mff = [5 7 9 6];
mlf = [8 11 10 14 13];
gsif = [2 1 3];
gcf = 12;
tlf = 4;
jop = 15;

fdbVar = out.feedback.variability;
fdbLefRightLag = out.feedback.leftRightLag;
fdbLefRightSim = out.feedback.leftRightSim;
fdbMean = out.feedback.mean;
fdbAmp = out.feedback.amplitude;
fdbAct = out.feedback.signals;

%%
ids=1:8;
out=load_data('1.0',1:8);
keep = out.energy.order(1:8);
%out=load_data('1.0',ids);
% Set variable names
% Energy
%out=load_data('1.0',1:8);
%exp_1_3=load_data('1.3',1:10);
%exp_1_6=load_data('1.6',1:8);


% Muscles

muscleAct = out.muscle.signals;
muscleName = out.muscleName;

mp = get_musclePrimitives(muscleAct,4);

muscleMP = mp.MP;
muscleMP_W = mp.W;
MP_Number = mp.MP_Number;
muscleMPName = mp.MP_Name;

%MP1 = reshape(muscleMP(keep,:,1),length(keep),1000)';
%MP2 = reshape(muscleMP(keep,:,2),length(keep),1000)';
%MP3 = reshape(muscleMP(keep,:,3),length(keep),1000)';
%MP4 = reshape(muscleMP(keep,:,4),length(keep),1000)';
%MP5 = reshape(muscleMP(keep,:,5),length(keep),1000)';
%MP6 = reshape(muscleMP(keep,:,6),length(keep),1000)';

cc_after = get_correlation(muscleMP,1);

clear cc;
for id=ids
    m = reshape(muscleAct(id,:,:),1000,7);
    mrec = reshape(muscleMP(id,:,:),1000,MP_Number)*reshape(muscleMP_W(id,:,:),MP_Number,7);
    muscleAct_rec(id,:,:) = mrec;
    cc(id,:) = diag(corr(m,mrec));
end


%imagesc(cc);caxis([0,1]);
%%
cc2=cc(keep,:);
%imagesc(cc2);caxis([min(cc2(:)) 1]);
imagesc(cc2);caxis([0,1]);
set(gca,'xticklabel',muscleName);
colorbar
%ylabel('repeat (order by CoT)')
set(gca,'xticklabel',muscleName);
%xlabel('muscles')
% Joint torques

jointName = out.jointName;
jointTorque = out.jointTorque.model;
jointTorqueHuman = out.jointTorque.human;

% Joint angles
jointName = out.jointName;
jointAngle = out.jointAngle.model;
jointAngleHuman = out.jointAngle.human;


% Golden ratio

grL = out.golden_ratio.left;
grR = out.golden_ratio.right;
gr_order = out.golden_ratio.order;


%%%%%%%%%%%%%%%%%
%               %
%               %
%               %
%               %
%     PLOT      %
%               %
%               %
%  subpart 1    %
%  exp comp.    %
%%%%%%%%%%%%%%%%%
%% Energy consumption
figure
plot_CoT(out.energy.CoT,out.energy.order)
%% Correlations 1
figure
h1=plot_correlation(muscleAct,muscleName, 'transpose',1, 'compareWith',4);
set(h1, 'Position', [500,00,200,200]);
h2=plot_correlation(jointTorque,jointName, 'transpose',1);
set(h2, 'Position', [500,200,200,70]);
h3=plot_correlation(jointAngle,jointName, 'transpose',1);
set(h3, 'Position', [500,400,200,70]);
%% Correlations 2
ind = [1     2     4     3     5     6     7];
[~,e_order] = sort(CoT);
compareWith = 2;
hFig=figure
subplot(311)
h1=plot_correlation(muscleAct(e_order,:,ind),muscleName(ind), 'rotate',0, 'bar',1,'compareWith',compareWith);
title('Muscles Activity','fontweight','normal','fontsize',14);
subplot(312)
h2=plot_correlation(jointTorque(e_order,:,:),jointName, 'transpose',1,'bar',1,'compareWith',compareWith);
title('Joints Torque','fontweight','normal','fontsize',14);
ylabel('Correlation coefficient');
subplot(313)
h3=plot_correlation(jointAngle(e_order,:,:),jointName, 'transpose',1,'bar',1,'compareWith',compareWith);
title('Joints Angle','fontweight','normal','fontsize',14);

%% Muscles activity between exp (split by energy)
ind = [1     2     4     3     5     6     7];
hFig=figure
subplot(131)
[~,e_order] = sort(CoT);
colors = jet(10);
%colors = colors(e_order,:);
j=0;
for i=e_order(1:4)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,1], 'returnSubplotHandler',[4,1],'ylim',[0,100],'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=e_order(5:8)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,2], 'returnSubplotHandler',[4,1],'ylim',[0,100]});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=e_order(9:end)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,3], 'returnSubplotHandler',[4,1],'ylim',[0,100],'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
%set(hFig, 'Position', [600,00,200,900]);
set(hFig, 'Position', [600,00,600,900]);

%% Muscles activity between exp (split by gr)
ind = [1     2     4     3     5     6     7];
hFig=figure
subplot(131)
[~,gr_order] = sort(abs(grR(3,:)-gr));
colors = jet(10);
%colors = colors(e_order,:);
j=0;
for i=gr_order(1:5)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,1], 'returnSubplotHandler',[4,1],'ylim',[0,100],'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=gr_order(6:8)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,2], 'returnSubplotHandler',[4,1],'ylim',[0,100]});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=gr_order(9:end)
    j=j+1;
    data=reshape(muscleAct(i,:,ind),1000,7);
    plot_meanSignal(100*data, 0*data,muscleName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[7,3,3], 'returnSubplotHandler',[4,1],'ylim',[0,100],'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
%set(hFig, 'Position', [600,00,200,900]);
set(hFig, 'Position', [600,00,600,900]);
%% Muscles activities between exp (mean by gr)
% ordered by golden ratio
% BLUE: abs(swing / double stance - gR) < 0.4
% GREEN : 0.4 < abs(swing / double stance - gR) < 0.8
% RED : abs(swing / double stance - gR) > 0.8
groups = {out.golden_ratio.order(1:5), out.golden_ratio.order(6:8), out.golden_ratio.order(9:end)};
hFig = subplot_shadedSignals(out.muscle.signals,out.muscleName,groups);
hs=get(hFig,'children');
set(hFig, 'Position', [600,00,400,800]);
set(hs(1),'Ylim',[-1.8,35]);
set(hs(2),'Ylim',[0,100]);
set(hs(3),'Ylim',[-1.8,95]);
set(hs(4),'Ylim',[0,100]);
set(hs(5),'Ylim',[-1.8,59]);
set(hs(6),'Ylim',[-1.8,55]);
set(hs(7),'Ylim',[-1.8,60]);
ylabel(hs(4), 'Muscle activity (%)')

%%%%%%%%%%%%%%%%%
%               %
%               %
%               %
%               %
%     PLOT      %
%               %
%               %
%  subpart 2    %
%  exp comp     %
%  with human   %
%%%%%%%%%%%%%%%%%

%% Correlation Joint
ids=1:10;
load_from_file=true;
order=out.energy.order;
hFig=figure;
subplot(211)
h2=plot_correlation([reshape(out.jointTorque.human,1,1000,3); out.jointTorque.model(order,:,:)],out.jointName, 'transpose',1,'bar',1,'compareWith',1,'dontShow',1);
title('Joints Torque','fontweight','normal','fontsize',14);
ylabel('Correlation coefficient                           ');
ylim([-0.1;1.0])
subplot(212)
h3=plot_correlation([reshape(out.jointAngle.human,1,1000,3); out.jointAngle.model(order,:,:)],out.jointName, 'transpose',1,'bar',1,'compareWith',1,'dontShow',1);
title('Joints Angle','fontweight','normal','fontsize',14);
set(hFig, 'Position', [00,200,450,300]);

%% Plot mean angle good GR
%e_order gives the order from low to high energy,
% 6 is one of the highest energetic gait
% 9 is one of the lowest energetic gait
plot_meanJointAngles(out.energy.order(1)*10,out.path);
plot_meanJointTorques(out.energy.order(1)*10,out.path);
%% Plot mean angle bad GR + bad angles ankle
plot_meanJointAngles(out.energy.order(10)*10,out.path);
plot_meanJointTorques(out.energy.order(10)*10,out.path);

%% Golden ratio 1
hFig = figure;
bar(out.golden_ratio.right(:,out.energy.order))
hold on;
plot(L,( gr )*ones(size(L)),'r','LineWidth',2);
set(gca,'xtick',1:3);
set(gca,'xticklabel',{'GR0', 'GR1', 'GR2'});
ylabel('golden ratio []');
set(hFig, 'Position', [00,200,450,180]);
%% Golden ratio 2
hFig = figure;
boxplot(out.golden_ratio.right(:,out.energy.order(3:end-3))');
hold on;
plot(L,gr*ones(size(L)),'r','LineWidth',2);
ylabel('golden ratio []');
set(gca,'xtick',1:3);
set(gca,'xticklabel',{'GR0', 'GR1', 'GR2'});
set(hFig, 'Position', [00,200,450,180]);

%% Golden ratio 3
hFig = figure;
bar(abs(out.golden_ratio.right(3,out.golden_ratio.order)-gr))
hold on;
L = get(gca,'XLim');
xlim([0,11])
plot(L,0.4*ones(size(L)),'m','LineWidth',3)
plot(L,0.8*ones(size(L)),'r','LineWidth',3)
ylabel('absolute difference with golden ratio')

%%%%%%%%%%%%%%%%%
%               %
%               %
%               %
%               %
%     PLOT      %
%               %
%               %
%  subpart 3    %
%  fdb variab.  %
%               %
%%%%%%%%%%%%%%%%%
%% feedback variability grouped by golden ratio group
group1 = fdbVar(gr_order(1:5),:)*1000;
group2 = fdbVar(gr_order(6:8),:)*1000;
group3 = 0*group1;%fdbVar(gr_order(9:end),:)*1000;
mean_g1 = mean(group1);
mean_g2 = mean(group2);
mean_g3 = mean(group3);

%% feedback variability of repeat that we systematically checked

group1 = fdbVar(e_order(1),:)*1000;
group2 = fdbVar(e_order(3),:)*1000;
group3 = fdbVar(e_order(9),:)*1000;
mean_g1 = (group1);
mean_g2 = (group2);
mean_g3 = (group3);

%% feedback flatness of repeat that we systematically checked
fdbVar=log(10*(fdbMean'./fdbAmp')+1)';

group1 = fdbVar(e_order(1),:);
group2 = fdbVar(e_order(3),:);
group3 = 0*group1;%fdbVar(e_order(9),:);

mean_g1 = (group1);
mean_g2 = (group2);
mean_g3 = (group3);



%% feedback left right variability
fdbVar=fdbLefRight;

group1 = fdbVar(e_order(1),:);
group2 = fdbVar(e_order(3),:);
group3 = fdbVar(e_order(9),:);

mean_g1 = (group1);
mean_g2 = (group2);
mean_g3 = (group3);

%% 3 groups
clear subplot
figure;
subplot(411);



barh([mean_g1(mff);mean_g2(mff);mean_g3(mff)]')
set(gca,'ytick',1:length(mff));
set(gca,'yticklabel',feedbackName(mff));
ylim([0,length(mff)+1]);
subplot(412);
barh([mean_g1(mlf);mean_g2(mlf);mean_g3(mlf)]')
set(gca,'ytick',1:length(mlf));
set(gca,'yticklabel',feedbackName(mlf));

subplot(413);
barh([mean_g1(gsif);mean_g2(gsif);mean_g3(gsif)]')
set(gca,'ytick',1:length(gsif));
set(gca,'yticklabel',feedbackName(gsif));

subplot(414);
barh([mean_g1([gcf tlf]);mean_g2([gcf tlf]);mean_g3([gcf tlf])]')
set(gca,'ytick',1:length([gcf tlf]));
set(gca,'yticklabel',feedbackName([gcf tlf]));
xlabel('Feedback Variability');
colormap(cool)
%% 2 groups
subplot(411);
barh([mean_g1(mff);mean_g2(mff)]')
set(gca,'ytick',1:length(mff));
set(gca,'yticklabel',feedbackName(mff));
ylim([0,length(mff)+1]);
subplot(412);
barh([mean_g1(mlf);mean_g2(mlf)]')
set(gca,'ytick',1:length(mlf));
set(gca,'yticklabel',feedbackName(mlf));

subplot(413);
barh([mean_g1(gsif);mean_g2(gsif)]')
set(gca,'ytick',1:length(gsif));
set(gca,'yticklabel',feedbackName(gsif));

subplot(414);
barh([mean_g1([gcf tlf]);mean_g2([gcf tlf])]')
set(gca,'ytick',1:length([gcf tlf]));
set(gca,'yticklabel',feedbackName([gcf tlf]));
xlabel('Feedback Variability');

%% Sample SNR signal
gauss = @(x,m,s) 1/(s*sqrt(2*pi))*exp(-(x-m).*(x-m)/(2*s*s));
x=linspace(0,1,1000);
val=logspace(-0.5,1.5,5)/10;
y=[];
for i=1:length(val)
    y(i,:) = gauss(x,0.5,val(i));
end
plot(repmat(x,5,1)',y','LineWidth',2)
xlim([0,1]);

snrvar=log(10*(mean(y,2)./std(y,0,2))+1);
legs = num2str(round(100*snrvar)/100);
flt=repmat(' flt',5,1);
        
legend([legs flt]);
legend boxoff
title('Sample signal with different flatness criterion')

%% Feedback SNR
clear subplot
figure;
m=mean(log(10*(fdbMean'./fdbAmp')+1),2);
s=std(log(10*(fdbMean'./fdbAmp')+1),0,2);
subplot(411);
barh(m(mff)');
hold on;
herrorbar(m(mff),1:length(mff),s(mff));
set(gca,'ytick',1:length(mff));
set(gca,'yticklabel',feedbackName(mff));

mm=(length(mff)+1)/2;
ylim([mm-3,mm+3]);
%xlim([0,10]);

subplot(412);
barh(m(mlf)')
hold on;
herrorbar(m(mlf),1:length(mlf),s(mlf));
set(gca,'ytick',1:length(mlf));
set(gca,'yticklabel',feedbackName(mlf));
%xlim([0,10]);
mm=(length(mlf)+1)/2;
ylim([mm-3,mm+3]);
subplot(413);
barh(m(gsif)')
hold on;
herrorbar(m(gsif),1:length(gsif),s(gsif));
set(gca,'ytick',1:length(gsif));
set(gca,'yticklabel',feedbackName(gsif));
%xlim([0,10]);
mm=(length(gsif)+1)/2;
ylim([mm-3,mm+3]);
subplot(414);
barh(m([gcf tlf])')
hold on;
herrorbar(m([gcf tlf]),1:length([gcf tlf]),s([gcf tlf]));
set(gca,'ytick',1:length([gcf tlf]));
set(gca,'yticklabel',feedbackName([gcf tlf]));
xlabel('Flatness criterion [flt]');
%xlim([0,10]);
mm=(length([gcf tlf])+1)/2;
ylim([mm-3,mm+3]);
colormap([0.5625 0.5625 0.5625])
%%
corr(mean(fdbVar')',CoT')
figure;
subplot(211);
barh(CoT/80);
title('Cost of transport [Nm^{-1}kg^{-1}]');
subplot(212)
barh(mean(fdbVar')*1000);
title('Mean inter-cycle variability');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedbacks correlations %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Correlations 2
ind = feedback_order;
ind = ind(1:end-1);
compareWith = 1;
h1=plot_correlation(fdbAct(gr_order,:,ind),feedbackName(ind), 'rotate',1, 'bar',0,'compareWith',compareWith);
title('Feedbacks Activity','fontweight','normal','fontsize',14);

%% Feedback activity between exp (split by energy)
ind = feedback_order;
ind = ind(1:end-1);
hFig=figure;
subplot(131)
colors = jet(10);
%colors = colors(e_order,:);
j=0;
for i=e_order(1:4)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,1], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=e_order(5:8)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,2], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=e_order(9:end)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,3], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
%set(hFig, 'Position', [600,00,200,900]);
set(hFig, 'Position', [600,00,600,900]);

%% Feedback activity between exp (split by gr)
ind = feedback_order;
ind = ind(1:end-1);
hFig=figure;
subplot(131)

colors = jet(10);
%colors = colors(e_order,:);
j=0;
for i=gr_order(1:5)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,1], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=gr_order(6:8)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,2], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
for i=gr_order(9:end)
    j=j+1;
    data=reshape(fdbAct(i,:,ind),500,13);
    plot_meanSignal(100*abs(data), 0*data,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[13,3,3], 'returnSubplotHandler',[7,1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
%set(hFig, 'Position', [600,00,200,900]);
set(hFig, 'Position', [600,00,600,900]);

%% Feedback mean activity
ind = feedback_order([1,2,3,6,7,13]);
colors = jet(10);

hFig=figure;
hold on;
data=reshape(fdbAct(e_order(1:9),:,ind),9,500,length(ind));
mdata=reshape(mean(data),500,length(ind));
sdata=reshape(std(data),500,length(ind));
plot_meanSignal(100*abs(mdata), 100*sdata,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[length(ind),1,1], 'returnSubplotHandler',[round(length(ind)),1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});

ind = feedback_order([4,5,8,9,10,11,12]);
colors = jet(10);

hFig=figure;
hold on;
data=reshape(fdbAct(e_order(1:9),:,ind),9,500,length(ind));
mdata=reshape(mean(data),500,length(ind));
sdata=reshape(std(data),500,length(ind));
plot_meanSignal(100*abs(mdata), 100*sdata,feedbackName(ind),{'LineStyle','-','Color',colors(j,:)},{'subplot',[length(ind),1,1], 'returnSubplotHandler',[round(length(ind)),1],'ylim',[0,100],'text',0,'tight',1});%,'area',{'EdgeColor','k','FaceColor','k'}});



