function out = change_stancePercentage(in,st_in,st_out,length_out)
    %BUGGY
if(size(in,1) < size(in,2))
    disp('Warning think of giving the transpose');
end


len = size(in,1);
if nargin ~= 4
    length_out = len;
end

dim = size(in,2);
out = zeros(length_out,dim);
for i=1:dim
    pp=spline(linspace(0,1,len),in(:,1));
    xst = ppval(linspace(0,st_in,len),pp);
    xsw = ppval(linspace(st_in,1,len),pp);
    
    ppst = spline(linspace(0,1,len),xst);
    ppsw = spline(linspace(0,1,len),xsw);
    out(:,i) = [ppval(linspace(0,1,round(len*st_out)),ppst) ppval(linspace(0,1,len-round(len*st_out)),ppsw)];
end    


end