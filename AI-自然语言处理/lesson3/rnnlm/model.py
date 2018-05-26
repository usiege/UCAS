#encoding:utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import tensorflow as tf
#from tf.nn import rnn_cell
#from tf.contrib import seq2seq

import numpy as np
import math

class RNNLM():
    def __init__(self, args, infer=False):
        self.args = args
        if infer:
            args.batch_size = 1
            args.seq_length = 1

        if args.model == 'rnn':
            cell_fn = tf.nn.rnn_cell.BasicRNNCell
        elif args.model == 'gru':
            cell_fn = tf.nn.rnn_cell.GRUCell
        elif args.model == 'lstm':
            cell_fn = tf.nn.rnn_cell.BasicLSTMCell
        else:
            raise Exception("model type not supported: {}".format(args.model))

        cell = cell_fn(args.hidden_num)

        self.cell = cell# = rnn_cell.MultiRNNCell([cell] * args.num_layers)
        self.learning_rate = args.learning_rate
        self.input_data = tf.placeholder(tf.int32, [args.batch_size, args.seq_length])
        self.targets = tf.placeholder(tf.int32, [args.batch_size, args.seq_length])
        self.initial_state = cell.zero_state(args.batch_size, tf.float32)

        with tf.variable_scope('rnnlm'):
            softmax_w = tf.get_variable("softmax_w", [args.hidden_num, args.vocab_size])
            softmax_b = tf.get_variable("softmax_b", [args.vocab_size])
            with tf.device("/cpu:0"):
                embedding = tf.get_variable("embedding", [args.vocab_size, args.hidden_num])
                inputs = tf.nn.embedding_lookup(embedding, self.input_data)
                #inputs = tf.split(tf.nn.embedding_lookup(embedding, self.input_data),args.seq_length,axis=1)
                #inputs = [tf.squeeze(input_, [1]) for input_ in inputs]

        # def loop(prev, _):
        #     prev = tf.matmul(prev, softmax_w) + softmax_b
        #     prev_symbol = tf.stop_gradient(tf.argmax(prev, 1))
        #     return tf.nn.embedding_lookup(embedding, prev_symbol)

        # outputs, last_state = tf.contrib.legacy_seq2seq.rnn_decoder(
        #        inputs, self.initial_state, cell, loop_function=loop if infer else None, scope='rnnlm')
        outputs, last_state = tf.nn.dynamic_rnn(cell, inputs, initial_state=self.initial_state)

        output = tf.reshape(tf.concat(outputs, axis=1), [-1, args.hidden_num])
        self.logits = tf.matmul(output, softmax_w) + softmax_b
        self.probs = tf.nn.softmax(self.logits)
       
        # loss = tf.contrib.legacy_seq2seq.sequence_loss_by_example([self.logits],
        #        [tf.reshape(self.targets, [-1])],
        #        [tf.ones([args.batch_size * args.seq_length])],
        #        args.vocab_size)
        flat_targets = tf.reshape(tf.concat(self.targets, axis=1), [-1])
        loss = tf.nn.sparse_softmax_cross_entropy_with_logits(logits=self.logits, labels=flat_targets)
        self.cost = tf.reduce_sum(loss) / (args.batch_size * args.seq_length)
        self.final_state = last_state
        
        self.lr = tf.Variable(self.learning_rate, trainable=False)
        tvars = tf.trainable_variables()
        grads, _ = tf.clip_by_global_norm(tf.gradients(self.cost, tvars),
                args.grad_clip)
        optimizer = tf.train.AdamOptimizer(self.lr)
        self.train_op = optimizer.apply_gradients(zip(grads, tvars))

    def sample(self, sess, words, vocab, num=200, prime='<START>', sampling_type=1):
        state = sess.run(self.cell.zero_state(1, tf.float32))
        
        for word in prime.split():
            x = np.zeros((1, 1))
            x[0, 0] = vocab[word]
            feed = {self.input_data: x, self.initial_state: state}
            [state] = sess.run([self.final_state], feed)

        def weighted_pick(weights):
            t = np.cumsum(weights)
            s = np.sum(weights)
            return int(np.searchsorted(t, np.random.rand(1)*s))

        ret = prime
        word = prime.split()[-1]
        for n in range(num):
            x = np.zeros((1, 1))
            x[0, 0] = vocab[word]
            feed = {self.input_data: x, self.initial_state: state}
            [probs, state] = sess.run([self.probs, self.final_state], feed)
            p = probs[0]

            if sampling_type == 0:
                sample = np.argmax(p)
            elif sampling_type == 2:
                sample = weighted_pick(p)
            else: # sampling_type == 1 default:
                sample = weighted_pick(p)

            pred = words[sample]
            ret += ' ' + pred
            word = pred
        return ret
