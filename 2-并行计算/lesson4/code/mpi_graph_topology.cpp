#include <iostream>
#include <vector>

#include "mpi.h"

using namespace std;

int main(int argc,char *argv[])
{
	// get and print peocess name
	int    namelen;
    char   processor_name[MPI_MAX_PROCESSOR_NAME];
    double startwtime, endwtime;

	int pid, psum;
	int topo_type;

	int nbr_xp, nbr_xn, nbr_yp, nbr_yn, nbr_zp, nbr_zn;

    //--------------------------------------------------//
	//neighbors of contact
	//Z-: 0,1	   Z+: 0,1	     X-: 0,1       X+: 0,1
	//Z-X-:0,1     Z+X-: 0,1     Z-X+: 0,1     Z+X+: 0,1
	//int neighbors[16];
	vector<int> grid_nbs;
	int grid_neighbor;

	//GRAPH-Topology
	int nn;
	int sources[1], degrees[1];
	int destins[8], weights[8], directs[8];
	int ncnt;

	//test topology
	int indegree, tsources[8], source_weights[8];
	int otdegree, tdestins[8], destin_weights[8];

	//cart border
	float border_Xn, border_Yn, border_Zn;
	float border_Xp, border_Yp, border_Zp;


	//-------------------------------------//
	//set up MPI 
	MPI_Init(&argc, &argv);
	
	MPI_Comm_size(MPI_COMM_WORLD, &psum);
	cout<<"COMM process size = "<<psum<<endl;

	//find self id in comm1d
	MPI_Comm_rank(MPI_COMM_WORLD, &pid);
	MPI_Get_processor_name(processor_name,&namelen);
	cout<<"process "<<pid<<" of "<<psum<<"    on  "<< processor_name<<endl;

	MPI_Comm comm_dda;

	//-------------------------------------//
	// fill grid_nbs[] from data files
	// ...

	if(grid_nbs.size() > 0) 
	{
		cout <<"Grid beighbors:" << endl;
		cout <<"    zn: "<<grid_nbs[0]<<", zp: "<<grid_nbs[1]<<"    xn: "<<grid_nbs[2]<<", xp: "<<grid_nbs[3] << endl;
		cout <<"    znxn: "<<grid_nbs[4]<<", zpxn: "<<grid_nbs[5]<<"    znxp: "<<grid_nbs[6]<<", zpxp: "<<grid_nbs[7] << endl;
	}

	//setup dist_graph topology
	nn=1;
	sources[0] = pid;
	for(int i=0; i<8; i++)
	{
		destins[i] = -1;
		weights[i] = 1;
		directs[i] = -1;
	}
	ncnt = 0;

	for(size_t i = 0; i<grid_nbs.size(); i++)
	{
		if(grid_nbs[i] != -1)
		{
		    destins[ncnt] = grid_nbs[i];
		    directs[ncnt] = i;
		    ncnt++;
		}
		//ii++;
	}
	degrees[0] = ncnt;
	MPI_Dist_graph_create(MPI_COMM_WORLD, nn, sources, degrees, destins, weights,
		                  MPI_INFO_NULL, 1, &comm_dda);

	//test topology
	if(pid == 0)
	{
		MPI_Topo_test(comm_dda,&topo_type);
		if(topo_type == MPI_DIST_GRAPH) cout<<"Topology type = MPI_DIST_GRAPH"<<endl;

		indegree = degrees[0];
		otdegree = degrees[0];
		MPI_Dist_graph_neighbors(comm_dda,
		                        indegree, tsources, source_weights,
		                        otdegree, tdestins, destin_weights);
		//MPI_Dist_graph_neighbors_count(comm_dda, &in, &out, &weighted);

		 cout<<"process "<<pid<<", indegree = "<<indegree<<", outdegree = "<<otdegree<<endl;
		 for(int i = 0; i< indegree; i++)
		 {
		    cout<<"    "<<"source = "<< tsources[i]<<"  ";
		 }
		 cout<<endl;
		 for(int i = 0; i< otdegree; i++)
		 {
		    cout<<"    "<<"dsetin = "<< tdestins[i]<<"  ";
		 }
		 cout<<endl;
	}

	MPI_Finalize();

	return 0;
}
