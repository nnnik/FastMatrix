#Include ../Matrix.ahk

m := new Matrix(3, 3) ;create a new Matrix m
m.fillRandom(1, 9) ;fill it with random data from 1 to 9
Msgbox % "Create a random matrix`nfill it with random integers from 1 to 9:`n" . m.toString("Round")

oldValue := m.values[2, 2]	;get the value at position 2, 2
m.values[2, 2] := 42		;overwrite the value with 42
Msgbox % "Overwrite the " . Round(oldvalue) . " in the middle with 42:`n" . m.ToString("Round")

m_column := m.values[1] ;get the first column as an array
for each, val in m_column { ;for each value in the column/array
	m_column[each] := val * oldValue ;multiply by the value we have taken from the middle and write it bnack to the array
} 
m.values["", 1] := m_column ;overwrite the first row with the result
Msgbox % "Replace the first row with the first column`n multiplied by the " . Round(oldValue) . " we got before:`n" . m.toString("Round")

oldRows := m.values ;get the entire matrix as a list of rows
newRows := []
Loop 3 { ;for each row thats free in newRows
	Random, newPosition, 1, 4-A_Index ;select a random row
	newRows.push(oldRows[newPosition]) ;from oldRows that will be put into newRows at this position
	oldRows.removeAt(newPosition) ;remove the row from oldRows to prevent pulling it twice
}
m.values := newRows ;set values of m to the new row list
Msgbox % "Shuffle the rows:`n" m.ToString("Round")