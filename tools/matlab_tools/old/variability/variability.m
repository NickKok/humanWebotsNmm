function y = variability(x,varargin)
    % VARIABILITY returns the variability of the 2D signal (made along
    % dimension dim)
    
    if (length(x) == 0)
        y = nan;
    else
        filtfilt(0.1*ones(1,10),1,x);
        dim = 2;
        if nargin == 2
            dim = varargin{1};
        end

        [s,I] = max(std(x,0,dim));
        m = mean(x,2);


        y=s/abs(m(I));
    end
end