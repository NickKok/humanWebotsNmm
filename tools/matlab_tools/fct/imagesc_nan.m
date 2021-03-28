function imagesc_nan(varargin)

    first_color = [0.8 0.8 0.8];
    ydir = 'normal';
    colors = hot(100);
    
    onlyZ=0;
    if nargin == 1
        onlyZ=1;
        C=varargin{1};
        varargin = varargin(2:end);
    else
        if isa(varargin{2},'double')
            x=varargin{1};
            y=varargin{2};
            C=varargin{3};
            varargin = varargin(4:end);
        else
            onlyZ=1;
            C=varargin{1};
            varargin = varargin(2:end);
        end
    end

    
    
    for i=1:2:length(varargin)
        if(strcmp(varargin{i},'first_color'))
            first_color = varargin{i+1};
        elseif(strcmp(varargin{i},'YDir'))
            ydir = varargin{i+1};
        elseif(strcmp(varargin{i},'colors'))
            colors = varargin{i+1};
        end
    end
   

    C(isnan(C)) = min(C(:))-0.1*(max(C(:))-min(C(:)));
    colors(1,:) = first_color;
    if onlyZ
        imagesc(C)
    else
        imagesc(x,y,C)
    end
    colormap(colors)
    set(gca,'YDir',ydir)
    
end