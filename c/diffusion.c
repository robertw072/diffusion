#include <stdio.h>
#include <stdlib.h>

#define mval(MEM,i,j,k) MEM[i*N*N+j*N+k]

int main (int argc, char** argv)
{
	const int maxsize = 10;
	const int N = maxsize;
	double* cube = malloc(N*N*N*sizeof(double));
	int i, j, k;
	// Partition Flag: (0) off, (1) on
	const int partitionflag = 1;

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

	double* partition = malloc(N*N*N*sizeof(double));
// If partition flag is on, construct the partition
	if (partitionflag == 1)
	{
		for(i = 0; i < maxsize; i++)
		{
			for (j = 0; j < maxsize; j++)
			{
				for (k = 0; k< maxsize; k++)
				{
					mval(partition,i,j,k) = 0.0;
				}
			}
		}
	}

	// construct the actual location of the partition
	if (partitionflag == 1)
	{
		int kp = maxsize / 2;
		for (i = 0; i < maxsize; i++)
		{
			for (j = maxsize - 1; j > (maxsize / 4); j--)
			{
				partition[i*N*N+j*N+k] = -1.0;
			}
		}
	}

	// Define variables
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

	// Diffusion Process
	do
	{
		for (i = 0; i < maxsize; i++)
		{
			for (j = 0; j < maxsize; j++)
			{
				for (k = 0; k < maxsize; k++)
				{
					// Repeat fro each step of the cube face, if partition is not present then diffuse
					if (0 <= k-1 && k-1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[i*N*N+j*N+(k-1)] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+j*N+(k-1)]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+j*N+(k-1)] = cube[i*N*N+j*N+(k-1)] + change;
							}
						}
						else
						{
						double change = (cube[i*N*N+j*N+k] - cube[i*N*N+j*N+(k-1)]) * dterm;
						cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
						cube[i*N*N+j*N+(k-1)] = cube[i*N*N+j*N+(k-1)] + change;
						}
					}

					if (0 <= k+1 && k+1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[i*N*N+j*N+(k+1)] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+j*N+(k+1)]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+j*N+(k+1)] = cube[i*N*N+j*N+(k+1)] + change;
							}
						}
						else
						{
						double change = (cube[i*N*N+j*N+k] - cube[i*N*N+j*N+(k+1)]) * dterm;
						cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
						cube[i*N*N+j*N+(k+1)] = cube[i*N*N+j*N+(k+1)] + change;
						}
					}

					if (0 <= j-1 && j-1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[i*N*N+(j-1)*N+k] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+(j-1)*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+(j-1)*N+k] = cube[i*N*N+(j-1)*N+k] + change;
							}
						}
						else
						{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+(j-1)*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+(j-1)*N+k] = cube[i*N*N+(j-1)*N+k] + change;
						}
					}

					if (0 <= j+1 && j+1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[i*N*N+(j+1)*N+k] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+(j+1)*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+(j+1)*N+k] = cube[i*N*N+(j+1)*N+k] + change;
							}
						}
						else
						{
								double change = (cube[i*N*N+j*N+k] - cube[i*N*N+(j+1)*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[i*N*N+(j+1)*N+k] = cube[i*N*N+(j+1)*N+k] + change;
						}
					}

					if (0 <= i-1 && i-1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[(i-1)*N*N+j*N+k] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[(i-1)*N*N+j*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[(i-1)*N*N+j*N+k] = cube[(i-1)*N*N+j*N+k] + change;
							}
						}
						else
						{
								double change = (cube[i*N*N+j*N+k] - cube[(i-1)*N*N+j*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[(i-1)*N*N+j*N+k] = cube[(i-1)*N*N+j*N+k] + change;
						}
					}

					if (0 <= i+1 && i+1 < maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i*N*N+j*N+k] != -1.0) && (partition[(i+1)*N*N+j*N+k] != -1.0))
							{
								double change = (cube[i*N*N+j*N+k] - cube[(i+1)*N*N+j*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[(i+1)*N*N+j*N+k] = cube[(i+1)*N*N+j*N+k] + change;
							}
						}
						else
						{
								double change = (cube[i*N*N+j*N+k] - cube[(i+1)*N*N+j*N+k]) * dterm;
								cube[i*N*N+j*N+k] = cube[i*N*N+j*N+k] - change;
								cube[(i+1)*N*N+j*N+k] = cube[(i+1)*N*N+j*N+k] + change;
						}
					}

				}
			}
		}

		// Update time
		time = time + timestep;

		double maxval = cube[0];
		double minval = cube[0];
		
		for (i=0; i < maxsize; i++)
		{
			for (j=0; j < maxsize; j++)
			{
				for (k=0; k < maxsize; k++)
				{
					// Determine maxval and minval 
					if (cube[i*N*N+j*N+k] > maxval)
						maxval = cube[i*N*N+j*N+k];
					// Partition values aren't changed so avoid zero
					if ((cube[i*N*N+j*N+k] < minval) && (cube[i*N*N+j*N+k] != 0.0))
						minval = cube[i*N*N+j*N+k];
				}
			}
		}

		// update ratio
		ratio = minval / maxval;
		printf("%f\n", ratio);		

	} while (ratio < 0.99); // termination condition

	printf("Box equilibrated in: %f\n", time);

	free(cube); // deallocate cube memory
	free(partition); //deallocate partition memory
}
