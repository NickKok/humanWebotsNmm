function [signals, stance, swing] = split_byEvent(in,time,ev,evContra,Knot,skip)
    % SPLIT_BYEVENT() splits the input vector (1xN) into 3xM subvectors where M is
    % the number of event present in the event vector.
    % The subvectors are interpolated using spline so that each of them
    % have the same length. 
    % If the input vector is of dimension 1, the output is a 3xMxKnot matrices.
    % If the input vector is of dimension N>2, output is a Nx3xMxKnot
    % matrices.
    % Where Knot is the number of point used for the spline interpolation (default Knot=1000)
    %
    %  out = split_byEvent(Input,Event,Knot)
    %
    % Input : input vector
    % Event : event vector (output of extract_gaitEvent(footfall,4))
    
    if ( nargin < 4)
        Knot = 100;
    end
    
    if (size(in,1) < size(in,2))
        in = in';
    end
    
    if ( nargin < 5 )
        skip = 0;
    end
    
    % CYCLE SHORTER THAN THRESHOLD ARE NOT TAKEN INTO ACCOUNT
    Threshold = 0.2; %s
    dt = time(2)-time(1);

    splitposContra = find(evContra==1); % touch down event
    splitpos = find(ev==1); % touch down event
    splitpos_StSw = find(ev==-1); % lift off event
    
    %if(size(in,2) > 1)
    %    signals = zeros(size(in,2),3,length(splitpos)-1,Knot);
    %else
    %    signals = zeros(3,length(splitpos)-1,Knot);
    %end
    
    % Ensure correct split pos
    first_after = @(this,in) find(this < in,1);
    resize = @(this,in) in(first_after(this,in):end);
    
    if(splitpos(1) > splitposContra(1))
        splitposContra = resize(splitpos(1),splitposContra);
    end
    if(splitpos(1) > splitpos_StSw(1))
        splitpos_StSw = resize(splitpos(1),splitpos_StSw);
    end
    
    l=min([length(splitpos) length(splitposContra) length(splitpos_StSw)]);
    splitpos = splitpos(1:l);
    splitposContra = splitposContra(1:l);
    splitpos_StSw = splitpos_StSw(1:l);
    
    
    % SPLIT THE SIGNALS
    corr = 0;
    for i=1+skip:length(splitpos)-2
        [seq,seq_stance,seq_swing,seq_finishingstance] = get_sequences(i);
                
        
        % make spline
        if(...
            length(seq) > Threshold/dt && ...
            length(seq_stance) > Threshold/dt/2 && ...
            length(seq_swing) > Threshold/dt/2 ...
            )
            if(size(in,2) == 1)
                signals(1,i-corr-skip,:) = spline_interpolant(in,time,seq,Knot);
                signals(2,i-corr-skip,:) = spline_interpolant(in,time,seq_stance,Knot);
                signals(3,i-corr-skip,:) = spline_interpolant(in,time,seq_swing,Knot);
                signals(4,i-corr-skip,:) = spline_interpolant(in,time,seq_finishingstance,Knot);
            else
                signals(:,1,i-corr-skip,:) = spline_interpolant(in,time,seq,Knot);
                signals(:,2,i-corr-skip,:) = spline_interpolant(in,time,seq_stance,Knot);
                signals(:,3,i-corr-skip,:) = spline_interpolant(in,time,seq_swing,Knot);
                signals(:,4,i-corr-skip,:) = spline_interpolant(in,time,seq_finishingstance,Knot);
            end
        else
            corr = corr + 1;
            fprintf('cycle %d length (%d) below threshold..skipping\n',i,length(seq));
        end
    end
    
    if (nargout == 3)
        if(size(in,2) == 1)
            stance = signals(2,:,:);
            swing = signals(3,:,:);
            signals = signals(1,:,:);
        else
            stance = signals(:,2,:,:);
            swing = signals(:,3,:,:);
            signals = signals(:,1,:,:);
        end
    end
    
    
    function [seq,seq_stance,seq_swing,seq_finishingstance] = get_sequences(i)
        % calculate the sequence for stance / swing / cycle
        seq = splitpos(i)+1:splitpos(i+1);
        
        from = splitpos;
        to = splitpos_StSw;
        seq_stance=get_seq(from,to,i);
        
        from = splitpos_StSw;
        to = splitpos(2:end);
        seq_swing=get_seq(from,to,i);
        
        from = splitposContra;
        to = splitpos_StSw;
        try
        seq_finishingstance=get_seq(from,to,i);
        catch
            keyboard
        end
        
    end
    function seq=get_seq(from,to,i)
        if from(i) < to(i) && from(i+1) > to(i)
            seq = from(i)+1:to(i);
        else
            disp('strange behavior with cycle i');
        end
    end
    function out = spline_interpolant(x,t,seq,Knot)
        out = spline(...
                t(seq),...
                x(seq,:)',...
                linspace(t(seq(1)),t(seq(end)),...
                Knot));
    end
end