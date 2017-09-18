#1.
#k为移动位数，n为数组长度，S为数组
def right_move01(k, n, S):
	p = 0 #附加的空间
	if k > n:
		k = k % n;
	for index in n:
		if index + k < n:
			p =  S[index + k];
			S[index + k] = S[index];
		else:
			p = S[(index + k) % n]
			S[(index + k) % n] = S[index]


#2.
def right_move02(k, n, S):
	p = 0 #附加的空间
	if k > n:
		k = k % n;
