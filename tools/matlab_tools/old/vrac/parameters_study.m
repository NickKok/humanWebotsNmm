function parameters_study(file1,file2)

    function [p m] = extract_info(file)
        boundaries =[]; 
        fitness_settings =[]; 
        job =[]; 
        parameters =[]; 
        data_names =[]; 
        fitness_values =[]; 
        optimizer_settings =[]; 
        population_size =[]; 
        data_values =[]; 
        folder =[]; 
        parameter_active =[]; 
        dispatcher_settings =[]; 
        iteration_times =[]; 
        parameter_names =[]; 
        fitness_names =[]; 
        iterations =[]; 
        parameter_values =[]; 

        folder = '../matlab_files/';
        load ([folder file])
        parameter_values_norm = zeros(size(parameter_values));
        for i=1:size(parameter_values,3)
            parameter_values_norm(:,:,i) = (parameter_values(:,:,i));
        end
        parameter_values = (parameter_values);
        p = zeros(size(parameter_values_norm,3),2);
        m = zeros(size(parameter_values,3),2);
        for i=1:25
            p(i,2) = std(parameter_values_norm(end,:,i));
            p(i,1) = std(parameter_values_norm(1,:,i));
            m(i,2) = mean(parameter_values(end,:,i));
            m(i,1) = mean(parameter_values(1,:,i));
        end
    end
    %parameters_study
    [p m] = extract_info(file1);
    subplot(1,2,1)
    bar(p(:,1))
    hold on
    bar(p(:,2),'r')
    title('Std deviation across particles (max speed 0.03)')
    xlim([0,26])
    xlabel('parameters')
    [p m] = extract_info(file2);
    subplot(1,2,2)
    bar(p(:,1))
    hold on
    bar(p(:,2),'r')
    title('Std deviation across particles (max speed 0.015)')
    xlim([0,26])
    xlabel('parameters')
%     subplot(1,2,2)
%     bar(m(:,1))
%     hold on
%     bar(m(:,2),'r')
%     title('Mean across particles')
%     legend('first generation','last generation');
%     xlim([0,26])
%     xlabel('parameters')
end