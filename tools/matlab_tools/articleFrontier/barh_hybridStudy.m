function data=barh_hybridStudy(what,extract,varargin)
applyToGivenRow = @(func, matrix) @(row) func(matrix(row, :));    
applyToRows = @(func, matrix) arrayfun(applyToGivenRow(func, matrix), 1:size(matrix,1))';
    
    plot = 1;
    color = [0,0,0];
    dim = 'x';
    
    
    for i=1:2:length(varargin)
        if(strcmp(varargin{i},'color'))
            color = varargin{i+1};
        elseif(strcmp(varargin{i},'dim'))
            dim = varargin{i+1};
        elseif(strcmp(varargin{i},'order'))
            order = varargin{i+1};
        elseif(strcmp(varargin{i},'plot'))
            plot = varargin{i+1};
        end
    end
    
    f = fieldnames(what);
    if nargin == 2
        color = [1,0,0];
    end
    for i=1:length(f)
        name = cell2mat(f(i));
        out = what.(name);

        %
        if strcmp(extract,'speed')
            d = out.fit.speedMean;
        elseif strcmp(extract,'stride')
            d = out.fit.cycleLength;
        elseif strcmp(extract,'cot')
            d = out.fit.EoD/80;
        end
            
        %
        %d = out.fit.stanceEndDuration;
        toRemove = abs(out.fit.speedMean-out.fit.speedInst) > 0.15;
        d(toRemove) = nan;
        toRemove = abs(out.fit.stanceDurationLeft-out.fit.stanceDurationRight) > 5e-3;
        d(toRemove) = nan;
        z=imagesc_hybridStudy(out,d,'plot',0);
        Z(i,:,:) = z;
        x_MIN(i,:)=((applyToRows(@nanmin,z)));
        y_MIN(i,:)=((applyToRows(@nanmin,z')));
        x_MAX(i,:)=((applyToRows(@nanmax,z)));
        y_MAX(i,:)=((applyToRows(@nanmax,z')));
    end
    

    if plot
        hold on;
    end
    if dim=='x'
        [a,b]=max(x_MAX-x_MIN,[],2);
        d = diag(x_MAX(:,b(:)));
        data.max = d;
        if plot
        barh([d(order) 0*d(order)],'FaceColor',color)
        end
        d = diag(x_MIN(:,b(:)));
        data.min = d;
        if plot
        barh([d(order) 0*d(order)],'FaceColor',[0.8,0.8,0.8]);
        end
    else
        [a,b]=max(y_MAX-y_MIN,[],2);
        d = diag(y_MAX(:,b(:)));
        data.max = d;
        if plot
        barh([0*d(order) d(order)],'FaceColor',color)
        end
        d = diag(y_MIN(:,b(:)));
        data.min = d;
        if plot
        barh([0*d(order) d(order)],'FaceColor',[0.8,0.8,0.8]);
        end
    end
    data.diff = data.max-data.min;
    data.pos = b;
end