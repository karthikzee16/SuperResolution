img = imread('book.png');
T = maketform('affine', [1 0 0; 0 1 0; 1 19 1]);   %# represents translation
img2 = imtransform(img, T,'XData',[1 size(img,2)], 'YData',[1 size(img,1)]);
imshow(img2);
imwrite(img2,'book_shifted_1_19.png');