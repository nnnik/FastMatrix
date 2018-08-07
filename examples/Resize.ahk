#Include ../Matrix.ahk

m := new Matrix(3, 3) ;create a new matrix and store it in m
mString0 := m.ToString(func("Round")) ;call the .ToString method to turn the matrix m into a string
;the first parameter lets all values run through the round function - that removes all those 0s

m.fillRandom(1, 9)  ;fill m1 with random integers from 1 to 9
mString := m.ToString(func("Round")) ;call the .ToString method to turn the matrix m into a string

m.resize(5, 5) ;resize the matrix m
mString2 := m.ToString(func("Round")) ;call the .ToString method to turn the matrix m into a string

m.resize(2, 2) ;resize the matrix m
mString3 := m.ToString(func("Round")) ;call the .ToString method to turn the matrix m into a string

m.resize(5, 5) ;resize the matrix m
mString4 := m.ToString(func("Round")) ;call the .ToString method to turn the matrix m into a string

Msgbox % "create a matrix m with the size 3, 3 `n" . mString0 
. "`n`nfill it with random data:`n" . mString 
. "`n`nresize it to 5, 5:`n" . mString2 
. "`n`nresize it to 2, 2:`n" . mString3 
. "`n`nand resize it back to 5, 5 - notice how the matrix only contains the data from the 2, 2 matrix:`n" . mString4


