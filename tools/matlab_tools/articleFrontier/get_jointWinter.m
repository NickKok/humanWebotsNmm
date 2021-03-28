function [mean,std] = get_jointWinter(speed,what)
    
    if nargin == 0
        speed = '1.3';
    end
    
    if strcmp(speed,'1.3')
        w='normal_walking__n19';
    elseif strcmp(speed,'1.6')
        w='fast_walking__n17';
    elseif strcmp(speed,'1.0')
        w='slow_walking__n19';
    end
    
    if(strcmp(what,'angle'))
        factor = [-1, 1, -1];
    else
        factor = [1, -1, 1];
        if(strcmp(speed,'1.6'))
            factor= [-1, 1, -1].*factor;
        end
    end
    
    
        
    
    disp([w ' data loading...']);
    tic
    winterData = extract_winterData();

    meanCycle_winter = winterData.(what).(w).data(:,2:2:6);
    stdCycle_winter = winterData.(what).(w).data(:,3:2:7);
    mean=change_length(meanCycle_winter,1000);
    
    for i=1:3
        mean(:,i) = factor(i)*mean(:,i);
    end
    
    std = change_length(stdCycle_winter,1000);
    
    toc
end