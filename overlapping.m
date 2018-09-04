a = imread('samplek/book.png');
b = imread('samplek/book_rot_40.png');
c = imread('samplek/book_rot_14.png');
subplot(3,1,1),imshow(a);
subplot(3,1,2),imshow(b);
im={a,b,c};


subplot(3,1,3),imshow( a ); hold on;
for k=1:3
    h = imagesc( im{k} ); % show the edge image
    set( h, 'AlphaData', 1/k ); hold on;
end


