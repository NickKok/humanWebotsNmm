var = zeros(12,10);
par = zeros(12,25);
for expnum=1:12
%% load one experiment
    par(i,:) = load_data(['/home/efx/Development/PHD/LabImmersion/Regis/v0.2/matlab_files/parameters_study/no_lift_new_tf/parameters1' int2str(i) '.txt'],'minimal');
    [exp,labels] = load_experiment(expnum,'/home/efx/Development/PHD/LabImmersion/Regis/v0.2/matlab_files/parameters_study/no_lift_new_tf/');
    dt = 0.001;
    % variable names;
    name{1} = 'std_duration';
    name{2} = 'mean_duration';
    name{3} = 'synchronisation';
    name{4} = 'time_to_enter_limit_cycle';
    name{5} = 'left_right_similarity';
    name{6} = 'max_hip';
    name{7} = 'max_knee';
    name{8} = 'max_ankle';
    name{9} = 'mean_energy_consumption';
    name{10} = 'std_energy_consumption';
    %name{10} = 'speed';

    %% extract all cycles
    % cycle start
    leftcycles.start=find(derivatives(exp.gait.footfall(1,:,1))==1);
    rightcycles.start=find(derivatives(exp.gait.footfall(1,:,2))==1);
    % cycle duration
    leftcycles.length =leftcycles.start(2:end)-leftcycles.start(1:end-1);
    rightcycles.length =rightcycles.start(2:end)-rightcycles.start(1:end-1);

    % cycle duration mean
    var(expnum,1) = 0.5*(mean(leftcycles.length)+mean(rightcycles.length))*dt;
    % cycle duration variability
    var(expnum,2) = 0.5*(std(leftcycles.length)+std(rightcycles.length))*dt;
    % left/right cycle duration synchronisation
    l = min([length(leftcycles.start) length(rightcycles.start)]);
    x = leftcycles.start(1:l)-rightcycles.start(1:l);
    var(expnum,3) = std(find(x>mean(x)-std(x) & x<mean(x)+std(x)))*dt;
    % time to enter limit cycle
    x = find(not(x>mean(x)-std(x) & x<mean(x)+std(x)));
    var(expnum,4) = leftcycles.start(x(end))*dt;
    clear l x;

    for k=2:min([length(leftcycles.start) length(rightcycles.start)])
        %% extract one cycle
        leftcycle.start = leftcycles.start(k-1);
        leftcycle.end = leftcycles.start(k)-1;
        rightcycle.start = rightcycles.start(k-1);
        rightcycle.end = rightcycles.start(k)-1;

        s1 = fieldnames(exp);
        cc = 0;
        count = 0;
        for i=1:length(s1)
            if(~strcmp(s1{i},'gait'))
                s2=fieldnames(eval(['exp.' s1{i}]));
                for j=1:length(s2)
                    eval(['left.' s1{i} '.' s2{j} '= exp.' s1{i} '.' s2{j} '(1,' int2str(leftcycle.start) ':' int2str(leftcycle.end) ',:);']);
                    eval(['right.' s1{i} '.' s2{j} '= exp.' s1{i} '.' s2{j} '(1,' int2str(rightcycle.start) ':' int2str(rightcycle.end) ',:);']);
                    l = eval(['min([size(left.' s1{i} '.' s2{j} ',2) size(right.' s1{i} '.' s2{j} ',2)])']);
                    n = eval(['min([size(left.' s1{i} '.' s2{j} ',3) size(right.' s1{i} '.' s2{j} ',3)])'])/2;
                    tmp = eval(['corrcoef(left.' s1{i} '.' s2{j} '(1,1:' int2str(l) ',1:' int2str(n) '),right.' s1{i} '.' s2{j} '(1,1:' int2str(l) ',' int2str(n+1) ':end))' ]);
                    tmp = min(min(tmp));
                    cc = cc+tmp;
                    count = count+1;
                end
            end
        end
        clear i j;
    end
    var(expnum,5) = cc/count;

    var(expnum,6) = 0.5*(max(exp.joints.angle(1,:,1))+max(exp.joints.angle(1,:,4)));
    var(expnum,7) = 0.5*(max(exp.joints.angle(1,:,2))+max(exp.joints.angle(1,:,5)));
    var(expnum,8) = 0.5*(max(exp.joints.angle(1,:,3))+max(exp.joints.angle(1,:,6)));

    var(expnum,9) = mean(derivatives(exp.gait.energy));
    var(expnum,10) = std(derivatives(exp.gait.energy));
    cycle(expnum) = length(rightcycles.start);
end
clearvars -except var name cycle par


%% BOOTSTRAPPING
%normalization
par=zscore(par);
var=zscore(var);
%real experiment
x=distmat(par);
y=distmat(var);
res_real = sum(sum(abs(x-y)))/2;
%pseudo experiment
nrepeat = 1000;
nexp = size(var,1);
par_ids=(ceil(rand(nexp,nrepeat)*nexp));
var_ids=(ceil(rand(nexp,nrepeat)*nexp));
res=zeros(1,nrepeat);
for i=1:nrepeat
    x_t=distmat(par(par_ids(:,1),:));
    y_t=distmat(par(var_ids(:,1),:));
    res(i) = sum(sum(abs(x_t-y_t)))/2;
end
%plot
hold on;
hist(res,round(nrepeat/10));
ylim = get(gca,'YLim'); 
plot(res_real*[1,1],ylim*1.05,'r-','LineWidth',2);
hold off;