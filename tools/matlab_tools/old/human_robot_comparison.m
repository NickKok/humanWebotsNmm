function [varargout] = human_robot_comparison(what, exp_number, varargin)
    col = lines(5);
    if(strcmp(what,'angle'))
        % load human data 
        addpath('fct');
        human = importdata('../../human_data/angle/normal.txt');
        % load robot data
        if(nargin >= 3)
            folder=varargin{1};
        else
            folder='/home/efx/Development/PHD/LabImmersion/Ted/global_data/raw_files/';
            %folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
        end
        if(isa(exp_number,'double') == 1)
            joints_angle = load_data([folder 'joints_angle' int2str(exp_number)]);
            footfall = load_data([folder 'footfall' int2str(exp_number)], 'minimal');
            
        else
            joints_angle = load_data([folder 'joints_angle_' exp_number]);
            footfall = load_data([folder 'footfall_' exp_number], 'minimal');
            exp_number = varargin{2};
        end
        % extract cycle start position
        
        pos = find(derivatives(footfall(:,1))==1);
        for i=15:size(pos)-1
            robot.data{i-14} = joints_angle.val.data(pos(i)-10:pos(i+1)-10, [3,5,1]);
        end
        %figure;
    elseif(strcmp(what,'torque'))
        % load human data 
        addpath('fct');
        human = importdata('../../human_data/torque/normal.txt');
        % load robot data
        if(nargin >= 3)
            folder=varargin{1};
        else
            folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/';
            %folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
        end

        if(isa(exp_number,'double') == 1)
            joints_torque = load_data([folder 'joints_force' int2str(exp_number)]);
            footfall = load_data([folder 'footfall' int2str(exp_number)], 'minimal');
        else
            joints_torque = load_data([folder 'joints_force_' exp_number]);
            footfall = load_data([folder 'footfall_' exp_number], 'minimal');
            exp_number = varargin{2};
        end
        % extract cycle start position
        
        pos = find(derivatives(footfall(:,1))==1);
        robot.data = filtfilt(0.01*ones(1,100), 1, joints_torque.val.data(pos(end-2)-30:pos(end-1)-30, [3,5,1]))/80;
        %figure;
    elseif(strcmp(what,'grf'))
        % load human data 
        addpath('fct');
        human = importdata('../../human_data/grf/normal.txt');
        % load robot data
        if(nargin >= 3)
            folder=varargin{1};
        else
            folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/';
            %folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
        end

        if(isa(exp_number,'double') == 1)
            grf = load_data([folder 'grf' int2str(exp_number)]);
            footfall = load_data([folder 'footfall' int2str(exp_number)], 'minimal');
        else
            grf = load_data([folder 'grf_' exp_number]);
            footfall = load_data([folder 'footfall_' exp_number], 'minimal');
            exp_number = varargin{2};
        end
        % extract cycle start position
        pos = find(derivatives(footfall(:,1))==1); % swing / stance transition 
        robot.data = filtfilt(0.01*ones(1,100), 1, grf.val.data(pos(end-2)-10:pos(end-1)-10, [2,1]));
        %figure;
    %elseif(strcmp(what,''))
    end
    if(strcmp(what,'grf'))
        % Y grf
        subplot(121);
        title('Y grf');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,1),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robot.data,1)),robot.data(:,1)/80,'Color',col(exp_number,:),'LineWidth',2);
        hold off;
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,1),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robot.data,1)),robot.data(:,1),linspace(0,1,50));
        grfycorr = corr(A',B'); 
        % X grf
        subplot(122);
        title('X grf');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,3),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robot.data,1)),-robot.data(:,2),'Color',col(exp_number,:),'LineWidth',2);
        %legend('human','robot');
        hold off;
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,3),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robot.data,1)),robot.data(:,2),linspace(0,1,50));
        grfxcorr = corr(A',B'); 

        if(nargout == 2)
            varargout{1} = grfycorr;
            varargout{2} = grfxcorr;
        end 
        if(nargout == 1)
            varargout{1} = robot.data
        end
    elseif(strcmp(what,'torque'))
        % HIP
        subplot(131);
        title('hip');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,1),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robot.data,1)),robot.data(:,1),'Color',col(exp_number,:),'LineWidth',2);
        hold off;
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,1),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robot.data,1)),robot.data(:,1),linspace(0,1,50));
        hipcorr = corr(A',B');

        % KNEE
        subplot(132);
        title('knee');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,[3]),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robot.data,1)),-robot.data(:,2),'Color',col(exp_number,:),'LineWidth',2);
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,[3]),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robot.data,1)),robot.data(:,2),linspace(0,1,50));
        kneecorr = corr(A',B');
        hold off;

        % ANKLE
        subplot(133);
        title('ankle');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,5),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robot.data,1)),robot.data(:,3),'Color',col(exp_number,:),'LineWidth',2);
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,5),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robot.data,1)),robot.data(:,3),linspace(0,1,50));
        anklecorr = corr(A',B');
        %legend('human','robot');
        hold off;

        if(nargout == 3)
            varargout{1} = hipcorr;
            varargout{2} = kneecorr;
            varargout{3} = anklecorr;
        end
    elseif(strcmp(what,'angle'))
        robotdata = zeros(50,3);
        for i=1:length(robot.data)
            robotdata(:,1) = robotdata(:,1) + interp1(linspace(0,1,size(robot.data{i},1)),robot.data{i}(:,1),linspace(0,1,50))';
            robotdata(:,2) = robotdata(:,2) + interp1(linspace(0,1,size(robot.data{i},1)),robot.data{i}(:,2),linspace(0,1,50))';
            robotdata(:,3) = robotdata(:,3) + interp1(linspace(0,1,size(robot.data{i},1)),robot.data{i}(:,3),linspace(0,1,50))';
        end
        robotdata = robotdata/length(robot.data);
        % HIP
        subplot(131);
        title('hip');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,1),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robotdata,1)),-180/pi*robotdata(:,1),'Color',col(exp_number,:),'LineWidth',2);
        hold off;
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,1),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robotdata,1)),180/pi*robotdata(:,1),linspace(0,1,50));
        hipcorr = corr(A',B');

        % KNEE
        subplot(132);
        title('knee');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,[3]),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robotdata,1)),180/pi*robotdata(:,2),'Color',col(exp_number,:),'LineWidth',2);
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,[3]),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robotdata,1)),180/pi*robotdata(:,2),linspace(0,1,50));
        kneecorr = corr(A',B');
        hold off;

        % ANKLE
        subplot(133);
        title('ankle');
        hold on;
        %plot(linspace(0,1,size(human.data,1)),human.data(:,5),'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
        plot(linspace(0,1,size(robotdata,1)),-180/pi*robotdata(:,3),'Color',col(exp_number,:),'LineWidth',2);
        A = interp1(linspace(0,1,size(human.data,1)),human.data(:,5),linspace(0,1,50));
        B = interp1(linspace(0,1,size(robotdata,1)),180/pi*robotdata(:,3),linspace(0,1,50));
        anklecorr = corr(A',B');
        %legend('human','robot');
        hold off;

        if(nargout == 3)
            varargout{1} = hipcorr;
            varargout{2} = kneecorr;
            varargout{3} = anklecorr;
        end
    end
end
%% ANGLE COMPARAISON full fitness
%./extract_reflex.py ../job_files/parameter_space_study/pso.xml.8.db get_raw_data
%./extract_reflex.py ../../v0.3/job_files/muscle_model_0/1.3ms_launching_gate/energy_noise/pso_energy_noise.1.db get_raw_data
%./extract_reflex.py ../../v0.3/job_files/muscle_model_0/1.3ms_launching_gate/energy_speed_steplength/pso_energy_speed_steplength.1.db get_raw_data
%./extract_reflex.py ../job_files/parameter_space_study/pso.xml.1.db get_raw_data
% col = lines(3);
% % Load human angle
% addpath('fct');
% angle.normal =importdata('../../human_data/angle/normal.txt');
% 
% % Load robot angle
% figure
% exp_number = 1;
% folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/human_robot_comparaison/';
% joints_angle = load_data([folder 'joints_angle' int2str(exp_number)]);
% footfall = load_data([folder 'footfall' int2str(exp_number)], 'minimal');
% pos = find(derivatives(footfall(:,1))==1);
% robot_angle.normal.data = joints_angle.val.data(pos(end-2):pos(end-1), [3,5,1]);
% 
% 
% subplot(131);
% title('hip');
% hold on;
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[1]));
% plot(linspace(0,1,size(robot_angle.normal.data,1)),-180/pi*robot_angle.normal.data(:,1),'Color',col(1,:));
% hold off;
% A = interp1(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[1]),linspace(0,1,50));
% B = interp1(linspace(0,1,size(robot_angle.normal.data,1)),180/pi*robot_angle.normal.data(:,1),linspace(0,1,50));
% corr(A',B')
% subplot(132);
% title('knee');
% hold on;
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[3]));
% plot(linspace(0,1,size(robot_angle.normal.data,1)),180/pi*robot_angle.normal.data(:,2),'Color',col(1,:));
% A = interp1(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[3]),linspace(0,1,50));
% B = interp1(linspace(0,1,size(robot_angle.normal.data,1)),180/pi*robot_angle.normal.data(:,2),linspace(0,1,50));
% corr(A',B')
% hold off;
% subplot(133);
% title('ankle');
% hold on;
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[5]));
% plot(linspace(0,1,size(robot_angle.normal.data,1)),-180/pi*robot_angle.normal.data(:,3),'Color',col(1,:));
% A = interp1(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[5]),linspace(0,1,50));
% B = interp1(linspace(0,1,size(robot_angle.normal.data,1)),180/pi*robot_angle.normal.data(:,3),linspace(0,1,50));
% corr(A',B')
% legend('human','robot');
% hold off;
% %% ANGLE COMPARAISON
% % Load human angle
% col = lines(3)
% addpath('fct');
% 
% angle.slow =importdata('../../human_data/angle/slow.txt');
% angle.normal =importdata('../../human_data/angle/normal.txt');
% angle.fast =importdata('../../human_data/angle/fast.txt');
% figure;
% subplot(131);
% title('hip');
% hold on;
% plot(linspace(0,1,size(angle.slow.data,1)),angle.slow.data(:,[1]),'Color',col(1,:))
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[1]));
% plot(linspace(0,1,size(angle.fast.data,1)),angle.fast.data(:,[1]),'Color',col(1,:));
% hold off;
% legend('slow','normal','fast');
% 
% subplot(132);
% title('knee');
% hold on;
% plot(linspace(0,1,size(angle.slow.data,1)),angle.slow.data(:,[3]),'Color',col(1,:))
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[3]));
% plot(linspace(0,1,size(angle.fast.data,1)),angle.fast.data(:,[3]),'Color',col(1,:));
% hold off;
% 
% subplot(133);
% title('ankle');
% hold on;
% plot(linspace(0,1,size(angle.slow.data,1)),angle.slow.data(:,[5]),'Color',col(1,:))
% plot(linspace(0,1,size(angle.normal.data,1)),angle.normal.data(:,[5]));
% plot(linspace(0,1,size(angle.fast.data,1)),angle.fast.data(:,[5]),'Color',col(1,:));
% hold off;
% 
% % Load robot angle
% figure
% exp_number = 1;
% %folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/speed_experiment';
% folder='/home/efx/Development/PHD/LabImmersion/Regis/v0.4/raw_files/';
% joints_angle = load_data([folder 'joints_angle' int2str(exp_number)]);
% footfall = load_data([folder 'footfall' int2str(exp_number)], 'minimal');
% pos = find(derivatives(footfall(:,1))==1);
% robot_angle.normal.data = joints_angle.val.data(pos(end-2):pos(end-1), [3,5,1]);
% % hip
% subplot(131);
% title('hip');
% plot(linspace(0,1,size(robot_angle.normal.data,1)),-180/pi*robot_angle.normal.data(:,1),'Color',col(1,:));
% % knee
% subplot(132);
% title('knee');
% plot(linspace(0,1,size(robot_angle.normal.data,1)),180/pi*robot_angle.normal.data(:,2),'Color',col(1,:));
% % ankle
% subplot(133);
% title('ankle');
% plot(linspace(0,1,size(robot_angle.normal.data,1)),-180/pi*robot_angle.normal.data(:,3),'Color',col(1,:));