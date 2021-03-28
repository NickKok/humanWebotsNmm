function out = extract_rawFile(dir,what,num,keepall)
freq = 1000; %hz
if(nargin < 3)
    num = 1;
end
if(nargin < 4)
    keepall = false;
end
disp(sprintf('%s/%s%d',dir,what,num))
out = importdata(sprintf('%s/%s%d',dir,what,num));
out.time = 1/freq*(0:size(out.data,1)-1);


indices_notin = @(side,leg) find(cellfun(@isempty,strfind(leg, side))~=0);
%REMOVE PKO_ANGLEOFFSET FEEDBACK BECAUSE NOT ACTIVE IN NORMAL WALKING
indiceToKeep = 1:length(out.colheaders);
if(~keepall)
    if(strcmp(what,'feedbacks') || strcmp(what,'cpgs'))
        if(strcmp(out.colheaders(23),'right_vas_pko_angleoffset'))
            indiceToKeep=indices_notin('PKO_ANGLEOFFSET',upper(out.textdata));
        end
    end
end
leg = upper(out.textdata);
leg = leg(indiceToKeep);
leg = strrep(leg,'FINISHINGSTANCE','STEND');
indices = @(side) find(cellfun(@isempty,strfind(leg, side))==0);


out.left = indices('LEFT');
out.right = indices('RIGHT');



out.legend.all = strrep(leg,'_','\_');

out.legend.one_side = {out.legend.all{out.left}};
out.legend.one_side = strrep(out.legend.one_side,'\_LEFT','');
out.legend.one_side = strrep(out.legend.one_side,'LEFT\_','');


out.data = out.data(:,indiceToKeep);
out.textdata = out.textdata(indiceToKeep);
out.colheaders = out.colheaders(indiceToKeep);

end
