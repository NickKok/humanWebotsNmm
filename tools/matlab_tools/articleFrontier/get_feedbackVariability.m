function out=get_feedbackVariability(id,raw_file_folder,type)
    if nargin==1
            raw_file_folder = 'sessionArticleFrontier';
    end
    if nargin > 1 && isempty(raw_file_folder)
        raw_file_folder = 'sessionArticleFrontier';
    end 
    if nargin < 3
        type = 'variability';
    end
    %% Init
    config = conf();
    dir = [ config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files

    knot = 1000; % number of knot for the spline interploation
    what1 = config.raw_filename.feedbacks;


    %% Data loading
    disp('Data loading...')
    tic
    signalRaw_fdb = extract_rawFile(dir,what1,id); % extract muscles activity
    time = signalRaw_fdb.time;
    footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
    toKeep_left = signalRaw_fdb.left;
    signalNum = length(toKeep_left);
    toKeep_right = signalRaw_fdb.right;
    toc

    %% Data processing

    disp('Data processing...')
    tic
    skip=10;
    out_fdb = signal_analysis(signalRaw_fdb,footFall,toKeep_left,knot,1,skip);
    out_fdb_right = signal_analysis(signalRaw_fdb,footFall,toKeep_right,knot,2,skip);
    toc

    cycleNum = out_fdb.signalSplitNumber;
    getSplitSig = @(x,i,j) reshape(x.signalSplit(j,i,1:end,:),size(x.signalSplit,3),1000)'; 
    getSplitCycle = @(x,j) getSplitSig(x,1,j);
    getSplitStance = @(x,j) getSplitSig(x,2,j);
    getSplitFinishingStance = @(x,j) getSplitSig(x,4,j);
    getSplitSwing = @(x,j) getSplitSig(x,3,j);

    getMeanSig = @(x,i,j) reshape(x.signalMean(j,i,:),length(j),knot)'; 
    getMeanCycle = @(x,i) getMeanSig(x,1,i);
    getMeanStance = @(x,i) getMeanSig(x,2,i);
    getMeanFinishingStance = @(x,i) getMeanSig(x,4,i);
    getMeanSwing = @(x,i) getMeanSig(x,3,i);

    getMeanSigs = @(x,i) reshape(x.signalMean(:,i,:),size(x.signalMean,1),knot)'; 
    getMeanCycles = @(x) getMeanSigs(x,1);
    getMeanStances = @(x) getMeanSigs(x,2);
    getMeanSwings = @(x) getMeanSigs(x,3);

    getStdSigs = @(x,i) reshape(x.signalStd(:,i,:),size(x.signalStd,1),knot)'; 
    getStdCycles = @(x) getStdSigs(x,1);
    getStdStances = @(x) getStdSigs(x,2);
    getStdSwings = @(x) getStdSigs(x,3);

    getVarSigs = @(x,i) reshape(x.signalVar(:,i,:),size(x.signalVar,1),knot)'; 
    getVarCycles = @(x) getVarSigs(x,1);
    getVarStances = @(x) getVarSigs(x,2);
    getVarSwings = @(x) getVarSigs(x,3);



    stdCycle_fdb = getStdCycles(out_fdb);
    varCycle_fdb = getVarCycles(out_fdb);
    meanCycle_fdb = getMeanCycles(out_fdb);
    meanCycle_fdb_right = getMeanCycles(out_fdb_right);
    stance_percentage = extract_stancePercentage(footFall);


    %% LEFT RIGHT ASSYMETRY
    %plot(meanCycle_fdb,'--')
    %hold on;
    %plot(meanCycle_fdb_right)
    %% FEEDBACK REPRODUCTION CORRELATION
    leg = strrep({signalRaw_fdb.textdata{toKeep_left}},'_','\_');

    findIn = @(in,what) find(cellfun(@isempty,strfind(in, what))==0);

    stanceFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_stance');
    swingFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_swing');
    finishingStanceFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_finishingstance');
    cycleFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_cycle');
    angleoffsetFdb = findIn({signalRaw_fdb.textdata{toKeep_left}},'_angleoffset');

    %minimum correlation
    cycleNum = out_fdb.signalSplitNumber;
    clear s s_std*
    for i=1:signalNum
        if(sum(stanceFdb==i))
            m=repmat(getMeanStance(out_fdb,i),1,cycleNum);
            s_left=getSplitStance(out_fdb,i);
            s_right=getSplitStance(out_fdb_right,i);
        elseif(sum(swingFdb==i) || sum(angleoffsetFdb==i))
            m=repmat(getMeanSwing(out_fdb,i),1,cycleNum);
            s_left=getSplitSwing(out_fdb,i);
            s_right=getSplitSwing(out_fdb_right,i);
        elseif(sum(cycleFdb==i))
            m=repmat(getMeanCycle(out_fdb,i),1,cycleNum);
            s_left=getSplitCycle(out_fdb,i);
            s_right=getSplitCycle(out_fdb_right,i);
        elseif(sum(finishingStanceFdb==i))
            m=repmat(getMeanFinishingStance(out_fdb,i),1,cycleNum);
            s_left=getSplitFinishingStance(out_fdb,i);
            s_right=getSplitFinishingStance(out_fdb_right,i);
        else
            disp(['error with feedback ' num2str(i)]);
        end
        s = zeros(size(s_left,1),size(s_right,2)+size(s_left,2));
        try
            s(:,2:2:end) = s_left;
            s(:,1:2:end) = s_right;
        catch 
            s(:,1:2:end) = s_left;
            s(:,2:2:end) = s_right;
        end

        mm(i) = abs(mean(m(:,1)));
        ss(i) = std(m(:,1));
        autocorr=xcorr(mean(s_right,2));
        [maxautocorr,maxautocorrPos]=max(autocorr);
        
        crosscorr=xcorr(mean(s_right,2),mean(s_left,2));
        [~,maxcrosscorrPos]=max(crosscorr);
        
        cc_sim(i) = corr(mean(s_right,2),mean(s_left,2));
        
        cc_lag(i) = abs(maxcrosscorrPos-1001)/1000;
        s_std(:,i) = std(s,0,2);
        len=min([size(s_left,2) size(s_right,2)]);

    end
    
    if(strcmp(type,'variability'))
        out = mean(s_std([1:150 end-150:end],:));
    elseif(strcmp(type,'mean'))
        out = mm;
    elseif(strcmp(type,'amplitude'))
        out = ss;
    elseif(strcmp(type,'left_right_lag'))
        out = cc_lag;
    elseif(strcmp(type,'left_right_sim'))
        out = cc_sim;
    elseif(strcmp(type,'all'))
        fdbVar=mean(s_std([1:150 end-150:end],:));
        fdbMean=mm;
        fdbAmp=ss;
        fdbLeftRightLag=cc_lag;
        fdbLeftRightSim=cc_sim;
        out = [ fdbVar; fdbMean; fdbAmp; fdbLeftRightLag; fdbLeftRightSim];
    end
    %I = I;
end