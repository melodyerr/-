# -*- coding: utf-8 -*-
"""
Created on Fri Oct 26 13:10:46 2018

@author: Aria
"""

import tensorflow as tf
import numpy as np


tf.reset_default_graph()


n_batch = 1000/100
batch_size = 100

x = tf.placeholder(tf.float32,[None,206])
y = tf.placeholder(tf.float64,[None,10])

#10 def funcation
def weight_variable(shape):
    # inital Weight
    initial = tf.truncated_normal(shape,stddev = 0.1)
    return tf.Variable(initial)

def bias_variable(shape):
    # initial bias
    initial = tf.constant(0.1,shape = shape)
    return tf.Variable(initial)

def conv2d(x,W):
    # 2D con
    return tf.nn.conv2d(x,W,strides = [1,1,1,1],padding = 'VALID')


#11 make inputdata to 4d tensor
x_image = tf.reshape(x,[-1,2,103,1])

#12 con1
W_conv1 = weight_variable([1,3,1,20])
b_conv1 = bias_variable([20])
h_conv1 = tf.nn.relu(conv2d(x_image,W_conv1)+b_conv1)


#12 con1
W_conv2 = weight_variable([1,3,20,20])
b_conv2 = bias_variable([20])
h_conv2 = tf.nn.relu(conv2d(h_conv1,W_conv2)+b_conv2)

h_pool1 = tf.nn.max_pool(h_conv2,ksize=[1,1,3,1],strides=[1,1,3,1],padding='VALID')

#12 con1
W_conv3 = weight_variable([1,3,20,40])
b_conv3 = bias_variable([40])
h_conv3 = tf.nn.relu(conv2d(h_pool1,W_conv3)+b_conv3)

#12 con1
W_conv4 = weight_variable([1,2,40,40])
b_conv4 = bias_variable([40])
h_conv4 = tf.nn.relu(conv2d(h_conv3,W_conv4)+b_conv4)

h_pool2 = tf.nn.max_pool(h_conv4,ksize=[1,1,2,1],strides=[1,1,2,1],padding='VALID')

#12 con1
W_conv5 = weight_variable([2,1,40,40])
b_conv5 = bias_variable([40])
h_conv5 = tf.nn.relu(conv2d(h_pool2,W_conv5)+b_conv5)

h_pool2_flat = tf.reshape(h_conv5,[-1,60000])
W_fc1 = weight_variable([60000,1024])
b_fc1 = bias_variable([1024])
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat,W_fc1)+b_fc1)

# dropout
keep_prob = tf.placeholder(tf.float32)
h_fc1_drop = tf.nn.dropout(h_fc1,keep_prob)

# 1204 nn to 10 output
W_fc2 = weight_variable([1024,10])
b_fc2 = bias_variable([10])
y_conv = tf.matmul(h_fc1_drop,W_fc2)+b_fc2

# loss funcation
loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels = y,logits = y_conv))

# gradient descent
train_step_1 = tf.train.AdadeltaOptimizer(learning_rate = 0.1).minimize(loss)

# cal accuracy
correct_prediction= tf.equal(tf.argmax(y,1),tf.argmax(y_conv,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction,tf.float32))
#initial
init = tf.global_variables_initializer()


# begin train
with tf.Session() as sess:
    sess.run(init)
    for epoch in range(1,2):
        for batch  in range(int(n_batch)):
            batch_x = traindata[(batch)*batch_size:(batch+1)*batch_size]
            batch_y = trainlabel[(batch)*batch_size:(batch+1)*batch_size]
            print("di  "+str(batch))
            #import
            sess.run(train_step_1,feed_dict = {x:batch_x,y:batch_y,keep_prob:0.5})
        #cal accuracy
        #accuracy_n = sess.run(accuracy,feed_dict = {x:validation_images,y:validation_labels,keep_prob:1.0})
        #print("第"+str(epoch)+"轮的准确度是:"+str(accuracy_n))
        print("第"+str(epoch))
        #global_step.assign(epoch).eval()
        #saver.save(sess,"logs/model.ckpt",global_step = global_step)
    
print("6")


writer = tf.summary.FileWriter('Summary/',tf.get_default_graph())
writer.close()





