#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<omp.h>

#define num_threads 3

int *L,*R;

//Merge函数合并两个子数组形成单一的已排好序的字数组
//并代替当前的子数组A[p..r] 
void Merge(int *a, int p, int q, int r)
{
    int i,j,k;
    int n1 = q - p + 1;
    int n2 = r - q;
    L = (int*)malloc((n1+1)*sizeof(int));
    R = (int*)malloc((n2+1)*sizeof(int));
    for(i=0; i<n1; i++)
        L[i] = a[p+i];
    L[i] = 65536;
    for(j=0; j<n2; j++)
        R[j] = a[q+j+1];
    R[j] = 65536;
    i=0,j=0;
    for(k=p; k<=r; k++){
        if(L[i]<=R[j]){
            a[k] = L[i];
            i++;
        }
        else{
            a[k] = R[j];
            j++;
        }
    }
} 
//归并排序
void MergeSort(int *a, int p, int r)
{
    if(p<r){
        int q = (p+r)/2;
        MergeSort(a,p,q);
        MergeSort(a,q+1,r);
        Merge(a,p,q,r);
    }
} 

void PSRS(int *array, int n)
{
    int id;
    int i=0;
    int count[num_threads][num_threads] = { 0 };    //每个处理器每段的个数
    int base = n / num_threads;     //划分的每段段数
    int p[num_threads*num_threads]; //正则采样数为p
    int pivot[num_threads-1];       //主元
    int pivot_array[num_threads][num_threads][50]={0};  //处理器数组空间

    omp_set_num_threads(num_threads);
#pragma omp parallel shared(base,array,n,i,p,pivot,count) private(id)
    {
        id = omp_get_thread_num();
        //每个处理器对所在的段进行局部串行归并排序
        MergeSort(array,id*base,(id+1)*base-1);

#pragma omp critical
        //每个处理器选出P个样本，进行正则采样
        for(int k=0; k<num_threads; k++)
            p[i++] = array[(id-1)*base+(k+1)*base/(num_threads+1)];
//设置路障，同步队列中的所有线程
#pragma omp barrier
//主线程对采样的p个样本进行排序
#pragma omp master
        {
            MergeSort(p,0,i-1);
            //选出num_threads-1个主元
            for(int m=0; m<num_threads-1; m++)
                pivot[m] = p[(m+1)*num_threads];
        }
#pragma omp barrier
        //根据主元对每一个cpu数据段进行划分
        for(int k=0; k<base; k++)
        {
            for(int m=0; m<num_threads; m++)
            {
                if(array[id*base+k] < pivot[m])
                {
                    pivot_array[id][m][count[id][m]++] = array[id*base+k];
                    break;
                }
                else if(m == num_threads-1) //最后一段
                {
                    pivot_array[id][m][count[id][m]++] = array[id*base+k];
                }
            }
        }
    }
//向各个线程发送数据，各个线程自己排序
#pragma omp parallel shared(pivot_array,count)
    {
        int id=omp_get_thread_num();
        for(int k=0; k<num_threads; k++)
        {
            if(k!=id)
            {
                memcpy(pivot_array[id][id]+count[id][id],pivot_array[k][id],sizeof(int)*count[k][id]);
                count[id][id] += count[k][id];
            }
        }
        MergeSort(pivot_array[id][id],0,count[id][id]-1);
    }
    i = 0;
    printf("result:\n");
    for(int k=0; k<num_threads; k++)
    {
        for(int m=0; m<count[k][k]; m++)
        {
            printf("%d ",pivot_array[k][k][m]);
        }
        printf("\n");
    }
}

int main()
{
    int array[36] = { 16,2,17,24,33,28,30,1,0,27,9,25, 34,23,19,18,11,7,21,13,8,35,12,29 , 6,3,4,14,22,15,32,10,26,31,20,5 };
    double begin,end,time;
    begin = omp_get_wtime();
    PSRS(array, 36);
/*  MergeSort(list,0,35);
    for(int i=0; i<36; i++)
    {
        printf("%d ",list[i]);
    }*/
    end = omp_get_wtime();
    time = end - begin;
    printf("The running time is %lfs\n",time);
    return 0;
}