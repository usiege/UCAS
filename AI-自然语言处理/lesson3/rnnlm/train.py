#encoding:utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf8')

from input_data import *
import tensorflow as tf
import argparse
import time
import random
import os
from six.moves import cPickle
from model import *
os.environ["CUDA_VISIBLE_DEVICES"] = "2"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--data_dir', type=str, default='./data',
                        help='data directory containing input.txt')
    parser.add_argument('--file_name', type=str, default='jay.seg.txt',
                        help='input file_name')
    parser.add_argument('--save_dir', type=str, default='./model',
                        help='directory to store checkpointed models')
    parser.add_argument('--save_freq', type=int, default=1000,
                        help='save frequency. Number of passes between checkpoints of the model.')
    parser.add_argument('--batch_size', type=int, default=1200,
                        help='minibatch size')
    parser.add_argument('--seq_length', type=int, default=5,
                        help='RNN sequence length')
    parser.add_argument('--hidden_num', type=int, default=256,
                        help='number of hidden layers')
    parser.add_argument('--word_dim', type=int, default=256,
                        help='number of word embedding')
    parser.add_argument('--num_epochs', type=int, default=200,
                        help='number of epochs')
    parser.add_argument('--model', type=str, default='lstm',
                        help='rnn, gru, or lstm')
    parser.add_argument('--grad_clip', type=float, default=5.,
                        help='clip gradients at this value')
    parser.add_argument('--learning_rate', type=float, default=0.01,
                        help='learning rate for optimizer')

    args = parser.parse_args()

    data_loader = TextLoader2(args.data_dir, args.file_name, args.batch_size, args.seq_length)
    # data_loader = TextLoader2(args.data_dir, args.batch_size, args.seq_length)
    args.vocab_size = data_loader.vocab_size
    
    with tf.variable_scope('root'): 
        train_model = RNNLM(args)
    with tf.variable_scope('root', reuse=True):
        infer_model = RNNLM(args, infer=True)

    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        saver = tf.train.Saver(tf.global_variables())
        
        ckpt = tf.train.get_checkpoint_state(os.path.dirname(os.path.join(args.save_dir, 'checkpoint')))
        if ckpt and ckpt.model_checkpoint_path:
            print('load from checkpoint')
            saver.restore(sess, ckpt.model_checkpoint_path)

        for e in range(args.num_epochs):
            data_loader.reset_batch_pointer()
            for b in range(data_loader.num_batches):
                start = time.time()
                x, y = data_loader.next_batch()
                feed = {train_model.input_data: x, train_model.targets: y}
                train_loss,  _ = sess.run([train_model.cost, train_model.train_op], feed)
                end = time.time()
                if b == data_loader.num_batches-1:
                    print("{}/{} (epoch {}), train_loss = {:.3f}, time/batch = {:.3f}" .format(
                        b, data_loader.num_batches, e, train_loss, end - start))

                if (e * data_loader.batch_size + b) % args.save_freq == 0 \
                        or (e == args.num_epochs - 1 and
                            b == data_loader.num_batches - 1):
                    # save for the last result
                    checkpoint_path = os.path.join(args.save_dir, 'model.ckpt')
                    saver.save(sess, checkpoint_path,
                               global_step=e * data_loader.num_batches + b)
                    print("model saved to {}".format(checkpoint_path))

                if b % 100 == 0:
                    prime = '<START>' 
                    for i in range(5):
                        text = infer_model.sample(sess, data_loader.words, 
                                    data_loader.vocab, num=20, prime=prime, sampling_type=1)
                        text = text[:text.find('<END>')+6]
                        print(text)
                        # prime = '<START> ' + random.sample(data_loader.words, 1)[0]


if __name__ == '__main__':
    main()
