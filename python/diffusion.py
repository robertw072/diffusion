#!/usr/bin/python
from numpy import*
import numpy as np

maxsize = 12 # size of each cell
# Create cube and fill with 0s
cube = zeros((maxsize,maxsize,maxsize),dtype=float64)

# Partition Flag
partitionflag = 1
# If partition is on, construct partition
if (partitionflag == 1):
  partition = zeros((maxsize,maxsize,maxsize),dtype=float64)

if (partitionflag == 1):
  kp = maxsize / 2
  for i in range (0,maxsize):
    for j in range (maxsize-1, (maxsize/4), -1):
      partition[i,j,kp] = -1

# define variables
diffusion_coeff = 0.175
room_dimension = 5.0					# Distance in meters
gas_speed = 250.0					# Based on 100 g/mol at RT
timestep = (room_dimension / gas_speed) / maxsize	# In seconds
block_distance = room_dimension / maxsize
dterm = diffusion_coeff * timestep / (block_distance*block_distance)
# initialize first cell of cube
cube[0,0,0] = 1.0e21

time = 0.0
ratio = 0.0
_pass = 0


while (ratio < 0.99):
	for i in range(0,maxsize):
		for j in range(0,maxsize):
			for k in range(0,maxsize):
				#repeat the steps for each face, if not trying to diffuse into the partition then diffuse
                if (0 <= k-1) and (k-1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i, j, k-1] != -1):
                            change = (cube[i, j, k] - cube[i, j, k-1]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i, j, k-1] = cube[i, j, k-1] + change
                    else:
                        change = (cube[i, j, k] - cube[i, j, k-1]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i, j, k-1] = cube[i, j, k-1] + change
#******************************************************************************************
                if (0 <= k+1) and (k+1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i, j, k+1] != -1):
                            change = (cube[i, j, k] - cube[i, j, k+1]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i, j, k+1] = cube[i, j, k+1] + change

                    else:
                        change = (cube[i, j, k] - cube[i, j, k+1]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i, j, k+1] = cube[i, j, k+1] + change
#******************************************************************************************
                if (0 <= j-1) and (j-1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i, j-1, k] != -1):
                            change = (cube[i, j, k] - cube[i, j-1, k]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i, j-1, k] = cube[i, j-1, k] + change

                    else:
                        change = (cube[i, j, k] - cube[i, j-1, k]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i, j-1, k] = cube[i, j-1, k] + change
#******************************************************************************************
                if (0 <= j+1) and (j+1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i, j+1, k] != -1):
                            change = (cube[i, j, k] - cube[i, j+1, k]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i, j+1, k] = cube[i, j+1, k] + change

                    else:
                        change = (cube[i, j, k] - cube[i, j+1, k]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i, j+1, k] = cube[i, j+1, k] + change
#******************************************************************************************
                if (0 <= i-1) and (i-1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i-1, j, k] != -1):
                           	change = (cube[i, j, k] - cube[i-1, j, k]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i-1, j, k] = cube[i-1, j, k] + change

                    else:
                        change = (cube[i, j, k] - cube[i-1, j, k]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i-1, j, k] = cube[i-1, j, k] + change
#******************************************************************************************
                if (0 <= i+1) and (i+1 < maxsize):
                    if partitionflag == 1:
                        if (partition[i, j, k] != -1) and (partition[i+1, j, k] != -1):
                            change = (cube[i, j, k] - cube[i+1, j, k]) * dterm
							cube[i, j, k] = cube[i, j, k] - change
							cube[i+1, j, k] = cube[i+1, j, k] + change

                    else:
                        change = (cube[i, j, k] - cube[i+1, j, k]) * dterm
                        cube[i, j, k] = cube[i, j, k] - change
                        cube[i+1, j, k] = cube[i+1, j, k] + change

	time = time + timestep # update timestep
	maxval = cube[0,0,0]
	minval = cube[0,0,0]
	for i in range(0,maxsize):
		for j in range(0,maxsize):
			for k in range(0,maxsize):
				# find min and max
				maxval = max(cube[i,j,k], maxval)
				if cube[i, j, k] != 0:
					minval = min(cube[i,j,k], minval)
	ratio = minval / maxval # update ratio
	_pass = _pass + 1
	print time, " ", ratio, " ", _pass


print "Box equilibrated in: ", time, " seconds."
