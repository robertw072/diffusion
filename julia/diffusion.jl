#!/usr/bin/julia

maxsize = 10 #size of each block
# partition flag: 0 is off, 1 is on
partitionflag = 0

# create and zero the cube
cube = zeros(Float64, (maxsize,maxsize,maxsize))

# create and zero the partition
partition = zeros(Float64, (maxsize,maxsize,maxsize))
# define the actual partition
if partitionflag == 1
	kp = maxsize/2
	jp = maxsize-1
	for i = 1:maxsize
		while jp > (maxsize/4)
			partition[i,jp,kp] = Float64(-1)
			jp = jp-1
		end
	end
end
# define variables 
diffusion_coeff = Float64(0.175)
room_dim = Float64(5)
gas_speed = Float64(250.0)
timestep = Float64((room_dim / gas_speed) / Float64(maxsize)) # increments simulated _time
block_distance = Float64(room_dim / Float64(maxsize))
dterm = Float64(diffusion_coeff * timestep / (block_distance * block_distance))

cube[1,1,1] = Float64(1.0e21)

_ratio = Float64(0.0)
_time = Float64(0.0) # keeps track of simulated time

while _ratio < 0.99 # termination condition
	for i = 1:maxsize
		for j = 1:maxsize
			for k = 1:maxsize
					# repeat for each cell face, if not trying to diffuse into the partition then diffuse
					if 1 <= k-1 && k-1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i, j, k-1] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i,j,k-1]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j,k-1] = cube[i,j,k-1] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i,j,k-1]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j,k-1] = cube[i,j,k-1] + change
						end
					end

					if 1 <= k+1 && k+1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i, j, k+1] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i,j,k+1]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j,k+1] = cube[i,j,k+1] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i,j,k+1]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j,k+1] = cube[i,j,k+1] + change
						end
					end

					if 1 <= j-1 && j-1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i, j-1, k] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i,j-1,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j-1,k] = cube[i,j-1,k] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i,j-1,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j-1,k] = cube[i,j-1,k] + change
						end
					end

					if 1 <= j+1 && j+1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i, j+1, k] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i,j+1,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j+1,k] = cube[i,j+1,k] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i,j+1,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i,j+1,k] = cube[i,j+1,k] + change
						end
					end

					if 1 <= i-1 && i-1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i-1, j, k] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i-1,j,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i-1,j,k] = cube[i-1,j,k] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i-1,j,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i-1,j,k] = cube[i-1,j,k] + change
						end
					end

					if 1 <= i+1 && i+1 <= maxsize
						if partitionflag == 1
							if (partition[i, j, k] != Float64(-1)) && (partition[i+1, j, k] != Float64(-1))
								change = Float64((cube[i,j,k] - cube[i+1,j,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i+1,j,k] = cube[i+1,j,k] + change
							end
							else
								change = Float64((cube[i,j,k] - cube[i+1,j,k]) * dterm)
								cube[i,j,k] = cube[i,j,k] - change
								cube[i+1,j,k] = cube[i+1,j,k] + change
						end
					end

			end
		end
	end

	global _time += timestep

	sumval = Float64(0.0)
	maxval = Float64(cube[ 1, 1, 1 ])
	minval = Float64(cube[ 1, 1, 1 ])
	for i = 1:maxsize
		for j = 1:maxsize
			for k = 1:maxsize
				# determine the max and min of the cube for the ratio update
				if cube[i,j,k] > maxval
					maxval = cube[i,j,k]
				end

				if cube[i,j,k] < minval && cube[i,j,k] != 0.0
					minval = cube[i,j,k]
				end
			end
		end
	end

	global _ratio = minval / maxval # update ratio

	println(_time, " ", _ratio)

end

	println("The box equilibrated in: ", _time)

exit(0)
