/*
	This example showcases how to transpose a matrix
	It also uses .values to set the contents of the matrix
*/

#Include ../Matrix.ahk

m := new Matrix(3, 3) ;create a new matrix and store it in m

Loop 3 {
	x := A_Index
	Loop 3
		m.values[x, A_Index] := x + 3*(A_Index-1)
}

mString := m.ToString("Round") ;call the .ToString method to turn the matrix m into a string

m2 := m.transpose() ;transpose m and put the result into m2
m2String := m2.ToString("Round")
Msgbox % "create a matrix m with the size 3, 3 `n" . mString
. "`n`ntranspose the matrix:`n" . m2String


m3 := new Matrix(4, 2) ;create a new matrix and store it in m3

Loop 4 {
	x := A_Index
	Loop 2
		m3.values[x, A_Index] := x + 4*(A_Index-1)
}

m3String := m3.ToString("Round")

m4 := m3.transpose() ;transpose the matrix m3
m4String := m4.ToString("Round") ;call the .ToString method to turn the matrix m4 into a string

Msgbox % "create a matrix m with the size 4, 2 `n" . m3String
. "`n`ntranspose the matrix:`n" . m4String