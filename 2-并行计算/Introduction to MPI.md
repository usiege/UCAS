# Introduction to MPI

标签（空格分隔）： course

---

## Message-Passing Model

进程传统上是一个程序计数器和地址空间，进程可以有多个线程（程序计数器和相关栈）共享一个地址空间，进行之间需要通信，这些进程具有独立的地址空间。

进程内部通信包括：同步；将数据从一个进程的地址空间移到另一个进程的地址空间。

![image_1ceqh04ehgj910hrs0d1lr91aiv16.png-7.1kB][1]

每个进程都需要向另一个进程发送以及接收数据。早期的供应商系统（(Intel’s NX, IBM’s EUI, TMC’s CMMD）是不可移植的（或者能力有限），早期便携式系统（PVM, p4, TCGMSG, Chameleon）没有解决信息传递的全部频谱问题，缺乏供应商的支持，没有达到最有效的实现。MPI论坛是一个供应商的聚集地，希望将所有的这些努力进行标准化。

## What is MPI

MPI：Message Passing Interface，MPI论坛开始于1992年，供应商包括IBM，英特尔，TMC，SGI，Conve，迈科，可移植性库的作者包括PVM，P4，它的用户为应用科学家和图书馆的作家；

以“标准”的方式进行整合，每个函数都有固定的参数，每个函数都有固定的语义；标准化系统实现MPI的具体过程不要求完全一致，只需要语义匹配（遵循协议？）；MPI不是一种编程语言或者编译器规范，它也不是具体的实现或者产品；

MPI-1支持经典的消息传递编程模型，有基本的点对点通信，集合和数据类型等；该定义于1994年完成，组内成员包括并行计算机供应商，计算机科学家，应用程序开发人员；MPI在之后实现发展很快，现在MPI在任何并行机上都被认为是厂商支持的软件，在集群和其他环境中免费的、可移植的实现有：MPICH，OpenMPI。

MPI-2在1997年发布，其后版本MPI-2.1在2008年，MPI-2.2在2009年，新版本扩展了消息传递模型；包括：并行输入输出，远程内存操作（单边），动态过程管理以及其他功能；添加了C++和Fortran 90的绑定，外部接口，语言的互操作性，以及MPI与线程的交互；

MPI-3，2012年，添加了一些新的特性；具体请见[http://www.mpi-forum.org](http://www.mpi-forum.org)，以及一些材料[http://www.mcs.anl.gov/mpi](http://www.mcs.anl.gov/mpi)；

![image_1ceql63oblsqir41l8h13jo124s1j.png-32.4kB][2]

主要新特性包括：非阻塞集合，相邻集合，改进的单面通信接口，工具接口，Fortran 2008绑定；移除了C++绑定；

![MPI-3实现状态表][3]
发布日期是估计日期，随时可能发生变化。空单元指示没有公开宣布的计划来实现/支持该特征。

MPI是唯一可以被认为是标准的消息传递库，几乎所有HPC平台都支持MPI标准，实际上它已经取代了以前所有的消息传递库；当将应用程序移植到支持MPI标准的不同平台时，不需要修改源代码；
供应商可以利用本机的硬件特性来优化性能，MPI拥有丰富的特征集和可利用性，既有公共的实现也有供应商独有实现，比如Intel MPI Mpich；
当使用MPI时，所有并行性都是显示的，程序员的职责只是识别出需要的并行操作，使用MPI构建完成并行算法的实现；

## Write a simple program in MPI

![image_1ceqm7u12a9hd0s5qt11ic10ol4v.png-11.2kB][4]
上图是一个简单的通信模型，应用程序需要指定MPI的实现；如何编译和运行MPI应用程序，如何识别进程，如何描述数据；

应用程序可以用C、C++和Fortran调用MPI来添加到程序适当的地方；普通应用程序编译如`gcc test.c -0 test`，MPI应用程序编译如`mpicc test.c -o test`；执行时，普通程序`./test`，MPI程序`mpiexec -n 16 ./test`，该程序创建了16个进程运行程序；

MPI进程被集成到一个组中，每个组可以有不同的上下文（colors/context），组以及它的上下文被称为通信器（communicator）；MPI程序启动时，所有进程所在的组初始化时都被赋予一个名为**MPI_COMM_WORLD**的预定义名称，同一个组可以有很多名称，不过简单的程序不必担心多个名字的情况；进程由通信器定义唯一的编号标识，称为秩（rank）；对于两个不同的通信器，同一进程可以分别在其中，且有两个不同的秩；只有先指定通信器时，才可以定义秩；

![Communicators][5]

* Simple MPI Program
```c++
#include <mpi.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
    int rank, size;

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("I am %d of %d\n", rank + 1, size);

    MPI_Finalize();
    return 0;
}
```

* MPI中的数据通信
MPI中的数据通信就像电子邮件交换一样，一个进程将数据的副本发送到另一个进程（或一组进程），另一个进程负责接收它；
通信需要发送者必须知道的信息：数据发送给接收进程的rank；可以发送100个整型数据或200个字符等；一个用于消息的用户定义标签，把它当作电子邮件主题，使接收进程了解到接收到的数据类型；
接收者可能必须知道的信息：指定的可发送方，发送方rank是`MPI_ANY_SOURCE`时，表示任何进程都可以发送；可以接收信息的类型；若并不清楚发送方标签，则标签将会是`MPI_ANY_TAG`；

* 数据类型
int -> MPI_INT
double -> MPI_DOUBLE
char -> MPI_CHAR
以上为部分基础类型举例，更复杂的数据类型也是支持的，例如可以创建如上类型组成的结构体类型或者矩阵列向量的数据类型；
`MPI_SEND`和`MPI_RECV`指的是应该传递的数据类型元素的量；

```c++
MPI_SEND(buf, count, datatype,  dest, tag, comn)
```
信息缓冲区由`(buf, count, datatype)`描述，目标进程由`dest`和`comn`指定，`dest`表示的是由`comn`指定的通信器中的目标进程的rank，`tag`是信息的用户自定义类型；当函数返回时，数据被传递到系统中，缓冲器可以被重用，消息可能未被目标进程接收；

```c++
MPI_RECV(buf, count, datatype,  source, tag, comm, status)
```
等待从系统接收到匹配`(source, tag, comm)`的信息，并且可以使用缓冲器；`source`是通信器`comn`或者`MPI_ANY_SOURCE`中的rank；接收少于`count`个数据类型是可以的，但是接收的多的话，会发生错误；
`status`包含了更多的信息：发送消息者，实际接收数据量，使用了什么标签信息；如不需要附加任何信息，则可以使用`MPI_STATUS_IGNORE`；

* Simple Communication in MPI
```c++
#include <mpi.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
    int rank, data[100];

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0)
        MPI_Send(data, 100, MPI_INT, 1, 0, MPI_COMM_WORLD);
    else if (rank == 1)
        MPI_Recv(data, 100, MPI_INT, 0, 0, MPI_COMM_WORLD,
                 MPI_STATUS_IGNORE);

    MPI_Finalize();
    return 0;
}
```

* Parallel Sort using MPI Send/Recv
![image_1ceqqecko1b6k1cri1f7l19oh1qdna0.png-67.5kB][6]
```c++
#include <mpi.h>
#include <stdio.h>
int main(int argc, char ** argv)
{
    int rank, a[1000], b[500];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0) {
        MPI_Send(&a[500], 500, MPI_INT, 1, 0, MPI_COMM_WORLD);
        sort(a, 500);
        MPI_Recv(b, 500, MPI_INT, 1, 0, MPI_COMM_WORLD,
				MPI_STATUS_IGNORE);

        /* Serial: Merge array b and sorted part of array a */
    }
    else if (rank == 1) {
        MPI_Recv(b, 500, MPI_INT, 0, 0, MPI_COMM_WORLD,
				MPI_STATUS_IGNORE);
        sort(b, 500);
        MPI_Send(b, 500, MPI_INT, 0, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize(); return 0;
}
```





  [1]: http://static.zybuluo.com/usiege/xis4d6udau6rsr48p3lhukb3/image_1ceqh04ehgj910hrs0d1lr91aiv16.png
  [2]: http://static.zybuluo.com/usiege/i7wcsgdjemeh9vll2c126eww/image_1ceql63oblsqir41l8h13jo124s1j.png
  [3]: http://static.zybuluo.com/usiege/y4r0xasti1jjyuhvlci4mduv/image_1ceqlasei1gus1kso1tsvo7lcek2g.png
  [4]: http://static.zybuluo.com/usiege/bcb9ruqzzxi14nr94brs9kvy/image_1ceqm7u12a9hd0s5qt11ic10ol4v.png
  [5]: http://static.zybuluo.com/usiege/kzu37txtrkvhm4exkb2l4y2l/image_1ceqnkbgc51em0vn6v1ugf1r3b6p.png
  [6]: http://static.zybuluo.com/usiege/ltoaek7ae9dbvaq7fn64qr8t/image_1ceqqecko1b6k1cri1f7l19oh1qdna0.png