# 算法exercise07

标签（空格分隔）： homework

---

```

const int N = 100;

int main(){

	int P[N] = {};	//邮局
	int m = 0;	//邮局数量
	int n = 0;	//房子数量
	int H[100] = {}; //到房子离街道起点距离，递增数列

	cin >> n;
	for (int i = 0; i < 100; ++i) cin >> H[i];
	
	P[0] = H[0] + 100;
	m = 1;

	for (int i = 1; i <= n; ++i)
	{		
		/* code */
		if (H[i] > P[m] + 100)
		{
			m++;
			P[m] = H[i] + 100;
		}
	}

	if(P[m] > H[n])
		P[m] = H[n];

}
```




