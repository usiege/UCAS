#-*-coding=utf-8-*-

from multiprocessing import Process
import os
import time


def run_process(name):
	time.sleep(2)
	print('Run child process %s is (%s). ' %(name, os.getpid()))

	pass

def hello_world():
	time.sleep(5)
	print('Run child process is (%s). ' %(os.getpid()))

	pass




if __name__ == "__main__":

	print("Parent process is %s." % (os.getpid()))

	p1 = Process(target=run_process, args=('test', ))
	p2 = Process(target=hello_world)

	print(" process will start...... ")

	p1.start()
	p2.start()
	p1.join()

	print(" process end!")


