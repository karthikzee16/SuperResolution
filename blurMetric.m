function blur = blurMetric(original)
I = double(original);
[y x] = size(I);

Hv = [1 1 1 1 1 1 1 1 1]/9;
Hh = Hv';

B_Ver = imfilter(I,Hv);%blur the input image in vertical direction
B_Hor = imfilter(I,Hh);%blur the input image in horizontal direction

D_F_Ver = abs(I(:,1:x-1) - I(:,2:x));%variation of the input image (vertical direction)
D_F_Hor = abs(I(1:y-1,:) - I(2:y,:));%variation of the input image (horizontal direction)

D_B_Ver = abs(B_Ver(:,1:x-1)-B_Ver(:,2:x));%variation of the blured image (vertical direction)
D_B_Hor = abs(B_Hor(1:y-1,:)-B_Hor(2:y,:));%variation of the blured image (horizontal direction)

T_Ver = D_F_Ver - D_B_Ver;%difference between two vertical variations of 2 image (input and blured)
T_Hor = D_F_Hor - D_B_Hor;%difference between two horizontal variations of 2 image (input and blured)

V_Ver = max(0,T_Ver);
V_Hor = max(0,T_Hor);

S_D_Ver = sum(sum(D_F_Ver(2:y-1,2:x-1)));
S_D_Hor = sum(sum(D_F_Hor(2:y-1,2:x-1)));

S_V_Ver = sum(sum(V_Ver(2:y-1,2:x-1)));
S_V_Hor = sum(sum(V_Hor(2:y-1,2:x-1)));

blur_F_Ver = (S_D_Ver-S_V_Ver)/S_D_Ver;
blur_F_Hor = (S_D_Hor-S_V_Hor)/S_D_Hor;

blur = max(blur_F_Ver,blur_F_Hor);

