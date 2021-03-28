%% Init

%
config = conf();
dir = [config.raw_filedir '/session10' ]; % directory where to look for raw files
id = 1; % extraction serie ID
tic
disp('Data loading...')
what = config.raw_filename.joints_force;
joints = extract_rawFile(dir,what,id); % extract muscles activity

what = config.raw_filename.muscles_activity;
muscles = extract_rawFile(dir,what,id); % extract muscles activity

%what = config.raw_filename.sensors_activity;
%sen = extract_rawFile(dir,what,id); % extract muscles activity

footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
toc

%% Data analysis
knot = 1000;
out = signal_analysis(joints,footFall,1:3,knot);
stdCycle = reshape(out.signalStd(:,1,:),3,knot)';
meanCycle = reshape(out.signalMean(:,1,:),3,knot)';
%% Plot
%http://jeb.biologists.org/content/213/24/4257/F2.large.jpg
figure

subplot(311)
plot(joints.data(:,1:3)/80)
hold on; plot(1:length(footFall.data),footFall.data(:,1),'LineWidth',2.0,'Color','black')
legend(...
    {strrep(joints.textdata{1},'_','\_')...
    strrep(joints.textdata{2},'_','\_')...
    strrep(joints.textdata{3},'_','\_')...
    'footfall'}...
    )
xlim([11000 13000])

subplot(312)
plot(muscles.data(:,[1 2 4]))
hold on; plot(1:length(footFall.data),0.5*footFall.data(:,1),'LineWidth',2.0,'Color','black')
legend(...
    {strrep(muscles.textdata{1},'_','\_')...
    strrep(muscles.textdata{2},'_','\_')...
    strrep(muscles.textdata{4},'_','\_')...
    'footfall'}...
    )
xlim([11000 13000])

subplot(313)
plot(sen.data(:,[33 34 35]))
hold on; plot(1:length(footFall.data),0.5*footFall.data(:,1),'LineWidth',2.0,'Color','black')
legend(...
    {strrep(sen.textdata{33},'_','\_')...
    strrep(sen.textdata{34},'_','\_')...
    strrep(sen.textdata{35},'_','\_')...
    'footfall'}...
    )
xlim([11000 13000])