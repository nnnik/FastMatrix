/*
This example showcases what an identity matrix is and checks if my calculations are working correctly
The identity matrix is like the number 1 during multiplication
If you multiply a matrix by the identity matrix it will not change
Its a quadratic matrix that is just as high as wide and all diagonal values are 1 while the other values are 0
*/

#Include ../Matrix.ahk

identityMatrix := new Matrix(2, 2)
identityMatrix.values := [[1, 0], [0, 1]]

testMatrix := new Matrix(2, 2)
testMatrix.fillRandom()

Msgbox % "This test multiplies a random matrix with the identity matrix:`nThe result should be the random matrix`n" . (res1 := testMatrix.toString()) . "`n`n*`n`n" . (id1 := identityMatrix.toString()) . "`n`n=`n`n" . (res2 := testMatrix.multiply(identityMatrix).toString()) "`n`n" ((res1 == res2) ? "The multiplication is working correctly" : "It is not working correctly")
Msgbox % "This test multiplies the identity matrix with a random matrix:`nThe result should be the random matrix`n" . id1 . "`n`n*`n`n" . res1 . "`n`n=`n`n" . (res2 := identityMatrix.multiply(testMatrix).toString()) "`n`n" ((res1 == res2) ? "The multiplication is working correctly" : "It is not working correctly")
Msgbox % "This test multiplies a transposed random matrix with the identity matrix:`nThe result should be the transposed random matrix`n" . (res3 := testMatrix.transpose().toString()) . "`n`n*`n`n" . id1 . "`n`n=`n`n" . (res4 := testMatrix.multiplyTransposed(identityMatrix).toString()) "`n`n" ((res3 == res4) ? "The multiplication is working correctly" : "It is not working correctly")
Msgbox % "This test multiplies the transposed identity matrix with a random matrix:`nThe result should be the random matrix`n" . (id2 := identityMatrix.transpose().toString()) . "`n`n*`n`n" . res1 . "`n`n=`n`n" . (res2 := identityMatrix.multiplyTransposed(testMatrix).toString()) "`n`n" ((res1 == res2) ? "The multiplication is working correctly" : "It is not working correctly")
Msgbox % "This test multiplies a random matrix with the transposed identity matrix:`nThe result should be the random matrix`n" . res1 . "`n`n*`n`n" . id2 . "`n`n=`n`n" . (res2 := testMatrix.multiplyTransposed2(identityMatrix).toString()) "`n`n" ((res1 == res2) ? "The multiplication is working correctly" : "It is not working correctly")
Msgbox % "This test multiplies the identity matrix with a transposed random matrix:`nThe result should be the transposed random matrix`n" . id1 . "`n`n*`n`n" . res3 . "`n`n=`n`n" . (res4 := identityMatrix.multiplyTransposed2(testMatrix).toString()) "`n`n" ((res3 == res4) ? "The multiplication is working correctly" : "It is not working correctly")