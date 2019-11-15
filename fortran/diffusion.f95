program diffusion
implicit none

        ! Declare necessary variables
        integer, parameter                              :: maxsize = 10 ! size of each "slice" of the room
        real(kind=8), dimension(:,:,:), allocatable     :: cube
        real(kind=8), dimension(:,:,:), allocatable     :: partition

        real(kind=8)    :: diffusion_coeff, room_dimension, gas_speed
        real(kind=8)    :: timestep, block_distance, dterm
        real(kind=8)    :: time, ratio

        integer         :: i, j, k ! iterative variables
        integer         :: kp
        integer         :: partitionflag

        real(kind=8)    :: change
        real(kind=8)    :: max_val, min_val

        ! Allocate memory to the cube
        allocate(cube(1:maxsize,1:maxsize,1:maxsize))
        partitionflag = 0 ! 0 is off, 1 is on

        ! Zero the cube

        do i = 1, maxsize
              do j = 1, maxsize
                do k = 1, maxsize
                        cube(i,j,k) = 0.0
                end do
              end do
        end do

        ! If partition flag is on, construct the partition
        allocate(partition(1:maxsize,1:maxsize,1:maxsize))
        if (partitionflag .eq. 1) then
          do i = 1, maxsize
                do j = 1, maxsize
                  do k = 1, maxsize
                          partition(i,j,k) = 0.0
                  end do
                end do
          end do
        end if

        ! define actual location of partition
        if (partitionflag .eq. 1) then
          kp = maxsize / 2
          do i = 1, maxsize
            do j = (maxsize-1), (maxsize/4), -1
              partition(i,j,kp) = real(-1)
            end do
          end do
        end if

        ! create variables to define timestep and dterm
        diffusion_coeff = 0.175
        room_dimension = 5.0  ! room is 5 by 5 by 5
        gas_speed = 250.0 !g/mol
        timestep = (room_dimension / gas_speed) / real(maxsize, 8) ! tracks simulated time
        block_distance = (room_dimension / real(maxsize, 8))
        dterm = diffusion_coeff * timestep / (block_distance * block_distance)

        cube(1,1,1) = 1.0e21 ! initialize initial cell of the cube

        time = 0.0
        ratio = 0.0

        do while (ratio .lt. 0.99)
          do i = 1, maxsize
            do j = 1, maxsize
              do k = 1, maxsize
                        ! repeat for each face, if not trying to diffuse into the partition, then diffuse, else don't
                        if ((1 .le. k-1) .and. (k-1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i,j,k-1) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i,j,k-1))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j,k-1) = cube(i,j,k-1) + change
                            end if
                            else
                              change = (cube(i,j,k) - cube(i,j,k-1))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j,k-1) = cube(i,j,k-1) + change
                          end if
                        end if

                        if ((1 .le. k+1) .and. (k+1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i,j,k+1) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i,j,k+1))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j,k+1) = cube(i,j,k+1) + change
                            end if
                            else
                              change = (cube(i,j,k) - cube(i,j,k+1))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j,k+1) = cube(i,j,k+1) + change
                          end if
                        end if

                        if ((1 .le. j-1) .and. (j-1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i,j-1,k) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i,j-1,k))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j-1,k) = cube(i,j-1,k) + change
                            end if
                          end if
                        else
                          change = (cube(i,j,k) - cube(i,j-1,k))*dterm
                          cube(i,j,k) = cube(i,j,k) - change
                          cube(i,j-1,k) = cube(i,j-1,k) + change
                        end if

                        if ((1 .le. j+1) .and. (j+1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i,j+1,k) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i,j+1,k))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j+1,k) = cube(i,j+1,k) + change
                            end if
                          else
                              change = (cube(i,j,k) - cube(i,j+1,k))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i,j+1,k) = cube(i,j+1,k) + change
                          end if
                        end if

                        if ((1 .le. i-1) .and. (i-1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i-1,j,k) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i-1,j,k))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i-1,j,k) = cube(i-1,j,k) + change
                            end if
                          else
                            change = (cube(i,j,k) - cube(i-1,j,k))*dterm
                            cube(i,j,k) = cube(i,j,k) - change
                            cube(i-1,j,k) = cube(i-1,j,k) + change
                          end if
                        end if

                        if ((1 .le. i+1) .and. (i+1 .le. maxsize)) then
                          if (partitionflag .eq. 1) then
                            if ((partition(i,j,k) .ne. real(-1)) .and. (partition(i+1,j,k) .ne. real(-1))) then
                              change = (cube(i,j,k) - cube(i+1,j,k))*dterm
                              cube(i,j,k) = cube(i,j,k) - change
                              cube(i+1,j,k) = cube(i+1,j,k) + change
                            end if
                          else
                            change = (cube(i,j,k) - cube(i+1,j,k))*dterm
                            cube(i,j,k) = cube(i,j,k) - change
                            cube(i+1,j,k) = cube(i+1,j,k) + change
                          end if
                        end if

              end do
            end do
          end do

                ! update timestep
                time = time + timestep

                max_val = cube(1,1,1)
                min_val = cube(1,1,1)
                do i = 1, maxsize
                        do j = 1, maxsize
                                do k = 1, maxsize
                                        ! determine minval and maxval
                                        if (cube(i,j,k) .gt. max_val) then
                                                max_val = cube(i,j,k)
                                        end if

                                        if (cube(i,j,k) .ne. 0.0) then
                                          if (cube(i,j,k) .lt. min_val) then
                                                  min_val = cube(i,j,k)
                                          end if
                                        end if
                                end do
                        end do
                end do

                ratio = min_val / max_val ! update ratio

                print *, time, " ", ratio

        end do

        print *, "Box equilibrated in: ", time

        deallocate(cube) ! deallocate memory of cube and partition
        deallocate(partition)
end program diffusion
