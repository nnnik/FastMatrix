/*
	This examle showcases how to add 2 matrices
	Additionally it also shows how the fillRandom method can generate integers only and the "Round feature" of the ToString method
*/


#Include ../Matrix.ahk
m1 := new Matrix(3, 3) ;create a new matrix and store it in m1
m1.fillRandom(0, 100)  ;fill m1 with random integers from 0 to 100

m2 := new Matrix(3, 3) ;create a second matrix and store it in m2
m2.fillRandom(0, 100)  ;fill m2 with random integers from 0 to 100

additionResult := m1.add(m2) ;add m2 to m1 and put the result into additionalResult
;the result is a new seperate matrix

m1String := m1.ToString("Round") ;call the .ToString method to turn the matrix m1 into a string
;the first parameter lets all values run through the round function - that removes all those 0s

m2String := m2.ToString("Round") ;call the .ToString method to turn the matrix m2 into a string

additionResultString := additionResult.ToString("Round") ;same with the result of the addition

Msgbox % m1String . "`n`n+`n`n" . m2String . "`n`n=`n`n" . additionResultString ;display the matrices