import numpy as np
import keras
import read_data as rd
import os

os.environ["CUDA_VISIBLE_DEVICES"] = "4"

# with h5py.File('eyediagram.h5') as f:
#     data = np.transpose(np.array(f['data']), [2, 1, 0])
#     labels = np.array(f['labels'])


hight = 460
length = 360
depth = 1
sample = 100000


def cnn_model():
    model = keras.models.Sequential()
    model.add(keras.layers.Conv2D(16, [3, 3], padding='SAME', activation='tanh', use_bias=False, input_shape=[length, hight, depth]))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(32, [3, 3], padding='SAME', activation='tanh', use_bias=False))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(64, [3, 3], padding='SAME', activation='tanh', use_bias=False))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(128, [3, 3], padding='SAME', activation='tanh', use_bias=False))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(95, [3, 3], padding='SAME', activation='tanh', use_bias=False))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(48, [3, 3], padding='SAME', activation='tanh', use_bias=False))
    model.add(keras.layers.MaxPool2D())
    model.add(keras.layers.Conv2D(1, [3, 3], padding='VALID', use_bias=True))
    model.add(keras.layers.GlobalAveragePooling2D())

    model.summary()
    return model


def train(model, x_train, y_train, x_test, y_test, batch_size, epochs, lr):
    opt = keras.optimizers.Adam(lr=lr)
    # model.compile(loss='mean_absolute_error', optimizer=opt, metrics=['mae'])
    model.compile(loss='mean_squared_error', optimizer=opt, metrics=['mse'])
    model.fit(x_train, y_train, batch_size=batch_size, epochs=epochs, validation_data=(x_test, y_test))


def preprocessing():
    pass


if __name__ == '__main__':
    train_path = './eyediagram_train_100x_1.h5'
    test_path = './eyediagram_test_100x_1.h5'
    data_train, labels_train = rd.read_h5(train_path)
    labels_train = np.log(labels_train+1e-5)
    data_test, labels_test = rd.read_h5(test_path)
    labels_test = np.log(labels_test+1e-5)
    model = cnn_model()
    train(model, data_train, labels_train, data_test, labels_test, 32, 10, 1e-4)
