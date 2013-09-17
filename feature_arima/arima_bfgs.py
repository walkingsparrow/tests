import sys
import random
from math import sqrt
from math import isinf
from math import log
from numpy import matrix
from numpy import linalg
from numpy import diag
from numpy import dot
from numpy import identity
from scipy.optimize import minimize

def diff(ts, d):
    """ 
        difference a time series 
        ts <- (1 - B)^d ts
    """
    for i in range(d):
        y = []
        for j in range(1, len(ts)):
            y.append(ts[j] - ts[j - 1])
        ts = y
    return ts

def get_errors(pars, *args):
    ts = args[0]
    p = args[1]
    q = args[2]

    phi = pars[0:p]
    theta = pars[p: p + q]

    n = max(p, q)
    z = []
    for i in range(n, len(ts)):
        t = 0.0
        for j in range(p):
            t += phi[j] * (ts[i - j - 1])
        for j in range(q):
            t += theta[j] * (0 if (i - j - 1) < n else z[i - j - 1 - n]) 
        z.append(ts[i] - t)

    return dot(z, z)

def arima(ts, p, d, q):
    """
        ARIMA
    """
    ts = diff(ts, d)
    par0 = [0.0] * (p + q)
    res = minimize(get_errors, par0, args = (ts, p, q), method = 'BFGS')

    print res


ts = [100.8, 81.6, 66.5, 34.8, 30.6, 7, 19.8, 92.5,
        154.4, 125.9, 84.8, 68.1, 38.5, 22.8, 10.2, 24.1, 82.9,
        132, 130.9, 118.1, 89.9, 66.6, 60, 46.9, 41, 21.3, 16, 
        6.4, 4.1, 6.8, 14.5, 34, 45, 43.1, 47.5, 42.2, 28.1, 10.1,
        8.1, 2.5, 0, 1.4, 5, 12.2, 13.9, 35.4, 45.8, 41.1, 30.4]

p = int(sys.argv[1])
d = int(sys.argv[2])
q = int(sys.argv[3])
arima(ts, p, d, q)

