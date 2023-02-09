#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

int main(int argc, char const *argv[])
{
	int m = 300, n = 300;

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

	n = m;

	if (argc > 4)
	{
		n = atoi(argv[4]);
	}

	float *a = (float *)calloc(m * n, sizeof(float *));
	float *b = (float *)calloc(n, sizeof(float *));
	float *c = (float *)calloc(m, sizeof(float *));

	if (a == NULL || b == NULL || c == NULL)
	{
		printf("vector-mult,parallel-paw-single-tiled-loop-inter,%d,speed-up,%d,%d,mem-allocation-error\n", cores, m, n);
		return 1;
	}

	int p = 0;
	int z = 0;
	for (p = 0; p < n; p++)
	{
		for (z = 0; z < m; z++)
		{
			a[z * n + p] = rand() * 1000;
		}

		b[p] = rand() * 1000;
	}

	int i, j;
	int _ret_val_0;

	int balancedTileSize = (sqrt((double)(cacheSize * 0.7 / 4)) / cores);

	if (argc > 5)
	{
		balancedTileSize = atoi(argv[5]);
	}


	int jj;
	int jTile = balancedTileSize;
	double start = omp_get_wtime();
	#pragma cetus parallel
	#pragma cetus private(i, j, jj)
	#pragma omp parallel private(i, j, jj)
	{
		float *reduce = (float *)malloc(m * sizeof(float));
		int reduce_span_0;
		for (reduce_span_0 = 0; reduce_span_0 < m; reduce_span_0++)
		{
			reduce[reduce_span_0] = 0;
		}
		#pragma loop name main #1
		#pragma cetus for
		#pragma omp for
		for (jj = 0; jj < n; jj += jTile)
		{
			#pragma loop name main #1 #0
			#pragma cetus private(i, j)
			for (i = 0; i < m; i++)
			{
				#pragma loop name main #1 #0 #0
				#pragma cetus private(j)
				/* #pragma cetus reduction(+: c[i])  */
				for (j = jj; j < ((((-1 + jTile) + jj) < n) ? ((-1 + jTile) + jj) : n); j++)
				{
					reduce[i] += (a[(i * n) + j] * b[j]);
				}
			}
		}
		#pragma cetus critical
		#pragma omp critical
		{
			for (reduce_span_0 = 0; reduce_span_0 < m; reduce_span_0++)
			{
				c[reduce_span_0] += reduce[reduce_span_0];
			}
		}
	}

	double end = omp_get_wtime();
	double time = end - start;

	free(a);
	free(b);
	free(c);

	printf("vector-mult,parallel-paw-single-tiled-loop-inter,%d,speed-up,%d,%d,%d,%f\n", cores, m, n, balancedTileSize, time);
	_ret_val_0 = 0;
	return _ret_val_0;
}
