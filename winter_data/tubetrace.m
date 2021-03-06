function tubetrace(x,y,z,N,R)
%Convert all vectors to column
x0=reshape(x,[],1);y0=reshape(y,[],1);z=reshape(z,[],1);
%Copy x, y 
x0=repmat(x0,1,N+1);y0=repmat(y0,1,N+1);
%Generate points in circles
myAng=linspace(0,2*pi,N+1);
xcir=R*cos(myAng);
ycir=R*sin(myAng);
xx=x0+repmat(xcir,size(x0,1),1);yy=y0+repmat(ycir,size(y0,1),1);
zz=repmat(z,1,N+1);
traceplot=surface(xx',yy',zz');
axis off equal