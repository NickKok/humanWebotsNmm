%%
load('~/Downloads/SCI_data (1).mat')

%%
what = 'trns';
figure;
hold on;
plot(mean(test.superStruct.x_01.speed_04.left.hip.(what),2));
plot(mean(test.superStruct.x_01.speed_04.left.knee.(what),2),'r')
plot(mean(test.superStruct.x_01.speed_04.left.ank.(what),2),'g')

plot(mean(test.superStruct.x_01.speed_04.right.hip.(what),2),'--')
plot(mean(test.superStruct.x_01.speed_04.right.knee.(what),2),'r--')
plot(mean(test.superStruct.x_01.speed_04.right.ank.(what),2),'g--')

legend('Hip','Knee','Ankle')

%%

joint = 'knee';
figure;
hold on;

plot(mean(test.superStruct.x_01.speed_04.left.(joint).sag,2));
plot(mean(test.superStruct.x_01.speed_04.left.(joint).frnt,2));
plot(mean(test.superStruct.x_01.speed_04.left.(joint).trns,2));
