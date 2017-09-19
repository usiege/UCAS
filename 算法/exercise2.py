#!usr/bin/python
#-*-encoding:utf-8-*-

import sys
import os, tarfile
import string

file_num = 0
result = 0

#命名
def despath_name(pathname):
	return pathname[:-9]

#解压缩tar
def unpack_path_file(pathname):
	archive = tarfile.open(pathname,'r:gz')
	filenames = archive.getnames()
	print("解压缩后的文件：" )
	print(filenames)
	despath = despath_name(pathname)
	archive.extractall(despath)
	# for filename in filenames:
	# 	filepath = os.getcwd() + "/" + filename
	# 	print(filepath)
	# 	archive.extract(filename,pathname[:-7])
	archive.close()

#读文件数字
def read_file_number(pathname):
	number = 0
	finalfile = open(pathname, 'r')
	line = finalfile.readline()
	number = (string.atoi(line) >= 0) and string.atoi(line) or 0		
	finalfile.close()
	return number

#文件操作
def file_action(pathname):
	global file_num
	file_num += 1
	global result
	result += read_file_number(pathname)

#递归求解
def recurs_file(pathname):
	unpack_path_file(pathname)
	pathname = pathname[:-7]

	if os.path.isdir(pathname):
		filelist = os.listdir(pathname)
		for file in filelist:
			current_path = pathname + "/" + file
			print("当前文件：" + current_path)
			recurs_file(current_path)
	else:
		file_action()
	# if pathname.endswith("tar.gz"):
		
	# else:
	# 	recurs_file(pathname)


recurs_file(sys.argv[1])
# unpack_path_file(sys.argv[1])

print("文件数是：" + '%d' %file_num)
print("非负数的和是：" + '%d' %result)


