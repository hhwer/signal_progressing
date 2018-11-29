X = randn(100,5);
weights = [0;2;0;-3;0]; % Only two nonzero coefficients
y = 1+X*weights% Small added noise
B = lasso(X,y);