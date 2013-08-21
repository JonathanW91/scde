%
%   File:      caponL2.m
%   Author(s): Horacio Sanson
%   Revision : 2007/10/17
%
%   Description:
%       Estimates the cross PSD of two signals using the Capon2 (NMLM) estimator.
%       This implementation is based on Dr. Lagunas code (CTTC) that creates a
%       fourier matrix and calculate the spectrum for all frequencies in one step.
%
%   Notes:
%        - Tested with Matlab 7.0.0.19901 (R14) and Octave 2.9.9
%        - The PSD is given at discrete samples 1/N apart of each other over the interval -1/2 to 1/2. To
%          obtain the frequency vector multiply the sample vector k with the sampling frequency.

function [C,k]=caponL2(x1,x2,M);

% Default to foward-backward covariance estimation
if nargin < 4
    METHOD = 'modified';   
end

N = length(x1);  % Signal length
L = N - M + 1;   %

R11 = corr_matlab(x1,x1,M,METHOD);
R22 = corr_matlab(x2,x2,M,METHOD);
R12 = corr_matlab(x1,x2,M,METHOD);
Ri11 = inv(R11);
Ri22 = inv(R22);

s = zeros(M,N);
k = [-N/2:N/2-1]/N;
for idx = 1:M
    s(idx,:) = exp(j*2*pi*(idx-1)*k);
end

num = s'*Ri11*R12*Ri22*s;
den = s'*Ri11*Ri22*s;

C = real(diag(num./den));

%C = 10*log10(real(diag(num./den)));   % Uncomment to get PSD in dB
