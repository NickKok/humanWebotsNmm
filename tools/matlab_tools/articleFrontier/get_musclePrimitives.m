function out = get_musclePrimitives(muscleAct,MP_Number)
        out = struct;
        %% Muscles primitives
        if nargin == 1
            MP_Number = 4;
        end
        muscleMPName={};
        for i=1:MP_Number
            muscleMPName{i} = ['MP' num2str(i)];
        end
        ids=1:size(muscleAct,1);
        muscleNumber = size(muscleAct,3);
        muscleMP = [];
        muscleMP_W = [];
        gauss = @(x,mu,sigma) exp(-(x-mu).^2./2*(sigma^2));
        x=linspace(0,1,1000);
        wcheck=zeros(1000,MP_Number);
        if mod(MP_Number,2) ~= 0
            for i=1:MP_Number
                mu=1/(MP_Number+1)*i;
                wcheck(:,i) = gauss(x,mu,8);
            end
        else
            for i=1:MP_Number/2
                mu=1/(MP_Number+1)*i;
                wcheck(:,i) = gauss(x,mu,8);
                mu=0.5+1/(MP_Number+1)*i;
                wcheck(:,i+MP_Number/2) = gauss(x,mu,8);
            end
        end
        tic
        for id = ids
            opt = statset('maxiter',1000,'display','off');
            % With initial condition
            [w,h] = nnmf(reshape(muscleAct(id,:,:),1000,muscleNumber),MP_Number,'w0',wcheck,'opt',opt,'alg','als');
            [w,h] = nmf(reshape(muscleAct(id,:,:),1000,muscleNumber),w,h,0.001,[],1000);
            
            % With random initial condition
            %[w,h] = nnmf(reshape(muscleAct(id,:,:),1000,muscleNumber),MP_Number,'rep',100,'opt',opt,'alg','mult');
            %[w,h] = nnmf(reshape(muscleAct(id,:,:),1000,muscleNumber),MP_Number,'w0',w,'h0',h,'opt',opt,'alg','mult','rep',100);
            
            muscleMP(id,:,:) = w;
            muscleMP_W(id,:,:) = h;
        end
        toc
        keep = [1:10]; %e_order;

        % reordering if needed
        cc_before = get_correlation(muscleMP,1);

        def = reshape(muscleMP(1,:,:),1000,MP_Number);

        for id=ids(2:end);
            act = reshape(muscleMP(id,:,:),1000,MP_Number);
            cc = corr(def,act);
            order=[];
            for i=1:MP_Number
                R=i;
                [C,I]=max(cc(i,:));
                order = [order I];
                %cc = cc(setdiff(1:size(cc,1),[R]),:);
                %cc = cc(:,setdiff(1:size(cc,2),C));
            end
            muscleMP(id,:,:) = muscleMP(id,:,order);
            muscleMP_W(id,:,:) = muscleMP_W(id,order,:);
        end

        out.MP = muscleMP;
        out.W = muscleMP_W;
        out.MP_Number = MP_Number;
        out.MP_Name = muscleMPName;
end