# -*- coding: utf-8 -*-
"""
Created on Mon Dec 21 01:23:33 2015

@author: daudt
"""

import numpy as np
import skimage as sk
import skimage.io as io

# Load images
lena = sk.img_as_float(io.imread('../lena.bmp'))
lena_uni = sk.img_as_float(io.imread('../lena_uni.bmp'))
lena_nor = sk.img_as_float(io.imread('../lena_nor.bmp'))
lena_ric = sk.img_as_float(io.imread('../lena_ric.bmp'))
lena_sp = sk.img_as_float(io.imread('../lena_sp.bmp'))

cameraman = sk.img_as_float(io.imread('../cameraman.bmp'))
cameraman_uni = sk.img_as_float(io.imread('../cameraman_uni.bmp'))
cameraman_nor = sk.img_as_float(io.imread('../cameraman_nor.bmp'))
cameraman_ric = sk.img_as_float(io.imread('../cameraman_ric.bmp'))
cameraman_sp = sk.img_as_float(io.imread('../cameraman_sp.bmp'))

baboon = sk.img_as_float(io.imread('../baboon.bmp'))
baboon_uni = sk.img_as_float(io.imread('../baboon_uni.bmp'))
baboon_nor = sk.img_as_float(io.imread('../baboon_nor.bmp'))
baboon_ric = sk.img_as_float(io.imread('../baboon_ric.bmp'))
baboon_sp = sk.img_as_float(io.imread('../baboon_sp.bmp'))


# Calculate MSE
lena_uni_mse = np.mean(np.square(lena_uni-lena))
lena_nor_mse = np.mean(np.square(lena_nor-lena))
lena_ric_mse = np.mean(np.square(lena_ric-lena))
lena_sp_mse = np.mean(np.square(lena_sp-lena))

cameraman_uni_mse = np.mean(np.square(cameraman_uni-cameraman))
cameraman_nor_mse = np.mean(np.square(cameraman_nor-cameraman))
cameraman_ric_mse = np.mean(np.square(cameraman_ric-cameraman))
cameraman_sp_mse = np.mean(np.square(cameraman_sp-cameraman))

baboon_uni_mse = np.mean(np.square(baboon_uni-baboon))
baboon_nor_mse = np.mean(np.square(baboon_nor-baboon))
baboon_ric_mse = np.mean(np.square(baboon_ric-baboon))
baboon_sp_mse = np.mean(np.square(baboon_sp-baboon))

# Calculate PSNR
lena_uni_psnr = 10*np.log10(1/lena_uni_mse)
lena_nor_psnr = 10*np.log10(1/lena_nor_mse)
lena_ric_psnr = 10*np.log10(1/lena_ric_mse)
lena_sp_psnr = 10*np.log10(1/lena_sp_mse)

cameraman_uni_psnr = 10*np.log10(1/cameraman_uni_mse)
cameraman_nor_psnr = 10*np.log10(1/cameraman_nor_mse)
cameraman_ric_psnr = 10*np.log10(1/cameraman_ric_mse)
cameraman_sp_psnr = 10*np.log10(1/cameraman_sp_mse)

baboon_uni_psnr = 10*np.log10(1/baboon_uni_mse)
baboon_nor_psnr = 10*np.log10(1/baboon_nor_mse)
baboon_ric_psnr = 10*np.log10(1/baboon_ric_mse)
baboon_sp_psnr = 10*np.log10(1/baboon_sp_mse)