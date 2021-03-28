%% Init
config = conf();
dir = [ config.raw_filedir '/sessionArticleFrontier_wavy2' ]; % directory where to look for raw files
id = 33; % extraction serie ID
knot = 1000; % number of knot for the spline interploation
what1 = config.raw_filename.feedbacks;
what2 = config.raw_filename.cpgs;


%% Data loading
disp('Data loading...')
tic
signalRaw_fdb = extract_rawFile(dir,what1,id); % extract muscles activity
signalRaw_cpg = extract_rawFile(dir,what2,id); % extract muscles activity
time = signalRaw_fdb.time;
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
toKeep_left = signalRaw_fdb.left;
signalNum = length(toKeep_left);
toKeep_right = signalRaw_fdb.right;
toc

%% Data processing

disp('Data processing...')
tic
skip=10;
out_cpg = signal_analysis(signalRaw_cpg,footFall,toKeep_left,knot,1,skip);
out_cpg_right = signal_analysis(signalRaw_cpg,footFall,toKeep_right,knot,2,skip);
out_fdb = signal_analysis(signalRaw_fdb,footFall,toKeep_left,knot,1,skip);
out_fdb_right = signal_analysis(signalRaw_fdb,footFall,toKeep_right,knot,2,skip);
toc

cycleNum = out_cpg.signalSplitNumber;
getSplitSig = @(x,i,j) reshape(x.signalSplit(j,i,1:end,:),size(x.signalSplit,3),1000)'; 
getSplitCycle = @(x,j) getSplitSig(x,1,j);
getSplitStance = @(x,j) getSplitSig(x,2,j);
getSplitFinishingStance = @(x,j) getSplitSig(x,4,j);
getSplitSwing = @(x,j) getSplitSig(x,3,j);

getMeanSig = @(x,i,j) reshape(x.signalMean(j,i,:),length(j),knot)'; 
getMeanCycle = @(x,i) getMeanSig(x,1,i);
getMeanStance = @(x,i) getMeanSig(x,2,i);
getMeanFinishingStance = @(x,i) getMeanSig(x,4,i);
getMeanSwing = @(x,i) getMeanSig(x,3,i);

getMeanSigs = @(x,i) reshape(x.signalMean(:,i,:),size(x.signalMean,1),knot)'; 
getMeanCycles = @(x) getMeanSigs(x,1);
getMeanStances = @(x) getMeanSigs(x,2);
getMeanSwings = @(x) getMeanSigs(x,3);

getStdSigs = @(x,i) reshape(x.signalStd(:,i,:),size(x.signalStd,1),knot)'; 
getStdCycles = @(x) getStdSigs(x,1);
getStdStances = @(x) getStdSigs(x,2);
getStdSwings = @(x) getStdSigs(x,3);

getVarSigs = @(x,i) reshape(x.signalVar(:,i,:),size(x.signalVar,1),knot)'; 
getVarCycles = @(x) getVarSigs(x,1);
getVarStances = @(x) getVarSigs(x,2);
getVarSwings = @(x) getVarSigs(x,3);


stdCycle_cpg = getStdCycles(out_cpg);
varCycle_cpg = getVarCycles(out_cpg);
meanCycle_cpg = getMeanCycles(out_cpg);
meanCycle_cpg_right = getMeanCycles(out_cpg_right);

stdCycle_fdb = getStdCycles(out_fdb);
varCycle_fdb = getVarCycles(out_fdb);
meanCycle_fdb = getMeanCycles(out_fdb);
meanCycle_fdb_right = getMeanCycles(out_fdb_right);
stance_percentage = extract_stancePercentage(footFall);


%% LEFT RIGHT ASSYMETRY
figure
plot(meanCycle_fdb,'b--')
hold on;
plot(meanCycle_fdb_right,'b')
%% FEEDBACK REPRODUCTION CORRELATION
leg = strrep({signalRaw_fdb.textdata{toKeep_left}},'_','\_');

findIn = @(in,what) find(cellfun(@isempty,strfind(in, what))==0);

stanceFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_stance');
swingFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_swing');
finishingStanceFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_finishingstance');
cycleFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_cycle');
angleoffsetFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_angleoffset');

%mean correlation
cc_mean = diag(corr(signalRaw_fdb.data(:,signalRaw_fdb.right),signalRaw_cpg.data(:,signalRaw_fdb.right)));
%minimum correlation
cycleNum = out_cpg.signalSplitNumber;
clear s s_std*
for i=1:signalNum
    if(sum(stanceFdb==i))
        m=repmat(getMeanStance(out_cpg,i),1,cycleNum);
        s_left=getSplitStance(out_fdb,i);
        s_right=getSplitStance(out_fdb_right,i);
    elseif(sum(swingFdb==i) || sum(angleoffsetFdb==i))
        m=repmat(getMeanSwing(out_cpg,i),1,cycleNum);
        s_left=getSplitSwing(out_fdb,i);
        s_right=getSplitSwing(out_fdb_right,i);
    elseif(sum(cycleFdb==i))
        m=repmat(getMeanCycle(out_cpg,i),1,cycleNum);
        s_left=getSplitCycle(out_fdb,i);
        s_right=getSplitCycle(out_fdb_right,i);
    elseif(sum(finishingStanceFdb==i))
        m=repmat(getMeanFinishingStance(out_cpg,i),1,cycleNum);
        s_left=getSplitFinishingStance(out_fdb,i);
        s_right=getSplitFinishingStance(out_fdb_right,i);
    else
        disp(['error with feedback ' num2str(i)]);
    end
    s = zeros(size(s_left,1),size(s_right,2)+size(s_left,2));
    try
        s(:,2:2:end) = s_left;
        s(:,1:2:end) = s_right;
    catch 
        s(:,1:2:end) = s_left;
        s(:,2:2:end) = s_right;
    end
    
    mm(i) =mean(abs(m(:,1)));
    s_std(:,i) = std(s,0,2);
    len=min([size(s_left,2) size(s_right,2)]);
    s_std_left(:,i) = std(s_left(:,len));
    s_std_right(:,i) = std(s_right(:,len));
%     cc_min(:,i)=diag(corr(m,s_left));
%     cc_min2(:,i)=diag(corr(m,s_right));
%     err(:,i) = mean((zscore(s_left)-zscore(m)).^2);
%     err2(:,i) = mean((zscore(s_left)-zscore(m)).^2);
%     derr(:,i) = mean((zscore(diff(s_left))-zscore(diff(m))).^2);
%     derr2(:,i) = mean((zscore(diff(s_left))-zscore(diff(m))).^2);
%     errm(:,i) = (max(abs(s_left))./mean(abs(m))-max(abs(m))./mean(abs(m))).^2;
%     errm2(:,i) = (max(abs(s_left))./mean(abs(m))-max(abs(m))./mean(abs(m))).^2;
%     derrm(:,i) = (max(abs(diff(s_left)))./mean(abs(diff(m)))-max(abs(diff(m)))./mean(abs(diff(m)))).^2;
%     derrm2(:,i) = (max(abs(diff(s_left)))./mean(abs(diff(m)))-max(abs(diff(m)))./mean(abs(diff(m)))).^2;

end
s_std_left_right_corr=diag(corr(s_std_left,s_std_right));
[value,I]=sort(mean(s_std([1:150 end-150:end],:)));
[value2,I2]=sort(sum(abs(meanCycle_fdb)));
[value3,I3]=sort(max(abs(meanCycle_fdb)));
[value4,I4]=sort(mm);
%% PLOT VARIABILITY
% [~,Icc]=sort(min([min(abs(cc_min));min(abs(cc_min2))]));
% [~,Ierr]=sort(max([max(err);max(err2)]));
% [~,Iderr]=sort(max([max(derr);max(derr2)]));
% [~,Ierrm]=sort(max([max(errm);max(errm2)]));
% [~,Iderrm]=sort(max([max(derrm);max(derrm2)]));

%vas__mff_stance --> ierrm
%ham_gif_stance --> ierr
%hf_gif_stance --> ierr
%ta_mlf_cycle --> ?
%sol_mff_stance --> ?

%figure
%bar(value);
%hold on;
%plot(0:16,ones(1,17)*0.02,'r', 'LineWidth',3);
%legend('feedback variability','threshold','Location','NorthWest');
threshold=1.5;
hFig = figure;
hold on;
colors = jet(14);
plot(ones(1,16)*threshold,0:15,'r', 'LineWidth',3);
for i = 1:14
    barh(i, value(i)*1000, 'facecolor', colors(i,:));
end
%plot(ones(1,16)*threshold,0:15,'r', 'LineWidth',3);
xtick = signalRaw_cpg.legend.one_side(I);
set(gca,'ytick',1:14)
set(gca,'yticklabel',strrep(xtick,'\_','_'));
xlabel('variability');
%legend('threshold','Location','SouthEast');
%legend boxoff
set(hFig, 'Position', [500,200,400,500]);

%% PLOT
side=1
toKeep = toKeep_left;
%toKeep = toKeep(gaitData.feedback.order);
hFig=figure;
set(hFig, 'Position', [500,200,800,500]);
lim=max(find((value < 0.002),1,'last'));
good=gaitData.feedback.order(1:end-1)
%subplot(211);
hold on;
plot(time,100*(1-footFall.data(:,side))*0.3,'k','LineWidth',5)
plot(time(2:end),100*abs(diff(footFall.data(:,side)))*0.4,'w','LineWidth',5)
for i = 1:length(good)
    plot(time,100*abs(signalRaw_fdb.data(:,toKeep(good(i)))),'Color',[0.2,0.2,0.2],'LineWidth',3);
end
for i = 1:length(good)
    plot(time,100*abs(signalRaw_cpg.data(:,toKeep(good(i)))),'--','LineWidth',3,'Color',[1.0, 1.0, 1.0]);
end
xlabel('time [s]')
ylabel('INsen activity [%]')
xtick = gaitData.feedbackName(good)';
legend(['Swing',' ',xtick],'Location','NorthEast','FontSize',10);


ev = find(extract_gaitEvent(footFall.data(:,side),config.gait_event.liftOff_touchDown)==1);
xlim([time(ev(14)) time(ev(15))]);


cc_mean_right = diag(corr(signalRaw_fdb.data(:,signalRaw_fdb.right),signalRaw_cpg.data(:,signalRaw_fdb.right)));
cc_mean_left = diag(corr(signalRaw_fdb.data(:,signalRaw_fdb.left),signalRaw_cpg.data(:,signalRaw_fdb.left)));
%% PLOT SUBPLOT
clear subplot
side=1
toKeep = toKeep_left;
hFig=figure;
set(hFig, 'Position', [500,200,800,500]);
lim=max(find((value < 0.002),1,'last'));
good=[1,2,3,8];
bad=[5,6,7,9,10,11,12,13];
subplot(211);
hold on;
plot(time,(1-footFall.data(:,side))*0.3,'k','LineWidth',5)
plot(time(2:end),abs(diff(footFall.data(:,side)))*0.4,'w','LineWidth',5)

for i = 1:length(good)
    plot(time,(signalRaw_fdb.data(:,toKeep(good(i)))),'Color',colors(i,:));
end
for i = 1:length(good)
    plot(time,(signalRaw_cpg.data(:,toKeep(good(i)))),'--','LineWidth',2,'Color',colors(i,:));
end
xlabel('time [s]')
ylabel('INsen activity [%]')
ev = find(extract_gaitEvent(footFall.data(:,2),config.gait_event.liftOff_touchDown)==1);
xlim([time(ev(10)) time(ev(12))]);
xtick = signalRaw_cpg.legend.one_side(good);
legend(['Swing',' ',xtick],'Location','NorthEast','FontSize',10);

subplot(212);
hold on;
plot(time,(1-footFall.data(:,side))*0.3,'k','LineWidth',5)
plot(time(2:end),abs(diff(footFall.data(:,side)))*0.4,'w','LineWidth',5)
for i = 1:length(bad)
    plot(time,(signalRaw_fdb.data(:,toKeep(bad(i)))),'Color',colors(i+length(good),:));
end
for i = 1:length(bad)
    plot(time,(signalRaw_cpg.data(:,toKeep(bad(i)))),'--','LineWidth',2,'Color',colors(i+length(good),:));
end
xlabel('time [s]')
ylabel('normalized INsen activity')

ev = find(extract_gaitEvent(footFall.data(:,2),config.gait_event.liftOff_touchDown)==1);
xlim([time(ev(10)) time(ev(12))]);
xtick = signalRaw_cpg.legend.one_side(bad);
legend(['Swing',' ',xtick],'Location','SouthEast','FontSize',10);


cc_mean_right = diag(corr(signalRaw_fdb.data(:,signalRaw_fdb.right),signalRaw_cpg.data(:,signalRaw_fdb.right)));
cc_mean_left = diag(corr(signalRaw_fdb.data(:,signalRaw_fdb.left),signalRaw_cpg.data(:,signalRaw_fdb.left)));