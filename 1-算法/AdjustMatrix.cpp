#include <iostream>
#include <cstdio>
using namespace std;

#define maxn 100
#define INF 1xffffff    //预定于的最大值
int n, m;   //顶点数、边数
int g[maxn][maxn];      //邻接矩阵表示

void Init()
{
    for(int i = 1; i <= n; i++)
        for(int j = 1; j <= n; j++)
        g[i][j] = 0;    //讲所有顶点度数置零，若为带权图，则置为INF
}
void Show() //打印邻接矩阵
{
    for(int i = 1; i <= n; i++)
    {
        for(int j = 1; j <= n; j++)
            cout << g[i][j] << " ";
        cout << endl;
    }
}
int main()
{
    int a, b;
    cout << "Enter n and m:";
    cin >> n >> m;
    while(m--)
    {
        cin >> a >> b;  //输入为边的始点、终点，若有权，还需输入权w
        g[a][b] = 1;    //a、b间存在边，将g[a][b]置1，若有权，则将其置为权值
        g[b][a] = 1;    //对于无向图，还要插入边(b，a）
    }
    Show();
    return 0;
}