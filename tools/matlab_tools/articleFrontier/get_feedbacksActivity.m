function out = get_feedbacksActivity(id,raw_file_folder)
    if nargin==1
        raw_file_folder = 'sessionArticlFrontier';
    end
    %% Init
    config = conf();
    dir = [config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files
    knot = 500;
    tic
    disp('Data loading...')
    footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
    stance_percentage = extract_stancePercentage(footFall);
    toc


    %% Data loading
    what = config.raw_filename.feedbacks;
    data = extract_rawFile(dir,what,id);
    
    toKeep = data.left;
    skip=10;
    out = signal_analysis(data,footFall,toKeep,knot,1,skip);

    %out = signal_analysis(data,footFall,toKeep,knot);
    stdCycle = reshape(out.signalStd(:,1,:),14,knot)';
    varCycle = reshape(out.signalVar(:,1,:),14,knot)';
    out = reshape(out.signalMean(:,1,:),14,knot)';
    
end