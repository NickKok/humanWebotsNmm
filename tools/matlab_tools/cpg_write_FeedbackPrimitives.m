%% Init

if ~exist('biPhasic','var')
    biPhasic = true
end
if ~exist('prefix','var')
    prefix = '' % = '_wavy';
end

if ~exist('factor','var')
    factor = 10
end
if ~exist('id','var')
    id = 1
end
if ~exist('write','var')
    write = true;
end
config = conf();
dir = [ config.raw_filedir '/sessionArticleFrontier' prefix ]; % directory where to look for raw files
%id = factor*id; % extraction serie ID
knot = 1000; % number of knot for the spline interploation
what = config.raw_filename.feedbacks;
toKeep = 1:15;
signalNum = length(toKeep);

%% Data loading
disp('Data loading...')
tic
keepAll = true;
signalRaw = extract_rawFile(dir,what,id*factor,keepAll); % extract muscles activity
footFall = extract_rawFile(dir,config.raw_filename.footfall,id*factor);
extract_gaitFrequency(footFall)

toc

%% Data analysis
disp('Data analysis')
tic
toKeep = signalRaw.left;
stance_percentage = extract_stancePercentage(footFall);
out = signal_analysis(signalRaw,footFall,toKeep,knot);
stereotyped = reshape(out.signalStereotypedShape(:,1,:),signalNum,knot)';
offsets = mean(reshape(out.signalNormData.offset(:,1,:),signalNum,size(out.signalNormData.offset,3)),2);
amplitudes = mean(reshape(out.signalNormData.amplitude(:,1,:),signalNum,size(out.signalNormData.amplitude,3)),2);
names = strrep({signalRaw.textdata{toKeep}},'left_','')';
toc
%% Generate CPG signals
%!mkdir /home/efx/Development/PHD/Airi/current/webots/conf_articleFrontier_wavy/cpg_gate/cpg_data/1
folder = ['/home/efx/Development/PHD/Airi/current/webots/conf_articleFrontier' prefix '/cpg_gate/cpg_data/' num2str(id) '/'];

fid = fopen([folder '../../cpg_parameters' num2str(id) '.txt'],'w+');
fprintf(fid,'amp_change_cpg 1.0\n');
fprintf(fid,'offset_change_cpg 0.0\n');
fprintf(fid,'amp_change_cst 1.0\n');
fprintf(fid,'offset_change_cst 0.0\n');
fprintf(fid,'amp_change_reflex 1.0\n');
fprintf(fid,'offset_change_reflex 0.0\n');
fprintf(fid,'freq_change %f\n',extract_gaitFrequency(footFall));
fclose(fid);

%findIn = @(what,in) find(cellfun(@isempty,strfind({signalRaw.textdata{toKeep}}, '_stance'))==0);
findIn = @(in,what) find(cellfun(@isempty,strfind(in, what))==0);

stanceFdb = findIn({signalRaw.textdata{toKeep}},'_stance');
swingFdb = findIn({signalRaw.textdata{toKeep}},'_swing');
finishingStanceFdb = findIn({signalRaw.textdata{toKeep}},'_finishingstance');
cycleFdb = findIn({signalRaw.textdata{toKeep}},'_cycle');
angleoffsetFdb = findIn({signalRaw.textdata{toKeep}},'_angleoffset');

stancePercentage = extract_stancePercentage(footFall);




stereotyped(isnan(stereotyped))=0;
if biPhasic
    stereotypedR=change_revertStanceSwing(stereotyped,stancePercentage/100);
    stSw = round(stancePercentage/100*knot);
    swSt = round((100-stancePercentage)/100*knot);
    stereotyped(stSw:end,stanceFdb) = 0.0;
    stereotypedR(swSt:end,swingFdb) = 0.0;
    
else
    stereotypedR=stereotyped;
end
col = jet(15);
hFig=figure;
for i=1:signalNum
    stereo = stereotyped(:,i);
    if(sum(swingFdb==i))
        awo = awo_modelFunc(stereotypedR(:,i));
    else
        awo = awo_modelFunc(stereotyped(:,i));
    end
    
    
    amp = amplitudes(i);
    off = offsets(i);
    
    input = awo.g(linspace(0,1,1000));
    input_derivatives = awo.dg(linspace(0,1,1000));
    
    if(sum(stanceFdb==i))
        cst = mean(awo.g(linspace(0,stance_percentage/100,1000)));
        subplot(3,2,1);
    elseif(sum(swingFdb==i))
        subplot(3,2,3);
        cst = mean(awo.g(linspace(stance_percentage/100,1,1000)));
    elseif(sum(cycleFdb==i))
        subplot(3,2,5);
        cst = mean(awo.g(linspace(0,1,1000)));
    elseif(sum(angleoffsetFdb==i))
        subplot(3,2,5);
        cst = mean(awo.g(linspace(0,1,1000)));
    elseif(sum(finishingStanceFdb==i))
        subplot(3,2,5);
        cst = mean(awo.g(linspace(50,stance_percentage/100,1000)));
    else
        disp(['error with feedback ' num2str(i)]);
    end
    hold on;
    plot(linspace(0,100,1000),amp.*input+off,'Color',col(i,:),'LineWidth',2);
    if write
    fid = fopen([folder names{i} '.txt'],'w+');  % Note the 'wt' for writing in text mode
    %plot(linspace(0,100,1000),ones(1,1000)*cst,'--','Color',col(i,:),'LineWidth',2);
    fprintf(fid,'%f %f %f\n',[off;amp;cst]);
    
    fprintf(fid,'%f %f\n',[input;input_derivatives]);  % The format string is applied to each element of a
    fclose(fid);
    end

end
subplot(3,2,1);
h=legend(strrep(names(stanceFdb),'_','\_'),'Location','BestOutside');
set(h,'FontSize',12);
legend boxoff
subplot(3,2,3);
h=legend(strrep(names(swingFdb),'_','\_'),'Location','BestOutside');
set(h,'FontSize',12);
legend boxoff
ylabel('normalized amplitude')
subplot(3,2,5);
h=legend(strrep(names([cycleFdb angleoffsetFdb finishingStanceFdb]),'_','\_'),'Location','BestOutside');
xlabel('cycle (%)')
set(h,'FontSize',12);
legend boxoff
h=subplot(1,2,2);
delete(h);
set(hFig, 'Position', [400,200,800,500])