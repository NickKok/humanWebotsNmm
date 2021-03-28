function hFig = subplot_shadedSignals(input,name,varargin)
    
    if(isa(input,'cell'))
        len = size(input{1},3);
        knot = size(input{1},2);
        ind = 1:len;
        if(nargin < 3)
            groups{1} = 1:size(input,1);
        else
            groups = varargin{1};
        end
        groupNumber = length(groups);
        colors = hsv(groupNumber);
        hFig=figure;
        for i=1:groupNumber
            m = reshape(input{1}(groups{i},:,ind),knot,len);
            s = reshape(input{2}(groups{i},:,ind),knot,len);
            if i == groupNumber
                text = 1;
            else
                text = 0;
            end
            hh=plot_meanSignal(100*m, 100*s,name(ind),{'LineStyle','-','Color',colors(i,:)},{'subplot',[len,1], 'returnSubplotHandler',[round((len+1)/2),1],'text',text,'numYTicks',3});%,'area',{'EdgeColor','k','FaceColor','k'}});
        end
    else
        len = size(input,3);
        knot = size(input,2);
        ind = 1:len;
        if(nargin < 3)
            groups{1} = 1:size(input,1);
        else
            groups = varargin{1};
        end
        groupNumber = length(groups);
        colors = hsv(groupNumber);
        hFig=figure;
        for i=1:groupNumber
            data = input(groups{i},:,ind);
            m = reshape(mean(data),knot,len);
            s = reshape(std(data),knot,len);
            if i == groupNumber
                text = 1;
            else
                text = 0;
            end
            hh=plot_meanSignal(100*m, 100*s,name(ind),{'LineStyle','-','Color',colors(i,:)},{'subplot',[len,1], 'returnSubplotHandler',[round((len+1)/2),1],'text',text,'numYTicks',3});%,'area',{'EdgeColor','k','FaceColor','k'}});
        end
    end
end