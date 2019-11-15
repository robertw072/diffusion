#!/usr/bin/sbcl --script

(defconstant maxsize 10)
(defvar cube)
(defvar partitionflag 0)

; Create and zero the cube
(setf cube (make-array (list maxsize maxsize maxsize) :initial-element 0.0))

; If partitionflag is on, create the partition
(defvar partition)
(if (= partitionflag 1)
	(setf partition (make-array (list maxsize maxsize maxsize) :initial-element 0.0))
)

; define actual partition location
(when (= partitionflag 1)
 	(defvar kp (/ maxsize 2))
	(defvar jp (- maxsize 1))
	(defvar stop (/ maxsize 4))
	(loop for i from 0 to (- maxsize 1) do
			(loop while (> jp stop) do
				(setf (aref partition i jp kp) -1.0)
				(setq jp (- jp 1))
			)
	)
)
; define variables to define timestep and dterm
(defvar diffusion_coeff 0.175)
(defvar room_dim 5.0) ; actual room size
(defvar gas_speed 250.0) ; based on 100 g/mol
(defvar timestep (/ (/ room_dim gas_speed) maxsize)) ; simulated time increment
(defvar block_distance (/ room_dim maxsize))
(defvar dterm (/ (* diffusion_coeff timestep) (* block_distance block_distance)))

(setf(aref cube 0 0 0) 1.0e21) ; initialize first cell of the cube

(defvar _time 0.0)
(defvar _ratio 0.0)
(defvar change)

(loop while (< _ratio 0.99) do
	(loop for i from 0 to (- maxsize 1) do
		(loop for j from 0 to (- maxsize 1) do
			(loop for k from 0 to (- maxsize 1) do

				; repeat for each cube face, only diffuse if not attempting to diffuse into the partition
				(when (and (<= 0 (- k 1)) (< (- k 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition i j (- k 1)) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube i j (- k 1))) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube i j (- k 1)) (+ (aref cube i j (- k 1)) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube i j (- k 1))) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube i j (- k 1)) (+ (aref cube i j (- k 1)) change))
					)
				)

				(when (and (<= 0 (+ k 1)) (< (+ k 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition i j (+ k 1)) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube i j (+ k 1))) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube i j (+ k 1)) (+ (aref cube i j (+ k 1)) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube i j (+ k 1))) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube i j (+ k 1)) (+ (aref cube i j (+ k 1)) change))
					)
				)

				(when (and (<= 0 (- j 1)) (< (- j 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition i (- j 1) k) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube i (- j 1) k)) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube i (- j 1) k) (+ (aref cube i (- j 1) k) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube i (- j 1) k)) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube i (- j 1) k) (+ (aref cube i (- j 1) k) change))
					)
				)

				(when (and (<= 0 (+ j 1)) (< (+ j 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition i (+ j 1) k) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube i (+ j 1) k)) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube i (+ j 1) k) (+ (aref cube i (+ j 1) k) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube i (+ j 1) k)) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube i (+ j 1) k) (+ (aref cube i (+ j 1) k) change))
					)
				)

				(when (and (<= 0 (- i 1)) (< (- i 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition (- i 1) j k) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube (- i 1) j k)) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube (- i 1) j k) (+ (aref cube (- i 1) j k) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube (- i 1) j k)) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube (- i 1) j k) (+ (aref cube (- i 1) j k) change))
					)
				)

				(when (and (<= 0 (+ i 1)) (< (+ i 1)(- maxsize 1)))
					(when (= partitionflag 1)
						(when (and (/= (aref partition i j k) -1.0) (/= (aref partition (+ i 1) j k) -1.0))
									(setq change (* (- (aref cube i j k) (aref cube (+ i 1) j k)) dterm))
									(setf (aref cube i j k) (- (aref cube i j k) change))
									(setf (aref cube (+ i 1) j k) (+ (aref cube (+ i 1) j k) change))
						)
					)
					(unless (= partitionflag 1)
						(setq change (* (- (aref cube i j k) (aref cube (+ i 1) j k)) dterm))
						(setf (aref cube i j k) (- (aref cube i j k) change))
						(setf (aref cube (+ i 1) j k) (+ (aref cube (+ i 1) j k) change))
					)
				)

			)
		)
	)

	(setq _time (+ _time timestep)) ; update time

	(defparameter maxval (aref cube 0 0 0))
	(defparameter minval (aref cube 0 0 0))

	; this loop determines max and min to be used by ratio
	(loop for i from 0 to (- maxsize 1) do
		(loop for j from 0 to (- maxsize 1) do
			(loop for k from 0 to (- maxsize 1) do
				(setq maxval (max (aref cube i j k) maxval))
				(if (/= (aref cube i j k) 0.0)
					(setq minval (min (aref cube i j k) minval))

				;(format t "~5f ~5d ~%" maxval minval)
				)
			)
		)
	)
	; update ratio
	(setq _ratio (/ minval maxval))

	(format t "~5f ~5d ~%" _time _ratio)
	(terpri)

)

(format t "The box equilibrated in ~5f seconds." _time)
