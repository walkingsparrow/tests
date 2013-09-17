import sys
import random
from numpy import matrix
from numpy import linalg

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

# ------------------------------------------------------------------------

def get_errors(ts, p, q, phi, theta):
    """
    compute the error items
    """
    mu = float(sum(ts))/len(ts)
    n = max(p, q)
    z = []
    for i in range(n, len(ts)):
        t = 0.0
        for j in range(p):
            t += phi[j] * (mu - ts[i - j - 1])
        for j in range(q):
            t += theta[j] * (0 if (i - j - 1) < n else z[i - j - 1 - n]) 
        z.append(ts[i] - t)
    return z

# ------------------------------------------------------------------------

def get_jacobian(ts, p, q, z):
    """
    compute the Jacobian matrix
    """
    mu = float(sum(ts))/len(ts)
    n = max(p, q)
    jacob = []
    for i in range(n, len(ts)):
        t = []
        for j in range(p):
            t.append(mu - ts[i - j - 1]) 
        for j in range(q):
            t.append(0 if (i - j - 1) < n else z[i - j - 1 - n])
        jacob.append(t)
    return jacob

# ------------------------------------------------------------------------
        
def iter(ts, p, q, phi, theta):
    """
    LMA iteration
    """
    z = get_errors(ts, p, q, phi, theta)
    jacob = get_jacobian(ts, p, q, z)

    m = matrix(jacob)
    m_crossprod = m.transpose() * m
    m_trans_z = m.transpose() * matrix(z).transpose()
    delta = linalg.solve(m_crossprod, m_trans_z).getA1()
     
    for i in range(p):
        phi[i] += delta[i]
    for i in range(q):
        theta[i] += delta[p + i]

    return [phi, theta]

# ------------------------------------------------------------------------

def arima(ts, p, d, q):
    """
    ARIMA
    """
    ts = diff(ts, d)
    phi = [random.random()] * p
    theta = [random.random()] * q
 
    print '....init: phi = %s, theta = %s' % (str(phi), str(theta))
    for i in range(100):
        [phi, theta] = iter(ts, p, q, phi, theta)
        print '....iter %d: phi = %s, theta = %s' % (i, str(phi), str(theta))

# ------------------------------------------------------------------------

ts = [100.8, 81.6, 66.5, 34.8, 30.6, 7, 19.8, 92.5,
        154.4, 125.9, 84.8, 68.1, 38.5, 22.8, 10.2, 24.1, 82.9,
        132, 130.9, 118.1, 89.9, 66.6, 60, 46.9, 41, 21.3, 16,
        6.4, 4.1, 6.8, 14.5, 34, 45, 43.1, 47.5, 42.2, 28.1, 10.1,
        8.1, 2.5, 0, 1.4, 5, 12.2, 13.9, 35.4, 45.8, 41.1, 30.4
    ]
p = int(sys.argv[1])
d = int(sys.argv[2])
q = int(sys.argv[3])
arima(ts, p, d, q)

