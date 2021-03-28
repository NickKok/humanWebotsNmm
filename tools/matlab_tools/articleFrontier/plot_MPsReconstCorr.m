function plot_MPsReconstCorr(out,ids,keep,MP_Number)
if nargin == 3
    MP_Number=4;
end

muscleAct = out.muscle.signals;
muscleName = out.muscleName;

if MP_Number == 3
mp = out.musclePrimitives.MP3;
elseif MP_Number == 4
mp = out.musclePrimitives.MP4;
end
muscleMP = mp.MP;
muscleMP_W = mp.W;
MP_Number = mp.MP_Number;
muscleMPName = mp.MP_Name;

%MP1 = reshape(muscleMP(keep,:,1),length(keep),1000)';
%MP2 = reshape(muscleMP(keep,:,2),length(keep),1000)';
%MP3 = reshape(muscleMP(keep,:,3),length(keep),1000)';
%MP4 = reshape(muscleMP(keep,:,4),length(keep),1000)';
%MP5 = reshape(muscleMP(keep,:,5),length(keep),1000)';
%MP6 = reshape(muscleMP(keep,:,6),length(keep),1000)';

cc_after = get_correlation(muscleMP,1);

clear cc;
for id=ids
    m = reshape(muscleAct(id,:,:),1000,7);
    mrec = reshape(muscleMP(id,:,:),1000,MP_Number)*reshape(muscleMP_W(id,:,:),MP_Number,7);
    muscleAct_rec(id,:,:) = mrec;
    cc(id,:) = diag(corr(m,mrec));
end
%imagesc(cc);caxis([0,1]);
cc2=cc(keep,:);
%imagesc(cc2);caxis([min(cc2(:)) 1]);
imagesc(cc2);caxis([0,1]);
set(gca,'xticklabel',muscleName);
colorbar
%ylabel('repeat (order by CoT)')
end