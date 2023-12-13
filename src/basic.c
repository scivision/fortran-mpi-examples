#include <stdio.h>
#include <stdlib.h>

#include <mpi.h>

int main(int argc, char **argv)
{
   printf("going to init MPI\n");

   if(MPI_Init(&argc,&argv)) {
      perror("could not init MPI\n");
      return EXIT_FAILURE;
   }
   printf("MPI Init OK\n");

   if(MPI_Finalize()) {
      perror("could not close MPI\n");
      return EXIT_FAILURE;
   }

   printf("MPI closed\n");

   return EXIT_SUCCESS;
}
