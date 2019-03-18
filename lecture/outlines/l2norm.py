import numpy as np
from numba import jit


n = 10 **7

x = np.random.randn(n)

def l2norm(x):
    out = 0.0
    for xi in x:
        out += xi*xi
    return np.sqrt(out)    


@jit
def l2norm_jit(x):
    out = 0.0
    for xi in x:
        out += xi*xi
    return np.sqrt(out)    


