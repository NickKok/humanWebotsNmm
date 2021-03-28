%% Extract Feedbacks
exps = {'base','rp','wg'};
exp = 5;
folder = '/home/efx/Development/PHD/Airi/current/raw_files/';

[a,b,c] = extract('feedbacks', 5 , folder);


%% Generate CPG signals
folder = '/home/efx/Development/PHD/Airi/current/webots/conf';
% names = {'gas__mff_stance'
% 'glu__mff_swing'
% 'glu_gif_stance'
% 'glu_hippd_swing_end'
% 'ham__mff_swing'
% 'ham_gif_stance'
% 'ham_hf_mlf_swing'
% 'hf__mlf_swing'
% 'hf_gif_stance'
% 'hf_hippd_swing_end'
% 'hf_tl_swing'
% 'sol__mff_stance'
% 'sol_ta_mff_stance'
% 'ta__mlf_cycle'
% 'vas__mff_stance'
% 'vas_gcf_stance_end'
% 'vas_kneepd_swing_end'
% 'vas_pko_angleoffset'};
names = {
'gas__mff_stance'
'glu__mff_swing'
'glu_gif_stance'
'ham__mff_swing'
'ham_gif_stance'
'ham_hf_mlf_swing'
'hf__mlf_swing'
'hf_gif_stance'
'hf_tl_swing'
'sol__mff_stance'
'sol_ta_mff_stance'
'ta__mlf_cycle'
'vas__mff_stance'
'vas_gcf_finishingstance'
'vas_pko_angleoffset'
};

SW = [2,4,6,7,9];%[2,4,6,7,9];
ST.G = [3,5,8,14];%[3,5,8,14];
ST.M = [1,10,11,13];%[1,10,11,13];
CY = [12,15];%[12,15];


col = jet(15);
for i=1:15
    %[mean(b(i).offset) mean(b(i).amplitude)];
    if length(a(i).value) == 0
        names{i}
    else
        fid = fopen([folder '/cpg_gate/cpg_data/' names{i} '.txt'],'w+');  % Note the 'wt' for writing in text mode
        input = filtfilt(1.0*ones(1,1),1,interp1(linspace(0,1,1000),a(i).value,0:0.001:1-0.001));
        hold on;
        plot(input,'Color',col(i,:),'LineWidth',2);
        
        if (true) % put false to extract offset and amplitude based on full cycle only
            if  ~isempty(find(SW==i))
                fprintf(fid,[num2str(mean(b(i).swing.offset)) ' ' num2str(mean(b(i).swing.amplitude)) '\n']);
            elseif ~isempty(find(ST.G==i)) | ~isempty(find(ST.M ==i))
                %keyboard
                fprintf(fid,[num2str(mean(b(i).stance.offset)) ' ' num2str(mean(b(i).stance.amplitude)) '\n']);
            elseif ~isempty(find(CY==i))
                fprintf(fid,[num2str(mean(b(i).offset)) ' ' num2str(mean(b(i).amplitude)) '\n']);
            end
        else
            fprintf(fid,[num2str(mean(b(i).offset)) ' ' num2str(mean(b(i).amplitude)) '\n']);
        end
        fprintf(fid,'%f\n',input);  % The format string is applied to each element of a
        fclose(fid);
    end
end
legend(strrep(names,'_','\_'))