#-*-coding=utf-8-*-

import time 
import math

def isprime(n):
	if not isinstance(n, int):
		raise TypeError("argument passed to is_prime is not of 'int' type")
	if n < 2:
		return False
	if n == 2:
		return True
	max = int(math.ceil(math.sqrt(n)))
	i = 2
	while i <= max:
		if n % i == 0:
			return False
		i += 1
	return True

def sum_primes(n):
	return sum([x for x in range(2, n) if isprime(x)])


#串行代码
print("{beg} serial process {beg}".format(beg='-'*16))
startTime = time.time()

inputs = (100000, 100100, 100200, 100300, 100400, 100500, 100600, 100700)
results = [(input,sum_primes(input)) for input in inputs]

for input, result in results:
    print("Sum of primes below %s is %s" % (input, result))

print("use: %.3fs"%( time.time()-startTime))


import pp

#并行代码
print("{beg} parallel process {beg}".format(beg='-'*16))
startTime = time.time()

job_server = pp.Server()

inputs = (100000, 100100, 100200, 100300, 100400, 100500, 100600, 100700)
jobs = [(input, job_server.submit(sum_primes, (input, ), (isprime, ),
        ("math", )) ) for input in inputs]

for input, job in jobs:
    print("Sum of primes below %s is %s" % (input, job()))

print("use: %.3fs"%( time.time()-startTime ) )



