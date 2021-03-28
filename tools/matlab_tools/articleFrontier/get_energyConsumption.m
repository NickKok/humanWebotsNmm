function out=get_energyConsumption(id,raw_file_folder)
    if nargin==1
        raw_file_folder = 'sessionArticlFrontier';
    end
    %% Init
    config = conf();
    dir = [ config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files

    knot = 1000; % number of knot for the spline interploation
    energy = config.raw_filename.energy;
    distance = config.raw_filename.distance;


    %% Data loading
    disp('Data loading...')
    tic
    energy = extract_rawFile(dir,energy,id); % extract muscles activity
    distance = extract_rawFile(dir,distance,id); % extract muscles activity
    toc
    out.energy = energy.data(end)-energy.data(1);
    out.distance = distance.data(end)-distance.data(1);
end