function y = removeOutliers(x,sign,threshold)
% removeOutliers : remove outliers from vector 1-D vector x
% TWO METHODS
%   simple threshold        : y = removeOutliers(x, threshold,sign);
%   derivative threshold    : y = removeOutliers(x, sign); 
%
%   sign : +1 / -1

    if size(x,1) == 1
        x = x';
    end
    if nargin == 1
        %separate the data set into part part
        factor = 10;
        stepsize = round(size(x,1)/factor);
        ctn = true;
        from = 1;
        length = size(x,1);
        y = NaN*ones(size(x));
        for from=1:1:length
            if(from+stepsize > length)
                to = length;
            else
                to = from+stepsize;
            end
            try
                xt = x(from:to);
                m = mean(xt);
                s = std(xt);
                %xt
                %xt = (removeOutliers(xt,1,m+5*s));
                %xt
                xt = removeOutliers(removeOutliers(xt,1,m+2*s),-1,m-2*s);
                %notnan = find(~isnan(xt));
                %x(notnan) = xt(notnan);
                y(from:to) = xt;
            catch
                disp('some value not taken into account');
            end
        end
        size(find(isnan(y)))
        y(isnan(y)) = x(isnan(y));
%         while(ctn)
%             if(from+stepsize > size(x,1))
%                 to = size(x,1);
%                 ctn = false;
%             else
%                 to = from+stepsize;
%             end
%             y(from:to) = removeOutliers(removeOutliers(x(from:to),1,mean(x(from:to))+2*std(x(from:to))),-1,mean(x(from:to))-2*std(x(from:to)));
%             from = from+stepsize+1; 
%         end
    elseif nargin == 2
        xd = derivatives(x,1);
        xd_mean = mean(xd);
        xd_std = std(xd);
        from = 0;
        to = 0;
        absurd_i = zeros(1,size(x,1));
        if sign == -1
            for I=1:size(x)
                if xd(I) < xd_mean - 7*xd_std && to == 0
                    from = I;
                end
                if xd(I) > xd_mean + 7*xd_std && from ~= 0
                    to = I;
                end 
                if from ~= 0 && to ~= 0
                    absurd_i(from:to) = 1;
                    from = 0;
                    to = 0;
                end
            end
        else
            for I=1:size(x)
                if xd(I) > xd_mean + 7*xd_std && to == 0
                    from = I;
                end
                if xd(I) < xd_mean - 7*xd_std && from ~= 0
                    to = I;
                end 
                if from ~= 0 && to ~= 0
                    absurd_i(from:to) = 1;
                    from = 0;
                    to = 0;
                end
            end
        end
        norm_values     = find(not(absurd_i))';
        temp = int32(linspace(norm_values(end)+1,size(x,1),size(x,1)-1-norm_values(end)));
        if(norm_values(end) < size(x,1))
            norm_values(size(norm_values,1)+1:size(norm_values,1)+size(temp,2)) = temp';
        end

        % interpolate
        y = interp1(norm_values, x(norm_values),1:1:size(x));
    elseif (nargin == 3)
        if(sign == 1)
            norm_values     = find(not(x>threshold));
        elseif(sign == -1)
            norm_values     = find(not(x<threshold));
        end
       if(norm_values(1) ~= 1)
           norm_values = [1 ; norm_values];
           x(1) = mean(x);
       end
        % interpolate
        y = interp1(norm_values, x(norm_values),1:1:size(x));
    else
        y = x;
    end
end