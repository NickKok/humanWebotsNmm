function out = get_footFall(id,raw_file_folder)
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
    out = footFall
    
    
end