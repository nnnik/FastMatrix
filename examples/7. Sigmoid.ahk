/*
	This showcases how to use the sigmoid and sigmoidDerivative method
	The sigmoid derivative function requires the result of .sigmoid of the matrice you want to get the derivative from
*/


#Include ../Matrix.ahk

;calculate the sigmoid for each value inside a matrix
;this is important for neural networks
;if you want some details google neural networks - activation function

;this method of the matrix class runs the sigmoid function over all the values inside the matrix and stores it inside an output matrix:

m := new Matrix(2, 2)	;create a matrix with the size 2, 2
m.fillRandom(-5.0, 5.0)			;fill it with random numbers
mString := m.ToString()	;turn it into a string

m2 := m.sigmoid()			;calculate the sigmoid of all values of m and store it in m2
m2String := m2.ToString()	;turn m2 into a string

m3 := m2.sigmoidDerivative()	;calculate the derivative of m over the sigmoid function (requires you to use sigmoid first)
m3String := m3.ToString()	;turn m3 into a string

Msgbox % "create a random matrix m and fill it with random values:`n" . mString . "`n`ncalculate the sigmoid of it:`n" . m2String . "`n`ncalculate its derivative:`n" . m3String