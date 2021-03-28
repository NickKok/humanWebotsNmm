config = conf();
dir = [ config.raw_filedir '/sessionPerturbation' ]; % directory where to look for raw files


%% Extract one perturbation
id =3;
perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
time = perturbation.time;
torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity

footFall = extract_rawFile(dir,config.raw_filename.footfall,id);



%% Generate perturbation structure
id=4;
perturbation = struct;

raw_perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
raw_torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
raw_angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity
raw_emg = extract_rawFile(dir,config.raw_filename.muscles_activity,id); % extract muscles activity
raw_footFall = extract_rawFile(dir,config.raw_filename.footfall,id);

perturbation.time = raw_perturbation.time(1:8*10^4);
perturbation.perturbation = struct;
perturbation.perturbation.data = raw_perturbation.data;
perturbation.perturbation.labels = raw_perturbation.colheaders;

perturbation.torque = struct;
perturbation.torque.data = raw_torque.data(1:8*10^4,1:3);
perturbation.torque.labels = raw_perturbation.colheaders;

perturbation.angle = struct;
perturbation.angle.data = raw_angles.data(1:8*10^4,1:3);
perturbation.angle.labels = raw_perturbation.colheaders;

perturbation.emg = struct;
perturbation.emg.data = raw_emg.data(1:8*10^4,1:7);
perturbation.emg.labels = raw_emg.colheaders(1:7);



perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(1:8*10^4,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);


data.noPert = perturbation;

id=2;
perturbation = struct;

raw_perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
raw_torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
raw_angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity
raw_emg = extract_rawFile(dir,config.raw_filename.muscles_activity,id); % extract muscles activity
raw_footFall = extract_rawFile(dir,config.raw_filename.footfall,id);

perturbation.time = raw_perturbation.time(1:8*10^4);
perturbation.perturbation = struct;
perturbation.perturbation.data = raw_perturbation.data;
perturbation.perturbation.labels = raw_perturbation.colheaders;

perturbation.torque = struct;
perturbation.torque.data = raw_torque.data(1:8*10^4,1:3);
perturbation.torque.labels = raw_perturbation.colheaders;

perturbation.angle = struct;
perturbation.angle.data = raw_angles.data(1:8*10^4,1:3);
perturbation.angle.labels = raw_perturbation.colheaders;

perturbation.emg = struct;
perturbation.emg.data = raw_emg.data(1:8*10^4,1:7);
perturbation.emg.labels = raw_emg.colheaders(1:7);



perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(1:8*10^4,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);



data.shortPert = perturbation;

id=3;
perturbation = struct;

raw_perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
raw_torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
raw_angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity
raw_emg = extract_rawFile(dir,config.raw_filename.muscles_activity,id); % extract muscles activity
raw_footFall = extract_rawFile(dir,config.raw_filename.footfall,id);

perturbation.time = raw_perturbation.time(1:8*10^4);
perturbation.perturbation = struct;
perturbation.perturbation.data = raw_perturbation.data;
perturbation.perturbation.labels = raw_perturbation.colheaders;

perturbation.torque = struct;
perturbation.torque.data = raw_torque.data(1:8*10^4,1:3);
perturbation.torque.labels = raw_perturbation.colheaders;

perturbation.angle = struct;
perturbation.angle.data = raw_angles.data(1:8*10^4,1:3);
perturbation.angle.labels = raw_perturbation.colheaders;

perturbation.emg = struct;
perturbation.emg.data = raw_emg.data(1:8*10^4,1:7);
perturbation.emg.labels = raw_emg.colheaders(1:7);



perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(1:8*10^4,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);




perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(:,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);


data.mediumPert = perturbation;

id=1;
perturbation = struct;

raw_perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
raw_torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
raw_angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity
raw_emg = extract_rawFile(dir,config.raw_filename.muscles_activity,id); % extract muscles activity
raw_footFall = extract_rawFile(dir,config.raw_filename.footfall,id);

perturbation.time = raw_perturbation.time(1:8*10^4);
perturbation.perturbation = struct;
perturbation.perturbation.data = raw_perturbation.data(1:8*10^4);
perturbation.perturbation.labels = raw_perturbation.colheaders;

perturbation.torque = struct;
perturbation.torque.data = raw_torque.data(1:8*10^4,1:3);
perturbation.torque.labels = raw_perturbation.colheaders;

perturbation.angle = struct;
perturbation.angle.data = raw_angles.data(1:8*10^4,1:3);
perturbation.angle.labels = raw_perturbation.colheaders;

perturbation.emg = struct;
perturbation.emg.data = raw_emg.data(1:8*10^4,1:7);
perturbation.emg.labels = raw_emg.colheaders(1:7);



perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(1:8*10^4,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);


data.longPert = perturbation;

%% 
id=19;
config = conf();

dir = [ config.raw_filedir '/sessionPerturbation' ]; % directory where to look for raw files


pert = getPerturbation(id,dir);


%% 
perturbation_data = struct;
dir = [ config.raw_filedir '/sessionPerturbation' ]; % directory where to look for raw files



for i = 25:30
    perturbation_data.(['exp' num2str(i)]) = getPerturbation(i,dir);
end
