from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
# import tensorflow as tf
import numpy as np
import pandas as pd


def get_feature(csv_path):
    data_set= pd.read_csv(csv_path)
    data_list=data_set.values
    feature_list=[]
    for ele in data_list:
        feature_list.append(ele[:-1])
    feature=np.array(feature_list)
    return feature
def get_labal(csv_path):
    data_label_set= pd.read_csv(csv_path,usecols=[4])
    label_list=[]
    for ele in data_label_set.values:
        for index in range(3):
            if ele[0]==index:
                label_np=np.zeros(3)
                label_np[index]=1
                label_list.append( label_np)
    label=np.array(label_list)
    return label

if __name__ == '__main__':
    train_csv_path='D:/llh/课程PPT/机器学习调研作业/data/Iris/iris_train.csv'
    test_csv_path ='D:/llh/课程PPT/机器学习调研作业/data/Iris/iris_test.csv'
    train_feature=get_feature(train_csv_path)
    train_label=get_labal(train_csv_path)
    test_feature=get_feature(test_csv_path)
    test_label = get_labal(test_csv_path)
    print(test_label)
    X = tf.placeholder("float", [None, 4])
    Y = tf.placeholder("float", [None, 3])
    nb_classes = 3

    W1 = tf.Variable(tf.random_normal([4, 20]))
    b1 = tf.Variable(tf.random_normal([20]))
    L1 = tf.nn.relu(tf.matmul(X, W1) + b1)

    W2 = tf.Variable(tf.random_normal([20, 10]))
    b2 = tf.Variable(tf.random_normal([10]))
    L2 = tf.nn.relu(tf.matmul(L1, W2) + b2)

    W3 = tf.Variable(tf.random_normal([10, 3]))
    b3 = tf.Variable(tf.random_normal([3]))
    hypothesis =tf.nn.softmax(tf.matmul(L2, W3) + b3)
    cost = tf.reduce_mean(-tf.reduce_sum(Y * tf.log(hypothesis), axis=1))
    optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.1).minimize(cost)
    is_correct = tf.equal(tf.arg_max(hypothesis, 1), tf.arg_max(Y, 1))
    accuracy = tf.reduce_mean(tf.cast(is_correct, tf.float32))
    with tf.Session() as sess:
       sess.run(tf.global_variables_initializer())

       for step in range(40001):
           sess.run(optimizer, feed_dict={X: train_feature, Y: train_label})
           if step % 200 == 0:
               print(step, sess.run(cost, feed_dict={X: train_feature, Y: train_label}))
               print("Accuracy: ", accuracy.eval(session=sess,
                                             feed_dict={X: test_feature, Y: test_label}))

