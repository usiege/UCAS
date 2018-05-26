#include "mpi.h"
   #include <stdio.h>
   #define NELEMENTS 6

   main(int argc, char *argv[])  {
   int numtasks, rank, source=0, dest, tag=1, i;
   int blocklengths[2], displacements[2];
   float a[16] = 
     {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 
      9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0};
   float b[NELEMENTS]; 

   MPI_Status stat;
   MPI_Datatype indextype;   // required variable

   MPI_Init(&argc,&argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &rank);
   MPI_Comm_size(MPI_COMM_WORLD, &numtasks);

   blocklengths[0] = 4;
   blocklengths[1] = 2;
   displacements[0] = 5;
   displacements[1] = 12;
   
   // create indexed derived data type
   MPI_Type_indexed(2, blocklengths, displacements, MPI_FLOAT, &indextype);
   MPI_Type_commit(&indextype);

   if (rank == 0) {
     for (i=0; i<numtasks; i++) 
      // task 0 sends one element of indextype to all tasks
        MPI_Send(a, 1, indextype, i, tag, MPI_COMM_WORLD);
     }

   // all tasks receive indextype data from task 0
   MPI_Recv(b, NELEMENTS, MPI_FLOAT, source, tag, MPI_COMM_WORLD, &stat);
   printf("rank= %d  b= %3.1f %3.1f %3.1f %3.1f %3.1f %3.1f\n",
          rank,b[0],b[1],b[2],b[3],b[4],b[5]);
   
   // free datatype when done using it
   MPI_Type_free(&indextype);
   MPI_Finalize();
   }
