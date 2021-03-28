function hFig = plot_meanJointTorques(id,raw_file_folder)
    if nargin==1
        raw_file_folder = 'sessionArticlFrontier';
    end
    %% Init
    config = conf();
    dir = [config.raw_filedir '/' raw_file_folder ]; % directory where to look for raw files
    knot = 1000;
    tic
    disp('Data loading...')
    footFall = extract_rawFile(dir,config.raw_filename.footfall,id);
    stance_percentage = extract_stancePercentage(footFall);
    winterData = extract_winterData();
    toc

    %% Joint torque
    toKeep = 1:3;
    what = config.raw_filename.joints_force;
    data = extract_rawFile(dir,what,id);
    out = signal_analysis(data,footFall,toKeep,knot);
    stdCycle = reshape(out.signalStd(:,1,:),3,knot)';
    varCycle = reshape(out.signalVar(:,1,:),3,knot)';
    meanCycle = reshape(out.signalMean(:,1,:),3,knot)';
    meanCycle(:,2) = meanCycle(:,2)*-1;

    %w='slow_walking__n19';
    %w='fast_walking__n17';
    w='normal_walking__n19';
    meanCycle_winter = winterData.torque.(w).data(:,2:2:6);
    stdCycle_winter = winterData.torque.(w).data(:,3:2:7);
    stancePercentage_winter = winterData.stance_percentage.(w);

    stdCycle_winter=change_length(stdCycle_winter,1000);
    meanCycle_winter=change_length(meanCycle_winter,1000);

    %meanCycle_winter=change_stancePercentage(meanCycle_winter,stancePercentage_winter,stance_percentage);
    %stdCycle_winter=change_stancePercentage(stdCycle_winter,stancePercentage_winter,stance_percentage);

    diag(corr(meanCycle_winter,meanCycle))

    hFig=figure;
    plot_meanSignal(meanCycle_winter,stdCycle_winter,data.legend.one_side,{'Color','k'},{'subplot',[3,1], 'ylim',[-1.2, 2]})
    h=plot_meanSignal(meanCycle/80,stdCycle/80,data.legend.one_side,{'LineStyle','-'},{'subplot',[3,1], 'returnSubplotHandler',[2,1],'numYTicks',5});
    ylabel(h,'Torque (N m kg^{-1})');
    set(hFig, 'Position', [0,0,300,440])
    %set(hFig, 'Position', [0,0,380,500])
end