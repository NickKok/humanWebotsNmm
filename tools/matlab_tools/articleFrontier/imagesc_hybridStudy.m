function Z=imagesc_hybridStudy(out,what,varargin)

    first_color = [0.8 0.8 0.8];
    colors = jet(100);
    colors = colors(1:end-10,:);
    plot = 1;
    for i=1:2:length(varargin)
        if(strcmp(varargin{i},'first_color'))
            first_color = varargin{i+1};
        elseif(strcmp(varargin{i},'colormap'))
            colors = varargin{i+1};
        elseif(strcmp(varargin{i},'plot'))
            plot = varargin{i+1};
        end
    end

    x=out.p_values(:,1);
    y=out.p_values(:,2);
    [X,Y]=meshgrid(unique(x),unique(y));
    Z=griddata(x,y,what(out.p_index), X,Y);
    if(plot)
        imagesc_nan(unique(x),unique(y),Z,'first_color',first_color,'colors',colors)
    end
end