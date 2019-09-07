% readdata.m: 
%   This file is used to read data from file 'Ddatak8' produced by readdatak8.m, as k=4.
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
k = 4;
n = 512*k;
m = 512/k;
Ddatak4 = zeros(n,m);
for i=1:m
    if mod(i,2)==1
        Ddatak4(:,i) = V(1:2048,(i+1)/2);
    elseif mod(i,2)==0
        Ddatak4(:,i) = V(2049:4096,i/2);
    end
end
save('resource/Ddatak4.mat','Ddatak4');
%--------------------------------------
%% show picture
% this step is to verify the last 'read data' step is correct
load('resource/Ddatak4.mat');
V = Ddatak4;
image = zeros(64,32,128);
for pic = 1:128
    for i=1:32
        image(:,i,pic) = V(64*(i-1)+1:64*i,pic);
    end
end
Image = zeros(512);
for row = 1:8
    for col = 1:16
        Image((row-1)*64+1:row*64,(col-1)*32+1:col*32) = image(:,:,(row-1)*16+col);
    end
end
% figure;imshow(Image);title('the original image');
%%