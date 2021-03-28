function out=load_data(suffix,ids,varargin)
    out = struct;
    out.feedback = struct;
    out.energy = struct;
    out.golden_ratio = struct;
    out.muscle = struct;
    out.jointAngle = struct;
    out.jointTorque = struct;
    
    
    out.jointName = get_jointName;
    out.feedbackName = get_feedbackName;
    out.muscleName = get_muscleName;
    
    prefix = '';
    load_from_file = true;
    factor = 10;
    if nargin < 1
        suffix = '1.0';
        ids = 1:10; 
    end
    if nargin < 2
        ids = 1:10;
    end
    
    if nargin > 2
        for i=1:2:length(varargin)
            if strcmp(varargin{i},'load_from_file')
                load_from_file = varargin{i+1};
            end
            if strcmp(varargin{i},'prefix')
                prefix = varargin{i+1};
            end
            if strcmp(varargin{i},'factor')
                factor = varargin{i+1};
            end
        end
    end

   
    
    path = ['sessionArticleFrontier_' suffix];
    
    out.path = path;
    %% LOADING DATA
    
    if load_from_file
        load(['articleFrontier/energy_' suffix prefix '.mat']);
        load(['articleFrontier/fdbVar_' suffix prefix '.mat']);
        load(['articleFrontier/fdbLeftRight_' suffix prefix '.mat']);
        load(['articleFrontier/fdbMean_' suffix prefix '.mat']);
        load(['articleFrontier/fdbAmp_' suffix prefix '.mat']);
        load(['articleFrontier/fdbAct_' suffix prefix '.mat']);
        load(['articleFrontier/muscleAct_' suffix prefix '.mat']);
        load(['articleFrontier/muscleMP_' suffix prefix '.mat']);
        load(['articleFrontier/jointTorque_' suffix prefix '.mat']);
        load(['articleFrontier/jointAngle_' suffix prefix '.mat']);
        load(['articleFrontier/grf_' suffix prefix '.mat']);
        load(['articleFrontier/gR_' suffix prefix '.mat']);        
        load(['articleFrontier/speed_' suffix prefix '.mat']);


    else
        %% 
        %% Speed
        speed = [];
        for id = ids
           speed(id) = get_speed(id*factor,path);
        end
        save(['./articleFrontier/speed_' suffix prefix '.mat'],'speed');
        %% Energy
        disp('generating energy...')
        CoT = [];
        for id = ids
           E = get_energyConsumption(id*factor,path);
           CoT(id) = E.energy/E.distance;
        end
        save(['./articleFrontier/energy_' suffix prefix '.mat'],'CoT');
        %% Get all feedback variabilities
        disp('generating feedback data...')
        fdbVar = [];
        fdbMean = [];
        fdbAmp = [];
        fdbLeftRightLag = [];
        fdbLeftRightSim = [];
        for id = ids
           out2 = get_feedbackVariability(id*factor,path,'all');
           fdbVar(id,:) = out2(1,:);
           fdbMean(id,:) = out2(2,:);
           fdbAmp(id,:) = out2(3,:);
           fdbLeftRightLag(id,:) = out2(4,:);
           fdbLeftRightSim(id,:) = out2(5,:);
        end  
        save(['./articleFrontier/fdbVar_' suffix prefix '.mat'],'fdbVar');
        save(['./articleFrontier/fdbLeftRight_' suffix prefix '.mat'],'fdbLeftRightLag','fdbLeftRightSim');
        save(['./articleFrontier/fdbMean_' suffix prefix '.mat'],'fdbMean');
        save(['./articleFrontier/fdbAmp_' suffix prefix '.mat'],'fdbAmp');
        
        %% Feedback activities
        fdbAct = [];
        for id = ids
           fdbAct(id,:,:) = get_feedbacksActivity(id*factor,path);
        end
        save(['./articleFrontier/fdbAct_' suffix prefix '.mat'],'fdbAct');
        %% Muscles activities
        disp('generating muscles data...')
        muscleAct = [];
        for id = ids
           muscleAct(id,:,:) = get_musclesActivity(id*factor,path);
        end
        save(['./articleFrontier/muscleAct_' suffix prefix '.mat'],'muscleAct');
        %% MotorPrimitives
        MP4 = get_musclePrimitives(muscleAct,4);
        MP3 = get_musclePrimitives(muscleAct,3);
        muscleMP.MP4 = MP4;
        for id=ids
            m = reshape(muscleAct(id,:,:),1000,7);
            mrec = reshape(muscleMP.MP4.MP(id,:,:),1000,muscleMP.MP4.MP_Number)*reshape(muscleMP.MP4.W(id,:,:),muscleMP.MP4.MP_Number,7);
            muscleAct_rec(id,:,:) = mrec;
            cc(id,:) = diag(corr(m,mrec));
        end
        muscleMP.MP4.reconstructionCorrelation = cc;
        muscleMP.MP3 = MP3;
        for id=ids
            m = reshape(muscleAct(id,:,:),1000,7);
            mrec = reshape(muscleMP.MP3.MP(id,:,:),1000,muscleMP.MP3.MP_Number)*reshape(muscleMP.MP3.W(id,:,:),muscleMP.MP3.MP_Number,7);
            muscleAct_rec(id,:,:) = mrec;
            cc(id,:) = diag(corr(m,mrec));
        end
        muscleMP.MP3.reconstructionCorrelation = cc;
        save(['./articleFrontier/muscleMP_' suffix prefix '.mat'],'muscleMP');
        %% Joint torques
        disp('generating joint torques data...')
        jointTorque = [];
        for id = ids
           jointTorque(id,:,:) = get_jointTorques(id*factor,path);
        end
        save(['./articleFrontier/jointTorque_' suffix prefix '.mat'],'jointTorque');
        %% Joint angles
        disp('generating joint angles data...')
        jointAngle = [];
        for id = ids
           jointAngle(id,:,:) = get_jointAngles(id*factor,path);
        end
        save(['./articleFrontier/jointAngle_' suffix prefix '.mat'],'jointAngle');
        %% GRF
        disp('generating grf data...')
        grf = [];
        for id = ids
           grf(id,:,:) = get_grf(id*factor,path);
        end
        save(['./articleFrontier/grf_' suffix prefix '.mat'],'grf');
        %% Golden ratio
        disp('generating golden ratio data...')
        grL = [];
        grR = [];
        for id = ids
           [grL(:,id), grR(:,id)] = extract_goldenRation(get_footFall(id*factor,path));
        end
        save(['./articleFrontier/gR_' suffix prefix '.mat'],'grR','grL');
    end

    
    %% GENERATING EXTRA VARIABLES 
    
    [~,e_order] = sort(CoT);
    [~,gr_order] = sort(abs(grR(3,:)-gr));

    [~, inv_e_order] = sort(e_order);
    [~, inv_gr_order] = sort(gr_order);
    
    mff = [5 7 9 6];
    mlf = [8 11 10 14 13];
    gsif = [2 1 3];
    gcf = 12;
    tlf = 4;
    jop = 15;

    if strcmp(suffix,'wavy') || strcmp(suffix,'wavy2')
        suffix = '1.3';
    end
    feedback_order = [mff mlf gsif gcf tlf];
    [m,s] = get_jointWinter(suffix,'torque');
    
    out.jointTorque.human = m;
    out.jointTorque.humanStd = s;
    
    
    [m,s] = get_jointWinter(suffix,'angle');
    out.jointAngle.human = m;
    out.jointAngle.humanStd = s;
    
    %% SAVE VARIABLE

    out.speed = speed;
    
    out.energy.CoT = CoT;
    out.energy.order = e_order;
    out.energy.order_inv = inv_e_order;

    out.feedback.variability = fdbVar;
    out.feedback.leftRightLag = fdbLeftRightLag;
    out.feedback.leftRightSim = fdbLeftRightSim;
    out.feedback.mean = fdbMean;
    out.feedback.amplitude = fdbAmp;
    out.feedback.signals = fdbAct;
    out.feedback.order = feedback_order;
    
    out.muscle.signals = muscleAct;
    out.musclePrimitives = muscleMP;
    out.jointTorque.model = jointTorque;
    out.jointAngle.model = jointAngle;
    out.grf.model = grf;
    
    
    out.golden_ratio.left = grL;
    out.golden_ratio.right = grR;
    out.golden_ratio.order = gr_order;
    out.golden_ratio.order_inv = inv_gr_order;
end