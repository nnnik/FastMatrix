/*
	This script is a rough speed comparison between the fastMatrix libraries matrix class and 
	a native AHK implementation for matrices and vectors
	
	For the comparison I have chosen the simple task of multiplying many vectors by a matrix multiple times
	
	I have optimized the native implementation as much as I could and 
	it actually gives some pretty decent results speed wise
	
	The FastMatrix is using one of its worst case operations:  
	That is multiplying and storing the result in one of the inputs
	See the docs regarding "Math II: Matrices" for details
	
	When comparing I gradually increase the size of the vectors and the matrix that we multiply
	
	Until the vectors reach a specific size the native implementation is faster than the FastMatrix implementation
	On my PC this point is once we hit 3 dimensional vectors
	
	After this the speed needed by the native implementation explodes
	Throughout my entire testing I have not been able to see a speed increase or decrease in the speed of the FastMatrix library
	
	This matches my expectations or rather in fact exceeds them
	The MCode tha I built seems to require no noticeable time where as most of the speed loss stems from the overhead of using it in AHK
	
	This affects how I have to plan future optimizations and will affect the design of this library heavily
	I now aim to decrease the overhead of using this library - it is my main goal
	
	This test was done using AHK 1.1.29.0 Unicode 32 bit
	AHK v2 will proobably be a lot faster when it comes to object accesses which will make the native version a lot faster
	Chances are that it will also decrease the overhead of using the library though so it is hard to tell the outcome without testing it.
	
	The 64 bit version should also be faster for both - I cannot make any predictions how much and which implementation is more affected by it though.
*/

#NoTrayIcon
#NoEnv
SetWorkingDir, %A_ScriptDir%

#Include ../Matrix.ahk

fileName := SubStr(A_ScriptName, 1, -4) . "/AHK " . A_AhkVersion . " " . (A_PtrSize*8) . " " . (A_IsUnicode?"U":"A") . " FastMatrix " . Matrix.getVersion() ".log"

fOut := fileOpen(fileName, "w`n")
if (!isObject(fOut))
	Throw exception("Error opening output file:`n" . fileName . "`nmake sure it is not opened by another program`nand dont run this from AHK studio (it somehow doesnt work)")

SetBatchLines, -1
InputBox, d, Benchmark Count, How many dimensions do you want to benchmark?`nWhen you dont know what this means just choose the default (5)`nevery dimension takes longer to complete so dont choose too much, , , , , , , , 5
Msgbox Starting Benchmark
fOut.writeLine("Comparing an old matrix library with the fast matrix library")
fOut.writeLine("Using a multiplication of 10000 vectors by a matrix")
fOut.writeLine("|`tvector dimensions`t|`tfastMatrix`t|`tnative AHK`t|")
fOut.writeLine("---------------------------------------------------------")
Critical
Loop %d% {
	size := A_Index
	fOut.write("|`t" . size . " dimensions`t`t")
	m1 := new Matrix(size, size)	;create a new matrix m1
	Loop %size% {
		m1.values[A_Index, A_Index] := 1.0
	}
	
	prototypeVector := new Matrix(1, size)	;create a vector
	prototypeVector.fillRandom()			;fill it with random values
	vectors := [prototypeVector]			;create a list that contains our vector
	Loop 9999							;and push a clone of that vector into the list 999 times
		vectors.push(prototypeVector.clone())
	
	Thread,  Priority, 2147483647
	Process, Priority,, R
	t := A_TickCount
	Loop 10
		for each, vector in vectors				;and now apply the rotation to each one
			vectors[each] := m1.multiply(vector, vector)			;multiply and put the result into vector - which just remains inside the array
	f := A_TickCount
	Thread,  Priority, 0
	Process, Priority,, N
	
	fOut.write("|`t" . (f-t) . "ms`t`t")
	
	MATRIX_A := CREATE_OLD_MATRIX(size, size)
	Loop %size% {
		MATRIX_A[A_Index, A_Index] := 1.0
	}
	
	VEC_B := CREATE_OLD_VECTOR(size)
	Loop %size% {
		Random, r, -1.0, 1.0 
		VEC_B[A_Index] := r
	}
	
	vectors2 := [VEC_B]
	Loop 9999 {
		vectors2.push(VEC_B.clone())
	}
	Thread,  Priority, 2147483647
	Process, Priority,, R
	t := A_TickCount
	Loop 10 {
		for each, vector in vectors2 {				;and now apply the rotation to each one
			vectors2[each] := MULTIPLY_OLD_MATRIX_VECTOR(MATRIX_A, vector)	;multiply and put the result into vector - which just remains inside the array
		}
	}
	f := A_TickCount
	Thread,  Priority, 0
	Process, Priority,, N
	
	fOut.writeLine("|`t" . (f-t) . "ms`t`t|")
}
fOut.close()
fOut := ""
Msgbox finished benchmark


CREATE_OLD_VECTOR(size) {
	vec := []
	While (A_Index<=size) {
		vec.push(0.0)
	}
	return vec
}

CREATE_OLD_MATRIX(w, h) { ;creates a matrix in native AHK
	row := []
	While (A_Index<=w) {
		row.push(0.0)
	}
	rows := [row]
	While (A_Index<h) {
		rows.push(row.clone()) ;clone should be faster than filling all rows individually
	}
	return rows ;the matrix is a list of rows - rows are a list of numbers - when creating the rows all numbers default to 0
}

MULTIPLY_OLD_MATRIX_VECTOR(m,v) ;multiplies an old style vector and matrix
{
	If (m.1.MaxIndex() != v.MaxIndex())
		Throw exception("Number of Columns in the first matrix must be equal to the number of rows in the second matrix." . disp(m) . "`n" . disp(v), -1)
	resultingVector := []
	for rowNr, row in m {
		value := 0
		for each, value in row {
			value += value * v[each]
		}
		resultingVector[rowNr] := value
	}
	Return resultingVector
}