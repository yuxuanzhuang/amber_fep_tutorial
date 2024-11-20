"""Python 3 script to compute the FEP results from the dV/dlambda files."""
import math
from collections import OrderedDict
import os
import sys
import glob
import numpy as np


class OnlineAvVar:
    """A class that uses an online algorithm to compute mean and variance."""

    def __init__(self, store_data=False):
        self.step = 0
        self.mean = 0.0
        self.M2 = 0.0

        self.store = store_data
        self.data = []

    def accumulate(self, x):
        """Accumulate data points to compute mean and variance on-the-fly."""
        self.step += 1

        delta = x - self.mean

        self.mean += delta / self.step
        self.M2 += delta * (x - self.mean)

        if self.store:
            self.data.append(x)

    def get_variance(self):
        """Convenience function to return variance."""
        if self.step > 1:
            return self.M2 / (self.step - 1)
        return float('nan')

    def get_stat(self):
        """Convenience function to return mean and standard deviation."""
        if self.step > 1:
            return self.mean, math.sqrt(self.M2 / (self.step - 1))
        return self.mean, float('nan')


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print(f"Usage: {sys.argv[0]} skip glob_pattern windows", file=sys.stderr)
        sys.exit(1)

    skip = int(sys.argv[1])
    glob_pattern = sys.argv[2]
    windows = sys.argv[3:]
    extrap = 'polyfit'  # or linear or polyfit
    stats = []

    data = OrderedDict()

    for window in windows:
        cwd = os.getcwd()
        os.chdir(window)

        dVdl = OnlineAvVar()
        ln = 0

        for en in glob.glob(glob_pattern):
            with open(en, 'r') as en_file:
                for line in en_file:
                    ln += 1

                    if ln > skip and line.startswith('L9') and 'dV/dlambda' not in line:
                        dVdl.accumulate(float(line.split()[5]))

        mean, std = dVdl.get_stat()
        if dVdl.step > 1:
            data[float(window)] = (mean, std / math.sqrt(dVdl.step), std)
        else:
            data[float(window)] = (mean, float('nan'), float('nan'))

        os.chdir(cwd)

    x = list(data.keys())
    y = [d[0] for d in data.values()]

    if extrap == 'linear':
        if 0.0 not in x:
            l = (x[0] * y[1] - x[1] * y[0]) / (x[0] - x[1])
            x.insert(0, 0.0)
            y.insert(0, l)

        if 1.0 not in x:
            l = ((x[-2] - 1.0) * y[-1] + ((1.0 - x[-1]) * y[-2])) / (x[-2] - x[-1])
            x.append(1.0)
            y.append(l)
    elif extrap == 'polyfit' and (0.0 not in x or 1.0 not in x):
        deg = min(len(x) - 1, 6)

        coeffs = np.polyfit(x, y, deg)

        if 0.0 not in x:
            x.insert(0, 0.0)
            y.insert(0, coeffs[-1])

        if 1.0 not in x:
            x.append(1.0)
            y.append(sum(coeffs))

    for a, b in zip(x, y):
        if a in data:
            v = data[a]
            print(a, v[0], v[1], v[2])
        else:
            print(a, b)

    print('# dG =', np.trapz(y, x))