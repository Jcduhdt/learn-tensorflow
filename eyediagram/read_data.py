import scipy.io as si
import numpy as np
import os
import h5py


def read_h5(path):
    with h5py.File(path) as f:
        data = np.transpose(f['data'])
        data = np.expand_dims(data, axis=3)
        labels = np.transpose(f['labels'])
        labels = np.squeeze(labels)
        # print(np.shape(data), np.shape(theta))
    return data, labels


if __name__ == '__main__':
    read_h5('./eyediagram.h5')
