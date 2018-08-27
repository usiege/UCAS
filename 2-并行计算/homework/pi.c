#include <stdio.h>
#include <omp.h>

static long num_steps = 1000000000; //定义所分块数

#define NUM_THREADS 2 //定义所开启的线程数

int main(int argc, char const *argv[])
{
	double time_serial, time_parallel;
	double start_time, run_time;
	int i = 0;

	//串行-----------------------------------
	printf("进行串行运算：\n");
	double sum = 0.0;
	double step = 1.0 / (double) num_steps;
	double x, pi;

	start_time = omp_get_wtime();
	for (i = 0; i < num_steps; ++i)
	{	
		x = (i + 0.5) * step;
		sum += 4.0 / (1.0 + x * x);
	}

	pi = step * sum;
	run_time = omp_get_wtime() - start_time;
	time_serial = run_time;

	printf("串行计算pi所用时间为：%f\n", run_time);
	printf("pi:%lf \n", pi);

	//并行-------------------------------------
	printf("进行并行运算：\n");
	omp_set_num_threads(NUM_THREADS);//开启线程
	i = 0;
	sum = 0.0;
	x = 0.0, pi = 0.0;
	step = 1.0 / (double) num_steps;

	start_time = omp_get_wtime();
#pragma omp parallel sections reduction(+:sum) private(x,i)
	{
	#pragma omp section
		{
			for (i = omp_get_thread_num(); i < num_steps; i = i+NUM_THREADS)
			{
				x = (i + 0.5) * step;
				sum += 4.0 / (1.0 + x * x);
			}
		}
	#pragma omp section
		{
			for (i = omp_get_thread_num(); i < num_steps; i = i+NUM_THREADS)
			{
				x = (i + 0.5) * step;
				sum += 4.0 / (1.0 + x * x);
			}
		}
	}
	pi = step * sum;
	run_time = omp_get_wtime() - start_time;
	time_parallel = run_time;
	printf("并行计算pi所用时间为：%f \n", run_time);
	printf("pi:%lf \n", pi);


	printf("加速比：%f \n", time_serial / time_parallel);
	return 0;
}






