%%%%%%%%%%%%%%%%%%%%%%%%
%%% Motor primitives %%%
%%%%%%%%%%%%%%%%%%%%%%%%
exp_1_0=load_data('1.0',1:8);
exp_1_3=load_data('1.3',1:10);
exp_1_6=load_data('1.6',1:8);
exp_wavy=load_data('wavy2',1:10);

%%
out=exp_1_0;
keep=out.energy.order(1:8);
ids=1:8;
%%
out=exp_1_3;
keep=out.energy.order(1:8);
ids=1:10;
%%
out=exp_1_6;
keep=out.energy.order(1:8);
ids=1:8;
%%
out=exp_wavy;
keep=out.energy.order(1:8);
ids=1:10;


%% MOTOR PRIMITIVES

%MP_mean = [mean(MP1,2) mean(MP2,2) mean(MP3,2) mean(MP4,2) mean(MP5,2)];
MP_mean = reshape(mean(out.musclePrimitives.MP(keep,:,:)),1000,out.musclePrimitives.MP_Number);
MP_std = reshape(std(out.musclePrimitives.MP(keep,:,:),0,1),1000,out.musclePrimitives.MP_Number);
colors = hsv(out.musclePrimitives.MP_Number);
for i=1:out.musclePrimitives.MP_Number
plot_meanSignal(100*MP_mean(:,i),100*MP_std(:,i),out.musclePrimitives.MP_Name,{'LineStyle','-','Color',colors(i,:)},{'ylim',[0,100],'text',0,'tight',0,'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
ylim([0,100]);
xlabel('stride %');
ylabel('motor primitives activity [%]');

%% FULL MOTOR PRIMITIVES 
mp = 'MP4';
shift=1;
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.08]);
subplot(4,2,1+shift);
out = exp_1_0;
keep = out.energy.order(1:8);

MPS = out.musclePrimitives.(mp);
MP = MPS.MP;
MP_Number = MPS.MP_Number;
MP_mean = reshape(mean(MP(keep,:,:)),1000,MP_Number);
MP_std = reshape(std(MP(keep,:,:),0,1),1000,MP_Number);
colors = hsv(MPS.MP_Number);
for i=1:MPS.MP_Number
plot_meanSignal(100*MP_mean(:,i),100*MP_std(:,i),MPS.MP_Name,{'LineStyle','-','Color',colors(i,:)},{'ylim',[0,100],'text',0,'tight',0,'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
title(['1.0 m/s ' mp]);

subplot(4,2,3+shift);
out = exp_1_3;
keep = out.energy.order(1:8);
MPS = out.musclePrimitives.(mp);
MP = MPS.MP;
MP_Number = MPS.MP_Number;
MP_mean = reshape(mean(MP(keep,:,:)),1000,MP_Number);
MP_std = reshape(std(MP(keep,:,:),0,1),1000,MP_Number);
colors = hsv(MPS.MP_Number);
for i=1:MPS.MP_Number
plot_meanSignal(100*MP_mean(:,i),100*MP_std(:,i),MPS.MP_Name,{'LineStyle','-','Color',colors(i,:)},{'ylim',[0,100],'text',0,'tight',0,'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
title(['1.3 m/s ' mp]);

subplot(4,2,5+shift);
out = exp_1_6;
keep = out.energy.order(1:8);
MPS = out.musclePrimitives.(mp);
MP = MPS.MP;
MP_Number = MPS.MP_Number;
MP_mean = reshape(mean(MP(keep,:,:)),1000,MP_Number);
MP_std = reshape(std(MP(keep,:,:),0,1),1000,MP_Number);
colors = hsv(MPS.MP_Number);
for i=1:MPS.MP_Number
plot_meanSignal(100*MP_mean(:,i),100*MP_std(:,i),MPS.MP_Name,{'LineStyle','-','Color',colors(i,:)},{'ylim',[0,100],'text',0,'tight',0,'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
title(['1.6 m/s ' mp]);

subplot(4,2,7+shift);
out = exp_wavy;
keep = out.energy.order(1:8);
MPS = out.musclePrimitives.(mp);
MP = MPS.MP;
MP_Number = MPS.MP_Number;
MP_mean = reshape(mean(MP(keep,:,:)),1000,MP_Number);
MP_std = reshape(std(MP(keep,:,:),0,1),1000,MP_Number);
colors = hsv(MPS.MP_Number);
for i=1:MPS.MP_Number
plot_meanSignal(100*MP_mean(:,i),100*MP_std(:,i),MPS.MP_Name,{'LineStyle','-','Color',colors(i,:)},{'ylim',[0,100],'text',0,'tight',0,'text',0});%,'area',{'EdgeColor','k','FaceColor','k'}});
end
title(['1.3 m/s robust ' mp]);


ylim([0,100]);


%% RECONSTRUCTION CORRELATION

clear cc;
mp = 'MP4';
MPS = out.musclePrimitives.(mp);
MN = out.muscle.signals;


MP = MPS.MP;
MP_Number = MPS.MP_Number;
W = MPS.W;


MN_Number = size(MN,3);

MN_rec = zeros(size(MN));

for id=ids
    m = reshape(MN(id,:,:),1000,MN_Number);
    mrec = reshape(MP(id,:,:),1000,MP_Number)*reshape(W(id,:,:),MP_Number,MN_Number);
    MN_rec(id,:,:) = mrec;
    cc(id,:) = diag(corr(m,mrec));
end
imagesc(cc);caxis([0,1]);

%% Bilateral extraction
clear cc m mrec;
out=exp_wavy;
ids = 1:8;
MN = out.muscle.signals;
for j=1:7
for i=ids
    MN(i,:,j+7) = [MN(i,500:end,j) MN(i,1:499,j)];
end
end

MPS = get_musclePrimitives(MN,4);
MP = MPS.MP;
MP_Number = MPS.MP_Number;
W = MPS.W;


MN_Number = size(MN,3);

MN_rec = zeros(size(MN));

for id=ids
    m = reshape(MN(id,:,:),1000,MN_Number);
    mrec = reshape(MP(id,:,:),1000,MP_Number)*reshape(W(id,:,:),MP_Number,MN_Number);
    MN_rec(id,:,:) = mrec;
    cc(id,:) = diag(corr(m,mrec));
end
imagesc(cc);caxis([0,1]);

%% Minimum reconstruction correlation
subplot(1,4,1)
keep = exp_1_0.energy.order(1:8);
min3=min(exp_1_0.musclePrimitives.MP3.reconstructionCorrelation,[],2);
min4=min(exp_1_0.musclePrimitives.MP4.reconstructionCorrelation,[],2);
boxplot([min3 min4]);
set(gca,'XTick',[1,2])
set(gca,'xticklabel',{'MP3','MP4'});
title('1.0 m/s');
ylabel('minimum correlation reconstruction');
subplot(1,4,2)
keep = exp_1_3.energy.order(1:8);
min3=min(exp_1_3.musclePrimitives.MP3.reconstructionCorrelation,[],2);
min4=min(exp_1_3.musclePrimitives.MP4.reconstructionCorrelation,[],2);
boxplot([min3 min4]);
set(gca,'XTick',[1,2])
set(gca,'xticklabel',{'MP3','MP4'});
title('1.3 m/s');
subplot(1,4,3)
keep = exp_1_6.energy.order(1:8);
min3=min(exp_1_6.musclePrimitives.MP3.reconstructionCorrelation,[],2);
min4=min(exp_1_6.musclePrimitives.MP4.reconstructionCorrelation,[],2);
boxplot([min3 min4]);
set(gca,'XTick',[1,2])
set(gca,'xticklabel',{'MP3','MP4'});
title('1.6 m/s');
subplot(1,4,4)
keep = exp_1_6.energy.order(1:8);
min3=min(exp_1_6.musclePrimitives.MP3.reconstructionCorrelation,[],2);
min4=min(exp_1_6.musclePrimitives.MP4.reconstructionCorrelation,[],2);
boxplot([min3 min4]);
set(gca,'XTick',[1,2])
set(gca,'xticklabel',{'MP3','MP4'});
title('1.3 m/s robust');
%% FULL RECONSTRUCTION CORRELATION
MP_Number = 4;
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.08],[0.1 0.05],[0.02 0.01]);
subplot(2,2,1);
out = exp_1_0;
keep = out.energy.order(1:8);
plot_MPsReconstCorr(out,1:8,keep,MP_Number)
colorbar off
title('1.0 m/s');

subplot(2,2,2);
out = exp_1_3;
keep = out.energy.order(1:8);
plot_MPsReconstCorr(out,1:10,keep,MP_Number)
colorbar off
title('1.3 m/s');

subplot(2,2,3);
out = exp_1_6;
keep = out.energy.order(1:8);
plot_MPsReconstCorr(out,1:8,keep,MP_Number)
xlabel('muscles')
colorbar off
c=colorbar('southOutside');
xlabel(c,'reconstruction correlation with 4MP')
title('1.6 m/s');

subplot(2,2,4);
out = exp_wavy;
keep = out.energy.order(1:10);
plot_MPsReconstCorr(out,1:10,keep,MP_Number)
title('1.3 m/s robust');

xlabel('muscles')
ylabel('repeat (order by CoT)')
colorbar off
c=colorbar('southOutside');
xlabel(c,'reconstruction correlation with 4MP')

%% Max position

mp = 'MP4';

out = exp_1_0;
keep = out.energy.order(1:8);
[a,b]=max(out.musclePrimitives.(mp).MP(keep,:,:),[],2);
b1 = sort(squeeze(b)/10,2);

out = exp_1_3;
keep = out.energy.order(1:8);
[a,b]=max(out.musclePrimitives.(mp).MP(keep,:,:),[],2);
b2 = sort(squeeze(b)/10,2);

out = exp_1_6;
keep = out.energy.order(1:8);
[a,b]=max(out.musclePrimitives.(mp).MP(keep,:,:),[],2);
b3 = sort(squeeze(b)/10,2);

out = exp_wavy;
keep = out.energy.order(1:8);
[a,b]=max(out.musclePrimitives.(mp).MP(keep,:,:),[],2);
b4 = sort(squeeze(b)/10,2);


boxplot([b1 b2 b3 b4],{repmat({'MP1','MP2','MP3','MP4'},1,4),[1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4]},'labelverbosity','minor','colors',repmat(cool(4)',1,15)')
ylabel('stride %')
%xlabel('muscles')
%label('repeat (order by CoT)')
%colorbar off
%c=colorbar('southOutside');
%xlabel(c,'reconstruction correlation with 4MP')