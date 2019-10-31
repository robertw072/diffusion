using System;

// Checked for mass consistency by Dr. Pounds on 10/25/19

namespace DiffusionProgram
{
	class Program
	{
	static void Main(string[] args)
	{
		// Variables for the max size of the cube and the cube itself
		int maxsize = 10;
		double[, ,] cube = new double [maxsize, maxsize, maxsize];

		// Zero the cube
		for (int i = 0; i < maxsize; i++)
		{
			for (int j = 0; j < maxsize; j++)
			{
				for (int k = 0; k < maxsize; k++)
				{
					cube[i, j, k] = 0.0;
				}
			}
		}

		// Variables
		double diffusion_coefficient = 0.175;
		double room_dimension = 5;								// Distance in meters
		double gas_speed = 250.0;								// Based on 100 g/mol at RT
		double timestep = (room_dimension / gas_speed) / maxsize;				// timestep in seconds
		double block_distance = room_dimension / maxsize;
		double DTerm = diffusion_coefficient * timestep / (block_distance*block_distance);

		// Initialize first cell
		cube[0, 0, 0] = 1.0e21;

		int pass = 0;
		double time = 0.0; 									// Tracks accumulated system time
		double ratio = 0.0;

		do
		{
			for (int i=0; i<maxsize; i++)
			{
			for (int j=0; j<maxsize; j++)
			{
				for(int k=0; k<maxsize; k++)
				{
				for(int l=0; l<maxsize; l++)
				{
					for(int m=0; m<maxsize; m++)
					{
					for(int n=0; n<maxsize; n++)
					{
						if ( ((i==l) && (j==m) && (k==n+1)) ||
						     ((i==l) && (j==m) && (k==n-1)) ||
						     ((i==l) && (j==m+1) && (k==n)) ||
						     ((i==l) && (j==m-1) && (k==n)) ||
						     ((i==l+1) && (j==m) && (k==n)) ||
						     ((i==l-1) && (j==m) && (k==n)) )
						{
							double change = (cube[i, j, k] - cube[l, m, n]) * DTerm;
							cube[i, j, k] = cube[i, j, k] - change;
							cube[l, m, n] = cube [l, m, n] + change;
						}
					}
					}
				}
				}
			}
			}
			
			time = time + timestep;

			// Check for mass consitency
			double sumval = 0.0;
			double maxval = cube[0, 0, 0];
			double minval = cube[0, 0, 0];
			for (int i=0; i<maxsize; i++)
			{
				for (int j=0; j<maxsize; j++)
				{
					for (int k=0; k<maxsize; k++)
					{
						maxval = Math.Max(cube[i, j, k], maxval);
						minval = Math.Min(cube[i, j, k], minval);
						sumval += cube[i, j, k];
					}
				}
			}

			ratio = minval / maxval;
			Console.WriteLine($"{time} {ratio} {sumval}");
		} while (ratio < 0.99);

		Console.WriteLine($"Box equilibrated in: {time} seconds of simulated time.");
	}
	}
}
