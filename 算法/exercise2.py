import os, tarfile

file_num = 0
result = 0

def unpack_path_file(pathname):
	archive = tarfile.open(pathname,'r:gz')
	for tarinfo in archive:
		archive.extract(tarinfo,os.getcwd())
	archive.closed()

def recurs_file(pathname):
	if pathname.endswith("tar.gz"):
		file_num += 1;
		unpack_path_file(pathname)
	else:
		



file_num,result = recurs_file(pathname)