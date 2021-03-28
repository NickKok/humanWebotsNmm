function out=extract_rawSystematic(conf,folder,prefix, suffix, varargin)
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
    disp(['../../current/systematicsearch_data/' folder '/' prefix suffix '_fitness' repeat]);
    fitness=importdata(['../../current/systematicsearch_data/' folder '/' prefix suffix '_fitness' repeat]);
    state=importdata(['../../current/systematicsearch_data/' folder '/' prefix suffix '_state' repeat]);

    
    disp(['Extracting ' prefix suffix ]);
    
    
    falled=1-state(:,end-1);

    %parameterNumber=find(state(1,:)==-1, 1, 'last' )-1;
    parameterNumber=(size(state,2)-3)/2;
    parameters=[];
    parametersFitness=struct;
    parametersValue=[];
    for i=1:parameterNumber
        parameters(:,i) = find(state(:,i+1)~=-1);
        parametersValue(:,i) = state(parameters(:,i),1+i+parameterNumber);

    end
    stepNumber=size(parameters,1);
    
    parametersFitness.FALLED=zeros(size(parameters));
    for i=1:length(fitnessName)
        parametersFitness.(fitnessName{i})=zeros(size(parameters));
    end
    for i=1:parameterNumber
        parametersFitness.FALLED(:,i) = falled(parameters(:,i));
        for j=1:length(fitnessName)
            parametersFitness.(fitnessName{j})(:,i) = fitness(parameters(:,i),j);
        end
    end
    
    parametersFitness_discardFall=[];
    for i=1:length(fitnessName)
        notFalled=(1-parametersFitness.FALLED);
        notFalled(notFalled==0)=NaN;
        parametersFitness_discardFall.(fitnessName{i}) = parametersFitness.(fitnessName{i}).*notFalled;
    end
    
    % Find combinaison limit

    limit=parametersFitness.FALLED(2:end,:)-parametersFitness.FALLED(1:end-1,:);
    limit=[limit;1-sum(limit)];
    
    subrange=find(limit~=0 & limit~=1);
    ok=true;
    if ~isempty(subrange)
        disp('   -) it seems that for the following parameters, there is more than one stable range');
        disp(['        --> ' prefix suffix '<--']);
        disp('      stableUntil and stableMax fields will be different');
        ok=false;
    end
    
    lastrow = zeros(1,parameterNumber);
    lastrow(sum(parametersFitness.FALLED(2:end,:))==0) = 1.0;
    temp = [parametersFitness.FALLED;lastrow];
    
    if (sum(parametersFitness.FALLED(1,:)) ~= 0)
        disp('   -)  strange the gait was unstable with default parameters.');
        disp(['      strange ' num2str(find(parametersFitness.FALLED(1,:)==1))])
        temp(1,:)=0;
        disp('');
        ok=false;
    end
    
    if(ok)
        disp('   -)  ok !');
    end
    fall_after = diff(temp);    
    
    stableUntil = zeros(parameterNumber,1);
    stableMax = zeros(parameterNumber,1);
    stableUntil_pos = zeros(parameterNumber,1);
    stableMax_pos = zeros(parameterNumber,1);
    for i=1:parameterNumber
        stableUntil_pos(i) = find(fall_after(:,i)==1,1,'first');
        stableMax_pos(i) = find(fall_after(:,i)==1,1,'last');
        stableUntil(i) = parametersValue(stableUntil_pos(i),i);
        stableMax(i) = parametersValue(stableMax_pos(i),i);
    end
    
    out=struct;
    out.p_number = parameterNumber;
    out.p_stableUntil = stableUntil;
    out.p_stableUntil_pos = stableUntil_pos;
    
    out.p_stableMax = stableMax;
    out.p_stableMax_pos = stableMax_pos;
    
    out.p_values = parametersValue;
    out.p_names = parametersInfo.textdata(:,2);
    out.p_classes = parametersInfo.textdata(:,1);
    out.fitness = parametersFitness;
    out.fitness_discardFall=parametersFitness_discardFall;
    
    

    
    %% Order the feedback
    % In the same order than feedbacks extracted from rawData
    if sum(strcmp('sol_ta_mff_stance',out.p_names(:))) == 1
        feedbackOrder=[7 8 9 5 6 15 12 1 13 3 14 4 2 10 11];
        [~,feedbackOrderInv]=sort(feedbackOrder);
        out.p_stableUntil = out.p_stableUntil(feedbackOrderInv);
        out.p_stableMax = out.p_stableMax(feedbackOrderInv);
        out.p_stableUntil_pos = out.p_stableUntil_pos(feedbackOrderInv);
        out.p_stableMax_pos = out.p_stableMax_pos(feedbackOrderInv);
        out.p_values = out.p_values(:,feedbackOrderInv);
        out.p_names = out.p_names(feedbackOrderInv);
        out.p_classes = out.p_classes(feedbackOrderInv);

        fields = fieldnames(out.fitness);
        for i=1:length(fields)
            out.fitness.(fields{i}) = out.fitness.(fields{i})(:,feedbackOrderInv);
            if ~strcmp(fields{i},'FALLED')
                out.fitness_discardFall.(fields{i}) = out.fitness_discardFall.(fields{i})(:,feedbackOrderInv);
            end
        end
    end
end