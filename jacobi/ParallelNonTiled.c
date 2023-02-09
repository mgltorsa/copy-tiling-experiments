#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char const *argv[])
{
	int m = 300;

	int cores = atoi(argv[1]);
	int cacheSize = atoi(argv[2]);

	if (cores > 0)
	{
		omp_set_num_threads(cores);
	}

	if (argc > 3)
	{
		m = atoi(argv[3]);
	}


	float **a = (float **)calloc(m , sizeof(float *));
	float **b = (float **)calloc(m , sizeof(float *));

	if (a == NULL || b == NULL)
	{
		printf("jacobi,parallel-non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, m, m);
		return 1;
	}

	int z, p;

	for (z = 0; z < m; z++)
	{
		a[z] = (float *)malloc(m * sizeof(float));
		b[z] = (float *)malloc(m * sizeof(float));
	}

	for (z = 0; z < m; z++)
	{
		for (p = 0; p < m; p++)
		{
			a[z][p] = rand() * 1000;
			b[z][p] = rand() * 1000;
		}
	}

	int i, j;
	int _ret_val_0;

	double start = omp_get_wtime();

	#pragma loop name main #0
	#pragma cetus private(i, j)
	#pragma cetus parallel
	#pragma omp parallel for private(i, j)
	for (i = 1; i < (m - 1); i++)
	{
		#pragma loop name main #0 #0
		#pragma cetus private(j)
		for (j = 1; j < (m - 1); j++)
		{
			a[i][j] = (0.2 * ((((b[j][i] + b[j - 1][i]) + b[j][i - 1]) + b[j + 1][i]) + b[j][i + 1]));
		}
	}

	double end = omp_get_wtime();
    double time = end - start;

    for (z = 0; z < m; z++)
    {
        free(a[z]);
        free(b[z]);
    }

    free(a);
    free(b);

    printf("jacobi,parallel-non-tiled,%d,speed-up,%d,%d,%d,%f\n", cores, m, m,0, time);

	_ret_val_0 = 0;
	return _ret_val_0;
}
