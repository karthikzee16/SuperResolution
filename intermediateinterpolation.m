function rec = intermediateinterpolation(rgb,delta_est,phi_est,factor)
% INTERPOLATION - reconstruct a high resolution image using bicubic interpolation

n=length(rgb);
ss = size(rgb{1});
if (length(ss)==2) ss=[ss 1]; end
center = (ss+1)/2;
phi_rad = phi_est*pi/180;
imc=0;
% compute the coordinates of the pixels from the N images, using DELTA_EST and PHI_EST

for i=1:n
    s{i}=rgb2gray(rgb{i});
%     s{i}=rgb{i};
end
s_ = []; r_ = []; c_ = []; sr_ = []; rr_ = []; cr_ = [];
for k=1:1 % for each color channel
  for i=1:n % for each image
    s_c{i}=s{i}(:,:);
    s_c{i} = s_c{i}(:);
    r{i} = [1:factor:factor*ss(1)]'*ones(1,ss(2)); % create matrix with row indices
    c{i} = ones(ss(1),1)*[1:factor:factor*ss(2)]; % create matrix with column indices
    r{i} = r{i}-factor*center(1); % shift rows to center around 0
    c{i} = c{i}-factor*center(2); % shift columns to center around 0
    coord{i} = [c{i}(:) r{i}(:)]*[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))]; % rotate
    r{i} = coord{i}(:,2)+factor*center(1)+factor*delta_est(i,1); % shift rows back and shift by delta_est
    c{i} = coord{i}(:,1)+factor*center(2)+factor*delta_est(i,2); % shift columns back and shift by delta_est
    rn{i} = r{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    cn{i} = c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    sn{i} = s_c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    
   % blankimage=im2double(blankimage);
   
    if  (k==1)
       s_ = [s_; sn{i}];
       r_ = [r_; rn{i}];
       c_ = [c_; cn{i}];
       rec_col = griddata(c_,r_,s_,[1:ss(2)*factor],[1:ss(1)*factor]','cubic');
       rec(:,:,i) = reshape(rec_col,ss(1)*factor,ss(2)*factor);
     %  figure;
      % imshow(rec(:,:,i));
         outim{i}=rec(:,:,i);
       %title('intermediate of interpolation');
      
    end
    
  end

end

figure
rec(isnan(rec))=0;
m = ones(5,1)*(1:5);
slmin = 1;
slmax = n;
hsl = uicontrol('Style','slider','Min',slmin,'Max',slmax,...
                'SliderStep',[1 1]./(slmax-slmin),'Value',1,...
                'Position',[20 20 200 20]);
set(hsl,'Callback',@(hObject,eventdata) imshow(outim{round(get(hObject,'value'))}) );

end