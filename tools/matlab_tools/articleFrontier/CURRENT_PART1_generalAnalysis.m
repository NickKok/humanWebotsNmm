%% DATA LOADING
exp_1_0=load_data('1.0',1:8);
exp_1_3=load_data('1.3',1:10);
exp_1_6=load_data('1.6',1:8);
exp_wavy=load_data('wavy2',1:10);
exp_geyer=load_data('wavy2',1,'factor',110,'prefix','_geyer');



%% PLOT
out = exp_wavy; % Choose the one you want.
%% Cost of transport
plot_CoT(out.energy.CoT,out.energy.order)

%% Muscle activities
% ordered by golden ratio
% BLUE: abs(swing / double stance - gR) < 0.4
% GREEN : 0.4 < abs(swing / double stance - gR) < 0.8
% RED : abs(swing / double stance - gR) > 0.8

groups = {out.golden_ratio.order(1:5), out.golden_ratio.order(6:8), out.golden_ratio.order(9:end)};
hFig = subplot_shadedSignals(out.muscle.signals,out.muscleName,groups);
hs=get(hFig,'children');
set(hFig, 'Position', [600,00,400,800]);
set(hs(1),'Ylim',[-1.8,35]);
set(hs(2),'Ylim',[0,100]);
set(hs(3),'Ylim',[-1.8,95]);
set(hs(4),'Ylim',[0,100]);
set(hs(5),'Ylim',[-1.8,59]);
set(hs(6),'Ylim',[-1.8,55]);
set(hs(7),'Ylim',[-1.8,60]);
ylabel(hs(4), 'Muscle activity (%)')

%% Joint angles correlation

order=out.energy.order;


hFig=figure;
subplot(211)
h2=plot_correlation([reshape(out.jointTorque.human,1,1000,3); out.jointTorque.model(order,:,:)],out.jointName, 'transpose',1,'bar',1,'compareWith',1,'dontShow',1);
title('Joints Torque','fontweight','normal','fontsize',14);
ylabel('Correlation coefficient                           ');
ylim([-0.1;1.0])
subplot(212)
h3=plot_correlation([reshape(out.jointAngle.human,1,1000,3); out.jointAngle.model(order,:,:)],out.jointName, 'transpose',1,'bar',1,'compareWith',1,'dontShow',1);
title('Joints Angle','fontweight','normal','fontsize',14);
set(hFig, 'Position', [00,200,450,300]);

%% Joint angles model

angle1_0 = exp_1_0.jointAngle.model;
angle1_0 = angle1_0(exp_1_0.golden_ratio.order(1:5),:,:);

angle1_3 = exp_1_3.jointAngle.model;
angle1_3 = angle1_3(exp_1_3.golden_ratio.order(1:5),:,:);

angle1_6 = exp_1_6.jointAngle.model;
angle1_6 = angle1_6(exp_1_6.golden_ratio.order(1:5),:,:);


hFig = subplot_shadedSignals([angle1_6;angle1_3; angle1_0],exp_1_0.jointName,{1:5,6:10,11:15});


%% Joint angles human
angle1_0 = exp_1_0.jointAngle.human;
angle1_3 = exp_1_3.jointAngle.human;
angle1_6 = exp_1_6.jointAngle.human;

angle1_0_std = exp_1_0.jointAngle.humanStd;
angle1_3_std = exp_1_3.jointAngle.humanStd;
angle1_6_std = exp_1_6.jointAngle.humanStd;


angle(1,:,:) = angle1_6;
angle(2,:,:) = angle1_3;
angle(3,:,:) = angle1_0;

angleStd(1,:,:) = angle1_6_std;
angleStd(2,:,:) = angle1_3_std;
angleStd(3,:,:) = angle1_0_std;

hFig = subplot_shadedSignals({angle, angleStd},exp_1_0.jointName,{1,2,3});


%%
%%%%%%%%%%%%%%%%%%%%
%%% GOLDEN RATIO %%%
%%%%%%%%%%%%%%%%%%%%

out=exp_wavy;
%out=exp_1_3;
%out=exp_1_6;
%gR = out.golden_ratio.right;
gR = gr_corr;

%% Correction of golden ratio (accounting for toe lacking)
st = 1./out.golden_ratio.left(1,:);
sw = 1./(out.golden_ratio.left(1,:).*out.golden_ratio.left(2,:));
dblsupp = 1./(out.golden_ratio.left(1,:).*out.golden_ratio.left(2,:).*out.golden_ratio.left(3,:));
error = 0.0184;%error = 1/gr - 1/median(out.golden_ratio.left(1,:));

st_corr = st+error;
sw_corr = sw-error;
dblsupp_corr = dblsupp+2*error;

gr_corr(1,:) = 1./st_corr;
gr_corr(2,:) = st_corr./sw_corr;
gr_corr(3,:) = sw_corr./dblsupp_corr;



%% Golden ratio 1
hFig = figure;

bar(gR(:,out.energy.order),'g')
%shading faceted
hold on;
plot(0:4,( gr )*ones(1,5),'r','LineWidth',2);
set(gca,'xtick',1:3);
set(gca,'xticklabel',{'GR0', 'GR1', 'GR2'});
ylabel('golden ratio []');
set(hFig, 'Position', [00,200,450,180]);
%% Golden ratio 2
hFig = figure;

boxplot(gR(:,out.energy.order(1:end))');
hold on;
plot(L,gr*ones(size(L)),'r','LineWidth',2);
ylabel('golden ratio []');
set(gca,'xtick',1:3);
set(gca,'xticklabel',{'GR0', 'GR1', 'GR2'});
set(hFig, 'Position', [00,200,450,180]);

%% Golden ratio 3
hFig = figure;
out.golden_ratio.right
bar(abs(gR(3,out.golden_ratio.order)-gr))
hold on;
L = get(gca,'XLim');
xlim([0,11])
plot(L,0.4*ones(size(L)),'m','LineWidth',3)
plot(L,0.8*ones(size(L)),'r','LineWidth',3)
ylabel('absolute difference with golden ratio')





%%
%%%%%%%%%%%%%%%%%%%%%%
%%% COMP WITH WAVY %%%
%%%%%%%%%%%%%%%%%%%%%%
wavy=load_data('wavy2',1:10);
original=load_data('1.3',1:10);


angle1 = original.jointAngle.model;



angle1_wavy = wavy.jointAngle.model;


angle1_0 = exp_1_0.jointAngle.model;
angle1_0 = angle1_0(exp_1_0.golden_ratio.order(1:5),:,:);

angle1_3 = exp_1_3.jointAngle.model;
angle1_3 = angle1_3(exp_1_3.golden_ratio.order(1:5),:,:);

angle1_6 = exp_1_6.jointAngle.model;
angle1_6 = angle1_6(exp_1_6.golden_ratio.order(1:5),:,:);



hFig = subplot_shadedSignals([angle1;angle1_wavy],original.jointName,{1:10,11:20});



%% PARAM COMP
param_name = {
    'solsol_wf'
    'solta_wf'
    'gasgas_wf'
    'vasvas_wf'
    'hamham_wf'
    'gluglu_wf'
    'tata_wl'
    'hfhf_wl'
    'hamhf_wl'
    'ta_bl'
    'hf_bl'
    'ham_bl'
    'kbodyweight'
    'kp'
    'kd'
    'kref'
    'deltas'
    'sol_activitybasal'
    'ta_activitybasal'
    'gas_activitybasal'
    'vas_activitybasal'
    'ham_activitybasal'
    'glu_activitybasal'
    'hf_activitybasal'
    'vas_activitybasal_stance'
    'bal_activitybasal_stance'
    'kphiknee'
    'klean'
    };
param_default = [
    1.30816200934
    0.521221985946
    1.02595462128
    1.4627876802
    0.268099035796
    0.298263344152
    1.1073380587
    0.948463233215
    1.79209242229
    0.804185317034
    0.718547498187
    0.755295491087
    1.03983110595
    2.5404765413
    0.395238242434
    0.113749122366
    0.254992995872
    0.0114066426217
    0.0361440315036
    0.0181384821075
    0.0109335061486
    0.0379101620235
    0.0177650761661
    0.0319532849735
    0.137372991086
    0.023448881317
    2.52157633434
    1.19963289289

    
    ];
param_wavy = [
    1.2853    1.2916    1.2392    1.3208    1.2740    1.2634    1.3149
    0.5399    0.5362    0.5918    0.5917    0.5796    0.5832    0.6201
    1.0502    1.0723    0.8604    0.9267    1.1184    1.0406    1.0042
    1.4467    1.4992    1.3998    1.4643    1.4784    1.4881    1.4423
    0.2251    0.2522    0.2319    0.3149    0.2246    0.2490    0.2580
    0.2998    0.2993    0.4058    0.2919    0.3055    0.3328    0.3113
    1.0424    1.0451    1.4437    1.0362    1.0717    1.1309    1.1420
    0.9943    0.9693    0.9207    0.9771    0.9906    0.9542    0.9542
    1.8031    1.7829    1.5986    1.8585    1.7656    1.9251    1.7347
    0.8835    0.7453    0.7125    0.8951    0.7897    0.7898    0.8159
    0.6883    0.7026    0.7190    0.7249    0.6797    0.6501    0.6762
    0.7604    0.7570    0.7726    0.7485    0.7353    0.7640    0.7519
    1.0369    1.0720    1.1007    1.0491    1.0163    1.0548    1.0320
    2.6490    2.5650    2.4649    2.6865    2.4980    2.5719    2.4688
    0.4219    0.4132    0.4560    0.3941    0.4152    0.3774    0.4071
    0.1339    0.1150    0.0866    0.1121    0.1194    0.1136    0.1158
    0.3902    0.2627    0.2342    0.2878    0.2761    0.1867    0.2671
    0.0107    0.0144    0.0234    0.0108    0.0170    0.0139    0.0143
    0.0326    0.0378    0.0359    0.0430    0.0401    0.0371    0.0434
    0.0302    0.0241    0.0192    0.0265    0.0148    0.0182    0.0214
    0.0122    0.0128    0.0124    0.0105    0.0112    0.0106    0.0106
    0.0365    0.0350    0.0374    0.0369    0.0441    0.0458    0.0391
    0.0202    0.0162    0.0166    0.0112    0.0135    0.0120    0.0167
    0.0362    0.0302    0.0310    0.0296    0.0345    0.0331    0.0272
    0.1309    0.1175    0.1105    0.0998    0.0913    0.1324    0.0948
    0.0319    0.0365    0.0826    0.0462    0.0480    0.0383    0.0370
    2.6754    2.8068    2.7130    2.6279    2.6154    2.4860    2.8097
    1.3671    1.2491    1.1037    1.3678    1.4159    1.2907    1.2014
    ];

%%
for i=1:7
    diff(:,i) = param_wavy(:,i)./param_default;
end

%% Stick figure
segments=extract_rawFile([config.raw_filedir '/sessionArticleFrontier_wavy2'],config.raw_filename.segments,31);
trunk_angle = segments.data(:,1);




x = segments.data(:,2:3:end);
y = segments.data(:,3:3:end);
z = segments.data(:,4:3:end);

segments = struct;
segments.trunk = 0.8;
segments.thigh = 0.5;
segments.shin = 0.5;
segments.ankle = 0.1;
segments.foot = 0.16;


z = [sin(trunk_angle).*segments.trunk+z(:,1) z];
y = [cos(trunk_angle).*segments.trunk+y(:,1) y];

footfall=extract_rawFile([config.raw_filedir '/sessionArticleFrontier_wavy2'],config.raw_filename.footfall,31);
inits = find(diff(footfall.data(:,1))==1);

start_pos = inits(5);
end_pos = inits(6);
%%
subplot(2,1,1)
for i=inits(4)-500:10:inits(5)
    plot(z(i,1:4),y(i,1:4),'Linewidth',2)
    hold on
    hold on;
end
axis tight
axis on
xlabel('distance [m]')
subplot(2,1,2)
for i=inits(4):50:inits(7);
    plot(z(i,1:4),y(i,1:4),'Linewidth',2)
    hold on
    plot(z(i,6:9),y(i,6:9),'Linewidth',2)
    hold on;
end
xlabel('distance [m]')
axis tight
axis on
