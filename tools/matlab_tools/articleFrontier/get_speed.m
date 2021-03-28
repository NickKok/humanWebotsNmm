function out = get_speed(id,raw_file_folder)
    if nargin==1
        raw_file_folder = 'sessionArticlFrontier';
    end
    %% Init
    config = conf();
    dir = [config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files
    distance = extract_rawFile(dir,config.raw_filename.distance,id);
    
    out = (distance.data(end)-distance.data(1))/length(distance.data)*1000;
    
end