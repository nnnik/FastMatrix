//calculate the sigmoid of the values of the matrix mIn and put them into mOut
//to use the same matrix for input and output you can set the input to the output
void sigmoid(double* mOut, double* mIn, unsigned int w, unsigned int h) {
	//using the tailor series to calculate e^x
	for (unsigned int i =0; i<w*h; i++) {
		double x = mIn[i];
		double result = x + 1;
		double dividend = x;
		double divisor = 1;
		for (double i=2; i<66; i++) { //we could increase precision especially for larger x by increasing the limit here
		//the effect is not major or neccessary though
			dividend *= x;
			divisor *= i;
			result += dividend/divisor;
		}
		mOut[i] = result/(result+1);
	}
}

//adds the values of 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void add(double* mOut, double* m1, double* m2, unsigned int w, unsigned int h) {
	for (unsigned int i =0; i<w*h; i++) {
		mOut[i] = m1[i]+m2[i];
	}
}

//subtracts the values of 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void subtract(double* mOut, double* m1, double* m2, unsigned int w, unsigned int h) {
	for (unsigned int i =0; i<w*h; i++) {
		mOut[i] = m1[i]-m2[i];
	}
}

//multiplies all values inside the matrix by a single factor
//the output matrix can be the input matrix
void multiplyFactor(double* mOut, double* mIn, double factor, unsigned int w, unsigned int h) {
	for (unsigned int i =0; i<w*h; i++) {
		mOut[i] = mIn[i]*factor;
	}
}

//multiplies each value inside 2 matrices and puts the result into an output matrix
//the output matrix can be any of the input matrices
//all matrices need to have equal measurements
void multiplyValues(double* mOut, double* m1, double* m2, unsigned int w, unsigned int h) {
	for (unsigned int i =0; i<w*h; i++) {
		mOut[i] = m1[i]*m2[i];
	}
}

//performs a matrix multiplication on m1 and m2 and puts the result into mOut
//requires a seperate output matrix
//the parameter wh describes the width of m1 and the height of m2
//the parameter w describes the width of m2 and mOut
//the parameter h describes the height of m1 and mOut
void multiply(double* mOut, double* m1, double* m2, unsigned int wh, unsigned int w, unsigned int h) { 
	for (unsigned int x=0; x<w; x++) {
		for (unsigned int y=0; y<h; y++) {
			double tmp = 0;
			for (unsigned int i=0; i<wh; i++) {
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
void multiplyTransposed(double* mOut, double* m1, double* m2, unsigned int h, unsigned int w1, unsigned int w2) {
	for (unsigned int x=0; x<w2; x++) {
		for (unsigned int y=0; y<w1; y++) {
			double tmp = 0;
			for (unsigned int i=0; i<h; i++) {
				tmp += m1[i+y*h]*m2[i+x*h];
			}
			mOut[x*w1+y] = tmp;
		}
	}
}

//transposes the matrix mIn and puts the transposed matrix into mOut
//requires a seperate output matrix
void transpose(double* mOut, double* mIn, unsigned int w, unsigned int h) {
	for (unsigned int x=0; x<w; x++) {
		for (unsigned int y=0; y<h; y++) {
			mOut[x+y*w] = mIn[x*h+y];
		}
	}
}