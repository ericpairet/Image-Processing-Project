close all
clc
%Iin=imread('C:\Users\PaolaAlejandra\Documents\I Semester\Image Processing\Project\Image-Processing-Project\synthetic-images\lena_nor.bmp');

%Iout=relnoise(Iin,3,0.5,'square','plot');

names = {'baboon_nor'; 'baboon_ric'; 'baboon_sp'; 'baboon_uni'; ...
    'cameraman_nor'; 'cameraman_ric'; 'cameraman_sp'; 'cameraman_uni'; ...
    'lena_nor'; 'lena_ric'; 'lena_sp'; 'lena_uni'};

for i = 1:length(names)
    image = imread(strcat(names{i}, '.bmp'));
    [thr,sorh,keepapp] = ddencmp('den', 'wv', image);
    Iout=relnoise(Iin,3,0.5,'square','plot');
    
    mse = mean((denoised - lena)^2);
    psnr = 10 * log10(1/mse);
    imwrite(uint8(denoised), strcat(names{i}, '-denoised.jpg'));
    
    fprintf('%s\nMSE: %d\nPSNR:%d', names{i})
end
%OR
%Iout=relnoise(Iin,3,0.5,'custom',strel('line',30,0),'plot');

