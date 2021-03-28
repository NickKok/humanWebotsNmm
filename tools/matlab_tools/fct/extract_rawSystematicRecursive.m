function out=extract_rawSystematicRecursive(conf,folder,prefix, suffix, varargin)
    fitnessName=get_systematicFitnessName();
    
    
    
    if nargin==0
        conf='articleFrontier';
        prefix='combinaisonStudy';
        suffix='6cst';
    end
    
    if nargin == 4
        repeat='';
    else
        repeat=varargin{1};
    end

    parametersInfo=importdata(['../../current/webots/conf_' conf '/systematic_search/' prefix]);
    disp(              ['../../current/systematicsearch_data/' folder '/' prefix suffix '_fitness' repeat])
    fitness=importdata(['../../current/systematicsearch_data/' folder '/' prefix suffix '_fitness' repeat]);
    state=importdata(['../../current/systematicsearch_data/' folder '/' prefix suffix '_state' repeat]);

    
    disp(['Extracting ' prefix suffix ]);
    
    parameterNumber=(size(state,2)-3)/2;



    start = 1+(parameterNumber+1);
    [parametersValue,index,~]=unique(state(:,start:start+1),'rows');

    stepNumber=length(unique(parametersValue(:,1)));



    falled=1-state(:,end-1);

    fitness_notFalled = fitness;
    fitness_notFalled(find(falled),:)=nan;

    out.p_index = index;
    out.p_info = parametersInfo;
    out.p_values = parametersValue;
    out.state = state;
    out.fitness = fitness;
    out.fitness_notFalled = fitness_notFalled;
    
    out.fit.speedMean = out.fitness_notFalled(:,2);
    out.fit.speedInst = out.fitness_notFalled(:,3);
    out.fit.EoD = out.fitness_notFalled(:,4)./out.fitness_notFalled(:,6);
    out.fit.EoT = out.fitness_notFalled(:,4)./out.fitness_notFalled(:,7);
    out.fit.cycleLength = out.fitness_notFalled(:,end-2);
    out.fit.stanceDurationLeft = out.fitness_notFalled(:,10);
    out.fit.swingDurationLeft = out.fitness_notFalled(:,9);
    out.fit.stanceEndDurationLeft = out.fitness_notFalled(:,8);
    out.fit.stanceDurationRight = out.fitness_notFalled(:,13);
    out.fit.swingDurationRight = out.fitness_notFalled(:,12);
    out.fit.stanceEndDurationRight = out.fitness_notFalled(:,11);
    out.fit.stanceDuration = 0.5*(out.fit.stanceDurationLeft+out.fit.stanceDurationRight);
    out.fit.swingDuration = 0.5*(out.fit.swingDurationLeft+out.fit.swingDurationRight);
    out.fit.stanceEndDuration = 0.5*(out.fit.stanceEndDurationLeft+out.fit.stanceEndDurationRight);
    
    
end
