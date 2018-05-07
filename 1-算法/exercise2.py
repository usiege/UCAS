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
	if not pathname.endswith("tar.gz"):
		return;
	archive = tarfile.open(pathname,'r:gz')
	filenames = archive.getnames()
	print("解压缩后的文件：" )
	print(filenames)
	despath = despath_name(pathname)
	archive.extractall(despath)
	archive.close()
	# for filename in filenames:
	# 	filepath = os.getcwd() + "/" + filename
	# 	print(filepath)
	# 	archive.extract(filename,pathname[:-7])
	

#读文件数字
def read_file_number(pathname):
	print("读到的文件路径：" + pathname)
	number = 0
	finalfile = open(pathname, 'r')
	line = finalfile.readline()
	print("文件内容是：" + line)
	number = (string.atoi(line) >= 0) and string.atoi(line) or 0		
	finalfile.close()
	return number

#文件操作
def file_action(pathname):
	global file_num
	global result
	result += read_file_number(pathname)
	if not os.path.isdir(pathname):
		file_num += 1

#递归求解
static_num = 0
def recurs_file(pathname):
	unpack_path_file(pathname)
	newpath = pathname[:-7]

	if os.path.isdir(newpath):
		filelist = os.listdir(newpath)
		print("子文件：")
		print(filelist)
		for file in filelist:
			global static_num
			static_num += 1
			current_path = newpath + "/" + file
			print("当前文件：" + current_path)
			recurs_file(current_path)
	else:
		file_action(newpath)


recurs_file(sys.argv[1])
print(static_num)
# unpack_path_file(sys.argv[1])

print("最终结果是：")
print("文件数：" + '%d' %file_num)
print("非负数的和：" + '%d' %result)


