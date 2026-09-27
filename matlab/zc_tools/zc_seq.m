function [zc_re, zc_im, tx, seq_re, seq_im] = zc_seq(N, root, n_block)
% Zadoff-Chu sequence of length N, repeated n_block times. tx = I + Q.
if nargin < 2, root = 1; end
if nargin < 3, n_block = 1; end

k = 0:N-1;
zc = exp(1j*pi*root*k.*(k + mod(N,2))/N);

zc_re = real(zc);
zc_im = imag(zc);
seq_re = repmat(zc_re, 1, n_block);
seq_im = repmat(zc_im, 1, n_block);
tx = seq_re + seq_im;
end
