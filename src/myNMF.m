function [W,H,iternum,distance] = myNMF(V,k,epsilon,itermax)
%MYNMF - The Non-negative Matrix Factorization algorithm.
%   To do the NMF for matrix V. The formula is shown as follows:
%   V(n*m) = W(n*k)*H(k*m)
%   For example, (n,m,k) = (4096,64,8) or (2048,128,4).
% 
%   Here are some message about NMF with the URL as follows:
%   https://zhuanlan.zhihu.com/p/27460660
%   https://blog.csdn.net/pipisorry/article/details/52098864
%
%   [W,H] = myNMF(V,epsilon,iternum)
% 
%   Input - 
%   V: the n*m data matrix, m n-vectors arranging by columns;
%   k: the number of basis vectors;
%   epsilon: error of distance between V and V' of two iterations;
%   itermax: iteration number upper limit.
%   Output - 
%   W : the n*k basis matrix, k n-vectors;
%   H : the k*m coefficient matrix, each columns are obtained by 
%       projecting each column of V matrix onto W matrix;
%   iternum : the number of interations consumed to meet epsilon;
%   distance : final distance between 2 metrics V and W*H after
%              iternum times of interations.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

%% pre-work
% n is the number of dimension, m is the number of n-vectors
[n,m] = size(V);
% initialize W and H
W_init = rand(n,k);
H_init = rand(k,m);
H_old = H_init;
W_old = W_init;
H_new = zeros(k,m);
W_new = zeros(n,k);
% some prepare variables
dist = zeros(itermax,1);
count = 2;
dist(count) = 100;
error = realmax;

%% iterate
% iterate as the following formula:
% 1. H_new(i,j) = H_old(i,j)*(W_old'*V)(i,j)/(W_old'*W_old*H_old)(i,j)
% 2. W_new(i,j) = W_old(i,j)*(V*H_old')(i,j)/(W_old*H_old*H_old')(i,j)
while error >= epsilon
    % update matrix H
    Hcoematx_up = (W_old')*V;
    Hcoematx_dn = (W_old')*W_old*H_old;
    for i=1:k
        for j=1:m
            if Hcoematx_dn(i,j)==0
                H_new(i,j) = H_old(i,j);
            else
                H_new(i,j) = H_old(i,j)*Hcoematx_up(i,j)/Hcoematx_dn(i,j);
            end
        end
    end
    % update matrix W
    % (?用Hold就是H和W同步更新，用Hnew就是H和W先后更新，怎么选)
    Wcoematx_up = V*(H_old)';       
    Wcoematx_dn = W_old*H_old*(H_old)';
    for i=1:n
        for j=1:k
            if Wcoematx_dn(i,j)==0
                W_new(i,j) = W_old(i,j);
            else
                W_new(i,j) = W_old(i,j)*Wcoematx_up(i,j)/Wcoematx_dn(i,j);
            end
        end
    end
    % calculate the difference between two iteration approximation matrices 
    dist(count) = sum(sum( (W_new*H_new-W_old*H_old).^2) );
    error = abs(dist(count)-dist(count-1));
    if mod(count,1000)==0
        fprintf('%d轮迭代误差为%d.\n',count,dist(count));
    end
    % The results of this round of iteration
    if count-1 == itermax
        fprintf('%d轮迭代已毕，误差仍未收敛.\n',itermax);
        break;
    end
    % prepare for the next round of round
    H_old = H_new;
    W_old = W_new;
    count = count+1;
end

%% get result

W = W_new;
H = H_new;
iternum = count-2;
distance = dist(count-1);

end
%%