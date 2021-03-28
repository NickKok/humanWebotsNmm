%% CONSTANT & VARIABLES INITIALISATION %%
P_NUMBER = 29; % number of parameters % geyer branch
%P_NUMBER = 46; % number of parameters % master2 branch
slopes = zeros(1,P_NUMBER);
trend = zeros(1,P_NUMBER);
corr = zeros(1,P_NUMBER);

%% INIT %%
SELECTED = [ 17, 2, 12, 18, 15, 29, 10, 4, 16, 5, 11, 28, 13, 9, 8, 30, 6, 7 ];

%%SELECTED = 2:47;
%AA = importdata('../job_generator/jobs/master2/4/param.txt');
AA = importdata('../job_generator/jobs/geyer/rp/param.txt');
P_values = AA.data(:,SELECTED); % parameters values
P_names = AA.colheaders(SELECTED)'; % parameters names
P_speed = round(AA.data(:,1)*10)/10; % speed associated to each parameters set. We round it to the first decimal



% X-Axis : speed
X = unique(P_speed);
[I1,~] = find((abs(P_speed - AA.data(:,1)))>0.05);
P_speed(I1) = -1;
P_speed(P_speed == 2.0) = -1;
%X = X(1:end-1);
i=1;

% Y-Axis : parameters values, mean and std.
Y_mean = zeros(length(X),length(SELECTED));
Y_std = zeros(length(X),length(SELECTED));


energy = importdata('../job_generator/jobs/geyer/__9__/energy.txt');
distance = importdata('../job_generator/jobs/geyer/__9__/distance.txt');
%v = energy.data(:,1)./distance.data(:,1)/80.;


for i=1:length(X)

   Y_mean(i,:) = mean(P_values(P_speed==X(i),:),1);
   %v_mean(i,:) = mean(v(P_speed==X(i),:),1);
   %v_std(i,:) = std(v(P_speed==X(i),:),1); 
   size(P_values(P_speed==X(i),:),1)
   Y_sum(i,:) = sum(abs(P_values(P_speed==X(i),:)))/size(P_values(P_speed==X(i),:),1);
   Y_std(i,:) = std(P_values(P_speed==X(i),:),1);
end

% We order by minimal std deviation (stability of the parameter values)
s_trend = mean(Y_std)./(max(Y_mean)-min(Y_mean));
[s_trend,I] = sort(s_trend);
P_names = P_names(I);
Y_mean = Y_mean(:,I);
Y_std = Y_std(:,I);

%% PLOT %%
% 
%
%
% need to be changed
%
%
%
%
for i=1:length(Y_mean) 
%     %corrcoef(X,Y_mean(:,i))
     errorbar(X,Y_mean(:,i),Y_std(:,i))
     xlabel('speeds (m/s)');
     ylabel(P_names{i});
     s_trend(i)
%     i
     pause       
 end

% HIP : 7 17 25
selected = [1, 5, 9, 2, 6, 12, 4, 3, 7];
for i=1:9
    subplot(3,3,i);
%    %corrcoef(X,Y_mean(:,i))

    errorbar(X,Y_mean(:,selected(i)),Y_std(:,selected(i)));
    xlabel('speeds (m/s)');
    xlim([0.8,1.8]);
    ylim([min(Y_mean(:,selected(i))-Y_std(:,selected(i))),max(Y_mean(:,selected(i))+Y_std(:,selected(i)))]);
    ylabel(P_names{selected(i)})
end
% STANCE : kphiknee=21,
% SWING : hfhf_wl = 4
%          kbodyweight

