%% Init

%
config = conf();
if(~exist('dir','var'))
    dir = [ config.raw_filedir '/session13' ]; % directory where to look for raw files
end
if(~exist('id','var'))
    id = 1; % extraction serie ID
end
knot = 100; % number of knot for the spline interploation
what = config.raw_filename.muscles_activity;
toKeep = 1:7;
signalNum = length(toKeep);

%% Data processing

disp('Data loading...')
tic
signalRaw = extract_rawFile(dir,what,id); % extract muscles activity
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
toc
disp('Data analysis')
tic
out = signal_analysis(signalRaw,footFall,toKeep);
toc
%% Plot
%subplot(2,1,1)
%plot(reshape(out.signalSplit(1,1,:,:),out.signalSplitNumber,knot)')
%legend(strrep(signalRaw.textdata{1},'_','\_'))
%subplot(2,1,2)
%plot(reshape(out.signalStereotypedShape(1,1,:),1,knot)','Linewidth',2)
%legend(strrep(signalRaw.textdata{1},'_','\_'))


%% NNMF extraction of motor_primitives
stereotypedShapeCycle = reshape(out.signalStereotypedShape(:,1,:),7,100)';
meanCycle = reshape(out.signalMean(:,1,:),signalNum,100)';


[moto_primitives,H] = nnmf(meanCycle,3);
meanCycleRec = moto_primitives*H;
corr3=diag(corr(meanCycle,meanCycleRec));
[moto_primitives,H] = nnmf(meanCycle,4);
meanCycleRec = moto_primitives*H;
corr4=diag(corr(meanCycle,meanCycleRec))
if(~isempty(find(corr3<0.95)))
    disp('4 mp');
    [moto_primitives,H] = nnmf(meanCycle,4);
    meanCycleRec = moto_primitives*H;
else
    disp('3 mp');
end

plot(meanCycleRec,'--','LineWidth',2)
 hold on;
plot(meanCycle,'LineWidth',2)
%leg = strrep(signalRaw.textdata,'_','\_');
%legend(leg{1:7})
% ylabel('normalized muscle activities');
% xlabel('cycle %');