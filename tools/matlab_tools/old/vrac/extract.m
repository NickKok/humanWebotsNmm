addpath('/home/efx/Development/PHD/LabImmersion/Regis/v0.2/matlab_tools/fct')
folder = '/home/efx/Development/PHD/LabImmersion/Regis/v0.2/matlab_files/parameters_study/no_lift_new_tf/';
%LOAD DATA
mn = load_data([folder 'motoneurons_activity1'], 'activity');
mu = load_data([folder 'muscles_force1'], 'force');
jo = load_data([folder 'joints_force1'], 'torque');
angles = load_data([folder 'joints_angle1'], 'angles');
energy = load_data([folder 'energy1'], 'energy');
footfall = load_data([folder 'footfall1'], 'footfall');
dist = load_data([folder 'instantaneous_distance1'], 'dist_per_step');



%GENERATE TIME VECTOR
%time step duration
