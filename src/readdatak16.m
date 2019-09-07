% readdatak16.m: 
%   This file is used to read data from file 'Ddatak8' produced by readdatak8.m, as k=16.
%   The raw data can be found here:
%   https://github.com/undersunshine/machine_learning_algorithms/blob/master/Matrix_Factorization/data.csv
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% read data
close;clear;
load('resource/Ddatak8.mat');
V = Ddatak8;
%--------------------------------------
% let k to be 4
k = 16;
n = 64*64*4;
m = 512/k;
Ddatak16 = zeros(n,m);
for i=1:m
    Ddatak16(1:4096,i) = V(:,2*i-1);
    Ddatak16(4097:4096*2,i) = V(:,2*i);
end
save('resource/Ddatak16.mat','Ddatak16');
%--------------------------------------
%% show picture
% this step is to verify the last 'read data' step is correct
load('resource/Ddatak16.mat');
V = Ddatak16;
image = zeros(64,32*4,32);
for pic = 1:32
    for i=1:32*4
        image(:,i,pic) = V(64*(i-1)+1:64*i,pic);
    end
end
Image = zeros(512);
for row = 1:8
    for col = 1:4
        Image((row-1)*64+1:row*64,(col-1)*(32*4)+1:col*(32*4)) = image(:,:,(row-1)*4+col);
    end
end
% figure;imshow(Image);title('the original image');
%%