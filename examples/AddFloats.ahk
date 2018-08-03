#Include ../Matrix.ahk
m1 := new Matrix(3, 3) ;create a new matrix and store it in m1
m1.fillRandom()  ;fill m1 with random integers from -1 to 1

m2 := new Matrix(3, 3) ;create a second matrix and store it in m2
m2.fillRandom()  ;fill m2 with random floats from -1 to 1

additionResult := m1.add(m2) ;add m2 to m1 and put the result into additionalResult
;the result is a new seperate matrix

m1String := m1.ToString() ;call the .ToString method to turn the matrix m1 into a string

m2String := m2.ToString() ;call the .ToString method to turn the matrix m2 into a string

additionResultString := additionResult.ToString() ;same with the result of the addition

Msgbox % m1String . "`n`n+`n`n" . m2String . "`n`n=`n`n" . additionResultString ;display the matrices