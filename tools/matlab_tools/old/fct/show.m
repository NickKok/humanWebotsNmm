function show(data,varargin)
    % data structure level 1, extract the time
    s = fieldnames(data);
    time = [];
    what = [];
    visual = 'subplot';
    
    if(nargin == 1)
        what = [];
    elseif(nargin == 2)
        what = varargin{1};
        
    else
        what = varargin{1};
        visual = varargin{2};
    end
    showsubplot = true;
    if(~strcmp(visual,'subplot'))
        showsubplot = false;
    end
    
    if(strcmp(s{1},'time'))
       time = eval(['data.' s{1}]);
       data = eval(['data.' s{2}]);
    else
       time = eval(['data.' s{2}]);
       data = eval(['data.' s{1}]);
    end
    % data structure level 2, extract fields
    s = fieldnames(data);
    nbelem = 1;
    for i=1:length(s)
        if(strfind(s{i}, what))
            nbelem = nbelem + 1;
        end
    end
    nrow = 3; %subplot number of rows
    nline = 1+(nbelem-mod(nbelem,nrow))/nrow;
    
    elem = 1;

    color = lines(length(s));
    if(~showsubplot)
        hold on;
    end
    for i=1:length(s)
        if(strfind(s{i}, what))
            pat = '(?<prefix>\w+)_(?<name>\w+)';
            n = regexp(s{i}, pat, 'names');
            name{elem} = [n.name '_{' n.prefix '}'];
            if(showsubplot)
                subplot(nline,nrow,elem);
                plot(time,eval(['data.' s{i}]));
                title(name{elem});
            else
                plot(time,eval(['data.' s{i}]),'Color', color(i,:),'DisplayName', name{elem});
            end
            
            xlim([12 13]);
            elem = elem + 1;
        end
    end
    %keyboard
    if(~showsubplot)
        temp = 'name{1}';
        for i=2:elem-1
            temp = [temp ',name{' int2str(i) '}'];
        end
        eval([ 'legend(' temp ');']);
        hold off;
    end
end