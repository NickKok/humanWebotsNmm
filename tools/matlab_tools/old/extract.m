function [varargout] = extract(what, exp_number, varargin)
    conf
    if nargin == 3
        folder=varargin{1};
    else
        %folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
        folder='/home/efx/Development/PHD/LabImmersion/Airi/current/raw_files/';
    end
    
    if(isa(exp_number,'double'))
        exp_number = int2str(exp_number);
        if(isa(folder,'cell')==1)
            folder = cell2mat(folder);
        end
        if(strcmp(what,'feedbacks'))
            [folder 'feedbacks' exp_number]
            spike_rate = load_data([folder 'feedbacks' exp_number]);
        elseif(strcmp(what,'cpgs'))
            [folder 'cpgs' exp_number]
            spike_rate = load_data([folder 'cpgs' exp_number]);
        elseif(strcmp(what,'interneurons'))
            [folder 'interneurons' exp_number]
            spike_rate = load_data([folder 'interneurons' exp_number]);
        elseif(strcmp(what,'motoneurons'))
            [folder 'motoneurons_activity' exp_number]
            spike_rate = load_data([folder 'motoneurons_activity' exp_number]);
        elseif(strcmp(what,'muscles'))
            [folder 'motoneurons_activity' exp_number]
            spike_rate = load_data([folder 'motoneurons_activity' exp_number]);
        end 
        footfall = load_data([folder 'footfall' exp_number], 'minimal');
    else
        if(strcmp(what,'feedbacks'))
            cell2mat([folder 'feedbacks_' exp_number])
            spike_rate = load_data(cell2mat([folder 'feedbacks_' exp_number]));
        elseif(strcmp(what,'interneurons'))
            cell2mat([folder 'interneurons' exp_number])
            spike_rate = load_data(cell2mat([folder 'interneurons_' exp_number]));
        elseif(strcmp(what,'motoneurons'))
            cell2mat([folder 'motoneurons_activity_' exp_number])
            spike_rate = load_data(cell2mat([folder 'motoneurons_activity_' exp_number]));
        elseif(strcmp(what,'muscles'))
            cell2mat([folder 'motoneurons_activity_' exp_number])
            spike_rate = load_data(cell2mat([folder 'motoneurons_activity_' exp_number]));
        end 
        footfall = load_data(cell2mat([folder 'footfall_' exp_number]), 'minimal');
    end
    
    keyboard
    
    length = size(spike_rate.val.data,2);
    for i=1:length/2
        try
            [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,1)),spike_rate.time,1000);
        catch
            disp(['cycle ' num2str(i) ' error'])
        end
    end
    for i=length/2+1:length
        try
            [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,2)),spike_rate.time,1000);
        catch
            disp(['cycle ' num2str(i) ' error'])
        end
    end
    if(nargout == 2)
        varargout{1} = signal;
        varargout{2} = signals;
    elseif(nargout == 3)
        varargout{1} = signal;
        varargout{2} = signals;
        varargout{3} = spike_rate.val.data;
    else
        figure
        subplot(121)
        A = reshape([signals(1:length/2).amplitude],size([signals(1:length/2).offset],2)/length*2,length/2);
        %A = A(3:end,:);
        boxplot(A-repmat(mean(A,1),size(A,1),1))
        subplot(122)
        O = reshape([signals(1:length/2).offset],size([signals(1:length/2).offset],2)/length*2,length/2);
        boxplot(O-repmat(mean(O,1),size(O,1),1));
        spike_rate.data
%         figure
%         subplot(311)
%         A=reshape([signals(7).error],size([signals(7).error],2)/14,14);
%         boxplot(A(1,:))
%         subplot(312)
%         plot([signals(13).value(:,signals(1).best)])
%         subplot(313)
%         plot([signals(7).value(:,signals(1).best)])

%         figure
%         subplot(311)
%         spike_rate = load_data([folder 'feedbacks' exp_number]);
%         i = 11;
%         [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,1)),spike_rate.time,100);
%         i = 12;
%         [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,1)),spike_rate.time,100);
%         title('Reflex circuitry of TA muscle')
%         plot([signal(11:12).value])
%         legend('Sol Force feedback (stance)','Ta length feedback (cycle)')
%         spike_rate = load_data([folder 'motoneurons_activity' exp_number]);
%         
%         i=6;
%         [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,1)),spike_rate.time,100);
%         subplot(312)
%         plot([signal(6).value])
%         legend('TA Motoneuron activity')
% 
%         spike_rate = load_data([folder 'muscles_activity' exp_number]);
%         i=6;
%         [signal(i), signals(i)] = extract_step_signal(spike_rate.val.data(:,i),derivatives(footfall(:,1)),spike_rate.time,100);
%         subplot(313)
%         plot([signal(6).value])
%         legend('TA Muscle Activity')
    end
end
