function out = extract_gaitEvent(ff, flag)
    % OUT = EXTRACT_FOOTFALL(FOOTFALL,FLAG)
    % FLAG = 0 : TOUCH DOWN
    % FLAG = 1 : LIFT OFF
    % FLAG = 2 : STANCE
    % FLAG = 3 : SWING
    % FLAG = 4 : LIFTOFF_TOUCHDOWN (-1 for lift off, 1 for touchdown
    out = zeros(size(ff));
    if(flag == 0)
        out(1:end-1) = (ff(1:end-1,1)-ff(2:end,1))>0;
    elseif(flag == 1)
        out(2:end) = (ff(1:end-1,1)-ff(2:end,1))<0;
    elseif(flag == 2)
        out = ff;
    elseif(flag == 3)
        out = 1-ff;
    elseif(flag == 4)
        temp = zeros(size(ff));
        temp(1:end-1) = ((ff(1:end-1,1)-ff(2:end,1))>0);
        out(2:end) = ((ff(1:end-1,1)-ff(2:end,1))<0) -temp(2:end);
    end
            
end