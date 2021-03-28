%% Load data
exp_wavy=load_data('wavy2',1:10);
exp_wavy_fblmin=load_data('wavy2',1,'factor',39,'prefix','_fblmin');

%% PLOT
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01]);
% Ankle
subplot(10,2,1)
plot(exp_wavy.jointAngle.model(3,:,3),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointAngle.model(1,:,3),'LineWidth',2)
axis off
axis tight

%legend('FBL','3FBLmin');

subplot(10,2,2)
plot(exp_wavy.jointTorque.model(3,:,3),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointTorque.model(1,:,3),'LineWidth',2)
axis off
axis tight
%title('Ankle torque')

subplot(10,1,2)
plot(exp_wavy.muscle.signals(3,:,7),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,7),'LineWidth',2)
axis off
axis tight
%title('TA')

subplot(10,1,3)
plot(exp_wavy.muscle.signals(3,:,6),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,6),'LineWidth',2)
axis off
axis tight
%title('SOL')

subplot(10,1,4)
plot(exp_wavy.muscle.signals(3,:,5),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,5),'LineWidth',2)
axis off
axis tight
%title('GAS')


% KNEE
subplot(10,2,9)
plot(exp_wavy.jointAngle.model(3,:,2),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointAngle.model(1,:,2),'LineWidth',2)
axis off
axis tight
%title('Knee angle')


subplot(10,2,10)
plot(exp_wavy.jointTorque.model(3,:,2),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointTorque.model(1,:,2),'LineWidth',2)
axis off
axis tight
%title('Knee torque')


subplot(10,1,6)
plot(exp_wavy.muscle.signals(3,:,3),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,3),'LineWidth',2)
axis off
axis tight
%title('VAS')

% KNEE
subplot(10,2,13)
plot(exp_wavy.jointAngle.model(3,:,1),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointAngle.model(1,:,1),'LineWidth',2)
axis off
axis tight
%title('Ankle angle')


subplot(10,2,14)
plot(exp_wavy.jointTorque.model(3,:,1),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.jointTorque.model(1,:,1),'LineWidth',2)
axis off
axis tight
%title('Ankle angle')

subplot(10,1,8)
plot(exp_wavy.muscle.signals(3,:,4),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,4),'LineWidth',2)
axis off
axis tight
%title('HAM')

subplot(10,1,9)
plot(exp_wavy.muscle.signals(3,:,1),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,1),'LineWidth',2)
axis off
axis tight
%title('HF')

subplot(10,1,10)
plot(exp_wavy.muscle.signals(3,:,2),'--','LineWidth',2)
hold on;
plot(exp_wavy_fblmin.muscle.signals(1,:,2),'LineWidth',2)
axis off
axis tight
%title('GLU')