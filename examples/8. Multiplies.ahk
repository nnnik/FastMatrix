/*
	This example performs a few multiplications using the 3 matrix multiplication methods
	it shows: multiply, multiplyTransposed, multiplyTransposed2
*/


#Include ../Matrix.ahk
m1 := new Matrix(2, 3), m1.fillRandom(1, 9) ;create a matrix m1 with the size 2, 3 and fill it with random integers from 1 to 9
m2 := new Matrix(3, 2), m2.fillRandom(1, 9) ;create a matrix m2 with the size 3, 2 and fill it with random integers from 1 to 9
m3 := new Matrix(2, 2), m3.fillRandom(1, 9) ;create a matrix m3 with the size 2, 2 and fill it with random integers from 1 to 9


;perform a matrix multiplication on m1 and m2:
m1xm2 := m1.multiply(m2)

Msgbox % "m1 * m2:`n" 
. m1.ToString("Round") . "`n`n*`n`n" 
. m2.ToString("Round") . "`n`n=`n`n" 
. m1xm2.ToString("Round")


;perform a matrix multiplication on m2 and m1 changing the order in comparison to the 1st example:
m2xm1 := m2.multiply(m1)

Msgbox % "m2 * m1:`n" 
. m2.ToString("Round") . "`n`n*`n`n" 
. m1.ToString("Round") . "`n`n=`n`n" 
. m2xm1.ToString("Round")


;multiply m3 and m2:
m3xm2 := m3.multiply(m2)

Msgbox % "m3 * m2:`n" 
. m3.ToString("Round") . "`n`n*`n`n" 
. m2.ToString("Round") . "`n`n=`n`n" 
. m3xm2.ToString("Round")


;transpose m2 and then multiply by m3:
m2xm3_1 := m2.transpose().multiply(m3)	;this is the standard way - it is slower and uses more ressources
m2xm3_2 := m2.multiplyTransposed(m3)	;this multiplies and transposes in a single step - the multip0lication is also faster than the normal multiplication

Msgbox % "transpose(m2) * m3:`n" 
. m2.transpose().ToString("Round") . "`n`n*`n`n" 
. m3.ToString("Round") . "`n`n=`n`n" 
. m2xm3_1.ToString("Round") . "`n`n=`n`n" 
. m2xm3_2.ToString("Round")


;multiplies m3 by a transposed m1:
m3xm1_1 := m3.multiply(m1.transpose())	;this is the standard way - it is slower and uses more ressources
m3xm1_2 := m3.multiplyTransposed2(m1)	;this multiplies and tranposes in the same step

Msgbox % "m3 * transpose(m1):`n" . m3.ToString("Round") . "`n`n*`n`n" 
. m1.transpose().ToString("Round") . "`n`n=`n`n" 
. m3xm1_1.ToString("Round") . "`n`n=`n`n" 
. m3xm1_2.ToString("Round")