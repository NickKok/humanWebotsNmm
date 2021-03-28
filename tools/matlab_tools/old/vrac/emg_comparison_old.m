addpath('/home/efx/Development/PHD/LabImmersion/Regis/v0.4/matlab_tools/fct')
folder = '/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
experiment ='';
%LOAD DATA
for i=1:12
    mn = load_data([folder experiment '/motoneurons_activity1'], 'activity');
    mu = load_data([folder experiment '/muscles_force1'], 'force');
    jo = load_data([folder experiment '/joints_force1'], 'torque');
end

%LOAD MUSCLES DATA
addpath('/home/efx/Development/PHD/LabImmersion/Regis/human_data/0-Speed dependence of averaged EMG profiles in walking')
load allmeas

i=1
nominal_motoneurone_signal;
%% GAS
subplot(121)
plot(signal(1).value)
subplot(122)
plotmusc(GM+GL)
xlim([0,100])
%% GLU
subplot(121)
plot(signal(2).value)
subplot(122)
plotmusc(GX+GD)
xlim([0,100])
%% VAS
subplot(121)
plot(signal(7).value)
subplot(122)
plotmusc(VM+VL)
xlim([0,100])
%% SOL
subplot(121)
plot(signal(6).value)
subplot(122)
plotmusc(PL+TA)
xlim([0,100])