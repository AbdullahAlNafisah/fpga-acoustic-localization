function ZC = EvenZC(M,N)
k = 0:N-1;
ZC = exp(1j .* M .* pi .* k.^2 ./ N);

end
