% 3 : fast gait at 1.8 m/s small steps (not sure)
% 5 : normal gait at 1.3 m/s normal steps (big)
% 6 : normal gait at 1.3 m/s with small steps
dir = '/home/efx/Development/PHD/Airi/current/raw_files/session1';
id = 3;
analysis_MusclesActivity
MC_3 = meanCycle;
MP_3 = moto_primitives;

id = 5;
analysis_MusclesActivity
MC_5 = meanCycle;
MP_5 = moto_primitives;

id = 6;
analysis_MusclesActivity
MC_6 = meanCycle;
MP_6 = moto_primitives;

%%
for i=1:3
    subplot(3,1,i)
    hold on;
    plot(MP_3(:,i),'LineWidth',2)
    plot(MP_5(:,i),'LineWidth',2)
    plot(MP_6(:,i),'LineWidth',2)
    title(sprintf('motor primitives %d',i))
end


%% 1 Comparaison of MPs with 3 and 4
%the early stance one gets split in two
[mp3_3,H] = nnmf(MC_3,3);
[mp3_4,H] = nnmf(MC_3,4);
[mp5_3,H] = nnmf(MC_5,3);
[mp5_4,H] = nnmf(MC_5,4);
[mp6_3,H] = nnmf(MC_6,3);
[mp6_4,H] = nnmf(MC_6,4);

figure
plot(mp3_3,'g')
hold on;
plot(mp3_4,'m')

figure
plot(mp5_3,'g')
hold on;
plot(mp5_4,'m')

figure
plot(mp6_3,'g')
hold on;
plot(mp6_4,'m')