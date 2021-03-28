function config=conf()
addpath('fct');
addpath('lib');
addpath('articleFrontier');
addpath('articleMotorPrimitives');
addpath('articlePerturbation');
%addpath('/home/efx/Development/PHD/Airi/tools/matlab_tools/lib/cpg');
%addpath('/home/efx/Development/PHD/Airi/tools/matlab_tools/lib/variability_study');

config = struct;
config.raw_filename = struct;
config.raw_filename.cpgs = 'cpgs';
config.raw_filename.muscles_activity = 'muscles_activity';
config.raw_filename.muscles_force = 'muscles_force';
config.raw_filename.muscles_v_CE = 'muscles_v_CE';
config.raw_filename.muscles_f_v = 'muscles_f_v';
config.raw_filename.muscles_length = 'muscles_length';
config.raw_filename.muscles_noise = 'muscles_noise';

config.raw_filename.distance = 'distance';
config.raw_filename.interneurons = 'interneurons';
config.raw_filename.motoneurons_activity = 'motoneurons_activity';
config.raw_filename.motor_patterns = 'motor_patterns';
config.raw_filename.joints_position_z = 'joints_position_z';
config.raw_filename.joints_force = 'joints_force';

config.raw_filename.feedbacks = 'feedbacks';
config.raw_filename.footfall = 'footfall';
config.raw_filename.joints_position_y = 'joints_position_y';
config.raw_filename.joints_angle = 'joints_angle';
config.raw_filename.segments = 'segments';
config.raw_filename.grf = 'grf';
config.raw_filename.sensors_activity = 'sensors_activity';
config.raw_filename.energy = 'energy';

config.raw_filename.perturbation = 'perturbation';


config.raw_filedir = '/home/efx/Development/PHD/Airi/current/raw_files';

config.gait_event = struct;
config.gait_event.touchDown = 0;
config.gait_event.liftOff = 1;
config.gait_event.stance = 2;
config.gait_event.swing = 3;
config.gait_event.liftOff_touchDown = 4;
end
