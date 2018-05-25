#pragma omp parallel shared(A, B, C) private(id)
{
	id = omp_get_thread_num();
	A[id] = big_calc1(id);

#pragma omp barrier
#pragma omp for
	for (int i = 0; i < N; ++i)	C[i] = big_calc3(i, A);

#pragma omp for nowait
	for (int i = 0; i < N; ++i)	B[i] = big_calc2(C, i);		

	A[i] = big_calc4(id);
}