function perturbation = getPerturbation(id,dir)
config = conf();

max_size = 150*10^4;
raw_perturbation = extract_rawFile(dir,config.raw_filename.perturbation,id); % extract muscles activity
raw_torque = extract_rawFile(dir,config.raw_filename.joints_force,id); % extract muscles activity
raw_angles = extract_rawFile(dir,config.raw_filename.joints_angle,id); % extract muscles activity
raw_emg = extract_rawFile(dir,config.raw_filename.muscles_activity,id); % extract muscles activity
raw_footFall = extract_rawFile(dir,config.raw_filename.footfall,id);


elemSize = 1:min([max_size length(raw_perturbation.time)]);
perturbation = struct;
perturbation.time = raw_perturbation.time(elemSize);
perturbation.perturbation = struct;
perturbation.perturbation.data = raw_perturbation.data(elemSize,:);
perturbation.perturbation.labels = raw_perturbation.colheaders;

perturbation.torque = struct;
perturbation.torque.data = raw_torque.data(elemSize,1:3);
perturbation.torque.labels = raw_perturbation.colheaders;

perturbation.angle = struct;
perturbation.angle.data = raw_angles.data(elemSize,1:3);
perturbation.angle.labels = raw_perturbation.colheaders;

perturbation.emg = struct;
perturbation.emg.data = raw_emg.data(elemSize,1:7);
perturbation.emg.labels = raw_emg.colheaders(1:7);



perturbation.footfall = struct;
perturbation.footfall.data = raw_footFall.data(elemSize,1);
perturbation.footfall.labels = raw_footFall.colheaders(1);

end