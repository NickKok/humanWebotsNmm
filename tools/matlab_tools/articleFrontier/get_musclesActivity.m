function out = get_musclesActivity(id,raw_file_folder)
    if nargin==1
        raw_file_folder = 'sessionArticlFrontier';
    end
    %% Init
    config = conf();
    dir = [config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files
    knot = 1000;
    tic
    disp('Data loading...')
    footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
    stance_percentage = extract_stancePercentage(footFall);
    toc


    %% Data loading
    toKeep = 1:7;
    what = config.raw_filename.muscles_activity;
    data = extract_rawFile(dir,what,id);
    out = signal_analysis(data,footFall,toKeep,knot);
    stdCycle = reshape(out.signalStd(:,1,:),7,knot)';
    varCycle = reshape(out.signalVar(:,1,:),7,knot)';
    out = reshape(out.signalMean(:,1,:),7,knot)';
    
end