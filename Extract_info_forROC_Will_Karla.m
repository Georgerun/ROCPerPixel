% Read all excel info

[num1,~,~] = xlsread('Summary MW analysis CT and MR_all tissues_221018','Summary table Fat(blue)');
[num2,~,~] = xlsread('Summary MW analysis CT and MR_all tissues_221018','Summary table Sternum MC(red)');
[num3,~,~] = xlsread('Summary MW analysis CT and MR_all tissues_221018','Summary table Vert MC(green)');

%Exclude all the NaN

% num1_new=num1(:,[1:2 5:18 20:28]);
% num2_new=num2(:,[1 3:28]);
% num3_new=num3(:,[1:9 11:18 20:28]);

% Perform 0 and 1 diagnostic classification

% First on a per-patient basis

% Create a single matrix

Matrix_1=num1([2808:3053],1:end); % Blue
Matrix_2=num2([2897:3818],1:end); % Red
Matrix_3=num3([2950:3609],1:end); % Green 

NMatrix_1=num1([2808:3053],1:size(Matrix_1,2)-4);
NMatrix_2=num2([2897:3818],1:size(Matrix_2,2)-4);
NMatrix_3=num3([2950:3609],1:size(Matrix_3,2)-4);

Add_pixels_NMatrix_1=sum(NMatrix_1(:,2:size(NMatrix_1,2)),2);
Add_pixels_NMatrix_2=sum(NMatrix_2(:,2:size(NMatrix_2,2)),2);
Add_pixels_NMatrix_3=sum(NMatrix_3(:,2:size(NMatrix_3,2)),2);

% Find nonzeros and exclude zeros

Getnonzeros_1=find(Add_pixels_NMatrix_1);
Getnonzeros_2=find(Add_pixels_NMatrix_2);
Getnonzeros_3=find(Add_pixels_NMatrix_3);

NAdd_pixels_NMatrix_1=Add_pixels_NMatrix_1(Getnonzeros_1);
NAdd_pixels_NMatrix_2=Add_pixels_NMatrix_2(Getnonzeros_2);
NAdd_pixels_NMatrix_3=Add_pixels_NMatrix_3(Getnonzeros_3);

NMatrix_1=NMatrix_1(Getnonzeros_1);
NMatrix_2=NMatrix_2(Getnonzeros_2);
NMatrix_3=NMatrix_3(Getnonzeros_3);

[pixel_NMatrix_1,~]=rude(NAdd_pixels_NMatrix_1,NMatrix_1)
[pixel_NMatrix_2,~]=rude(NAdd_pixels_NMatrix_2,NMatrix_2)
[pixel_NMatrix_3,~]=rude(NAdd_pixels_NMatrix_3,NMatrix_3)

% Createones_NMatrix_1=ones(1,length(pixel_NMatrix_1));
% Createzeros_NMatrix_1=zeros(1,length(pixel_NMatrix_1));
% Createones_NMatrix_2=ones(1,length(pixel_NMatrix_2));
% Createzeros_NMatrix_2=zeros(1,length(pixel_NMatrix_2));
% Createones_NMatrix_3=ones(1,length(pixel_NMatrix_3));
% Createzeros_NMatrix_3=zeros(1,length(pixel_NMatrix_3));

Blue_pixel=pixel_NMatrix_1;
Red_pixel=pixel_NMatrix_2;
Green_pixel=pixel_NMatrix_3;

% Prepare matrices and diagnostic matrices for ROC

% 1. Green vs Red + Blue

Red_Blue_pixel=[Blue_pixel Red_pixel];
Createzeros_Red_Blue_pixel=zeros(1,length(Red_Blue_pixel));
Createones_Green_pixel=ones(1,length(Green_pixel));

Green_vs_Red_Blue_pixel=[Red_Blue_pixel Green_pixel]';
Diagn_1=[Createzeros_Red_Blue_pixel Createones_Green_pixel]';

% 2. Green vs  Blue

Createzeros_Blue_pixel=zeros(1,length(Blue_pixel));

Green_vs_Blue_pixel=[Blue_pixel Green_pixel]';
Diagn_2=[Createzeros_Blue_pixel Createones_Green_pixel]';

% 3. Green vs Red

Createzeros_Red_pixel=zeros(1,length(Red_pixel));

Green_vs_Red_pixel=[Red_pixel Green_pixel]';
Diagn_3=[Createzeros_Red_pixel Createones_Green_pixel]';

% 4. Red vs Blue

Createones_Red_pixel=ones(1,length(Red_pixel));

Red_vs_Blue_pixel=[Blue_pixel Red_pixel]';
Diagn_4=[Createzeros_Blue_pixel Createones_Red_pixel]';

Get_lowest_red=min(Red_pixel);

% 5. Red vs Green

Createzeros_Green_pixel=zeros(1,length(Green_pixel));

Red_vs_Green_pixel=[Red_pixel Green_pixel]';
Diagn_5=[Createones_Red_pixel Createzeros_Green_pixel];



