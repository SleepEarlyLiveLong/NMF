% readdatak8.m: 
%   This file is used to read data from a XXX.txt file as k=8.
%   The raw data can be found here:
%   https://github.com/undersunshine/machine_learning_algorithms/blob/master/Matrix_Factorization/data.csv
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% read data
close;clear;
filename = 'resource/digitsdata.txt';
fileID = fopen(filename);
C=textscan(fileID,'%n');
fclose(fileID);
%--------------------------------------
% let k to be 8
k = 8;
n = 512*k;
m = 512/k;
Ddatak8 = zeros(n,m);
for i=1:n
    Ddatak8(i,:) = C{1,1}((i-1)*m+1:i*m);
end
save('resource/Ddatak8.mat','Ddatak8');
%--------------------------------------
%% show picture
% this step is to verify the last 'read data' step is correct
load('resource/Ddatak8.mat');
V = Ddatak8;
image = zeros(64,8*k,512/k);
for pic = 1:512/k
    for i=1:8*k
        image(:,i,pic) = V(64*(i-1)+1:64*i,pic);
    end
end
Image = zeros(512);
for row = 1:8
    for col = 1:64/k
        Image((row-1)*64+1:row*64,(col-1)*(8*k)+1:col*(8*k)) = image(:,:,(row-1)*8+col);
    end
end
% figure;imshow(Image);title('the original image');

%% save the raw data and files of other formats
imwrite(Image,'resource/data_image.png');
save('resource/Dimage.mat','Image');