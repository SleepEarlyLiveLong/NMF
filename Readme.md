# NMF

This is a realization of Principle Component Analysis (Nonnegative Matrix Factor, NMF) and its applications (Code + Description). Here is the file structure:

```
   NMF
    |-- src
        |-- resource
                |-- data_image.png
                |-- Ddatak4
                |-- Ddatak8
                |-- Ddatak16
                |-- digitsdata.txt
                |-- Dimage
        |-- myNMF.m
        |-- NMF_test.m
        |-- readdatak4.m
        |-- readdatak8.m
        |-- readdatak16.m
    |-- LICENSE
    |-- Readme.md
    |-- 学习笔记 _ 非负矩阵分解(NMF)浅析.md
```
Among the files above:
- folder 'resource' contains data and image to be used and produced in the project;
- file 'digitsdata.txt' is the data ro be used in this project in the form of TXT;
- file 'Ddatak8' is the data produced through file 'readdatak8.m' according to 'digitsdata.txt';
- file 'data_image.png' is the data produced through file 'readdatak8.m';
- file 'Dimage' is the data produced through file 'readdatak8.m';
- file 'Ddatak4' is the data produced through file 'readdatak4.m' according to 'Ddatak8';
- file 'Ddatak16' is the data produced through file 'readdatak16.m' according to 'Ddatak8';
- file 'myNMF.m' is a function to realize NMF by me myself;
- file 'NMF_test.m' is a test file to examine the performance of NMF;
- file 'readdatak4.m' is a file to produce data 'Ddatak4';
- file 'readdatak8.m' is a file to produce data 'Ddatak8';
- file 'readdatak16.m' is a file to produce data 'Ddatak16';
- file 'LICENSE' is the license file produced by github;
- file '学习笔记 _ 非负矩阵分解(NMF)浅析.md' is a detailed introduction document for this project. 

Here is the guide of running these files above:

First, you need file 'digitsdata.txt' in folder 'resource', other files in the dictionary is not necessary;
Then, run 'readdatak8.m' and you will get file 'Ddatak8', 'Dimage' and 'data_image.png';
After that, run 'readdatak4.m' and 'readdatak16.m' to get data 'Ddatak8' and 'Ddatak16' respectively;
Finally, you can use date 'Ddatak4', 'Ddatak8' and 'Ddatak16' respectively to run file 'NMF_test.m' and watch the performance of NMF.



For more detailed information, refer to article [学习笔记 _ 非负矩阵分解(NMF)浅析.md]().
