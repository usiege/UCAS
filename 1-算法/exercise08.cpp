#define maxn 100  //最大顶点个数
int n, m;       //顶点数，边数

struct arcnode  //边结点
{
    int vertex;     //与表头结点相邻的顶点编号
    int weight = 0;     //连接两顶点的边的权值
    arcnode * next; //指向下一相邻接点
};

struct vernode      //顶点结点，为每一条邻接表的表头结点
{
    int vex;    //当前定点编号
    arcnode * firarc;   //与该顶点相连的第一个顶点组成的边
}Ver[maxn];

struct Graph
{
    vernode* Adj[maxn];
    int n;
    int m;
};

//插入边
void insertEdge(Graph g, int start, int end)
{
    vernode* vn = new vernode();
    vn->vex = end;
    if (g.Adj[start]->firarc == NULL)
    {   
        vernode* sn = new vernode();
        sn->vex = start;
        g.Adj[start] = sn;
    }
    vernode* temp = g.Adj[start];
    while(temp->firarc)   temp = temp->firarc;
    temp->firarc = vn;
}

void transpose(Graph origin, Graph des, int n)
{
    if ( (origin == NULL) || (des == NULL)) return;
    for (int i = 0; i < n; ++i)
    {
        vernode* vn = origin.Adj[i];
        while(vn)   insertEdge(des, vn->vex, i);
    }
}