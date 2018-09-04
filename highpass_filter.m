function [highpass] = highpass_filter(m,n)
	[fx,fy]=freqspace([m,n],'meshgrid');
	fx=fx/2;
	fy=fy/2;
	for i=1:m
		for j=1:n
			if(abs(fx(i,j))<=0.5&&abs(fy(i,j))<=0.5)
				temp=cos(pi*fx(i,j))*cos(pi*fy(i,j));
	            highpass(i,j)=(1.0-temp)*(2.0-temp);
			else
				highpass(i,j)=0;
			end
		end
	end