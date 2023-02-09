
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

int main(int argc, char *argv[])
{

    int n = 300, m = n;

	int cores = atoi(argv[1]);
	int cacheSize = atoi(argv[2]);

    if (cores > 0)
    {
        omp_set_num_threads(cores);
    }

    if (argc > 3)
    {
        n = atoi(argv[3]);
    }

    m = n;

    if (argc > 4)
    {
        m = atoi(argv[4]);
    }


    float **a = (float **)calloc(n, sizeof(float *));
    float **b = (float **)calloc(n, sizeof(float *));
    float **d = (float **)calloc(n, sizeof(float *));

    if (a == NULL || b == NULL || d == NULL)
    {
        printf("matrix-mult,parallel-non-tiled,%d,speed-up,%d,%d,mem-allocation-error\n", cores, n, m);
        return 1;
    }

    int z, p;

    for (z = 0; z < n; z++)
    {
        a[z] = (float *)calloc(m, sizeof(float));
        b[z] = (float *)calloc(m, sizeof(float));
        d[z] = (float *)calloc(m,  sizeof(float));
    }

    for (z = 0; z < n; z++)
    {
        for (p = 0; p < n; p++)
        {
            a[z][p] = rand() * 1000;
            b[z][p] = rand() * 1000;
            d[z][p] = rand() * 1000;
        }
    }

    int i, j, k;

    double start = omp_get_wtime();
    
    #pragma omp parallel for private(i, j, k)
    for (i = 0; i < n; i++)
    {

        for (j = 0; j < m; j++)
        {

            for (k = 0; k < n; k++)
            {

                d[i][j] = d[i][j] + a[i][k] * b[k][j];
            }
        }
    }

    double end = omp_get_wtime();
    double time = end - start;

    for (z = 0; z < n; z++)
    {
        free(a[z]);
        free(b[z]);
        free(d[z]);
    }

    free(a);
    free(b);
    free(d);

    printf("matrix-mult,parallel-non-tiled,%d,speed-up,%d,%d,%d,%f\n", cores, n, m,0, time);

    return 0;
}
