function rec=do(imageFilenames)

  % load images
  IMAGESNUMBER = length(imageFilenames);
  IMAGES = {};
  IMAGES{1} = imread(imageFilenames{1});
  IMAGESINFO{1} = imfinfo(imageFilenames{1});
  refimage=imread(imageFilenames{1});
  osize=size(refimage)
  for i=2:IMAGESNUMBER
      tempImage = imread(imageFilenames{i});
      sc=scale(refimage , tempImage);
      b=imresize(tempImage,sc);
      %figure;
      b=imcrop(b,[1 1  osize(2)-1 osize(1)-1]);
      %imshow(b);
	  %uncomment to save images in a specific folder
    %  z=strcat('E:\project6\now\live\SuperResolution\Datasets\rescaledimages\image', num2str(i));
    %  z=strcat(z, '.jpg');
    %  imwrite(b,z);
      %sc;
  end

  
  
