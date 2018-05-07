#include <iostream>
#include <cstdio>
using namespace std;

#define maxn 100  //最大顶点个数
int n, m;       //顶点数，边数

struct arcnode  //边结点
{
    int vertex;     //与表头结点相邻的顶点编号
    int weight = 0;     //连接两顶点的边的权值
    arcnode * next; //指向下一相邻接点
    arcnode() {}
    arcnode(int v,int w) :vertex(v), weight(w), next(NULL) {}
    arcnode(int v) :vertex(v), next(NULL) {}
};

struct vernode      //顶点结点，为每一条邻接表的表头结点
{
    int vex;    //当前定点编号
    arcnode * firarc;   //与该顶点相连的第一个顶点组成的边
}Ver[maxn];

void Init()  //建立图的邻接表需要先初始化，建立顶点结点
{
    for(int i = 1; i <= n; i++)
    {
        Ver[i].vex = i;
        Ver[i].firarc = NULL;
    }
}

void Insert(int a, int b, int w)  //尾插法，插入以a为起点，b为终点，权为w的边，效率不如头插，但是可以去重边
{
    arcnode * q = new arcnode(b, w);
    if(Ver[a].firarc == NULL)
        Ver[a].firarc = q;
    else
    {
        arcnode * p = Ver[a].firarc;
        if(p->vertex == b)  //如果不要去重边，去掉这一段
        {
            if(p->weight < w)
                p->weight = w;
            return ;
        }
        while(p->next != NULL)
        {
            if(p->next->vertex == b)    //如果不要去重边，去掉这一段
            {
                if(p->next->weight < w);
                    p->next->weight = w;
                return ;
            }
            p = p->next;
        }
        p->next = q;
    }
}
void Insert2(int a, int b, int w)   //头插法，效率更高，但不能去重边
{
    arcnode * q = new arcnode(b, w);
    if(Ver[a].firarc == NULL)
        Ver[a].firarc = q;
    else
    {
        arcnode * p = Ver[a].firarc;
        q->next = p;
        Ver[a].firarc = q;
    }
}

void Insert(int a, int b)   //尾插法，插入以a为起点，b为终点，无权的边，效率不如头插，但是可以去重边
{
    arcnode * q = new arcnode(b);
    if(Ver[a].firarc == NULL)
        Ver[a].firarc = q;
    else
    {
        arcnode * p = Ver[a].firarc;
        if(p->vertex == b) return;      //去重边，如果不要去重边，去掉这一句
        while(p->next != NULL)
        {
            if(p->next->vertex == b)    //去重边，如果不要去重边，去掉这一句
                return;
            p = p->next;
        }
        p->next = q;
    }
}
void Insert2(int a, int b)   //头插法，效率跟高，但不能去重边
{
    arcnode * q = new arcnode(b);
    if(Ver[a].firarc == NULL)
        Ver[a].firarc = q;
    else
    {
        arcnode * p = Ver[a].firarc;
        q->next = p;
        Ver[a].firarc = q;
    }
}
void Delete(int a, int b)   //删除以a为起点，b为终点的边
{
    arcnode * p = Ver[a].firarc;
    if(p->vertex == b)
    {
        Ver[a].firarc = p->next;
        delete p;
        return ;
    }
    while(p->next != NULL)
        if(p->next->vertex == b)
        {
            p->next = p->next->next;
            delete p->next;
            return ;
        }
}

void Show()     //打印图的邻接表（有权值）
{
    for(int i = 1; i <= n; i++)
    {
        cout << Ver[i].vex;
        arcnode * p = Ver[i].firarc;
        while(p != NULL)
        {
            cout << "->(" << p->vertex << "," << p->weight << ")";
            p = p->next;
        }
        cout << "->NULL" << endl;
    }
}

void Show2()     //打印图的邻接表(无权值）
{
    for(int i = 1; i <= n; i++)
    {
        cout << Ver[i].vex;
        arcnode * p = Ver[i].firarc;
        while(p != NULL)
        {
            cout << "->" << p->vertex;
            p = p->next;
        }
        cout << "->NULL" << endl;
    }
}
int main()
{
    int a, b, w;
    cout << "Enter n and m：";
    cin >> n >> m;
    Init();
    while(m--)
    {
        cin >> a >> b >> w;       //输入起点、终点
        Insert(a, b, w);        //插入操作
        Insert(b, a, w);        //如果是无向图还需要反向插入
    }
    Show();
    return 0;
}