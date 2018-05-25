# OpenMP work with it

标签（空格分隔）： course

---

## Synchronize single masters and stuff



* barrier*
每个线程等待直到所有线程均已到达：
```c++
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
```

* master
```c++
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
```

* single
```c++
#pragma omp parallel
{
	do_many_things();
	#pragma omp single
	{
		exchange_boundaries();
	}
	do_many_other_things();
}
```
* sections
```c++
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
```
* lock
```c++
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
```

### Runtime Library runtines
```c++
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
```

### Environment Variables

* OMP_NUM_THREADS
默认使用的线程数；

* OMP_STACKSIZE
OpenMP向环境变量中添加该变量用来控制子线程栈的大小；

* OMP_WAIT_POLICY
使用该变量来提示运行时系统如何处理空闲的线程；
    - ACTIVE 在 barriers/locks 保持线程激活；
    - PASSIVE 在 barriers/locks 尝试做释放处理；

## Data environment

![image_1ceb5ej89rqr1evj16bq10h16j716.png-83.7kB][1]

* private(var)
    - 为每个线程创建一个局部副本；
    - 局部私有副本未初始化；
    - 原始变量的值在该区域之后不变；
```c++
void wrong() {
    int tmp = 0;
    #pragma omp parallel for private(tmp)
    for (int j = 0; j < 1000; ++j)
        tmp += j;
    printf(“%d\n”, tmp);
}
```
* firstprivate(var)
    - 变量从shared变量处初始化；
    - 每个线程获得各自的incr的副本，且初始化为0；
```c++
incr = 0;
#pragma omp parallel for firstprivate(incr)
for (i = 0; i <= MAX; i++) {
    if ((i%2)==0) incr++;
    A[i] = incr;
}
```
* lastprivate(var)
    * 变量使用上次迭代的值更新共享变量；
    * “x”具有“最后一次”迭代的值（即i＝（n-1））；
```c++
void sq2(int n, double *lastterm) 
{
    double x; int i;
#pragma omp parallel for lastprivate(x)
    for (i = 0; i < n; i++){
        x = a[i]*a[i] + b[i]*b[i];
        b[i] = sqrt(x);
    }
    *lastterm = x;
}
```
### A Test

![image_1ceb8m0o9dta12cfh611f9j15q1p.png-97.6kB][2]

在并行区域内部：

* 所有线程共享变量A，且等于1；
* B的初始值未定义；
* C的初始值为1；

在并行区域之后：

* B和C恢复为它们的原始值，均为1；
* A的值为1或者为它在并行区域内部设置的值；

## Linked lists and OpenMP

* To create a team of threads（创建一组并行线程）
`#pragma omp parallel`

* To share work between threads （线程间的共享工作）
`#pragma omp for`
`#pragma omp single`

* To prevent conflicts (prevent races)（防止冲突）
`#pragma omp critical`
`#pragma omp atomic`
`#pragma omp barrier`
`#pragma omp master`

* Data environment clauses（数据环境子句）
`private(variable_list)`
`firstprivate(variable_list)`
`lastprivate(variable_list)`
`reduction(+:variable_list)`

### 考虑以下程序
```c++
p=head;
while (p) {
    process(p);
    p = p->next;
}
```
并行共享结构只能使用`for`，不能使用`while`；

### Using C++ STL
```c++
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
```


  [1]: http://static.zybuluo.com/usiege/teggsbudqhepnglxzka64pug/image_1ceb5ej89rqr1evj16bq10h16j716.png
  [2]: http://static.zybuluo.com/usiege/ypzy9jkfnybn4x7db6gw3g2h/image_1ceb8m0o9dta12cfh611f9j15q1p.png