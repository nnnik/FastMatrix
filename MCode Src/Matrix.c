double (*exp2)(double)  = 0;		//the exp function of the MSVCRT.dll
double (*sqrt2)(double) = 0;		//the sqrt function of the MSVCRT.dll

//needs to b called when initializing the library
//links against the functions mentioned above
//they can be found in msvcrt.dll
void link(double (*pexp)(double), double (*psqrt)(double)) {
	exp2  = pexp;
	sqrt2 = psqrt;
}

//calculate the sigmoid of the values of the matrix mIn and put them into mOut
//to use the same matrix for input and output you can set the input to the output
void sigmoid(double* mOut, double* mIn, int w, int h) {
	//using the tailor series to calculate e^x
	for (int i =0; i<w*h; i++) {
		double result = exp2(mIn[i]);
		mOut[i] = result/(result+1);
	}
}

//adds the values of 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void add(double* mOut, double* m1, double* m2, int w, int h) {
	for (int i =0; i<w*h; i++) {
		mOut[i] = m1[i]+m2[i];
	}
}

//subtracts the values of 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void subtract(double* mOut, double* m1, double* m2, int w, int h) {
	for (int i =0; i<w*h; i++) {
		mOut[i] = m1[i]-m2[i];
	}
}

//multiplies all values inside the matrix by a single factor
//the output matrix can be the input matrix
void multiplyFactor(double* mOut, double* mIn, double factor, int w, int h) {
	for (int i =0; i<w*h; i++) {
		mOut[i] = mIn[i]*factor;
	}
}

//multiplies each value inside 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void multiplyValues(double* mOut, double* m1, double* m2, int w, int h) {
	for (int i =0; i<w*h; i++) {
		mOut[i] = m1[i]*m2[i];
	}
}

//performs a matrix multiplication on m1 and m2 and puts the result into mOut
//requires a seperate output matrix
//the parameter wh describes the width of m1 and the height of m2
//the parameter w describes the width of m2 and mOut
//the parameter h describes the height of m1 and mOut
void multiply(double* mOut, double* m1, double* m2, int wh, int w, int h) { 
	for (int x=0; x<w; x++) {
		for (int y=0; y<h; y++) {
			double tmp = 0;
			for (int i=0; i<wh; i++) {
				tmp += m1[i*h+y]*m2[x*wh+i];
			}
			mOut[x*h+y] = tmp;
		}
	}
}

//performs a matrix multiplication on m1 and m2 and puts the result into mOut
//unlike multiply it acts as if m1 was transposed - thats faster and avoids unneccessary transposing
//requires a seperate output matrix
//the parameter h describes the height of m1 and m2
//the parameter w1 describes the width of m1 and the height of mOut
//the parameter w2 describes the width of m2 and mOut
void multiplyTransposed(double* mOut, double* m1, double* m2, int h, int w1, int w2) {
	for (int x=0; x<w2; x++) {
		for (int y=0; y<w1; y++) {
			double tmp = 0;
			for (int i=0; i<h; i++) {
				tmp += m1[i+y*h]*m2[i+x*h];
			}
			mOut[x*w1+y] = tmp;
		}
	}
}

//performs a matrix multiplication on m1 and m2 and puts the result into mOut
//unlike multiply it acts as if m2 was transposed - that avoids unneccessary transposing _ sadly it is slower than multiplyTransposed
//requires a seperate output matrix
//the parameter w describes the width of m1 and m2
//the parameter h1 describes the height of m1 and the height of mOut
//the parameter h2 describes the height of m2 and mOut
void multiplyTransposed2(double* mOut, double* m1, double* m2, int w, int h1, int h2) {
	for (int x=0; x<h2; x++) {
		for (int y=0; y<h1; y++) {
			double tmp = 0;
			for (int i=0; i<w; i++) {
				tmp += m1[i*h1+y]*m2[i*h2+x];
			}
			mOut[x*h1+y] = tmp;
		}
	}
}

//transposes the matrix mIn and puts the transposed matrix into mOut
//requires a seperate output matrix
void transpose(double* mOut, double* mIn, int w, int h) {
	for (int x=0; x<w; x++) {
		for (int y=0; y<h; y++) {
			mOut[x+y*w] = mIn[x*h+y];
		}
	}
}


//readjusts the binary data after resizing has been done
//assures that the old data is kept and that new data will be 0
//the output matrix can be the same as the input matrix
void resize(double* mOut, double* mIn, int oldW, int oldH, int newW, int newH) {
	if (oldH>newH) {
		for (int i=1; i<oldW; i++) {
			int oldX = i*oldH;
			int newX = i*newH;
			for (int j=0;j<oldH;j++) {
				mOut[newX+j] = mIn[oldX+j];
			}
		}
	} else if (oldH<newH) {
		for (int i=oldW-1; i>0; i--) { 
			int oldX = i*oldH;
			int newX = i*newH;
			int j=newH-1;
			for (;j>=oldH;j--) {
				mOut[newX+j] = 0;
			}
			for (;j>=0;j--) {
				mOut[newX+j] = mIn[oldX+j];
			}
		}
		for (int j=newH-1;j>=oldH;j--) {
			mOut[j] = 0;
		}
	}
	if (newW>oldW) {
		for (int i=oldW;i<newW;i++) {
			for (int j=0;j<newH;j++) {
				mOut[i*newH+j] = 0;
			}
		}
	}
}

//calculates the magnitude of the entire matrix acting as if it were a single vector
//uses the msvcrt.dlls pow and sqrt functions
double magnitude(double *mIn, int w, int h) {
	double sum = 0;
	for (int i = 0; i<w*h; i++) {
		sum += mIn[i]*mIn[i];
	}
	return sqrt2(sum);
}