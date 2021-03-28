function out = change_length(in,length_out)
if(size(in,1) < size(in,2))
    disp('Warning think of giving the transpose');
end
length = size(in,1);
dim = size(in,2);

if nargin ~= 2
    length_out = length;
end
out = zeros(length_out,dim);

for i=1:dim
out(:,i) = ppval(spline(linspace(0,1,length),in(:,i)),linspace(0,1,length_out));
end