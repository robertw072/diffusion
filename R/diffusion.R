#!/usr/bin/env Rscript

# Size of each block
maxsize <- 10
# Create the cube and zero it
cube <- array(rep(0.0, maxsize*maxsize*maxsize),dim = c(maxsize,maxsize,maxsize))

# partition flag: 0 is off, 1 is on
partitionflag <- 0

# Create and zero the partition
if (partitionflag == 1)
{
	partition <- array(rep(0.0, maxsize*maxsize*maxsize),dim = c(maxsize,maxsize,maxsize))
}

if (partitionflag == 1)
{
	kp <- maxsize/2
	dec <- maxsize(4)
	jp <- maxsize
	for (i in 1:maxsize)
	{
		while(jp > dec)
		{
				partition[i,jp,kp] <- -1
				jp = jp-1
		}
	}
}
# define variables
diffusion_coeff <- 0.175
room_dim <- 5.0
gas_speed <- 250.0

timestep <- (room_dim/gas_speed)/maxsize # simulated time increment
block_distance <- room_dim/maxsize
dterm <- diffusion_coeff*timestep/(block_distance*block_distance)

# Initialize first cell of the cube
cube[1,1,1] <- 1.0e21

time <- 0.0 # keeps track of simulated time
ratio <- 0.0 # keeps track of termination condition

while (ratio < 0.99) # termination condition
{
	for (i in 1:maxsize)
	{
		for (j in 1:maxsize)
		{
			for (k in 1:maxsize)
			{
					# repeat for each face
					# if not trying to diffuse into the partition (or from) then diffuse!
					if (1 <= k-1 && k-1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i, j, k-1] != -1))
							{
								change <- (cube[i,j,k]-cube[i,j,k-1])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i,j,k-1] <- cube[i,j,k-1]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i,j,k-1])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i,j,k-1] <- cube[i,j,k-1]+change
						}
					}

					if (1 <= k+1 && k+1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i, j, k+1] != -1))
							{
								change <- (cube[i,j,k]-cube[i,j,k+1])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i,j,k+1] <- cube[i,j,k+1]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i,j,k+1])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i,j,k+1] <- cube[i,j,k+1]+change
						}
					}

					if (1 <= j-1 && j-1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i, j-1, k] != -1))
							{
								change <- (cube[i,j,k]-cube[i,j-1,k])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i,j-1,k] <- cube[i,j-1,k]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i,j-1,k])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i,j-1,k] <- cube[i,j-1,k]+change
						}
					}

					if (1 <= j+1 && j+1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i, j+1, k] != -1))
							{
								change <- (cube[i,j,k]-cube[i,j+1,k])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i,j+1,k] <- cube[i,j+1,k]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i,j+1,k])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i,j+1,k] <- cube[i,j+1,k]+change
						}
					}

					if (1 <= i-1 && i-1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i-1, j, k] != -1))
							{
								change <- (cube[i,j,k]-cube[i-1,j,k])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i-1,j,k] <- cube[i-1,j,k]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i-1,j,k])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i-1,j,k] <- cube[i-1,j,k]+change
						}
					}

					if (1 <= i+1 && i+1 <= maxsize)
					{
						if (partitionflag == 1)
						{
							if ((partition[i, j, k] != -1) && (partition[i+1, j, k] != -1))
							{
								change <- (cube[i,j,k]-cube[i+1,j,k])*dterm
								cube[i,j,k] <- cube[i,j,k]-change
								cube[i+1,j,k] <- cube[i+1,j,k]+change
							}
						}
						else
						{
							change <- (cube[i,j,k]-cube[i+1,j,k])*dterm
							cube[i,j,k] <- cube[i,j,k]-change
							cube[i+1,j,k] <- cube[i+1,j,k]+change
						}
					}

				}
		}
	}
	time <- time + timestep # update simulated time

	# Check for mass consitency
	sumval <- 0.0
	maxval <- cube[1,1,1]
	minval <- cube[1,1,1]
	for (i in 1:maxsize)
	{
		for (j in 1:maxsize)
		{
			for (k in 1:maxsize)
			{
				# find max and min of cube for ratio
				if (cube[i,j,k] > maxval)
				{
					maxval <- cube[i,j,k]
				}

				if ((cube[i,j,k] < minval) && (cube[i,j,k] != 0.0))
				{
					minval <- cube[i,j,k]
				}
				sumval <- sumval + cube[i,j,k]
			}
		}
	}

	ratio <- minval/maxval # update ratio
	cat(time, " ", ratio, "\n")
}

cat("Box equilibrated in: ", time, "\n")
