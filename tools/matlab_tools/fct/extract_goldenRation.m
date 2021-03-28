function varargout = extract_goldenRation(footfall)
    left=footfall.data(:,footfall.left);
    right=footfall.data(:,footfall.right);

    %everything starts at first left touchdown
    LT = find(diff(left)==1);
    %then comes right take off
    RO = find(diff(right)==-1);
    RO = RO(find(RO>LT(1),1):end);
    %then comes right touchdown
    RT = find(diff(right)==1);
    RT = RT(find(RT>RO(1),1):end);
    %then left take off comes
    LO = find(diff(left)==-1);
    LO = LO(find(LO>RT(1),1):end);

    nCycle = min([length(RT),length(RO), length(LT), length(LO)]);
    LT = LT(1:nCycle);
    RO = RO(1:nCycle);
    RT = RT(1:nCycle);
    LO = LO(1:nCycle);


    % cycle duration
    C_L = diff(LT);
    C_R = diff(RT);
    ST_L = LO-LT;
    ST_R = RO(2:end)-RT(1:end-1);
    SW_L = LT(2:end)-LO(1:end-1);
    SW_R = RT-RO;

    Dbl_L = RO-LT;
    Dbl_R = LO-RT;
    
    c_l = mean(C_L);
    c_r = mean(C_R);
    sw_l = mean(SW_L);
    sw_r = mean(SW_R);
    st_l = mean(ST_L);
    st_r = mean(ST_R);
    dbl_l = mean(Dbl_L);
    dbl_r = mean(Dbl_R);
    
    

    if(nargout > 0)
        varargout{1} = [c_l/st_l st_l/sw_l sw_l/(dbl_l+dbl_r)];
    end
    if(nargout > 1)
        varargout{2} = [c_r/st_r st_r/sw_r sw_r/(dbl_l+dbl_r)];
    end
    
end