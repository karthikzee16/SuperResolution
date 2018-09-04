function [rec,inp]=startSR(imageFilenames, handles)

  
  % load images
  IMAGESNUMBER = length(imageFilenames);
  IMAGES = {};
  IMAGESINFO = {};

  IMAGES{1} = imread(imageFilenames{1});
  IMAGESINFO{1} = imfinfo(imageFilenames{1});

  for i=2:IMAGESNUMBER
      tempImage = imread(imageFilenames{i});
      tempInfo = imfinfo(imageFilenames{i});

      % check for size mismatch
      if not(size(IMAGES{1}) == size(tempImage))
          error(['Image ' IMAGESSTRING{i} ' has not the same size as image ' IMAGESSTRING{1}], 'Size error');
          return;
      elseif not(IMAGESINFO{1}.BitDepth == tempInfo.BitDepth)
          error(['Image ' IMAGESSTRING{i} ' is not the same type as image ' IMAGESSTRING{1}], 'Size error');
          return;
      else
          IMAGES{i} = tempImage;
          IMAGESINFO{i} = tempInfo;
      end
  end

  %%% preprocessing images
  for i=1:IMAGESNUMBER
%      display(i/IMAGESNUMBER);
      im{i} = IMAGES{i};
      im{i} = im2double(im{i}); %double(im{i})/(2^(IMAGESINFO{i}.BitDepth/3));
      imColor{i} = im{i};
      if (size(size(IMAGES{1}), 2) == 3)
          im{i} = rgb2gray(im{i});
      end
      im_part{i} = imColor{i};

  end
  % performing image rgistration  using keren algorithm
  inp=im_part{1};
  [delta_est, phi_est] = keren(im);
   
  disp('estimated shifts :');
  disp(delta_est);
  
  disp('estimated rotation :');
  disp(phi_est);
  axes(handles.axes2);
  hold off;
  imshow( im{1} ); hold on;
  for k=2:IMAGESNUMBER
      h = imagesc( im{k});%imresize(im{k},2) ); % show the edge image
      set( h, 'AlphaData', 1/k );  % .5 transparency
  end
  
  axes(handles.axes3);
  hold off;
  imshow( im{1} ); hold on;
  for k=2:IMAGESNUMBER
      %subplot(2,2,k-1),imshow( im{1} ),title('overlap'); 
      J = imtranslate(im{k},[-1*delta_est(k), -1*delta_est(k+IMAGESNUMBER)]);
      J = imrotate(J,-1*phi_est(k));
      h = imagesc( J);%imresize(J,2) ); % show the edge image
      set( h, 'AlphaData', 1/k ); % .5 transparency hold on;
  end
  % for showing intermediate steps in interpolation optional for output
  intermediateinterpolation(im_part,delta_est,phi_est,handles.current_data);
  % performing image reconstruction
  [rec,factor]= interpolation(im_part,delta_est,phi_est,handles.current_data);
  
  %  Blur metric and other image quality metrics
 
  inp=imresize(inp,handles.current_data);
  %disp(size(inp));
  %disp(size(rec));
  b1=blurMetric(inp);
  b2=blurMetric(rec);
  disp('blur metric input image');
  disp(b1);
  disp('blur metric output image');
  disp(b2);

  imwrite(rec,'ans.png');
  disp('Mean Square Error = ');
  img = imresize(im_part{1},factor);
  mse = immse(rec,img);
  disp(mse);
  disp('Peak Signal to Noise Ratio = ');
  Psnr = psnr(rec,img);
  disp(Psnr);
  disp('Structural Similarity Index = ');
  ssi = ssim(img,rec);
  disp(ssi);
  
  
% figure;
 % imshow(rec);
  %title('final image after super resolution');
