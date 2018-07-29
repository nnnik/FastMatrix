#include %A_LineFile%/../../../MCode-Ex/src/MCodeCompileChain.ahk
compiler1 := new VSCompiler()
compiler1.setOptimization("full")
compiler1.setInputFile("Matrix.c")
compiler2 := new VSCompiler()
compiler2.setOptimization("none")
compiler2.setInputFile("Extra.c")
package1  := new MCodeExPackage()
fileOpen("../MatrixMCode.ahk", "w").write("static functionality := MCodeEx(""" . package1.buildPackage([compiler2, compiler1]) . """)")