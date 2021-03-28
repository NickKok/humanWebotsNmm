%% Init
config = conf();
dir = [ config.raw_filedir '/sessionArticleFrontier' ]; % directory where to look for raw files
id = 72; % extraction serie ID
knot = 100; % number of knot for the spline interploation
what1 = config.raw_filename.muscles_activity;

what2 = config.raw_filename.muscles_v_CE;
what3 = config.raw_filename.muscles_length;
what4 = config.raw_filename.muscles_force;
what5 = config.raw_filename.muscles_f_v;
what6 = config.raw_filename.muscles_noise;
toKeep = 1:7;
signalNum = length(toKeep);

%% Data loading
disp('Data loading...')
tic
signalRaw_A = extract_rawFile(dir,what1,id); % extract muscles activity
signalRaw_v = extract_rawFile(dir,what2,id); % extract muscles activity
signalRaw_l = extract_rawFile(dir,what3,id); % extract muscles activity
signalRaw_F = extract_rawFile(dir,what4,id); % extract muscles activity
signalRaw_f_v = extract_rawFile(dir,what5,id); % extract muscles activity
signalRaw_noise = extract_rawFile(dir,what6,id); % extract muscles activity
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
toc

%% Data analysis
disp('Data analysis')
tic
out = signal_analysis(signalRaw,footFall,toKeep);
toc

%% Plot
meanCycle = reshape(out.signalMean(:,1,:),signalNum,knot)';
meanStance = reshape(out.signalMean(:,2,:),signalNum,knot)';
meanSwing = reshape(out.signalMean(:,3,:),signalNum,knot)';


% mean cycle with negative values
Neg = find(any(meanCycle<0.0,1));
Pos = find(1-any(meanCycle<0.0,1));