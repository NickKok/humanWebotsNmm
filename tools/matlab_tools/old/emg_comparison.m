addpath('/home/efx/Development/PHD/LabImmersion/Ted/human_data/0-Speed dependence of averaged EMG profiles in walking');
addpath('/home/efx/Development/PHD/LabImmersion/Ted/global_tools/matlab_tools');
addpath('/home/efx/Development/PHD/LabImmersion/Ted/global_tools/matlab_tools/fct');

load allmeas.mat
muscles_name = {'GAS','GLU','HAM','HF','SOL','TA','VAS'};
muscles=[4 2 3 7 1 6 5];
xticklabel = {'HF','GLU','HAM','VAS','GAS','TA','SOL'};


H{4} = zscore(RF(1:100,3));
H{2} = zscore(GX(1:100,3)+GD(1:100,3));
H{3} = zscore(BF(1:100,3)+ST(1:100,3));
H{7} = zscore(VM(1:100,3)+VL(1:100,3));
H{1} = zscore(GM(1:100,3)+GL(1:100,3));
H{6} = zscore(TA(1:100,3));
H{5} = zscore(SO(1:100,3));
H{4} = zscore(-H{7}+H{4});
k=0;


col = lines(5);
A={};
pos={};
exp_numbers={'base','rp','wg'};
%exp_numbers=1:4;
k=0;
folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/full_reflex/';
%folder = '/home/efx/Development/PHD/LabImmersion/Ted/global_data/flat_ground/';
for exp_number = exp_numbers
    if( isa(exp_number,'double') == 1)
        spike_rate = load_data([folder 'muscles_force' int2str(exp_number)], 'minimal');
        footfall=load_data([folder 'footfall' int2str(exp_number)], 'minimal');
    else
        spike_rate = load_data(cell2mat([folder 'muscles_force_' exp_number]), 'minimal');
        footfall=load_data(cell2mat([folder 'footfall_' exp_number]), 'minimal');
    end
	k=k+1;
	A{k} = spike_rate;
	pos{k} = find(derivatives(footfall(:,1))==1);
end

figure;
j=1;

k=0;
for i=muscles
    k=k+1;
    subplot(7,1,k);
    for j=1:length(exp_numbers)
        x=linspace(0,100,pos{j}(end-1)+1-pos{j}(end-2));
        y=zscore(filtfilt(0.1*ones(1,10),1,A{j}(pos{j}(end-2):pos{j}(end-1),i)));
        plot(x,y,'Color',col(j,:),'LineWidth',2);
        ylimit(j,:) = [min(y) max(y)];
        hold on;
    end
    ylim([min(ylimit(:,1)) max(ylimit(:,2))]);
    title(muscles_name(i))
end   
k=0;
for i=muscles
    k=k+1;
    subplot(7,1,k);plot(H{i},'Color',[0,0,0],'LineWidth',2, 'LineStyle', '--');
    set(gca,'YTick',-20:40:20)
    %ylim([min(H{i}) max(H{i})]);
end

%% CORRELATION
l=0;
clear C;
for j=exp_numbers
k=0;
l=l+1
for i=muscles
    k=k+1;
    X=zscore((filtfilt(0.1*ones(1,10),1,A{l}(pos{l}(end-2):pos{l}(end-1),i))));
    C(k,l) = corr(H{i},zscore(interp1(X,linspace(1,length(X),100)))');
end
end
figure
imagesc(C)
grid on
set(gca,'Ytick',1:7,'YTickLabel',xticklabel);
%set(gca,'Xtick',1:4,'XTickLabel',{'exp1','exp2','exp3','exp4'});
set(gca,'Xtick',1:3,'XTickLabel',{'flat','random push','wavy ground'});
xlabel('experiment')
ylabel('muscles')