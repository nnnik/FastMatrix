/*
This script showcases the output Matrix parameter available in the matrix methods
It lets you define a matrix that should be used as output for the newly created data
This avoids creating a new Matrix Object and resizing it which is incredibly slow compared to the other calculations

As long as the Matrix has the correct size you can output the data to any matrix - even to one of the input matrices
However in some cases that require some extra steps from the matrix object and the pointer of it might change during that time
Performance might also be worse for those actions however Im not certain about that
*/

#Include ../Matrix.ahk
SetBatchlines, -1

/*
lets create a simple test case for performance
we have a 3d graphics and we want to rotate it
we will create a matrix for rotating it:
*/

m1 := new Matrix(3, 3)	;create a new matrix m1
m1.values := [[(2**0.5)/2, (2**0.5)/2, 0], [-(2**0.5)/2, (2**0.5)/2, 0], [0, 0, 0]]
;^this is a rotation around the z axis by 45 degrees

/*
then we create a 3d model which is just a lot of vectors:
*/


prototypeVector := new Matrix(1, 3)	;create a vector
prototypeVector.fillRandom()			;fill it with random values
vectors := [prototypeVector]			;create a list that contains our vector
Loop 9999							;and push a clone of that vector into the list 999 times
	vectors.push(prototypeVector.clone())
;this will result in a list with 10000 vectors

t := A_TickCount
Loop 10
	for each, vector in vectors				;and now apply the rotation to each one
		vectors[each] := m1.multiply(vector)	;multiply and push back into the array
f := A_TickCount
Msgbox % "rotating 10000 vectors 10 times took " (measurement_wo := f-t) " ms`nwithout the outputMatrix parameter"

;this time we will do the rotating again but use the outputMatrix parameter for more speed
t := A_TickCount
Loop 10
	for each, vector in vectors				;and now apply the rotation to each one
		m1.multiply(vector, vector)			;multiply and put the result into vector - which just remains inside the array
f := A_TickCount
Msgbox % "rotating 10000 vectors 10 times took " (measurement_w := f-t) " ms`nwith the outputMatrix parameter"
Msgbox % "using the outputMatrix parameter was " . (measurement_wo/measurement_w) . " times faster"



/*
	for our second test we want to move all the vectors by a second vector:
*/

vector2 := new Matrix(1, 3)
vector2.fillRandom()

t := A_TickCount
Loop 10
	for each, vector in vectors				;for each vector
		vectors[each] := vector2.add(vector)	;add the vector2 to vector and push the resulting vector into the list
f := A_TickCount
Msgbox % "moving 10000 vectors 10 times took " . (measurementa_wo := f-t) . " ms`nwithout the outputMatrix parameter"

t := A_TickCount
Loop 10
	for each, vector in vectors				;for each vector
		vector2.add(vector, vector)			;add the vector2 to vector and store the result in vector
f := A_TickCount
Msgbox % "moving 10000 vectors 10 times took " . (measurementa_w := f-t) . " ms`nwith the outputMatrix parameter"
Msgbox % "using the outputMatrix parameter was " . (measurementa_wo/measurementa_w) . " times faster"