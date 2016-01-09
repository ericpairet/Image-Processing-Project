#!/usr/bin/env

from ksvd import KSVD, KSVD_Encode
import numpy.random as rn
from numpy import array, zeros, dot
from PIL import Image
from skimage import data, io, filters
from skimage.viewer import ImageViewer

if __name__ == "__main__":

    D = io.imread("./lena.jpg", True)
    viewer = ImageViewer(D)
    viewer.show() 
   
    rs = rn.RandomState(0)

    target_sparsity = 32
    p = D.shape[1]
    d = D.shape[0]
    n = 1000

    M = zeros( (n, D.shape[0] + 1) )

    M[:, :target_sparsity] = rs.normal(size = (n, target_sparsity) )
    
    M = M.ravel()[:n*D.shape[0]].reshape(n, D.shape[0])

    X = dot(M, D)

    #KSVD(X,dict_size, target_sparsity,max_iterations,D_init = 'random', enable_printing = False, print_interval = 25, grad_descent_iterations = 2, convergence_check_interval = 50, convergence_threshhold = 0, enable_eigen_threading = False, enable_threading = True, enable_32bit_initialization = True, max_initial_32bit_iterations = 0)\n    \n    Runs an approximate KSVD algorithm using batch orthogonal matching pursuit.\n\n    :`X`:\n      n by p matrix of signals, where `n` is the number of signals and\n      p is the dimension of each signal.\n\n    :`dict_size`:\n      The size of the target dictionary.\n\n    :`target_sparsity`:\n      The target sparsity of the signal.\n\n    :`max_iterations`:\n      The maximum number of iterations to perform.  Generally takes 500-5000.\n    \n    :`D_init`:\n      Initialization mode of the dictionary.  If a `dict_size` by `p`\n      array is given, then this is used to initialize the dictionary.\n      Otherwise, if ``D_init == 'random'``, It is initialized\n      randomly.  If ``D_init == 'svd'`` (default), part of the\n      dictionary is initialized using a singular value decomposition\n      of the signal.  This can give faster convergence in some cases,\n      but hits a bad local minimum in others.\n\n    :`enable_printing`:\n      If True, prints periodic status messages about the\n      convergence. (default = False).\n\n    :`print_interval`:\n      How often to print convergence information.\n\n    :`grad_descent_iterations`:\n      The number of gradient descent steps used to approximate the\n      primary svd vectors at each iteration.  Default = 2.\n\n    :`convergence_check_interval`:\n      How often to check convergence.  This step can be expensive (default = 50).\n\n    :`convergence_threshhold`:\n      When the approximation accuracy falls below this, the algorithm\n      terminates.  Approximation accuracy is measured by\n      ``||X - D * Gamma||_2 / n``, where ``n`` is the number of signals.\n      If 0"" (default), the algorithm runs for ``max_iterations`` or to\n      machine epsilon, whichever comes first.\n\n    :`enable_eigen_threading`:\n      Whether to enable threading in linear algebra operations in the\n      Eigen libraries.  This is recommended only for very large\n      problems. (default = False).\n    \n    :`enable_threading`:\n      Whether to enable threading in calculating the sparse\n      projections in the Batch OMP step.  Generally, this can give\n      substantial speedup. (default = True).\n    \n    :`enable_32bit_initialization`:\n      Whether to process as much as possible using the faster 32bit\n      mode.  This is generally recommended, as the accuracy is\n      typically good enough for the start of most problems.  Once the\n      accuracy falls below what 32bit floats can accurately determine,\n      the computation switches to 64bit.\n    \n    :`max_initial_32bit_iterations`:\n      The maximum number of 32 bit iterations to do before switching\n      to 64bit mode.  If 0 (default), no limit.\n\n    Returns tuple (D, Gamma), where X \\simeq Gamma * D.\n    ";
    [dic, gamma] = KSVD(X, p, target_sparsity, 100, print_interval = 5)
    
    r = dot( gamma, dic)
    
    print dic.shape  
    print gamma.shape

    imgNoised = io.imread("./lena_sp.jpg", True);
    viewer = ImageViewer(imgNoised)
    viewer.show() 
   
    
    res = KSVD_Encode(imgNoised, dic, target_sparsity)
    #print res
    