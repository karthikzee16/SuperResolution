function [rec,scaleto] = interpolation(s,shifts,angles,scaleto)
% INTERPOLATION - reconstruct a high resolution image using bicubic interpolation

n=length(s);
z = size(s{1});
if (length(z)==2) 
    z=[z 1];
end
center = (z+1)/2;
phi_rad = angles*pi/180;
imc=0;
%figure;
% compute the coordinates of the pixels from the N images, using shifts and
% angles estimated

% for each layer in image
for k=1:z(3) 
    % for every image
  for i=1:n 
      
    s_c{i}=s{i}(:,:,k);
    s_c{i} = s_c{i}(:);
    % creating  matrix with indexes of row
    oldr{i} = [1:scaleto:scaleto*z(1)]'*ones(1,z(2));
    % creating  matrix with indexes of column
    oldc{i} = ones(z(1),1)*[1:scaleto:scaleto*z(2)]; 
    % shift rows to center around 0
    oldr{i} = oldr{i}-scaleto*center(1); 
    % shift columns to center around 0
    oldc{i} = oldc{i}-scaleto*center(2); 
    % performing rotation of image with estimated angle
    rotation=[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))];
    coord{i} = [oldc{i}(:) oldr{i}(:)]*rotation; 
    
    % shift rows back and shift by shifts
    newr{i} = coord{i}(:,2)+scaleto*center(1)+scaleto*shifts(i,1); 
    % shift columns back and shift by shifts
    newc{i} = coord{i}(:,1)+scaleto*center(2)+scaleto*shifts(i,2);
    
    % checking for out of indexes when performed rotation and translation 
    rn{i} = newr{i}((newr{i}>0)&(newr{i}<=scaleto*z(1))&(newc{i}>0)&(newc{i}<=scaleto*z(2)));
    cn{i} = newc{i}((newr{i}>0)&(newr{i}<=scaleto*z(1))&(newc{i}>0)&(newc{i}<=scaleto*z(2)));
    sn{i} = s_c{i}((newr{i}>0)&(newr{i}<=scaleto*z(1))&(newc{i}>0)&(newc{i}<=scaleto*z(2)));
    
   % blankimage=im2double(blankimage);
  
    
  end

  pixelvalues = [];
  rowcoord = [];
  colcoord = [];
  sr_= [];
  rr_ = []; 
  cr_ = [];
  
  % collecting all pixel values from all images
  for i=1:n % for each image
    pixelvalues = [pixelvalues; sn{i}];
    rowcoord = [rowcoord; rn{i}];
    colcoord = [colcoord; cn{i}];
     
  end
  

  % interpolate the high resolution pixels using cubic interpolation
  rec_col = griddata(colcoord,rowcoord,pixelvalues,[1:z(2)*scaleto],[1:z(1)*scaleto]','cubic');
  
  rec(:,:,k) = reshape(rec_col,z(1)*scaleto,z(2)*scaleto);
 

end

rec(isnan(rec))=0;
