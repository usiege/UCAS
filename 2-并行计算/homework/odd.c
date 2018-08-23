
#include <stdio.h>

int main(int argc, char const *argv[])
{
	long a = 10000;
	long b, c = 2800;
	long d, e, f[2801], g;

	for(;b-c;)
		f[b++] = a/5;
	for(;d=0, g = c*2; c -= 14, printf("%.4ld ", e + d/a), e = d%a)
		for(b = c; d += f[b]*a, f[b] = d%--g, d /= g--, --b; d*= b);

	return 0;
}

// #include <stdio.h>
// int a=10000, b, c=2800, d, e, f[2801], g; 
// main() 
// { 
// 	for(;b-c;) 
// 	f[b++]=a/5; 
// 	for(;d=0,g=c*2;c-=14,printf("%.4d",e+d/a),e=d%a) 
// 	for(b=c;d+=f[b]*a,f[b]=d%--g,d/=g--,--b;d*=b); 
// }