/*
	This is an example to showcase a simple geometrical calculation I added
	We will get the length of a 2 dimensional vector
	Its still very simple so I added it as 3rd example
*/

#Include ../Matrix.ahk

v1 := new Matrix(1, 2)	;v1 is a matrix with a height of 1 - its the same as a vector
v1.values[1, 1] := 42	;it goes exactly 42 units upwards

s := "v1 is a vector that looks like:`n" . v1.ToString() . "`n`nits length is:`n" . v1.magnitude() . " units"

v2 := new Matrix(1, 2)	;v2 same as v1
v2.fillRandom()		;but its filled with random data
s .= "`n`nv2 is a vector that looks like:`n" . v2.ToString() . "`n`nits length is:`n" . v2.magnitude() . " units"

v3 := v1.add(v2)		;the addition of v1 and v2
Msgbox % s . "`n`nv3 is the addition of v1 and v2 and looks like:`n" . v3.ToString() . "`n`nit's length is:`n" . v3.magnitude() . " units"