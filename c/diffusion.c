#include <stdio.h>
#include <stdlib.h>

#define mval(MEM,i,j,k) MEM[i*N*N+j*N+k]

int main (int argc, char** argv)
{
	const int maxsize = 10;
	const int N = maxsize;
	double* cube = malloc(N*N*N*sizeof(double));
	int i, j, k, l, m, n;

	// Zero the cube
	for (i = 0; i < maxsize; i++)
	{
		for (j = 0; j < maxsize; j++)
		{
			for (k = 0; k < maxsize; k++)
			{
				mval(cube,i,j,k) = 0.0;
			}
		}
	}

	double diffusion_coeff = 0.175;
	double room_dim = 5.0;
	double gas_speed = 250.0;
	double timestep = (room_dim / gas_speed) / (double) maxsize;
	double block_distance = room_dim / (double) maxsize;
	double dterm = diffusion_coeff * timestep / (block_distance*block_distance);

	// Initialize first cell
	cube[0] = 1.0e21;
	
	double time = 0.0;
	double ratio = 0.0;

	do
	{
		i = 0; j = 0; k = 0;
		for (i; i < maxsize; i++)
		{
		for (j; j < maxsize; j++)
		{
			for (k; k < maxsize; k++)
			{
			for (l = 0; l < maxsize; l++)
			{
				for (m = 0; m < maxsize; m++)
				{
				for (n = 0; n < maxsize; n++)
				{
					if (	((i==l) && (j==m) && (k==n+1)) ||
						((i==l) && (j==m) && (k==n-1)) ||
						((i==l) && (j==m+1) && (k==n)) ||
						((i==l) && (j==m-1) && (k==n)) ||
						((i==l+1) && (j==m) && (k==n)) ||
						((i==l-1) && (j==m) && (k==n)) )
					{
						double change = (cube[i*N*N+j*N+k] - cube[l*N*N+m*N+n])*dterm;
						cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
						cube[l*N*N+m*N+n] = cube[l*N*N+m*N+n] + change;
					}

				}
				}
			}
			}
		}
		}

		time = time + timestep;

		double maxval = cube[0];
		double minval = cube[0];
		i = 0; j = 0; k = 0;
		for (i; i < maxsize; i++)
		{
			for (j; j < maxsize; j++)
			{
				for (k; k < maxsize; k++)
				{
					// Determine maxval and minval 
					if (cube[i*N*N+j*N+k] > maxval)
						maxval = cube[i*N*N+j*N+k];
			
					if (cube[i*N*N+j*N+k] < minval)
						minval = cube[i*N*N+j*N+k];
				}
			}
		}

		ratio = minval / maxval;
//		printf("%f\n", ratio);		

	} while (ratio < 0.99);

	printf("Box equilibrated in: %f\n", time);

	free(cube);
}
