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

#pragma omp parallel
{
	do_many_things();
	#pragma omp master
	{
		exchange_boundaries();
	}

	#pragma omp barrier
	do_many_other_things();
}

#pragma omp parallel
{
	do_many_things();
	#pragma omp single
	{
		exchange_boundaries();
	}
	do_many_other_things();
}

#pragma omp parallel
{
	#pragma omp sections
	{
		#pragma omp section
		x_calculation();
		#pragma omp section
		y_calculation();
		#pragma omp section
		z_calculation();
	}
}

#pragma omp parallel for
for (int i = 0; i < NBUCKETS; ++i)
{
	omp_init_lock(&hist_locks[i]);
	hist[i] = 0;
}
#pragma omp parallel for
for (int i = 0; i < NVALS; ++i)
{
	ival = (int)sample(arr[i]);
	omp_set_lock(&hist_locks[ival]);
		hist[ival]++;
	omp_unset_lock(&hist_locks[ival]);
}

for (int i = 0; i < NBUCKETS; ++i)
{
	omp_destroy_lock(&hist_locks[i]);
}


#include <omp.h>
void main()
{     
	int num_threads;

	omp_set_dynamic( 0 );
	omp_set_num_threads( omp_num_procs() );

	#pragma omp parallel
	{     
		int id=omp_get_thread_num();

		#pragma omp single
	    num_threads = omp_get_num_threads();
		do_lots_of_stuff(id);
	}
}

std::vector<node *> nodelist;
for (p = head; p != NULL; p = p->next)
{
	nodelist.push_back(p);
}

int j = (int)nodelist.size();

#pragma omp parallel for schedule(static, 1)
for (int i = 0; i < j; ++i)
{
	processwork(nodelist[i]);
}















