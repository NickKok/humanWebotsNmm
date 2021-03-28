function out=load_systematicNoise(folder,subfolder,study,suffix,varargin)


    disp(['loading ' study ' data']);
    
    repeat = 1:5;
    paramSet = 1:10;
    
    if nargin > 4 
        for i=1:2:length(varargin)
            if strcmp(varargin{i},'repeat')
                repeat = varargin{i+1};
            end
            if strcmp(varargin{i},'paramSet')
                paramSet = varargin{i+1};
            end
            if strcmp(varargin{i},'noRepeat')
                noRepeat = varargin{i+1};
            end
        end
    end
    
    if ~isempty(suffix)
        suffix = ['_' suffix];
    end
    
    out.RawData = cell(length(paramSet),length(repeat));
    out.Data = struct;
    out.Data.p_stableUntil = zeros(length(paramSet),length(repeat));
    out.Data.p_stableMax = zeros(length(paramSet),length(repeat));
    out.Data.falled = zeros(length(paramSet),length(repeat),11);
    for j=repeat
        tic
        for i=paramSet
            if noRepeat
                out.RawData{i,j} = extract_rawSystematic(folder,subfolder,study,['_fdb' num2str(i) suffix],''); 
            else
                out.RawData{i,j} = extract_rawSystematic(folder,subfolder,study,['_fdb' num2str(i) suffix],['_repeat' num2str(j)]); 
            end
            out.Data.p_stableUntil(i,j) = out.RawData{i,j}.p_stableUntil;
            out.Data.p_stableMax(i,j) = out.RawData{i,j}.p_stableMax;
            out.Data.falled(i,j,:) = out.RawData{i,j}.fitness.FALLED;
        end
        toc
    end
end