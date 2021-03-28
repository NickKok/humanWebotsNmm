function combinaisonStudy = load_systematicCombinaisonStudy(what_cpg,what_cst,suffix)
    combinaisonStudy = struct;
    combinaisonStudy.cstData = struct;
    combinaisonStudy.cstData.FALLED = nan(10,11,15);
    combinaisonStudy.cstData.ENERGY = nan(10,11,15);
    combinaisonStudy.cstData.DISTANCE = nan(10,11,15);
    combinaisonStudy.cstData.MEAN_VELOCITY = nan(10,11,15);
    combinaisonStudy.cstData.MEAN_RIGHT_STEP_LENGTH = nan(10,11,15);
    combinaisonStudy.cstData.MEAN_LEFT_STEP_LENGTH = nan(10,11,15);

    combinaisonStudy.cstData.CoT = nan(10,11,15);
    combinaisonStudy.cstData.SL = nan(10,11,15);

    combinaisonStudy.cpgData = struct;
    combinaisonStudy.cpgData.FALLED = nan(10,11,15);
    combinaisonStudy.cpgData.ENERGY = nan(10,11,15);
    combinaisonStudy.cpgData.DISTANCE = nan(10,11,15);
    combinaisonStudy.cpgData.MEAN_VELOCITY = nan(10,11,15);
    combinaisonStudy.cpgData.MEAN_RIGHT_STEP_LENGTH = nan(10,11,15);
    combinaisonStudy.cpgData.MEAN_LEFT_STEP_LENGTH = nan(10,11,15);

    combinaisonStudy.cpgData.CoT = nan(10,11,15);
    combinaisonStudy.cpgData.SL = nan(10,11,15);

    if nargin < 2 
        what_cst = what_cpg;
    end
    
    if nargin < 3
        suffix = '';
    end

    order = 1:10;
    
    get_raw('cpg',what_cpg);
    get_raw('cst',what_cst);
    
    function get_raw(str,what)
        tic
        for i=what
            raw=extract_rawSystematic('articleFrontier',['combinaisonStudy' suffix],'combinaisonStudy',['_fdb' num2str(i) '_' str num2str(i)]);
            combinaisonStudy.raw.([str '_' num2str(order(i))]) = raw;

            combinaisonStudy.([str 'Data']).STABLE_UNTIL(i,:) = raw.p_stableUntil;

            combinaisonStudy.([str 'Data']).STABLE_MAX(i,:) = raw.p_stableMax;

            combinaisonStudy.([str 'Data']).MEAN_DURATION(i,:,:) = ...
                0.5*( ...
                    raw.fitness_discardFall.MEAN_LEFT_STANCE_END_DURATION + ...
                    raw.fitness_discardFall.MEAN_LEFT_STANCE_DURATION + ...
                    raw.fitness_discardFall.MEAN_LEFT_SWING_DURATION + ...
                    raw.fitness_discardFall.MEAN_RIGHT_STANCE_END_DURATION + ...
                    raw.fitness_discardFall.MEAN_RIGHT_STANCE_DURATION + ...
                    raw.fitness_discardFall.MEAN_RIGHT_SWING_DURATION ...
                );
            combinaisonStudy.([str 'Data']).FALLED(i,:,:) = raw.fitness.FALLED;
            combinaisonStudy.([str 'Data']).ENERGY(i,:,:) = raw.fitness_discardFall.ENERGY;
            combinaisonStudy.([str 'Data']).DISTANCE(i,:,:) = raw.fitness_discardFall.DISTANCE;
            combinaisonStudy.([str 'Data']).MEAN_VELOCITY(i,:,:) = raw.fitness_discardFall.MEAN_VELOCITY;
            combinaisonStudy.([str 'Data']).MEAN_RIGHT_STEP_LENGTH(i,:,:) = raw.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
            combinaisonStudy.([str 'Data']).MEAN_LEFT_STEP_LENGTH(i,:,:) = raw.fitness_discardFall.MEAN_LEFT_STEP_LENGTH;

            combinaisonStudy.([str 'Data']).CoT(i,:,:) = raw.fitness_discardFall.ENERGY./raw.fitness_discardFall.DISTANCE;
            combinaisonStudy.([str 'Data']).SL(i,:,:) = 0.5*raw.fitness_discardFall.MEAN_LEFT_STEP_LENGTH+0.5*raw.fitness_discardFall.MEAN_RIGHT_STEP_LENGTH;
        toc
        end
    end
    
end