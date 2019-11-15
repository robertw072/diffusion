package main

import "fmt"

func main() {
	const maxsize int = 15 // size of each block
	var cube[maxsize][maxsize][maxsize] float64
  // Partition flag 0 off, 1 on
  var partitionflag int = 1

	// Zero the cube
	var i, j, k int
	for i = 0; i < maxsize; i++ {
		for j = 0; j < maxsize; j++ {
			for k = 0; k < maxsize; k++ {
				cube[i][j][k] = 0.0
			}
		}
	}

  var partition[maxsize][maxsize][maxsize] float64
  // If partition is on, zero the partition and construct it
  if (partitionflag == 1) {
    for i = 0; i < maxsize; i++ {
      for j = 0; j < maxsize; j++ {
        for k = 0; k < maxsize; k++ {
          partition[i][j][k] = 0.0
        }
      }
    }
  }
  // create the actual partition
  if (partitionflag == 1) {
    var kp int = maxsize / 2
    for i = 0; i < maxsize; i++ {
      for j = maxsize - 1; j > (maxsize / 4); j-- {
        partition[i][j][kp] = float64(-1)
      }
    }
  }

  	// define variables
	var diffusionCoeff float64 = 0.175
	var roomDim float64 = 5.0 // room is 5 by 5 by 5
	var gasSpeed float64 = 250.0 
	var timestep float64 = (roomDim / gasSpeed) / float64(maxsize) // used to update simulated time
	var blockDistance float64 = roomDim / float64(maxsize)
	var dterm float64 = diffusionCoeff * timestep / (blockDistance * blockDistance) 

  	// initialize first cell of the cube
	cube[0][0][0] = 1.0e21

	var time float64 = 0.0 // keeps track of simulated time
	var ratio float64 = 0.0 // keeps track of termination condition

	for ratio < 0.99 {
		for i = 0; i < maxsize; i++ {
			for j = 0; j < maxsize; j++ {
				for k = 0; k < maxsize; k++ {
					// repeat for each face of the current cell
					// if not trying to diffuse into or from the partition, then diffuse
					if (0 <= k-1 && k-1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i][j][k-1] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i][j][k-1])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j][k-1] = cube[i][j][k-1] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i][j][k-1])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j][k-1] = cube[i][j][k-1] + change
							}
					}

					if (0 <= k+1 && k+1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i][j][k+1] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i][j][k+1])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j][k+1] = cube[i][j][k+1] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i][j][k+1])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j][k+1] = cube[i][j][k+1] + change
							}
					}

					if (0 <= j-1 && j-1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i][j-1][k] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i][j-1][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j-1][k] = cube[i][j-1][k] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i][j-1][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j-1][k] = cube[i][j-1][k] + change
							}
					}

					if (0 <= j+1 && j+1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i][j+1][k] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i][j+1][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j+1][k] = cube[i][j+1][k] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i][j+1][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i][j+1][k] = cube[i][j+1][k] + change
							}
					}

					if (0 <= i-1 && i-1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i-1][j][k] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i-1][j][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i-1][j][k] = cube[i-1][j][k] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i-1][j][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i-1][j][k] = cube[i-1][j][k] + change
							}
					}

					if (0 <= i+1 && i+1 < maxsize) {
						if (partitionflag == 1) {
							if ((partition[i][j][k] != float64(-1)) && (partition[i+1][j][k] != float64(-1))) {
								var change float64 = (cube[i][j][k] - cube[i+1][j][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i+1][j][k] = cube[i+1][j][k] + change
							}
						} else {
								var change float64 = (cube[i][j][k] - cube[i+1][j][k])*dterm
								cube[i][j][k] = cube[i][j][k] - change
								cube[i+1][j][k] = cube[i+1][j][k] + change
							}
					}

				}
			}
		}


		time = time + timestep // update simulated time

		var maxval float64 = cube[0][0][0]
		var minval float64 = cube[0][0][0]

		for i = 0; i < maxsize; i++ {
			for j = 0; j < maxsize; j++ {
				for k = 0; k < maxsize; k++ {
					// determine max and min of cube for ratio update
					if (cube[i][j][k] > maxval) {
						maxval = cube[i][j][k]
					}

					if ((cube[i][j][k] < minval) && (cube[i][j][k] != 0.0)) {
						minval = cube[i][j][k]
					}
				}
			}
		}

		ratio = minval / maxval // update the ratio
		fmt.Println(time, " ", ratio)

	}

		fmt.Println("Box equilibrated in: ", time)

}
