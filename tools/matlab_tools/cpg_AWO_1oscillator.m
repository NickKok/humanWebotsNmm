%% Get Stereotyped shape
%config
config = conf();
dir = [config.raw_filedir '/session11' ]; % directory where to look for raw files
id = 12; % extraction serie ID
knot = 50; % number of knot for the spline interploation
what = config.raw_filename.feedbacks;
toKeep = 14;
signalNum = length(toKeep);

% Data loading
signalRaw = extract_rawFile(dir,what,id); % extract muscles activity
footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
out = signal_analysis(signalRaw,footFall,toKeep,knot);

% Get mean signal
stereoShape = reshape(out.signalStereotypedShape(1,:),signalNum,knot)';
offset = mean(out.signalNormData.offset(1,:));
amplitude = mean(out.signalNormData.amplitude(1,:));
%% Build model function
m = awo_modelFunc(amplitude*stereoShape+offset);

%% Differential equation
w=2.0;
gamma = 100;
dydt = @(t,y)[w;100*(2*m.g(y(1))+3-y(2))+2*m.dg(y(1))*w];
[t,y] = ode45(dydt, [0 20], [w;0]);