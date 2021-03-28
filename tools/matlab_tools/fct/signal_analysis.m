function out = signal_analysis(rawSignal,footFall,signal2Keep, Knot, side,skip)
    % SIGNAL_ANALYSIS() returns the mean cycles of the input.
    % The input should be the output of the split_byEvent function
    %
    %  out = signal_analysis(Input,Id,Knot)
    %
    % Input : raw_filename (one of the config.raw_filename entries)
    % Id : id of the raw file (default 1)
    % signal2Keep : vector of signals you want to keep
    % Knot : number of knot used for the interpolation (default 100)
    
    config = conf();
    dir = config.raw_filedir; % directory where to look for raw files

    if(nargin < 4) 
        Knot = 100; % number of knot for the spline interploation
    end
    if(nargin < 5)
        side = 1;
    end
    if(nargin < 6)
        skip = 0;
    end
    
    sideContra=1;
    if(side==1)
        sideContra=2;
    end
    %% Extract data
    out = struct;
    %% Generate liftoff touchdown vector
    ev = extract_gaitEvent(footFall.data(:,side),config.gait_event.liftOff_touchDown);
    evContra = extract_gaitEvent(footFall.data(:,sideContra),config.gait_event.liftOff_touchDown);
    %% Split muscles activity
    
    out.signalSplit = split_byEvent(rawSignal.data(:,signal2Keep),rawSignal.time,ev,evContra,Knot,skip);
    out.signalSplitNumber = size(out.signalSplit,length(size(out.signalSplit))-1);
    out.signalMean = split_getMean(out.signalSplit);
    out.signalStd = split_getStd(out.signalSplit);
    out.signalVar = split_getVar(out.signalSplit);
    %% Normalization
    [out.signalNorm,out.signalNormData] = split_normalize(out.signalSplit);
    %% Stereotyped shape
    out.signalStereotypedShape = split_getMean(out.signalNorm);
   
end