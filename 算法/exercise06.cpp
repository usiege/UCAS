#include<iostream>
#include<cstdio>
#include<algorithm>
const int N=100;
using namespace std ;
int main()
{
    int i,j,n,a,b,c,d,ans=0;
    int l[N],r[N],m[2][N]={0},w[N]={0},p[2][N]={0};
    cin>>n;
    for(i=1;i<=n;i++)    cin>>l[i]>>r[i];
    m[0][1]=m[1][1]=0;
    for(i=1;i<n;i++)//
    {
        //  a|b     c|d
        //  si      si+1
        a=l[i],b=r[i];
        c=l[i+1],d=r[i+1];

        if((m[0][i]+b*c)>(m[1][i]+a*c))
            m[0][i+1]+=m[0][i]+b*c,p[0][i+1]=0;
        else  m[0][i+1]+=m[0][i]+a*c,p[0][i+1]=1;

        if((m[0][i]+b*d)>(m[1][i]+a*d))
            m[1][i+1]+=m[0][i]+b*d,p[1][i+1]=0;
        else m[1][i+1]+=m[0][i]+a*d,p[1][i+1]=1;
    }
    if(m[0][n]>m[1][n])  w[n]=0,cout<<m[0][n]<<endl;
    else                 w[n]=1,cout<<m[1][n]<<endl;
    for(i=n;i>1;i--)
        if(w[i]==0) w[i-1]=p[0][i];
        else        w[i-1]=p[1][i];
    for(i=1;i<=n;i++)   cout<<w[i]<<" ";
}
