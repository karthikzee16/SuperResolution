q=rgb2gray(imread('car.jpg'));
r=imresize(q,0.1);

r2=imresize(q,0.2);
r3=r;
for i = 40:size(r,1)+39
    for j = 50:size(r,2)+49
        r3(i-39,j-49)=r2(i,j);
    end
end
imshow(r3);
size(r)
size(r3)
%imshow(q);
%imshow(r);
imwrite(r3,'1car_resized_0.1_0.2.jpg');