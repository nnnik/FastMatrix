#Include %A_LineFile%/../MCodeEx.ahk

;matrix := new Matrix(width,  height)
;	creates a new instance of the matrix class with the specified height and width
class Matrix {
	
	;loads the Machine Code thats stored in a file
	;and puts all the contained functions in a list named functionality
	#Include %A_LineFile%/../MatrixMCode.ahk
	
	binary	:= ""
	w		:= 0
	h		:= 0
	
	;create a new matrix
	;at the moment it's just resizing
	__New(w := "", h := "") {
		this._init()
		this.resize(w, h, true)
	}
	
	_init() {
		static init := 0
		if init
			return
		hDLL := DllCall("LoadLibrary", "Str", "msvcrt.dll", "Ptr")
		exp2  := DllCall("GetProcAddress", "Ptr", hDLL, "AStr", "exp", "Ptr")
		sqrt2 := DllCall("GetProcAddress", "Ptr", hDLL, "AStr", "sqrt", "Ptr")
		DllCall(this.functionality.link, "Ptr", exp2, "Ptr", sqrt2, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError)
		}
	}
	
	;resizes the matrix
	;makes sure that the old values are moved to their new positions and that new values are 0
	resize(w, h, init := 0) {
		;if w and h are invalid values
		if !(w ~= "s)^[1-9]\d*$" && h ~= "s)^[1-9]\d*$") {
			;warn the user
			throw exception("width and height need to be valid numbers: width:" . w . " height:" . h, -1-init)
		}
		;set the size of the binary that contains all the values of the matrix
		if (this.capacity < w*h*8)
			this.capacity := w*h*8
		DllCall(this.functionality.resize, "Ptr", this.ptr, "Ptr", this.ptr, "Int", this.w, "Int", this.h, "Int", w, "Int", h, "Cdecl" )
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		;updates the width and height
		this.w	:= w
		this.h	:= h
	}
	
	;gets the pointer of the binary
	ptr[] {
		get {
			return this.getAddress("binary")
		}
	}
	
	;gets or sets the capacity of the binary
	capacity[] {
		get {
			return this.GetCapacity("binary")
		}
		set {
			return this.setCapacity("binary", value)
		}
	}
	
	;this.values[x, y]
	;	gets a single value of the matrix at the point x, y
	;this.values[x, y] := value
	;	sets a single value of the matrix at the point x, y
	;	x and y use 1 based counting
	
	;this.values[x]
	;	gets the column with the index x of the matrix as an array
	;this.values[x] := column_array
	;	sets the column with the index x of the matrix to column_array
	;	column_array needs to be an array with the same length as the column
	
	;this.values["", y]
	;	gets the row with the index y of the matrix as an array
	;this.values["", y] := row_array
	;	sets the column with the index y of the matrix to row_array
	;	row_array needs to be an array with the same length as the row
	
	;this.values
	;	gets the entire matrix as a 2d array
	;	the array is a list of all rows
	;this.values := matrix_array
	;	sets the entire matrix to the value of matrix_array
	;	needs to be a list of rows
	;	you need as many rows as the matrix high is
	;	each row needs to be as wide as the array wide is
	
	values[x :="", y := ""] {
		get {
			if (x=="") 
			{
				if (y=="") { 				;this.values
					rows := []
					While (A_Index <= this.h) {
						rows.push(this.values["", A_Index])
					}
					return rows
				} 
				else if (y<=this.h && y>0)	;this.values["", y]
				{
					row := []
					While (A_Index <= this.w)
						row.push(This.values[A_Index, y])
					return row
				}
				throw exception("invalid y parameter for values access: " y, -1)
			} 
			else if (x<=this.w && x>0)
			{
				if (y=="") {				;this.values[x]
					column := []
					While (A_Index <= this.h)
						column.push(this.values[x, A_Index])
					return column
				} 
				else if (y<=this.h && y>0)	;this.values[x, y]
				{
					return NumGet((this.ptr+(y-1+(x-1)*this.h)*8), "Double")
				}
				throw exception("invalid y parameter for values access: " y, -1)
			}
			throw exception("invalid x parameter for values access: " x, -1)
		}
		
		set {
			if (x=="") 
			{
				if (y=="") {				;this.values := matrix_array
					if (isObject(value) && value.length()=this.h) {
						for each, row in value {
							this.values["", A_Index] := row
						}
						return value
					}
					throw exception("tried assigning an invalid 2d array: " value, -1)
				} 
				else if (y<=this.h && y>0) 	;this.values["", y] := row_array
				{
					if (isObject(value) && value.length()=this.w) {
						for each, val in value {
							this.values[A_Index, y] := val
						}
						return value
					}
					throw exception("tried assigning an invalid row: " value, -1)
				}
				throw exception("invalid y parameter for values access: " y, -1)
			} 
			else if (x<=this.w && x>0) 
			{
				if (y=="") {				;this.values[x] := column_array
					if (isObject(value) && value.length()=this.h) {
						for each, val in value {
							this.values[x, A_Index] := val
						}
					}
					throw exception("tried assigning an invalid column: " value, -1)
				} 
				else if (y<=this.h && y>0) 	;this.values[x, y] := value
				{
					NumPut(value, this.ptr+(y-1+(x-1)*this.h)*8, "Double")
					return NumGet((this.ptr+(y-1+(x-1)*this.h)*8), "Double")
				}
				throw exception("invalid y parameter for values access: " y, -1)
			}
			throw exception("invalid x parameter for values access: " x, -1)
		}
	}
	
	;this.toString()
	;	turns the Matrix into a nicely looking string for display purposes
	toString(fn := "") {
		str := "|"
		if !(fn=="") {
			if (%fn%(0.5) == "") {
				throw exception("The function passed to toString needs to result in a new value for each number passed to it. The function returned nothing when 0.5 was passed.", -1)
			}
		}
		While (A_Index<=this.h) {
			y := A_Index
			While (A_Index<=this.w) {
				str .= "`t" . ( (!(fn==""))?%fn%(this.values[A_Index, y]):this.values[A_Index, y]) . "|"
			}
			str .= "`n|"
		}
		return RTrim(str, "`n|") . "|"
	}
	
	;this.fillRandom(min, max, seed)
	;	fills the Matrix with random numbers
	;	min:	the smallest number that should be randomly chosen - defaults to -1.0
	;	max: the highest number that should be randomly chosen - defaults to 1.0
	;	seed: if you put a number here the randomly generated numbers will be generated using this specific seed
	;		all numbers that are generated with a specific seed will follow a fixed sequence
	fillRandom(min := -1.0, max := 1.0, seed := "") {
		if !(seed == "") {
			Random, , seed
		}
		rMin := min(min, max)
		rMax := max(min, max)
		While (A_Index<=this.w) {
			x := A_Index
			While (A_Index<=this.h) {
				Random, var, rMin, rMax
				this.values[x, A_Index] := var
			}
		}
	}
	
	;----------	OPERATIONS
	;a few general things about all operations that can be applied to the matrix
	;all operations have an additional outputMatrix parameter - it's always the last
	;it should be an Object that inherits from the Matrix class (e.g. a Vector or a 2dRotationMatrix)
	;often you can even set the output matrix to one of the inputs
	;if you do not choose an output it will create a new matrix as output
	;regardless of what you do the outputMatrix is returned
	
	
	;sigmoid()
	;	applies the sigmoid function to all values in this matrix
	;	the outputMatrix can be equal to this
	;	it uses the local msvcrt.dlls exp function to calculate e^x
	sigmoid(outputMatrix := "") {
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]`nparameter2.size", -1)
		}
		DllCall(this.functionality.sigmoid, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;sigmoidDerivative()
	;	applies the local derivative of the sigmoid function to all values in the matrix
	;	it expects a matrix that is the result of a sigmoid() call
	;	the outputMatrix parameter can be equal to this
	sigmoidDerivative(outputMatrix := "") {
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]`nparameter2.size", -1)
		}
		DllCall(this.functionality.sigmoidDerivative, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;add(matrix)
	;	adds the values of 2 matrices and puts the result into a new matrix
	;	both matrices need to be equal in size
	;	the outputMatrix parameter can be equal to either inputs
	add(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.h != this.h || this.w != inputMatrix.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		}
		DllCall(this.functionality.add, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;subtract(matrix)
	;	subtracts the values of 2 matrices and puts the result into an output matrix
	;	both matrices need to be equal in size
	;	the outputMatrix parameter can be equal to either inputs
	subtract(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.h != this.h || this.w != inputMatrix.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		}
		DllCall(this.functionality.subtract, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;multiplyByFactor(factor)
	;	multiplies the values of this matrix by a factor and puts the result into an output matrix
	;	the outputMatrix can be equal to the inputMatrix
	multiplyByFactor(factor, outputMatrix := "") {
		if !(factor~="s)^\d+\.?\d*$")
			throw exception("invalid number in parameter 1: " . factor, -1)
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		}
		DllCall(this.functionality.multiplyFactor, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Double", factor, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;multiplyValues(matrix)
	;	mutliplies all the values of 2 matrices value by value and puts the result into a new one
	;	both matrices need to be equal in size
	;	this function works similar to the add function but multiplies instead of adding
	;	the multiply method works differently it performs a real matrix multiplication
	;	the outputMatrix parameter can be equal to either inputs
	multiplyValues(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.h != this.h || this.w != inputMatrix.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		}
		DllCall(this.functionality.multiplyValues, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;multiply(matrix)
	;	performs a matrix multiplication (please google it if you dont know what I mean)
	;	since order matters: this is the first operand in a matrix multiplication, the matrix the second: (this * matrix = outputMatrix)
	;	size dependencies: 
	;		the height of this should be equal to the width of matrix
	;		the width of this should be equal to the width of the outputMatrix
	;		the height of matrix should be equal to the height of the outputMatrix
	;	the output cannot be equal to either of the input matrices
	multiply(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.h != this.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(inputMatrix.w, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || inputMatrix.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		} else if (outputMatrix == this || outputMatrix == inputMatrix) {
			throw exception("output to input not implemented", -1)
		}
		DllCall(this.functionality.multiply, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.w, "Int", inputMatrix.w, "Int",  this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;multiplyTransposed(matrix)
	;	performs a matrix multiplication with a transposed this
	;	since order matters: this is the first operand in a matrix multiplication, matrix the second: (transpose(this) * matrix = outputMatrix)
	;	size dependencies: 
	;		the width of this should be equal to the width of matrix
	;		the height of this should be equal to the height of the outputMatrix
	;		the height of matrix should be equal to the width of the outputMatrix
	;	in comparison to the normal multiply it is slightly faster (due to better caching and stuff) and also avoids transposing where it isnt neccessary
	;	the output cannot be equal to either of the input matrices
	multiplyTransposed(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.h != this.h) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(inputMatrix.w, this.w)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.w || inputMatrix.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		} else if (outputMatrix == this || outputMatrix == inputMatrix) {
			throw exception("output to input not implemented", -1)
		}
		DllCall(this.functionality.multiplyTransposed, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.h, "Int", this.w, "Int", inputMatrix.w, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;multiplyTransposed2(matrix)
	;	performs a matrix multiplication with a transposed matrix
	;	since order matters: this is the first operand in a matrix multiplication, matrix the second: (this * transpose(matrix) = outputMatrix)
	;	size dependencies: 
	;		the height of this should be equal to the height of matrix
	;		the width of this should be equal to the heihgt of the outputMatrix
	;		the height of matrix should be equal to the width of the outputMatrix
	;	in comparison to the normal multiply it avoids transposing where it isnt neccessary
	;	the output cannot be equal to either of the input matrices
	multiplyTransposed2(inputMatrix, outputMatrix := "") {
		if !(inputMatrix.__Class == "Matrix") {
			throw exception("invalid paramter expected a second matrix got: " inputMatrix . "instead", -1)
		}
		if (inputMatrix.w != this.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		}
		if (outputMatrix == "") {
			outputMatrix := new Matrix(inputMatrix.h, this.h)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || inputMatrix.w != outputMatrix.h) {
			throw exception("invalid width or height in parameter 2:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]`nparameter2.size = [" . outputMatrix.w . ", " . outputMatrix.h . "]", -1)
		} else if (outputMatrix == this || outputMatrix == inputMatrix) {
			throw exception("output to input not implemented", -1)
		}
		DllCall(this.functionality.multiplyTransposed2, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Ptr", inputMatrix.ptr, "Int", this.w, "Int", this.h, "Int", inputMatrix.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;tranpose()
	;	transposes the matrix
	;	the outputMatrix cannot be equal to this
	transpose(outputMatrix := "") {
		if (outputMatrix == "") {
			outputMatrix := new Matrix(this.h, this.w)
		} else if !(outputMatrix.__Class == "Matrix"){
			throw exception("invalid parameter expected an output matrix got: " . outputMatrix . "instead", -1)
		} else if (outputMatrix.h != this.h || this.w != outputMatrix.w) {
			throw exception("invalid width or height in parameter 1:`nthis.size = [" . this.w . ", " . this.h . "]`nparameter1.size = [" . inputMatrix.w . ", " . inputMatrix.h . "]", -1)
		} else if (outputMatrix == this) {
			throw exception("output to input not implemented", -1)
		}
		DllCall(this.functionality.transpose, "Ptr", outputMatrix.ptr, "Ptr", this.ptr, "Int", this.w, "Int", this.h, "Cdecl")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return outputMatrix
	}
	
	;----------	OPERATIONS2
	;The following operations dont result in a output matrix but rather return a direct value
	;thus they dont have an outputMatrix parameter
	
	
	;magnitude()
	;	calculates the length of a vector
	;	it multipolies all values by themselves then adds the seperate values up
	;	and finally calculates the square root
	;	while it is a calculation from vectors I have provided it for the general matrix class
	magnitude() {
		output := DllCall(this.functionality.magnitude, "Ptr", this.ptr, "Int", this.w, "Int", this.h, "cdecl double")
		if (ErrorLevel || A_LastError) {
			throw exception("Error in DllCall:`nErrorLevel: `t" . ErrorLevel . "`nA_LastError: `t" . A_LastError, -1)
		}
		return output
	}
	
}