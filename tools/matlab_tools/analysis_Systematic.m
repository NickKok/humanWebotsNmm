%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ANALYSIS SYSTEMATIC STUDY %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Feedback systematic study %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters name
fitnessName=get_systematicFitnessName();
feedbackOrder=[7 8 9 5 6 15 12 1 13 3 14 4 2 10 11];
%feedbackOrder=[7 8 9 5 6 12 1 13 3 14 4 2 10 11];
[~,feedback]=sort(feedbackOrder);
feedbackName=get_feedbackName;
feedbackName{end+1}= 'VAS<-KNEE OPF';
feedbackName = feedbackName(feedbackOrder);

%% LOAD DATA
rawSystematic_1cst=extract_rawSystematic('articleFrontier','combinaisonStudy','1cst');
rawSystematic_1cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','1cpg');

rawSystematic_6cst=extract_rawSystematic('articleFrontier','combinaisonStudy','6cst');
rawSystematic_6cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','6cpg');

rawSystematic_10cst=extract_rawSystematic('articleFrontier','combinaisonStudy','10cst');
rawSystematic_10cpg=extract_rawSystematic('articleFrontier','combinaisonStudy','10cpg');

%% PLOT: combinaison limit
mean_0 = @(x) sum(x) ./ (sum(x~=0));
s = size(rawSystematic_1cst.p_values);
E_cst = [];
E_cst(1,:,:) = rawSystematic_1cst.fitness.ENERGY.*(1-rawSystematic_1cst.fitness.FALLED);
E_cst(2,:,:) = rawSystematic_6cst.fitness.ENERGY.*(1-rawSystematic_6cst.fitness.FALLED);
E_cst(3,:,:) = rawSystematic_10cst.fitness.ENERGY.*(1-rawSystematic_10cst.fitness.FALLED);
E_cst(E_cst==0)=NaN;

Speed_cst = [];
Speed_cst(1,:,:) = rawSystematic_1cst.fitness.ENERGY.*(1-rawSystematic_1cst.fitness.FALLED);
Speed_cst(2,:,:) = rawSystematic_6cst.fitness.ENERGY.*(1-rawSystematic_6cst.fitness.FALLED);
Speed_cst(3,:,:) = rawSystematic_10cst.fitness.ENERGY.*(1-rawSystematic_10cst.fitness.FALLED);
Speed_cst(Speed_cst==0)=NaN;



boxplot((reshape(E_cst(1,:,:),s)))