package main

import "fmt"

func main() {
	const maxsize int = 10
	var cube[maxsize][maxsize][maxsize] float64

	// Zero the cube
	var i, j, k, l, m, n int
	for i = 0; i < maxsize; i++ {
		for j = 0; j < maxsize; j++ {
			for k = 0; k < maxsize; k++ {
				cube[i][j][k] = 0.0
			}
		}
	}

	var diffusion_coeff float64 = 0.175
	var room_dim float64 = 5.0
	var gas_speed float64 = 250.0
	var timestep float64 = (room_dim / gas_speed) / float64(maxsize)
	var block_distance float64 = room_dim / float64(maxsize)
	var dterm float64 = diffusion_coeff * timestep / (block_distance * block_distance)

	cube[0][0][0] = 1.0e21

	var time float64 = 0.0
	var ratio float64 = 0.0

	for ratio < 0.99 {
		for i = 0; i < maxsize; i++ {
		for j = 0; j < maxsize; j++ {
			for k = 0; k < maxsize; k++ {
			for l = 0; l < maxsize; l++ {
				for m = 0; m < maxsize; m++ {
				for n = 0; n < maxsize; n++ {
					if (((i==l) && (j==m) && (k==n+1)) || 
					    ((i==l) && (j==m) && (k==n-1)) || 
					    ((i==l) && (j==m+1) && (k==n)) || 
					    ((i==l) && (j==m-1) && (k==n)) || 
					    ((i==l+1) && (j==m) && (k==n)) || 
					    ((i==l-1) && (j==m) && (k==n)) ) {
						var change float64 = (cube[i][j][k] - cube[l][m][n]) * dterm
						cube[i][j][k] = cube[i][j][k] - change
						cube[l][m][n] = cube[l][m][n] + change
					}
				}
				}
			}
			}
		}		
		}

		time = time + timestep

		var maxval float64 = cube[0][0][0]
		var minval float64 = cube[0][0][0]

		for i = 0; i < maxsize; i++ {
			for j = 0; j < maxsize; j++ {
				for k = 0; k < maxsize; k++ {
					if (cube[i][j][k] > maxval) {
						maxval = cube[i][j][k]
					}
		
					if (cube[i][j][k] < minval) {
						minval = cube[i][j][k]
					}
				}
			}
		}

		ratio = minval / maxval
		fmt.Println(time, " ", ratio)

	}

		fmt.Println("Box equilibrated in: ", time)

}
