# OpenMP Programming Model

------
## <omp.h\>

create 4 thread parallel region:
```C++
double A[1000];
omp_set_num_threads(4);
#pragma omp parallel
{
	int ID = omp_get_thread_num();
	pooh(ID,A);
}

```
------
## Test1

* Serial PI Program
> Code: test1_Pi/pi.c

* A simple parallel PI Program
> test1_Pi/solutions/pi_spmd_simple.c


### SPMD vs. Worksharing

* Loop Worksharing constructs

### Reduction

`#pragma omp parallel for reduction (+:ave)`

------

## Synchronization

### Barrier

`#pragma omp barrier`
`#pragma omp for`
`#pragma omp for nowait`

`#pragma omp master`	//只能用主线程
`#pragma omp single`	//只能用一个线程，不限定哪个线程

```
#pragma omp sections
{
	#pragma omp section
}
```

```C++
//Lock routines
omp_init_lock(&hist_locks[i]);
omp_set_lock(&hist_locks[val]);
omp_unset_lock(&hist_locks[val]);
omp_destory_lock(&hist_locks[val]);
```

### Critical
### Region

------
## PS

```
//sublime 开启命令log
sublime.log_commands(True)
```

```
//Markdown preview
//sublime 绑定热键
{ "keys":["super+alt+m"],"command":"markdown_preview","args":{"target":"browser","parser":"markdown"}},
```

|	a	|	b	|
|-----|-----|
|
