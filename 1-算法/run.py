#!usr/bin/python

import sys
import os, tarfile

def unpack_path_file(pathname):
	archive = tarfile.open(pathname,'r:gz')
	filenames = archive.getnames()
	# print(filenames)

	for filename in filenames:
		archive.extract(filename,os.getcwd())
		filepath = os.getcwd() + "/" + filename
		# if os.path.isdir(filepath):
		# 	pass
		# else:
		# 	os.mkdir(filepath[:-7])
		# print(filename,filepath)
	archive.close()


print(str(sys.argv[1]))
unpack_path_file(sys.argv[1])