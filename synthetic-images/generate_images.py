# -*- coding: utf-8 -*-
"""
Created on Sat Dec 19 22:11:58 2015

@author: daudt
"""

import numpy as np
import skimage as sk
import skimage.io as io

###############################################################################
##### Function definitions #####

def uni_u(val,s):
    "Additive Uniform noise function"
    u_noise = (np.random.rand()-0.5)*s*np.sqrt(12)
    return np.clip(val+u_noise,0,1)

uni = np.vectorize(uni_u)


def nor_u(val,s):
    "Additive Gaussian noise function"
    nor_noise = np.random.randn()*s
    return np.clip(val+nor_noise,0,1)

nor = np.vectorize(nor_u)


def saltNpepper_u(val,frac):
    "Additive Salt and Pepper noise function"
    out = val
    x =  np.random.rand()
    if x < (frac/2):
        out = 0
    elif x < frac:
        out = 1
    return np.clip(out,0,1)

saltNpepper = np.vectorize(saltNpepper_u)
    

def ric_u(val,s,v):
    "Additive Rician noise function"
    # average calculated for s = 0.1 and v = 0.05, recalculate if changed
    avg = 0.13311580132059475
    x = s*np.random.randn()
    y = s*np.random.randn()+v
    rician_noise = np.sqrt(x*x+y*y)-avg
    return np.clip(val+rician_noise,0,1)
    
ric = np.vectorize(ric_u)

###############################################################################
##### Applying noise #####

# Lena
lena = sk.img_as_float(io.imread('lena.bmp'))
lena_uni = uni(lena,0.1)
io.imsave('lena_uni.bmp',lena_uni)
lena_nor = nor(lena,0.1)
io.imsave('lena_nor.bmp',lena_nor)
lena_ric = ric(lena,0.1,0.05)
io.imsave('lena_ric.bmp',lena_ric)
lena_sp = saltNpepper(lena,0.1)
io.imsave('lena_sp.bmp',lena_sp)

# Cameraman
cameraman = sk.img_as_float(io.imread('cameraman.bmp'))
cameraman_uni = uni(cameraman,0.1)
io.imsave('cameraman_uni.bmp',cameraman_uni)
cameraman_nor = nor(cameraman,0.1)
io.imsave('cameraman_nor.bmp',cameraman_nor)
cameraman_ric = ric(cameraman,0.1,0.05)
io.imsave('cameraman_ric.bmp',cameraman_ric)
cameraman_sp = saltNpepper(cameraman,0.1)
io.imsave('cameraman_sp.bmp',cameraman_sp)

# Baboon
baboon = sk.img_as_float(io.imread('baboon.bmp'))
baboon_uni = uni(baboon,0.1)
io.imsave('baboon_uni.bmp',baboon_uni)
baboon_nor = nor(baboon,0.1)
io.imsave('baboon_nor.bmp',baboon_nor)
baboon_ric = ric(baboon,0.1,0.05)
io.imsave('baboon_ric.bmp',baboon_ric)
baboon_sp = saltNpepper(baboon,0.1)
io.imsave('baboon_sp.bmp',baboon_sp)



