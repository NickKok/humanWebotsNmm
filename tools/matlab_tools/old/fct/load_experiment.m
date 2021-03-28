function [exp,labels] = load_experiment(i,varargin)
    folder = '/home/efx/Development/PHD/LabImmersion/Regis/v0.2/matlab_files/parameters_study/no_lift_new_tf/';
    if(nargin == 2)
        folder = varargin{1};
    end
    if(nargin == 3)
        exp = varargin{2};
    else
        exp = struct;
    end

    %LOAD DATA
    if(~IsField(exp,'spike_rate'))
        exp.motoneuron.spike_rate = [];
        exp.muscles.force = [];
        exp.joints.force = [];
        exp.joints.angle = [];
        exp.gait.footfall = [];
        exp.gait.energy = [];
        exp.gait.distance = [];
        labels.motoneuron.spike_rate = load_fieldname([folder 'motoneurons_activity' int2str(i)], 'minimal');
        labels.muscles.force = load_fieldname([folder 'muscles_force' int2str(i)], 'minimal');
        labels.joints.force = load_fieldname([folder 'joints_force' int2str(i)], 'minimal');
        labels.joints.angle = load_fieldname([folder 'joints_angle' int2str(i)], 'minimal');
        labels.gait.footfall = load_fieldname([folder 'footfall' int2str(i)], 'minimal');
        labels.gait.energy = load_fieldname([folder 'energy' int2str(i)], 'minimal');
        labels.gait.distance = load_fieldname([folder 'instantaneous_distance' int2str(i)], 'minimal');
        expnumber=1;
    else
        expnumber=size(exp,1)+1;
    end

    exp.motoneuron.spike_rate(expnumber,:,:) = load_data([folder 'motoneurons_activity' int2str(i)], 'minimal');
    exp.muscles.force(expnumber,:,:) = load_data([folder 'muscles_force' int2str(i)], 'minimal');
    exp.joints.force(expnumber,:,:) = load_data([folder 'joints_force' int2str(i)], 'minimal');
    exp.joints.angle(expnumber,:,:) = load_data([folder 'joints_angle' int2str(i)], 'minimal');
    exp.gait.footfall(expnumber,:,:) = load_data([folder 'footfall' int2str(i)], 'minimal');
    exp.gait.energy(expnumber,:,:) = load_data([folder 'energy' int2str(i)], 'minimal');
    exp.gait.distance(expnumber,:,:) = load_data([folder 'instantaneous_distance' int2str(i)], 'minimal');



    %GENERATE TIME VECTOR
    %time step duration

end