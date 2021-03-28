data=load('~/Downloads/pso_noiseSqrtSen_speed_1.3.3.db.mat');
stage = reshape(data.data_values(:,:,31),350,25);

value = reshape(data.fitness_values(:,:,1),350,25);
value(stage~=2)=0;
[~,I]=max(value');

energy = reshape(data.fitness_values(:,:,8),350,25);
gr0 = reshape(data.fitness_values(:,:,21),350,25);
gr1 = reshape(data.fitness_values(:,:,22),350,25);
gr2 = reshape(data.fitness_values(:,:,23),350,25);
distance = reshape(data.fitness_values(:,:,5),350,25);
speed = reshape(data.fitness_values(:,:,29),350,25);

data = struct;
data.energy = zeros(350,1);
data.gr0 = zeros(350,1);
data.gr1 = zeros(350,1);
data.gr2 = zeros(350,1);
data.distance = zeros(350,1);
data.speed = zeros(350,1);
for i=1:350
    data.energy(i) = energy(i,I(i));
    data.gr0(i) = gr0(i,I(i));
    data.gr1(i) = gr1(i,I(i));
    data.gr2(i) = gr2(i,I(i));
    data.speed(i) = speed(i,I(i));
    data.distance(i) = distance(i,I(i));
    data.energyoverdistance(i) = data.energy(i)/data.distance(i);
end

start = 4;

subplot(3,1,1)
plot([data.gr0(start:end) data.gr1(start:end) data.gr2(start:end)],'LineWidth',2)
hold on;
plot(ones(1,length(data.gr0)-2)* 0.5*(1+sqrt(5)),'k--','LineWidth',2)
ylabel('golden ratio []');

subplot(3,1,2)
plot(data.speed(start:end),'LineWidth',2);
hold on;
plot(ones(1,length(data.gr0)-2)* 1.3,'k--','LineWidth',2)
ylabel('speed [m/s]');

subplot(3,1,3)
plot(data.energyoverdistance(start:end)/1000,'LineWidth',2);
xlabel('iterations');
ylabel('CoT [kN/m]');

