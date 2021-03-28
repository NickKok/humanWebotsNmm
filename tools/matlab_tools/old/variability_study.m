%% VARIABILITY STUDY
folder = {
    '/home/efx/Development/PHD/Airi/current/raw_files/';
    };


SW = [2,4,6,7,9];%[2,4,6,7,9];
ST.G = [3,5,8,14];%[3,5,8,14];
ST.M = [1,10,11,13];%[1,10,11,13];
CY = [12,15];%[12,15];
%INSEN_NAME = {'GAS MFF ST ','GLU MFF SW ','GLU GIT ST','HAM MFF SW','HAM GIF ST','HAM MLF SW','HF MLF SW','HF GIF ST','SOL MFF ST','TA MLF CY','VAS MFF ST','VAS GCF'};
INSEN_NAME = {
    'GAS\leftarrowGAS MFF ST '
    'GLU\leftarrowGLU MFF SW '
    'GLU\leftarrowGLU GIF ST'
    'HAM\leftarrowHAM MFF SW'
    'TRUNK,GROUND\leftarrowHAM GIF ST'
    'HF\leftarrowHAM MLF SW'
    'HF\leftarrowHF MLF SW'
    'TRUNK,GROUND_{ipsi}\leftarrowHF GIF ST'
    'TRUNK_{LEAK}\leftarrowHF CST SW'
    'SOL\leftarrowSOL MFF ST'
    'TA\leftarrowSOL MFF ST'
    'TA\leftarrowTA MLF CY'
    'VAS\leftarrowVAS MFF ST'
    'GROUND_{contra}\leftarrowVAS GCF ST_{end}'
    'KNEE\leftarrowVAS OEP CY'
    };

INSEN_STATE = [
    1
    2
    1
    2
    1
    2
    2
    1
    2
    1
    1
    0
    1
    1
    0
    ];

%% coefficient de variation

%[a,b,c] = extract('feedbacks', 1, folder);

A=[];
A_st=[];
A_sw=[];

for i=1:length(b) 

    B(i) = variability(b(i).value(:,b(i).best));
    B_st(i) = 0;
    B_sw(i) = 0;
    if length(b(i).stance) ~= 0
        B_st(i) = variability(b(i).stance.value(:,b(i).best));
    end
    if length(b(i).swing) ~= 0
        B_sw(i) = variability(b(i).swing.value(:,b(i).best));
    end
       
end

st_g(1:15) = 0;
st_m(1:15) = 0;
sw(1:15) = 0;
cy(1:15) = 0;

st_g(ST.G) = B_st(ST.G);
st_m(ST.M) = B_st(ST.M);
sw(SW) = B_sw(SW);
cy(CY) = B(CY);

bar(st_g,'r');
hold on;
bar(st_m,'y');
bar(sw,'g');
bar(cy,'b');
legend({'Stance stability feedbacks','Stance muscle feedbacks','Swing muscle feedbacks','Whole cycle feedback'})

pause
%% periodic variability
A_n = [];
A_d = [];
for i=1:15
    A_n(i) = mean( ...
                sum( ...
                    ( ...
                        b(i).value(:,:)-repmat(mean(b(i).value,2),1,size(b(i).value,2)) ...
                    ).^2,...
                    2 ...
                  ) ...
                );
    A_d(i) = sum( ...
                mean(b(i).value,2).^2 ...
                );
            
end
    A = A_n./A_d


%%
leg = {'exp 2','exp 3','exp 4', 'exp 6a', 'exp 7a'};
B1 = zeros(4,30);
B2 = zeros(4,30);
y11 = zeros(4,30);
e11 = zeros(4,30);
y21 = zeros(4,30);
e21 = zeros(4,30);
y12 = zeros(4,30);
e12 = zeros(4,30);
y22 = zeros(4,30);
e22 = zeros(4,30);
REORDER = [SW ST.M CY ST.G];

xtick = INSEN_NAME(REORDER);
exps = [];
exps(1).val = [1];
%exps(2).val = {'rp','wg'};
count = 0;
figure;
hold on; 
for f=1:length(exps)
for j=1:length(exps(f).val)
    [a,b,c] = extract('feedbacks', exps(f).val(j), folder);
    count = count+1;
    for i=1:30
        if(length(b(i).value) ~= 0)
            K=b(i).best(end);
            for k=b(i).best(end:-1:1)
                if(k~=K)
                    break;
                end
                K=K-1;
            end
            %[~,B1(count,i)] = periodic_variability(b(i).value(:,2:10));
            %[~,B2(count,i)] = periodic_variability(b(i).value(:,11:end));

            [~,M(count,i),E(count,i)] = periodic_variability(b(i).value(:,1:end));

            yA(count,i) = mean(b(i).amplitude(4:end));
            eA(count,i) = std(b(i).amplitude(4:end));

            yO(count,i) = mean(b(i).offset(4:end));
            eO(count,i) = std(b(i).offset(4:end));
        end
    end
    if(f == 1 && j == 3)
        clear A13;
        for i=1:length(a); A13(i,:) = a(i).value; end;
    end
    if(f == 2 && j == 2)
        clear A22;
        for i=1:length(a); A22(i,:) = a(i).value; end;
    end
end
end
hold off;
kept = [1:8 10 12:14];
M = M(:,REORDER);
E = E(:,REORDER);


%% VARIABILITY PLOT
figure;
subplot(311)
bar(M'); ylim([0,1.01*max(max(M))])
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
set(gca,'xtick',[])
set(gca,'xticklabel',[])
legend(leg,'Orientation','horizontal','Location','NorthWest')
legend boxoff;
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} variability ')

subplot(312)
bar(eO(:,REORDER)')
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
%legend(leg,'Orientation','horizontal','Location','NorthWest')
%legend boxoff;
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} 1st momentum variability ')

subplot(313)
bar(eA(:,REORDER)')
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} 2nd momentum variability ')

%% VARIABILITY PLOT
figure;
subplot(411)
bar(M'); ylim([0,1.01*max(max(M))])
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
set(gca,'xtick',[])
set(gca,'xticklabel',[])
legend(leg,'Orientation','horizontal','Location','NorthWest')
legend boxoff;
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} variability ')

subplot(412)
bar(eO(:,REORDER)')
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
%legend(leg,'Orientation','horizontal','Location','NorthWest')
%legend boxoff;
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} 1st momentum variability ')

subplot(413)
bar(eA(:,REORDER)')
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} 2nd momentum variability ')


subplot(414)
bar(yA(:,REORDER)')
set(gca,'FontSize',12)
xlim([0;length(REORDER)+1])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%xticklabel_rotate([1:length(xtick)],45,xtick,'FontSize',12)
%xlabel('IN_{SEN}')
ylabel('IN_{SEN} 2nd momentum variability ')

%% SIGNAL EXAMPLE
figure;
h = colormap(hsv(5));
start = 0;
subplot(131);
set(gca,'FontSize',14)
hold on;
for i=1:length(SW)
    plot(linspace(0,1,1000),A13(SW(i),:)','LineWidth',2,'Color',h(i,:))
end
ylabel('normalized amplitude')
start = start+i-1;
legend(INSEN_NAME([SW]),'Location','NorthEast');
legend boxoff
hold off;
subplot(132)
set(gca,'FontSize',14)
hold on;
for i=1:length(ST.M)
    plot(linspace(0,1,1000),A13(ST.M(i),:)','LineWidth',2,'Color',h(i,:))
    
end
xlabel('normalized time');
start = start+i-1;
for i=1:length(CY)
    plot(linspace(0,1,1000),A13(CY(i),:)','LineWidth',2,'Color',h(i+length(ST.M),:))
end
legend(INSEN_NAME([ST.M CY]),'Location','NorthEast');
legend boxoff
start = start+i-1;
subplot(133)
set(gca,'FontSize',14)
hold on;
for i=1:length(ST.G)
    plot(linspace(0,1,1000),A13(ST.G(i),:)','LineWidth',2,'Color',h(i,:))
end
legend(INSEN_NAME([ST.G]),'Location','NorthEast');
legend boxoff
hold off;


start = 0;
subplot(131);
hold on;
for i=1:length(SW)
    plot(linspace(0,1,1000),A22(SW(i),:)','LineWidth',2,'Color',h(i,:),'LineStyle','-.')
end
start = start+i-1;
hold off;
subplot(132)
hold on;
for i=1:length(ST.M)
    plot(linspace(0,1,1000),A22(ST.M(i),:)','LineWidth',2,'Color',h(i,:),'LineStyle','-.')
    
end
start = start+i-1;
for i=1:length(CY)
    plot(linspace(0,1,1000),A22(CY(i),:)','LineWidth',2,'Color',h(i+length(ST.M),:),'LineStyle','-.')
end
start = start+i-1;
subplot(133)
hold on;
for i=1:length(ST.G)
    plot(linspace(0,1,1000),A22(ST.G(i),:)','LineWidth',2,'Color',h(i,:),'LineStyle','-.')
end
hold off;


%for i=1:length(REORDER)
%    plot(filtfilt(0.1*ones(1,10),1,A(REORDER(i),:)'),'LineWidth',2,'Color',h(i,:),'LineStyle','--'); 
%end;
%legend(xtick);



%% SIGNAL EXAMPLE CORRELATION
figure;
subplot(131);
set(gca,'FontSize',14)
d = diag(corr(A22(SW,:)',A13(SW,:)'));
bar_h = bar([d';d']), colormap(hsv(5));
xlim([0.5;1.5]);
ylabel('correlation');
set(gca,'xtick',[])
set(gca,'xticklabel',[])

subplot(132);
set(gca,'FontSize',14)
d = diag(corr(A22([ST.M CY],:)',A13([ST.M CY],:)'));
bar_h = bar([d';d']), colormap(hsv(5));
xlim([0.5;1.5]);
set(gca,'xtick',[])
set(gca,'xticklabel',[])

subplot(133);
set(gca,'FontSize',14)
d = diag(corr(A22(ST.G,:)',A13(ST.G,:)'));
bar_h = bar([d';d']), colormap(hsv(5));
xlim([0.5;1.5]);
set(gca,'xtick',[])
set(gca,'xticklabel',[])






