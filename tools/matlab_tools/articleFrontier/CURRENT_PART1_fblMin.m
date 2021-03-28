%% DATA LOADING
gaitData_fblMin=load_data('1.3',1,'prefix', 'fblmin','factor' , 12);
gaitData=load_data('1.3',1:10);

%% PLOT1 : Joint angles
plot(squeeze(180/pi*gaitData_fblMin.jointAngle.model),'LineWidth',2);
hold on;
plot(squeeze(180/pi*gaitData.jointAngle.model(1,:,:)),'--','LineWidth',2);
title('Joint angles [deg]')
%% PLOT2 :: Joint torques
plot(squeeze(gaitData_fblMin.jointTorque.model));
hold on;
plot(squeeze(gaitData.jointTorque.model(1,:,:)),'--');
title('Joint torques [Nm]')
%% PLOT1 : Muscles
for i=1:7
    subplot(7,1,i)
    hold on
    plot((squeeze(gaitData.muscle.signals(1,:,i))),'r--','LineWidth',2)
    plot((squeeze(gaitData_fblMin.muscle.signals(1,:,i))),'b','LineWidth',2)
    title(gaitData.muscleName{i})
end

%% Footfall
dir = [ config.raw_filedir '/sessionArticleFrontier' ]; % directory where to look for raw files
id = 12; % extraction serie ID
footFall_fblMin = extract_rawFile(dir,config.raw_filename.footfall,id);
id = 10; % extraction serie ID
footFall= extract_rawFile(dir,config.raw_filename.footfall,id);