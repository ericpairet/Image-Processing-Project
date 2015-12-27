clc;
clear all;
close all;

names = {'baboon_nor'; 'baboon_ric'; 'baboon_sp'; 'baboon_uni'; ...
    'cameraman_nor'; 'cameraman_ric'; 'cameraman_sp'; 'cameraman_uni'; ...
    'lena_nor'; 'lena_ric'; 'lena_sp'; 'lena_uni'};

for i = 1:length(names)
    image = imread(strcat(names{i}, '.bmp'));
    [thr,sorh,keepapp] = ddencmp('den', 'wv', image);
    denoised = wdencmp('gbl', image, 'sym4', 2, thr, sorh, keepapp);
    imwrite(uint8(denoised), strcat(names{i}, '-denoised.bmp'));
end