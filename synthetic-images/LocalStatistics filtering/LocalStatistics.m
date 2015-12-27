close all
clc
Iin=imread('C:\Users\PaolaAlejandra\Documents\I Semester\Image Processing\Project\Image-Processing-Project\synthetic-images\lena_nor.bmp');

Iout=relnoise(Iin,3,0.5,'square','plot');
%OR
%Iout=relnoise(Iin,3,0.5,'custom',strel('line',30,0),'plot');

