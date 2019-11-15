using System;

// Checked for mass consistency by Dr. Pounds on 10/25/19

namespace Diffusion
{
	class Program
	{
	static void Main(string[] args)
	{
		// Variables for the max size of the cube and the cube itself
		int maxsize = 50;
		double[, ,] cube = new double [maxsize, maxsize, maxsize];

		// Partition Flag: (0) partition off, (1) partition on
		int partitionflag = 0; 

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

		double[, ,] partition = new double [maxsize, maxsize, maxsize];
		// If partition flag is on, construct the partition
		if (partitionflag == 1)
		{
			// Construct partition array
			for (int i = 0; i < maxsize; i++)
                	{
                        	for (int j = 0; j < maxsize; j++)
                        	{
                                	for (int k = 0; k < maxsize; k++)
                                	{
                                        	partition[i, j, k] = 0.0; // Zero partition array
                                	}
                        	}
                	}
		}

		if (partitionflag == 1)
		{
			int kp = maxsize / 2;
			for (int i = 0; i < maxsize; i++)
			{
				for (int j = maxsize - 1; j > (maxsize/4); j--)
				{
					partition[i, j, kp] = -1; // Spaces where the partition is present
				}
			}
		}

		// Variables
		double diffusion_coefficient = 0.175;
		double room_dimension = 5;								// Distance in meters
		double gas_speed = 250.0;								// Based on 100 g/mol at RT
		double timestep = (room_dimension / gas_speed) / maxsize;				// timestep in seconds
		double block_distance = room_dimension / maxsize;
		double dterm = diffusion_coefficient * timestep / (block_distance*block_distance);

		// Initialize first cell
		cube[0, 0, 0] = 1.0e21;

		//int pass = 0;
		double time = 0.0; 									// Tracks accumulated system time
		double ratio = 0.0;
		double change;

		do
		{
			for (int i=0; i<maxsize; i++)
			{
				for (int j=0; j<maxsize; j++)
				{
					for(int k=0; k<maxsize; k++)
					{
						// Repeat this for each cell, if not diffusing into partition diffuse
						if (0 <= k-1 && k-1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i, j, k-1] != -1))
								{
										change = (cube[i, j, k] - cube[i, j, k-1]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i, j, k-1] = cube[i, j, k-1] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i, j, k-1]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i, j, k-1] = cube[i, j, k-1] + change;
							}
						}

						if (0 <= k+1 && k+1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i, j, k+1] != -1))
								{
										change = (cube[i, j, k] - cube[i, j, k+1]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i, j, k+1] = cube[i, j, k+1] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i, j, k+1]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i, j, k+1] = cube[i, j, k+1] + change;
							}
						}

						if (0 <= j-1 && j-1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i, j-1, k] != -1))
								{
										change = (cube[i, j, k] - cube[i, j-1, k]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i, j-1, k] = cube[i, j-1, k] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i, j-1, k]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i, j-1, k] = cube[i, j-1, k] + change;
							}
						}

						if (0 <= j+1 && j+1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i, j+1, k] != -1))
								{
										change = (cube[i, j, k] - cube[i, j+1, k]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i, j+1, k] = cube[i, j+1, k] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i, j+1, k]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i, j+1, k] = cube[i, j+1, k] + change;
							}
						}

						if (0 <= i-1 && i-1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i-1, j, k] != -1))
								{
										change = (cube[i, j, k] - cube[i-1, j, k]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i-1, j, k] = cube[i-1, j, k] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i-1, j, k]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i-1, j, k] = cube[i-1, j, k] + change;
							}
						}

						if (0 <= i+1 && i+1 < maxsize)
						{
							if (partitionflag == 1)
							{
								if ((partition[i, j, k] != -1) && (partition[i+1, j, k] != -1))
								{
										change = (cube[i, j, k] - cube[i+1, j, k]) * dterm;
										cube[i, j, k] = cube[i, j, k] - change;
										cube[i+1, j, k] = cube[i+1, j, k] + change;
								}
							}
							else
							{
								change = (cube[i, j, k] - cube[i+1, j, k]) * dterm;
								cube[i, j, k] = cube[i, j, k] - change;
								cube[i+1, j, k] = cube[i+1, j, k] + change;
							}
						}
					}
				}
			}

			time = time + timestep; // update timestep

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
						if (cube[i, j, k] != 0.0)	// Since the values where the partition is aren't changing, don't consider 0 for min
							minval = Math.Min(cube[i, j, k], minval);
						sumval += cube[i, j, k];
					}
				}
			}

			ratio = minval / maxval; // update ratio 
			Console.WriteLine($"{time} {ratio}");
		} while (ratio < 0.99);

		Console.WriteLine($"Box equilibrated in: {time} seconds of simulated time.");
	}
	}
}
