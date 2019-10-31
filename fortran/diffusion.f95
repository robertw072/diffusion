program diffusion
implicit none

        integer                                         :: maxsize
        real(kind=8), dimension(:,:,:), allocatable     :: cube
        
        real(kind=8)    :: diffusion_coeff, room_dimension, gas_speed
        real(kind=8)    :: timestep, block_distance, dterm
        real(kind=8)    :: time, ratio
        
        integer         :: i, j, k
        integer         :: l, m, n

        real(kind=8)    :: change
        real(kind=8)    :: max_val, min_val

        ! Allocate memory to the cube
        maxsize = 10
        allocate(cube(1:maxsize,1:maxsize,1:maxsize))


        ! Zero the cube

        do i = 1, maxsize
              do j = 1, maxsize
                do k = 1, maxsize
                        cube(i,j,k) = 0.0
!                        print*, cube(i,j,k)
                end do
              end do    
        end do 
!        print *, size(cube)

        diffusion_coeff = 0.175
        room_dimension = 5.0
        gas_speed = 250.0
        timestep = (room_dimension / gas_speed) / real(maxsize, 8)
        block_distance = (room_dimension / real(maxsize, 8))
        dterm = diffusion_coeff * timestep / (block_distance * block_distance)

        cube(1,1,1) = 1.0e21

        time = 0.0
        ratio = 0.0

        do while (ratio .lt. 0.99)
                do i = 1, maxsize
                do j = 1, maxsize
                        do k = 1, maxsize
                        do l = 1, maxsize
                                do m = 1, maxsize
                                do n = 1, maxsize
                                        if (((i .eq. l) .and. (j .eq. m) .and. (k .eq. n+1)) .or. &
                                            ((i .eq. l) .and. (j .eq. m) .and. (k .eq. n-1)) .or. &
                                            ((i .eq. l) .and. (j .eq. m+1) .and. (k .eq. n)) .or. &
                                            ((i .eq. l) .and. (j .eq. m-1) .and. (k .eq. n)) .or. &
                                            ((i .eq. l+1) .and. (j .eq. m) .and. (k .eq. n)) .or. &
                                            ((i .eq. l-1) .and. (j .eq. m) .and. (k .eq. n)) ) then
                                                change = (cube(i,j,k) - cube(l,m,n))*dterm
                                                cube(i,j,k) = cube(i,j,k) - change
                                                cube(l,m,n) = cube(l,m,n) + change
                                        end if
 
                                end do
                                end do
                        end do
                        end do
                end do
                end do
                
                time = time + timestep

                max_val = cube(1,1,1)
                min_val = cube(1,1,1)
                do i = 1, maxsize
                        do j = 1, maxsize
                                do k = 1, maxsize
                                        if (cube(i,j,k) .gt. max_val) then
                                                max_val = cube(i,j,k)
                                        end if
        
                                        if (cube(i,j,k) .lt. min_val) then
                                                min_val = cube(i,j,k)
                                        end if
                                end do
                        end do
                end do

                ratio = min_val / max_val

                print *, time, " ", ratio

        end do

        print *, "Box equilibrated in: ", time

        deallocate(cube)
end program diffusion
