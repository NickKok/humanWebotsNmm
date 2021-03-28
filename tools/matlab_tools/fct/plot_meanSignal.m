function h=plot_meanSignal(meanCycle,stdCycle,leg,varargin)
    %figure;

    
    hold on;
    Knot = size(meanCycle,1);
    do_plotStancePercentage = 0;
    do_ylim = 0;
    do_subplot = 0;
    do_returnSubplotHandler = 0;
    do_area = 0;
    do_title = 1;
    do_changeYTicks = 0;
    do_tight = 0;
    returnSubplotHandler = [1,1];
    minY=min(min(meanCycle-stdCycle));
    maxY=max(max(meanCycle+stdCycle));    
    
    colors = lines(size(meanCycle,2));
    line_option = {'LineWidth',2,'LineStyle','--'};
    if nargin > 3
        line_option = [line_option,varargin{1}];
    end
    
    if nargin > 4
        option = varargin{2};
        
        for i=1:2:length(option)
            val=option{i+1};
            if strcmp(option{i},'subplot')
                do_subplot = 1;
                line = val(1);
                col = val(2);
                skip = 1;
                start = 1;
                if length(val) == 3
                    skip = val(2);
                    start = val(3);
                end
            elseif strcmp(option{i},'stancePercentage')
                do_plotStancePercentage = 1;
                stance_percentage = val(1);
            elseif strcmp(option{i},'ylim')
                do_ylim = 1;
                yy = val;
                if(length(yy)==2)
                    minY=yy(1);
                    maxY=yy(2);
                end
            elseif strcmp(option{i},'returnSubplotHandler')
                do_returnSubplotHandler = 1;
                returnSubplotHandler=val;
            elseif strcmp(option{i},'area')
                do_area = 1;
                line_option = val;
            elseif strcmp(option{i},'text')
                do_title = val;
            elseif strcmp(option{i},'numYTicks')
                do_changeYTicks = 1;
                numYticks = val;
            elseif strcmp(option{i},'tight')
                do_tight = val;
            end
            
        end
        


    end

    %if do_tight
    %    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
    %end
    
    
    minY=minY-0.04*(maxY-minY);
    maxY=maxY+0.04*(maxY-minY);

    


    t = linspace(0,100,Knot);

    %plot(t,meanCycle)

    if ~do_subplot
        if do_plotStancePercentage == 1
            t_ff=linspace(stance_percentage,100,100);
            H_ff=area(t_ff,(minY+0.015*(maxY-minY))*ones(size(t_ff)),'FaceColor',[0.1,0.1,0.1],'EdgeColor',[0.7,0.7,0.7]);
            area(t_ff,(minY+0.025*(maxY-minY))*ones(size(t_ff)),'FaceColor',[1.0,1.0,1.0],'EdgeColor',[1.0,1.0,1.0]);
        end
    end
    lH = [];
    for i=1:size(meanCycle,2)
        if do_subplot
            htemp=subplot(line,col,start+skip*(i-1));
            if(do_returnSubplotHandler)
                itest=(returnSubplotHandler(1)-1)*col+returnSubplotHandler(2);
                if(itest==i)
                    h = htemp;
                end
            end
            hold on;
            if do_plotStancePercentage == 1
                t_ff=linspace(stance_percentage,100,100);
                H_ff=area(t_ff,(minY+0.015*(maxY-minY))*ones(size(t_ff)),'FaceColor',[0.1,0.1,0.1],'EdgeColor',[0.7,0.7,0.7]);
                area(t_ff,(minY+0.025*(maxY-minY))*ones(size(t_ff)),'FaceColor',[1.0,1.0,1.0],'EdgeColor',[1.0,1.0,1.0]);
            end
        end
        if do_area==0
            H(i)=shadedErrorBar(t, meanCycle(:,i), stdCycle(:,i), [{'Color',colors(i,:)},line_option], 0);
        else
            area(t,meanCycle(:,i),line_option{:});%,'Color',colors(i,:),line_option);
        end
        %H(i)=shadedErrorBar(t, meanCycle(:,i), stdCycle(:,i), {'-','Color',colors(i,:),'LineWidth',2}, 0);
        %lH = [lH H(i).patch];
        %lH = [lH H(i).mainLine];
        if(do_subplot)
            if(do_title)
                title(leg(i))
            end
            if(do_ylim)
                ylim([minY maxY]);
            end
        end
        if(do_changeYTicks)
            L = get(gca,'YLim');
            fac = 10^((round(log10(L(2)-L(1))))-2);
            set(gca,'YTick',round(linspace(L(1),L(2),numYticks)/fac)*fac);
        end
        if do_tight
            set(gca, 'XTickLabel', [],'XTick',[],'YTickLabel', [],'YTick',[]);
        end
    end
   
    
    if(do_title)
        if ~do_subplot

            legend(lH,leg);
        end
        legend boxoff
        xlabel('Gait cycle (%)');
    end    
    if(do_ylim)
        ylim([minY maxY]);
    end
end