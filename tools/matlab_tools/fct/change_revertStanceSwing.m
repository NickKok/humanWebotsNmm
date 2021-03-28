function out = change_revertStanceSwing(in,st_in)
    %BUGGY
if(size(in,1) < size(in,2))
    disp('Warning think of giving the transpose');
end

len = size(in,1);

dim = size(in,2);
out = zeros(len,dim);
for i=1:dim
    
    pp=spline(linspace(0,2,2000),[in(:,i);in(:,i)]);
    out(:,i) = ppval(linspace(st_in,st_in+1,1000),pp);
    
end    


end