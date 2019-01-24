# -*- coding: utf-8 -*-
"""
Created on Fri Oct 26 13:10:46 2018

@author: Aria
"""
import pandas as pd
import numpy as np
import tensorflow as tf

tf.reset_default_graph()

# load Data
train_data = pd.read_csv("pair_data.csv")
train_label = pd.read_csv("pair_label.csv")
test_data = pd.read_csv("test1.csv")
x_train = train_data.iloc[:, :].values
x_train = x_train.astype(np.float)
test = test_data.iloc[:, :].values
test = test.astype(np.float)
# 5 abstract dataset labels
train_labels_flat = train_label.iloc[:, 0].values.ravel()
# labels_flat = train[[0]].values.ravel()
train_labels_count = np.unique(train_labels_flat).shape[0]


# One_Hot
def dense_to_one_hot(labels_dense, num_classes):
    num_labels = labels_dense.shape[0]
    index_offset = np.arange(num_labels) * num_classes
    labels_one_hot = np.zeros((num_labels, num_classes))
    labels_one_hot.flat[index_offset + labels_dense.ravel() - 1] = 1
    return labels_one_hot


# 6 eval one_hot
y_train = dense_to_one_hot(train_labels_flat, train_labels_count)
y_train = y_train.astype(np.uint8)

# ==============================================================
# 打乱顺序
train_data_shape = x_train.shape[0]
test_shape = test.shape[0]
arr = np.arange(train_data_shape)
np.random.shuffle(arr)
x_train = x_train[arr]
y_train = y_train[arr]
# =============================================================
# 划分训练集和验证集20%
k = 80400
validdata = x_train[:k]
validlabel = y_train[:k]

traindata = x_train[k:]
trainlabel = y_train[k:]
# print(traindata.shape[0])
# print(validdata.shape[0])
# =============================================================
# n_batch = train_data_shape*0.8/100
batch_size = 100

x = tf.placeholder(tf.float32, [None, 400])
y = tf.placeholder(tf.float64, [None, 10])


# 10 def funcation
def weight_variable(shape):
    # inital Weight
    initial = tf.truncated_normal(shape, stddev=0.1)
    return tf.Variable(initial)


def bias_variable(shape):
    # initial bias
    initial = tf.constant(0.1, shape=shape)
    return tf.Variable(initial)


def conv2d(x, W):
    # 2D con
    return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='VALID')


# 11 make inputdata to 4d tensor
x_image = tf.reshape(x, [-1, 2, 200, 1])

# 12 con1
W_conv1 = weight_variable([1, 9, 1, 10])
b_conv1 = bias_variable([10])
h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)

# 12 con2
W_conv2 = weight_variable([2, 1, 10, 10])
b_conv2 = bias_variable([10])
h_conv2 = tf.nn.relu(conv2d(h_conv1, W_conv2) + b_conv2)

# 12 con3
W_conv3 = weight_variable([1, 3, 10, 10])
b_conv3 = bias_variable([10])
conv3 = tf.nn.conv2d(h_conv2, W_conv3, strides=[1, 1, 1, 1], padding='SAME')
h_conv3 = tf.nn.relu(conv3 + b_conv3)

h_pool1 = tf.nn.max_pool(h_conv3, ksize=[1, 1, 3, 1], strides=[1, 1, 3, 1], padding='VALID')

# 12 con4
W_conv4 = weight_variable([1, 3, 10, 20])
b_conv4 = bias_variable([20])
h_conv4 = tf.nn.relu(conv2d(h_pool1, W_conv4) + b_conv4)

# 12 con5
W_conv5 = weight_variable([1, 3, 20, 20])
b_conv5 = bias_variable([20])
h_conv5 = tf.nn.relu(conv2d(h_conv4, W_conv5) + b_conv5)

h_pool2 = tf.nn.max_pool(h_conv5, ksize=[1, 1, 2, 1], strides=[1, 1, 2, 1], padding='VALID')

# 12 con6
W_conv6 = weight_variable([1, 3, 20, 40])
b_conv6 = bias_variable([40])
h_conv6 = tf.nn.relu(conv2d(h_pool2, W_conv6) + b_conv6)

# 12 con7
W_conv7 = weight_variable([1, 3, 40, 40])
b_conv7 = bias_variable([40])
h_conv7 = tf.nn.relu(conv2d(h_conv6, W_conv7) + b_conv7)

h_pool3 = tf.nn.max_pool(h_conv7, ksize=[1, 1, 2, 1], strides=[1, 1, 2, 1], padding='VALID')

# 12 con8
W_conv8 = weight_variable([1, 13, 40, 80])
b_conv8 = bias_variable([80])
h_conv8 = tf.nn.relu(conv2d(h_pool3, W_conv8) + b_conv8)

# 12 con9
W_conv9 = weight_variable([1, 1, 80, 80])
b_conv9 = bias_variable([80])
h_conv9 = tf.nn.relu(conv2d(h_conv8, W_conv9) + b_conv9)

# 12 con10
W_conv10 = weight_variable([1, 1, 80, 10])
b_conv10 = bias_variable([10])
y_conv = conv2d(h_conv9, W_conv10) + b_conv10

y_out_soft = tf.nn.softmax(y_conv)

y_out = tf.reshape(y_out_soft, [100, 10])
out = tf.argmax(y_out, 1)

# loss funcation
loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y, logits=y_conv))

# gradient descent
train_step_1 = tf.train.AdadeltaOptimizer(learning_rate=0.001).minimize(loss)

# cal accuracy
correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_out, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
# initial
init = tf.global_variables_initializer()
saver = tf.train.Saver()

# begin train
with tf.Session() as sess:
    sess.run(init)
    for epoch in range(10000):
        for i in range(3210):
            start = (i * batch_size) % 321000  # traindata.shape[0]
            end = start + batch_size
            batch_x = traindata[start:end]
            batch_y = trainlabel[start:end]
            # print("di  "+str(i))
            sess.run(train_step_1, feed_dict={x: batch_x, y: batch_y})
        # cal accuracy
        for i in range(804):
            start = (i * batch_size) % 80400  # validdata.shape[0]
            end = start + batch_size
            batch_xx = validdata[start:end]
            batch_yy = validlabel[start:end]
            accuracy_n = sess.run(accuracy, feed_dict={x: batch_xx, y: batch_yy})
        print("第" + str(epoch) + "轮的准确度是:" + str(accuracy_n))
        # print("第"+str(epoch))
        # global_step.assign(epoch).eval()
        saver.save(sess, "logs/model.ckpt", global_step=epoch)

print("6")

writer = tf.summary.FileWriter('Summary/', tf.get_default_graph())
writer.close()

# pred=sess.run(out,feed_dict = {x:test})