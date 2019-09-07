% NMF_test.m: 
%   This file is used for testing the NMF(Non-negative Matrix
%   Factorization) algorithm, and you can find some message 
%   about this case with the URL as follows:
%   https://zhuanlan.zhihu.com/p/27460660
%   https://blog.csdn.net/pipisorry/article/details/52098864
%   For example, (n,m,k) = (2048,128,4) or (4096,64,8) or else.
%
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% pre-work
clear;close;
load('resource/Ddatak16.mat');      % load data
V = Ddatak16;
%% NMF algorithm
epsilon = 0;
itermax = 10000;
k = 16;              % the number of basis vectors
[W,H,iternum,distance] = myNMF(V,k,epsilon,itermax);
%% get matrix W and transfer W into image
% matrix W contains main information about the original image V
[n,~] = size(W);
% --------------Img, horizontal typesetting
Img_r = zeros(64,8*k*k);
for pic = 1:k
    for i=1:8*k
        Img_r(:,(pic-1)*(8*k)+i) = W(64*(i-1)+1:64*i,pic);
    end
end
% --------------Img, vertical typesetting 
Img_c = zeros(64*k,8*k);
for pic=1:k
    Img_c(64*(pic-1)+1:64*pic,:) = Img_r(:,(8*k)*(pic-1)+1:(8*k)*pic);
end
figure;imshow(Img_c,'InitialMagnification','fit');
title(['main information of the original image',newline,...
    'distance=',num2str(distance),', ','iternum=',num2str(iternum)]);
%% about matrix H
% process H, columns of H are Projection Vector of each column of V on W, 
% just like COORDINATES.
[B,I] = sort(H,'descend');
coord = I(1:2,:)';