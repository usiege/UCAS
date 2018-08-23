#include <stdio.h>
#include <time.h>

#define N 1000000

int main(int argc, char const *argv[])
{
	double local, pi = 0.0,w;
	long i;
	w = 1.0/N;

	clock_t t1 = clock();

	for (int i = 0; i < N; ++i)
	{
		local = (i+0.5) * w;
		pi += 4.0/(1.0 + local*local);
	}

	clock_t t2 = clock();

	printf("π is %.20f\n",pi*w);
	printf("Time: %.2f seconds\n", (float)(t2-t1)/CLOCKS_PER_SEC);

	return 0;
}