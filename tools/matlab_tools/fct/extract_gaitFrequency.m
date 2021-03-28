function freq = extract_gaitFrequency(footFall,side)

    dF=diff(footFall.data(:,footFall.left));
    dF=find(dF==1);
    freqL = mean((dF(10:end)-dF(9:end-1))/1000.);

    dF=diff(footFall.data(:,footFall.right));
    dF=find(dF==1);
    freqR = mean((dF(10:end)-dF(9:end-1))/1000.);

    if(nargin == 1)
        freq = freqL/2+freqR/2;
        freq = 1/freq;
    elseif side == 1
        freq = 1/freqL;
    elseif side == 2
        freq = 1/freqR;
    end
    
end