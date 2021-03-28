function hFig = subplot_fillSignals(input,name,varargin)
        input = squeeze(input);
        len = size(input,2);
        knot = size(input,1);
        ind = 1:len;
        
        for i=1:len;
            subplot(len,1,i);
            area(squeeze(input(:,i)));
            title(name(i));
            ylim([0,1.0])
            if(i~=len)
            axis off;
            end
        end
end