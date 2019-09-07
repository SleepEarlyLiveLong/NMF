
# <center><font face="宋体"> 学习笔记|非负矩阵分解(NMF)浅析 </font></center>

*<center><font face="Times New Roman" size = 3> Author：[chentianyang](https://github.com/chentianyangWHU) &emsp;&emsp; E-mail：tychen@whu.edu.cn &emsp;&emsp; [Link](https://github.com/chentianyangWHU/NMF)</center>*

**概要：** <font face="宋体" size = 3> 这篇博客和博客 [学习笔记|主成分分析[PCA]及其若干应用](https://blog.csdn.net/ctyqy2015301200079/article/details/85325125)、[学习笔记|独立成分分析(ICA, FastICA)及应用](https://blog.csdn.net/ctyqy2015301200079/article/details/86705869) 属于一个系列，简单地介绍非负矩阵分解(Non-negative Matrix Factorization, NMF)。</font>

**关键字：** <font face="宋体" size = 3 >非负矩阵分解; NMF</font>

# <font face="宋体"> 1 背景说明 </font>

&emsp;&emsp; <font face="宋体">非负矩阵分解问题涉及的面很广很多，这里只通过一个例子简单理解它的概念和物理意义。这道题是从[知乎](https://zhuanlan.zhihu.com/p/27460660)上看到的，现摘录如下：</font>

> 题目的要求如下图，其中如2-digits这张图，图中每两个数字构成一个子图（横着看，比如第一行为41,43,42,14,12,14,23,41），对应的右图为左图的一个主成分元素，即2-digits这张图中的每个单一的数字都是一个主成分，要求利用主成分分析等方法将图中的数字一一分离出来，如右图所示。


<center><img src="https://img-blog.csdnimg.cn/20190811191403158.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="50%">  </center><center><font face="宋体" size=2 > 图1 2-digits NMF练习题 </font> </center>

# <font face="宋体"> 2 NMF简介 </font>

&emsp;&emsp; <font face="宋体">非负矩阵分解(Non-negative Matrix Factorization, NMF)的基本思想可以简单描述为：对于任意给定的一个非负矩阵V，NMF算法能够寻找到一个非负矩阵W和一个非负矩阵H，使得 V=W*H 成立 ，从而将一个非负的矩阵分解为左右两个非负矩阵的乘积。</font>

&emsp;&emsp; <font face="宋体">NMF本质上说是一种矩阵分解的方法，它的特点是可以将一个大的非负矩阵分解为两个小的非负矩阵，又因为分解后的矩阵也是非负的，所以也可以继续分解。NMF的应用包括但不限于提取特征、快速识别、基因和语音的检测等等。</font>

&emsp;&emsp; <font face="宋体">NMF算法自于1999年由Lee和Seung发表于Nature后便广泛应用于各个场景。从矩阵空间的角度分析，NMF的意义在于在原空间中寻找一组新基底并将原数据投影到该基底上去。原非负矩阵V对应原空间中的原数据，分解之后的两个非负矩阵W和H分别对应寻找得到的新基底和投影在新基底上的数值。</font>

&emsp;&emsp; <font face="宋体">不妨假设原n维实数空间中有m个数据，将其排列成一个n\*m的矩阵V，则NMF的任务就变成在该n维实数空间中寻找k个n维基向量(n-vector)，排成n\*k矩阵W，将m个n维数据分别投影到这k个n-vector上，得到一组新的m个k维数据，记作k\*m矩阵H。因此，整个NMF的公式可以写作：</font>

> V(n\*m) = W(n\*k)\*H(k\*m)

&emsp;&emsp; <font face="宋体">以上内容可以用图2的一页PPT表示：</font>

<center><img src="https://img-blog.csdnimg.cn/20190811194744690.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="80%">  </center><center><font face="宋体" size=2 > 图1 2-digits NMF练习题 </font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">为了帮助读者清晰直观地理解NMF算法的实现原理，以二维空间中四个数据的变换为例讲解矩阵分解和线性空间中的线性变换的原理，如图2所示。</font>

<center><img src="https://img-blog.csdnimg.cn/20190811210504462.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="80%">  </center><center><font face="宋体" size=2 > 图2 以二维空间为例说明线性空间中的线性变换</font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">需要注意的是，图2并不能完全表明NMF的工作原理。非负矩阵分解的关键是“非负”，即原数据和新基底都必须是非负数，或者说位于“第一象限”，这样原数据投影在新基底上的数值才自然也是非负数。而图2中的四个数据中的C和D明显就不是非负数，同样基底j也不位于第一象限，所以上图的关键是介绍矩阵的分解，也就是线性空间中的线性变换方法。</font>

&emsp;&emsp; <font face="宋体">下面用数学语言对NMF进行描述，并直接给出求解NMF的迭代公式，如图3所示。</font>

<center><img src="https://img-blog.csdnimg.cn/20190811211015323.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="80%">  </center><center><font face="宋体" size=2 > 图3 NMF的数学描述和求解迭代公式</font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">如图3所示，NMF的本质是通过一个矩阵去求解两个为止矩阵。图3采用的是迭代法，一步步逼近最终的结果，当计算得到的两个矩阵W和H收敛时，就说明分解成功。需要注意的是，原矩阵和分解之后两个矩阵的乘积并不要求完全相等，可以存在一定程度上的误差。</font>

&emsp;&emsp; <font face="宋体">如果要在计算机中实现NMF，则可以根据如图4所示的步骤进行。</font>

<center><img src="https://img-blog.csdnimg.cn/20190811211421444.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="80%">  </center><center><font face="宋体" size=2 > 图4 NMF算法步骤</font> </center>

# <font face="宋体"> 3 核心代码 </font>

```
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

```

# <font face="宋体"> 4 NMF的应用 </font>

&emsp;&emsp; <font face="宋体">现在，就用NMF算法解文章最开始提出的问题。</font>

&emsp;&emsp; <font face="宋体">首先介绍原始数据。我们能得到的最原始的数据其实并不是图1左侧所示的那张图，而是一个4096\*64的矩阵，存储于一个.txt文件中。该矩阵按列存储图1左侧中所示的128个、64组数字：矩阵的每一列代表图中的一个数字组，图中每两个横向连接的数字构成一个正方形的数字组，每一个数字组的图像大小是64\*64，计4096个像素。图中每个数字都是集合{1，2，3，4}中的某个元素，单形状不同、浓淡（像素值）各异。经过一些基本的处理，就可以将这个4096\*64的矩阵转换为图1左侧所示的图像。</font>

&emsp;&emsp; <font face="宋体">对这一问题的处理思路如下。以两个横向相邻的数字为1组，形成8\*8共计64张子图，将这64张子图，或者说是64个4096维向量映射到由8个新基底构成的坐标系上，这8个新基底向量仍在原数据所在的4096维实数空间中。</font>

&emsp;&emsp; <font face="宋体">以上内容可由图5概括，如下所示。</font>

<center><img src="https://img-blog.csdnimg.cn/20190811214336395.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="90%"> </center><center><font face="宋体" size=2 > 图5 用NMF提取图像主要成分的过程分析</font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">用NMF的方程表述，应当写成如下形式：</font>

<center><img src="https://img-blog.csdnimg.cn/20190811215124750.png" width="50%"> </center><center><font face="宋体" size=2 ></font> 

</center> &nbsp; &emsp;&emsp; <font face="宋体">最后的结果如图6所示：</font> 

<center><img src="https://img-blog.csdnimg.cn/20190811215610357.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="70%"> </center><center><font face="宋体" size=2 > 图6 用NMF提取图像主要成分的结果</font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">下面分析图6的含义。</font>

&emsp;&emsp; <font face="宋体">W是新产生的基底，有8个，每个仍然是4096维实数空间中的向量，在这里就体现为64\*64的图像方块。在这个方块中，数字位于左右两侧，非左即右；且位于左侧和位于右侧的数字数量都是4，数字1，2，3，4各一，这很好地体现了基底之间线性不相关的性质。</font>

&emsp;&emsp; <font face="宋体">以W为新基底，就可以将整张图投影到该基底上去。不妨按照顺序从上到下将新基底编号，那么原图64组数据都能在该基底上进行投影，相当于可以用一个8维向量，或者说是坐标，来表示原来的64\*64子图，一定意义上也起到了数据压缩（有损压缩）的作用。</font>

&emsp;&emsp; <font face="宋体">下面举例说明。第一张子图中的数字是42——42的左侧是数字4，左侧数字4在第5个位置，对应第5号基底；42的右侧是数字2，右侧数字2在第4个位置，对应第4号基底——因此，第一张子图对应的8位坐标中的第4个和第5个数字应当明显比其余6个数字大，图6中右侧的“变量-H”表中的第一列数据明显符合这一结论，红色矩形框圈出的两个最大的数字分别位于第4位和第5位。同理，第二张子图中的数字是11，对应新基底中的1号轴和3号轴，因此该子图在这两个轴上的投影最大，对应“变量-H”表中第二列数字中第1个和第3个数字最大。其余以此类推。</font>

# <font face="宋体"> 5 背景问题的拓展 </font>
&emsp;&emsp; <font face="宋体">经过上文的分析说明，读者应该对NMF有了基本的了解，并应当对它的物理意义有了更加深刻的体会。但是，我在把这个问题弄明白之后，又有了一点疑惑，就是为什么产生的新基底的数量要是8？或者说，为什么原图要拆分成64个子图、每个子图中有2个左右相邻的数字？我能不能将原图拆成128组、每组中只有1个数字？又或者我能不能将原图拆成32组、每组中有4个数字？甚至是16组、每组8个数字；8组、每组16个数字？等等。</font>

&emsp;&emsp; <font face="宋体">为此，我又做了其他一些实验。结果表明，上述想法是可行的，在原理上也是正确的。下面我分别贴上将原图拆成128组、每组中只有1个数字和将原图拆成32组、每组中有4个数字这两组实验的结果，分别如图7和图8所示。这里不再对图7-8作仔细的分析。</font>

<center><img src="https://img-blog.csdnimg.cn/20190811223141817.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="90%"> </center><center><font face="宋体" size=2 > 图7 将原图拆成128组、每组中只有1个数字的NMF结果</font> </center>

<center><img src="https://img-blog.csdnimg.cn/20190811223020699.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="90%"> </center><center><font face="宋体" size=2 > 图8 将原图拆成32组、每组中有4个数字的NMF结果</font> </center>

# <font face="宋体"> 6 小结 </font>
&emsp;&emsp; <font face="宋体">在全文的最后，我将对这一系列的三篇文章，包括本篇和前两篇博客 [学习笔记|主成分分析[PCA]及其若干应用](https://blog.csdn.net/ctyqy2015301200079/article/details/85325125)、[学习笔记|独立成分分析(ICA, FastICA)及应用](https://blog.csdn.net/ctyqy2015301200079/article/details/86705869) 进行一个小结。</font>

&emsp;&emsp; <font face="宋体">PCA、ICA和NMF虽然格局特色，但是可以用一个关键词将它们联系起来：矩阵分解。从数学上来看，三者都可以用同一个公式表达：A=B\*C，其中A、B、C都是矩阵。不同的是，在不同的算法中三个矩阵的已知和待求解的关系不同，对该公式的理解角度也不尽相同。下面用一张图简单描述上述三种方法的联系和区别，如图9所示。</font>

<center><img src="https://img-blog.csdnimg.cn/20190812124836361.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2N0eXF5MjAxNTMwMTIwMDA3OQ==,size_16,color_FFFFFF,t_70" width="90%"> </center><center><font face="宋体" size=2 > 图8 将原图拆成32组、每组中有4个数字的NMF结果</font> </center>

&nbsp;
&emsp;&emsp; <font face="宋体">本文为原创文章，转载或引用务必注明来源及作者。</font>






