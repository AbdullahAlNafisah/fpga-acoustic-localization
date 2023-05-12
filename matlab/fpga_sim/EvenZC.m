function ZC = EvenZC(N,M)
    % This function generates ZC sequence with length N where M and N
    % are integers and M is coprime to N
    
    k = 0:N-1;
    ZC = exp(1j .* M .* pi .* k.^2 ./ N);

end