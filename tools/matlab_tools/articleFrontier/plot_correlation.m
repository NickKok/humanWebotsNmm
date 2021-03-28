function h=plot_correlation(data,leg,varargin)
    opt_rotate = false;
    opt_transpose = false;
    opt_compareWith = 1;
    opt_bar = false;
    opt_dontShow = false;
    for i=1:2:length(varargin)
        if strcmp(varargin{i}, 'rotate')
            if(varargin{i+1} == 1)
                opt_rotate = true;
            end
        elseif strcmp(varargin{i}, 'transpose')
            if(varargin{i+1} == 1)
                opt_transpose= 1;
            end
        elseif strcmp(varargin{i}, 'compareWith')
            opt_compareWith= varargin{i+1};
        elseif strcmp(varargin{i}, 'bar')
            opt_bar= varargin{i+1};
            opt_transpose = false;
        elseif strcmp(varargin{i}, 'dontShow')
            opt_dontShow= true;
        else
            disp('error, unknown parameters');
            return;
        end
    end


    cc = [];
    for i=1:size(data,3)
        temp=corr(data(:,:,i)')';
        cc(:,i) = temp(:,opt_compareWith);
    end
    if(opt_bar)
        h=-1;
        if(opt_dontShow)
            cc = cc(setdiff(1:size(cc,1),opt_compareWith),:);
            bar(cc');
        else
            bar(cc');
            hold on;
            cc2 = zeros(size(cc));
            cc2(opt_compareWith,:)=1.0;
            bar(cc2','k');
        end
    else
        h=figure;
        if(opt_transpose)
            imagesc(cc')
        else
            imagesc(cc)
        end
    end
    if(nargin > 2)
        if(opt_transpose)
            set(gca,'ytick',1:size(data,3));
            set(gca,'yticklabel',strrep(leg,'\_','_'));
        else
            if(opt_rotate)
                xticklabel_rotate(1:size(data,3), 45, leg, 'FontSize',12);
            else
                set(gca,'xtick',1:size(data,3));
                set(gca,'xticklabel',strrep(leg,'\_','_'));
            end
        end
    end
end