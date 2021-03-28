%% Load evaluation data
folder_path = '/home/efx/Development/PHD/Airi/current/evaluation/data';
out = exp_wavy;
%%
raw_wavy_ground = importdata([folder_path '/' 'distance_param3.txt']);
wavy_ground = struct;
for i=1:size(raw_wavy_ground.textdata,1)
    evolve_on = cell2mat(['ev_' raw_wavy_ground.textdata(i,1)]);
    repeat = cell2mat(raw_wavy_ground.textdata(i,2));
    evaluate_on = strrep(cell2mat(raw_wavy_ground.textdata(i,3)),'.wbt','');
    
    wavy_ground.(evolve_on).(repeat).(evaluate_on) = [];
end

for i=1:size(raw_wavy_ground.textdata,1)
    evolve_on = cell2mat(['ev_' raw_wavy_ground.textdata(i,1)]);
    repeat = cell2mat(raw_wavy_ground.textdata(i,2));
    evaluate_on = strrep(cell2mat(raw_wavy_ground.textdata(i,3)),'.wbt','');
    d = wavy_ground.(evolve_on).(repeat).(evaluate_on);
    d = [d i];
    wavy_ground.(evolve_on).(repeat).(evaluate_on) = d;
end

%%
raw_rp_eval = importdata([folder_path '/' 'rp_eval.txt']);
rp_eval = struct;
for i=1:size(raw_rp_eval.textdata,1)
    evolve_on = cell2mat(['ev_' raw_rp_eval.textdata(i,1)]);
    repeat = cell2mat(raw_rp_eval.textdata(i,2));
    rp_eval.(evolve_on).(repeat) = [];
end
for i=1:size(raw_rp_eval.textdata,1)
    evolve_on = cell2mat(['ev_' raw_rp_eval.textdata(i,1)]);
    repeat = cell2mat(raw_rp_eval.textdata(i,2));
    d = rp_eval.(evolve_on).(repeat);
    d = [d i];
    rp_eval.(evolve_on).(repeat) = d;
end

%% Structurate rp_eval (for wavy experiment)
data = rp_eval;
fields = fieldnames(data);
gaitData = struct;
for i=1:length(fields)
    force = [];
    falled = [];
    subfields = fieldnames(data.(cell2mat(fields(i))));
    for j=1:length(subfields)
        d = data.(cell2mat(fields(i))).(cell2mat(subfields(j)));
        force(j,:) = raw_rp_eval.data(d,1);
        falled(j,:) = 1-raw_rp_eval.data(d,2);
    end
    gaitData.(cell2mat(fields(i))).rpEval_force = force;
    gaitData.(cell2mat(fields(i))).rpEval_falled = falled;
    %rp_eval.(cell2mat(fields(i))).data = data;
end

% Falled ordered same as in table 5
gaitData.base.rpEval_falled(out.energy.order([10,6,4,3,1,8,2,7,9,5]),:)'

%%
data = rp_eval;
fields = fieldnames(data);
gaitData = struct;
for i=1:length(fields)
    force = [];
    falled = [];
    subfields = fieldnames(data.(cell2mat(fields(i))));
    for j=1:length(subfields)
        d = data.(cell2mat(fields(i))).(cell2mat(subfields(j)));
        force(j,:) = raw_rp_eval.data(d,1);
        falled(j,:) = 1-raw_rp_eval.data(d,2);
    end
    gaitData.(cell2mat(fields(i))).rpEval_force = reshape(force,6,length(force)/6);
    gaitData.(cell2mat(fields(i))).rpEval_falled = reshape(falled,6,length(falled)/6);
    %rp_eval.(cell2mat(fields(i))).data = data;
end

%% Structurate wavy_ground
data = wavy_ground;
fields = fieldnames(data);
%gaitData = struct;
clear d
for i=1:length(fields)
    subfields = fieldnames(data.(cell2mat(fields(i))));
    distance = [];
    for j=1:length(subfields)
        d(1) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg1;
        
        d(2) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg2;
        d(3) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg3;
        d(4) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg4;
        d(5) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg5;
        d(6) = data.(cell2mat(fields(i))).(cell2mat(subfields(j))).version52_wg6;
        
        
        distance(j,:) = raw_wavy_ground.data(d,1);
    end
    gaitData.(cell2mat(fields(i))).wavy_distance = distance;
    %rp_eval.(cell2mat(fields(i))).data = data;
end


%% Wavy ground get slope
ground_data = importdata('articleFrontier/version52_wavyGround.txt');
get_ground = @(ground) ground_data.data(ground_data.data(:,1) == ground,:);
get_ground_elem = @(ground,elem) ground_data.data(ground_data.data(:,1) == ground,elem);

get_distances = @(ground) ground(:,3);
get_last_wave = @(ground,distance) find(get_distances(get_ground(ground)) < distance,1,'last');
get_next_wave = @(ground,distance) find(get_distances(get_ground(ground)) > distance,1,'first');

get_slopes = @(ground) get_ground_elem(ground,4)./get_ground_elem(ground,5).*get_ground_elem(ground,6);
parent = @(x, varargin) x(varargin{:});

get_slope = @(ground,distance) parent(get_slopes(ground),get_next_wave(ground,distance));


%% Get slopes
% reached
for i=1:size(gaitData.base.wavy_distance,2)
    gaitData.base.wavy_maxSlope(:,i) = arrayfun(@(x) get_slope(i,x), gaitData.base.wavy_distance(:,i));
end


meanSlope = mean(gaitData.base.wavy_maxSlope*100,2);

%% Force
d = importdata(['../../current/evaluation/data/force.txt']); dh =  importdata(['../../current/evaluation/data/header_force.txt']);
id=sum(cell2mat(d.textdata(:,1)),2);
el=unique(id);

data = d.data;
for i=1:length(el)
els = id == el(i);

dist = data(els,1);
forceVec.(['e' num2str(i)])(:,:) = data(els,2:3);
forceAmp.(['e' num2str(i)]) = sqrt(data(els,2).*data(els,2)+data(els,3).*data(els,3));
forcePos.(['e' num2str(i)])(:,:)  = data(els,4);
falled.(['e' num2str(i)])(:,:)  = ~data(els,5);

end


