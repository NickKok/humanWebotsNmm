%% Init
config = conf();
dir = config.raw_filedir; % directory where to look for raw files
id = 6; % extraction serie ID
knot = 100; % number of knot for the spline interploation
what = config.raw_filename.sensors_activity;
toKeep = 30:35;
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
meanCycle = reshape(out.signalMean(:,1,:),signalNum,knot)';
meanStance = reshape(out.signalMean(:,2,:),signalNum,knot)';
meanSwing = reshape(out.signalMean(:,3,:),signalNum,knot)';

