function plot_subplot(x,y,varargin)
    if nargin < 2
        disp('error 2 argument needed');
        return;
    end
    
    [numSubplot, dimSubplot] = min(size(y));
    
    if(dimSubplot == 1)
        y = y';
    end
    for i=1:numSubplot;
        subplot(7,1,i);  
        plot(linspace(0,1,size(y,1)),y(:,i),varargin); 
    end;
        
end