function out = get_jointAnglesWinter(speed)
    
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
    
    disp('Data loading...')
    tic
    winterData = extract_winterData();

    meanCycle_winter = winterData.angle.(w).data(:,2:2:6);
    out=change_length(meanCycle_winter,1000);
    out(:,1) = out(:,1)*-1;
    out(:,3) = out(:,3)*-1;
    toc
end