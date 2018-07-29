//calculates the derivative of sigmoid of all values of mIn and puts them into mOut
//assumes that the sigmoid function has run over the input matrix
//to use the same matrix for input and output you can set the input to the output
void sigmoidDerivative(double* mOut, double* mIn, unsigned int w, unsigned int h) {
	for (unsigned int i =0; i<w*h; i++) {
		double var = mIn[i];
		mOut[i] = var * (1 - var);
	}
}