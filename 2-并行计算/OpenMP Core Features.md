# OpenMP Core Features

标签（空格分隔）： course

---

## Creating threads
![image_1ce5vv8jn8l9st2195stlvctp.png-49.7kB][1]

并行性逐渐增加直到满足性能目标：即顺序程序演变成并行程序。
### 使用OpenMP创建线程

```c++
double A[1000];
omp_set_num_threads(4);
#pragma omp parallel
{
    int ID = omp_get_thread_num();
    pooh(ID,A);
}
```
上面的程序在并行区域内创建了四个线程，每个线程调用了`pooh(ID,A)`，其中ID = 0 to 3；

另外一种写法：
```c++
double A[1000];

#pragma omp parallel num_threads(4)
{
    int ID = omp_get_thread_num();
    pooh(ID,A);
}
```
![image_1ce614sch7ud1s0pjva1mo7orc53.png-72.9kB][2]

* what the compiler does
![image_1ce618s2epfi5808gb1rnf3gf5g.png-12.1kB][3]
![image_1ce619rlspqgm7dplgm0ng115t.png-37.4kB][4]
所有已知的OpenMP实现都使用线程池，所以对于并行区域，线程创建和销毁的全部成本不会发生。
只创建三个线程，因为最后一个并行部分将从父线程调用。

### PI的数值积分

* 在串行程序中

```c++
static long num_steps = 100000;
double step;
int main ()
{ 
    int i; double x, pi, sum = 0.0;

    step = 1.0/(double) num_steps;

    for (i=0;i< num_steps; i++){
        x = (i+0.5)*step;
        sum = sum + 4.0/(1.0+x*x);
    }
    pi = step * sum;
}
```
* 准备工作：
注意：Shared versus private variables
```c++
int omp_get_num_threads();  //线程数
int omp_get_thread_num();   //线程ID
double omp_get_wtime();     //上一个定点？
```
* 改写成并行版本：
```c++
#include <omp.h>
static long num_steps = 100000; double step;
#define NUM_THREADS 2
int main ()
{ 
    int i, nthreads; 
    double pi, sum[NUM_THREADS];
    //使用数组避免资源竞争
    
    step = 1.0/(double) num_steps;
    omp_set_num_threads(NUM_THREADS);
    #pragma omp parallel
    {
        int i, id, nthrds; 
        double x;
        
        id = omp_get_thread_num();
 	    sum[id]=0.0
	    nthrds = omp_get_num_threads();
	    
        if (id == 0) nthreads = nthrds;
        //只有一个线程复制值，避免向地址写入冲突。
        for (i=id; i< num_steps; i= i+nthrds)
        {
            x = (i+0.5)*step;
            sum[id] += 4.0/(1.0+x*x);
        }
    }
    
    for(i=0, pi=0.0; i<nthreads; i++)  
        pi += sum[i] * step;
}
```

* False sharing

![image_1ce62t6k110p4mqt6joi5jdhi8h.png-52.3kB][5]
如果将标量提升为一个数组以支持SPMD (Single Program Multiple Data) 程序的创建，数组元素在内存中是连续的，因此共享缓存行……导致可扩展性差。如上图。
解决方法是，使用PAD数组，因此您使用的元素位于不同的缓存行上。
```c++
#include <omp.h>
static long num_steps = 100000; double step;
#define PAD 8 // assume 64 byte L1 cache line size
#define NUM_THREADS 2
int main ()
{ 
    int i, nthreads; 
    double pi, sum[NUM_THREADS][PAD];
    
    step = 1.0/(double) num_steps;
    omp_set_num_threads(NUM_THREADS);
    #pragma omp parallel
    {
        int i, id, nthrds; 
        double x;
        
        id = omp_get_thread_num();
        nthrds = omp_get_num_threads();
        
        if (id == 0) 
            nthreads = nthrds;
            
  	    for (i=id, sum[id]=0.0; i< num_steps; i= i+nthrds)
  	    {
            x = (i+0.5)*step;
            sum[id][0] += 4.0/(1.0+x*x);
        }
    }
    for(i=0, pi=0.0; i<nthreads; i++)  
        pi += sum[i][0] * step;
}
```

## Synchronization

* Barrier
每个线程都需要等待直到所有线程全部到达；
```c++
#pragma omp parallel
{
    int id = omp_get_thread_num();
    A[id] = big_calc1(id);
#pragma omp barrier

    B[id] = big_calc2(id,A);
}
```

* Mutual exclusion
互斥：同一时刻只有一个线程可以进入临界区
```
float res;

#pragma omp parallel
{
    float B;
    int i, id, nthrds;
    id = omp_get_thread_num();
    nthrds = omp_get_num_threads();
    for(i = id; i < niters; i+=nthrds) {
        B = big_job(i);
#pragma omp critical
        res += consume(B);
    }
}
```
```c++
#pragma omp parallel
{
    double tmp, B;
    B = DOIT();
    tmp = big_ugly(B);
#pragma omp atomic
    X += tmp;
}
```
在atomic中的语句必须是下面的形式：
    1. x binop = expr
    2. x++ / ++x
    3. x-- / --x

* Using a critical section to remove impact of false sharing
```c++
#include <omp.h>
static long num_steps = 100000;    double step;
#define NUM_THREADS 2
void main ()
{ 	
    double pi; 
    step = 1.0/(double) num_steps;
 	omp_set_num_threads(NUM_THREADS);
    #pragma omp parallel
    {
      	int i, id,nthrds; 
      	double x, sum;
      	
     	id = omp_get_thread_num();
     	nthrds = omp_get_num_threads();
     	
     	if (id == 0) nthreads = nthrds;
     	
     	id = omp_get_thread_num();
     	nthrds = omp_get_num_threads();
     	
     	for (i=id, sum=0.0;i< num_steps; i=i+nthreads){
     		x = (i+0.5)*step;
     		sum += 4.0/(1.0+x*x);
     	}
    	#pragma omp critical
    	pi += sum * step;
    }
}
```

## Parallel Loops 

一个并行构造本身创建了一个SPMD程序…，即，每个线程冗余地执行相同的代码。
我们如何在团队内的线程之间通过代码分解路径？

### Loop Worksharing construct
使用Loop Worksharing construct在线程之间拆分循环迭代；
```c++
#pragma omp parallel
{
#pragma omp for
    for(i = 0; i < N; i++ {
        NEAT_STUFF(i);
    }
}
//变量i默认在每个线程中是私有的，你需要明确的标识出来private(i)
```

对比以下三段代码，它们具有相同的作用：
```c++
for(i = 0 ; i < N ; i++ )   
    { a[i] = a[i] + b[i]; }
```
```c++
#pragma omp parallel
{
    int id, i, Nthrds, istart, iend;
    id = omp_get_thread_num();
    Nthrds = omp_get_num_threads();
    istart = id * N / Nthrds;
    iend = (id + 1) * N /Nthrds;
    if (id == Nthrds - 1)	
    {	
    	iend = N;
    }
    for (int i = 0; i < iend; ++i)
    {
    	a[i] = a[i] + b[i];
    }
}
```
```c++
#pragma omp parallel
#pragma omp for
    for (int i = 0; i < iend; ++i)
    {
    	a[i] = a[i] + b[i];
    }
```
![image_1ce669e1g15dqsme1kdk1eaq1g6aa8.png-78kB][6]

### Nested loops
对于嵌套循环，可以使用折叠子句，下面的句子将会形成一个长度为N*M的单循环，然后并行化：
```c++
#pragma omp parallel for collapse(2)
for (int i = 0; i < N; ++i)
{
	for (int i = 0; i < M; ++i)
	{
		......
	}
}
```

### Reduction

reduction子句为变量指定一个操作符，每个线程都会创建reduction变量的私有拷贝，在OpenMP区域结束处，将使用各个线程的私有拷贝的值通过制定的操作符进行迭代运算，并赋值给原来的变量。
```c++
double ave = 0.0, A[MAX];
int i;
#pragma omp parallel for reduction(+:ave)
for (int i = 0; i < MAX; ++i)
{	
	ave += A[i];
}
ave = ave / MAX;
```

最后给出两个例子，分别为串行和并行版本：

```c++
#include <stdio.h>
#include <omp.h>
static long num_steps = 1000000000;
double step;
int main ()
{
	  int i;
	  double x, pi, sum = 0.0;
	  double start_time, run_time;

	  step = 1.0/(double) num_steps;

	  start_time = omp_get_wtime();

	  for (i=1;i<= num_steps; i++){
		  x = (i-0.5)*step;
		  sum = sum + 4.0/(1.0+x*x);
		  //printf("-------->");
	  }

	  pi = step * sum;
	  run_time = omp_get_wtime() - start_time;
	  printf("\n pi is %f in %f seconds\n",pi,run_time);
}	
```

```c++
#include <stdio.h>
#include <omp.h>
static long num_steps = 1000000000;
double step;
int main ()
{
	 int i;
	 double x, pi, sum = 0.0;
	 double start_time, run_time;

	 step = 1.0/(double) num_steps;

	 for (i=1;i<=4;i++)
	 {
        sum = 0.0;
        omp_set_num_threads(i);
	  	start_time = omp_get_wtime();
		#pragma omp parallel  
		{
		#pragma omp single
			  printf(" num_threads = %d",omp_get_num_threads());

		#pragma omp for reduction(+:sum)
			  for (i=1;i<= num_steps; i++){
				  x = (i-0.5)*step;
				  sum = sum + 4.0/(1.0+x*x);
			  }
		}
	    pi = step * sum;
	    run_time = omp_get_wtime() - start_time;
	    printf("\n pi is %f in %f seconds and %d threads\n",pi,run_time,i);
	}
}	  
```
通过编译运行，得出两程序运行结果如下：
![image_1ce6ks9h7asuck01fnv7v4g44p.png-700kB][7]


  [1]: http://static.zybuluo.com/usiege/wn25q7odiu6nq5ts0soz1yy9/image_1ce5vv8jn8l9st2195stlvctp.png
  [2]: http://static.zybuluo.com/usiege/ghtg12r8fy8gk7tgud4b8asy/image_1ce614sch7ud1s0pjva1mo7orc53.png
  [3]: http://static.zybuluo.com/usiege/b7qect9qhqvhznq8l1wa9e0q/image_1ce618s2epfi5808gb1rnf3gf5g.png
  [4]: http://static.zybuluo.com/usiege/1qu1m4wraj9weev3esrph9xd/image_1ce619rlspqgm7dplgm0ng115t.png
  [5]: http://static.zybuluo.com/usiege/bp0gl2i28whr1ujw262kl0vp/image_1ce62t6k110p4mqt6joi5jdhi8h.png
  [6]: http://static.zybuluo.com/usiege/7ncpe73v5vn5oxsi5pcqak84/image_1ce669e1g15dqsme1kdk1eaq1g6aa8.png
  [7]: http://static.zybuluo.com/usiege/0t76ku7ain60t6geznj29djl/image_1ce6ks9h7asuck01fnv7v4g44p.png