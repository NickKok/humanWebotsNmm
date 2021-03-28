% 3 : fast gait at 1.8 m/s small steps (not sure)
% 5 : normal gait at 1.3 m/s normal steps (big)
% 6 : normal gait at 1.3 m/s with small steps
sess = 'session4';
dir = ['/home/efx/Development/PHD/Airi/current/raw_files/' sess];
MP_1 = [];
MP_2 = [];
MP_3 = [];
MP_4 = [];
MP3_corr = [];
MP4_corr = [];
for id=3:6
    analysis_MusclesActivity
    eval(['MC_' num2str(i) ' = meanCycle;']);
    MP_1 = [MP_1 moto_primitives(:,1)];
    MP_2 = [MP_2 moto_primitives(:,2)];
    MP_3 = [MP_3 moto_primitives(:,3)];
    MP_4 = [MP_4 moto_primitives(:,4)];
    MP3_corr = [MP3_corr corr3];
    MP4_corr = [MP4_corr corr4];
end
sess = 'session5';
dir = ['/home/efx/Development/PHD/Airi/current/raw_files/' sess];
for id=6
    analysis_MusclesActivity
    eval(['MC_' num2str(i) ' = meanCycle;']);
    MP_1 = [MP_1 moto_primitives(:,1)];
    MP_2 = [MP_2 moto_primitives(:,2)];
    MP_3 = [MP_3 moto_primitives(:,3)];
    MP_4 = [MP_4 moto_primitives(:,4)];
    MP3_corr = [MP3_corr corr3];
    MP4_corr = [MP4_corr corr4];
end
%%
for i=1:4
    subplot(4,1,i)
    hold on;
    plot(eval([ 'MP_' num2str(i)]),'LineWidth',2)
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