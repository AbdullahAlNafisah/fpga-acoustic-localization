% Parameters
M = 8;              % Number of symbols (M-ary)
Eb_N0_dB = -5:0.5:20; % Range of Eb/N0 values in dB
Eb_N0 = 10.^(Eb_N0_dB/10); % Convert dB to linear scale

% Calculate Gallager Bound
Gallager_bound = 2*(1 - 1/M) * qfunc(sqrt(3*Eb_N0*log2(M)/(M-1)));

% Simulate BER using Monte Carlo simulations
numBitsPerSymbol = log2(M);
numBits = numBitsPerSymbol * floor(1e6 / numBitsPerSymbol); % Adjusted number of bits
numSimulations = 10; % Number of simulations

BER_simulated = zeros(size(Eb_N0));

for sim = 1:numSimulations
    % Generate random bits
    bits = randi([0, 1], 1, numBits);
    
    % Symbol mapping (M-ary)
    numSymbols = length(bits) / numBitsPerSymbol;
    symbols = bi2de(reshape(bits, numBitsPerSymbol, numSymbols).', 'left-msb');
    
    % AWGN Channel
    for idx = 1:length(Eb_N0)
        noise = sqrt(1 / (2 * log2(M) * Eb_N0(idx))) * randn(size(symbols));
        received_symbols = symbols + noise;
        
        % Symbol demapping (decision)
        received_bits = de2bi(received_symbols, numBitsPerSymbol, 'left-msb');
        received_bits = received_bits(:)';
        
        % Calculate bit errors
        bit_errors = sum(bits ~= received_bits);
        
        % Update BER for this simulation
        BER_simulated(idx) = BER_simulated(idx) + bit_errors;
    end
end

BER_simulated = BER_simulated / (numBits * numSimulations);

% Plot results
semilogy(Eb_N0_dB, Gallager_bound, 'r--', 'LineWidth', 2);
hold on;
semilogy(Eb_N0_dB, BER_simulated, 'b-o', 'LineWidth', 2);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
legend('Gallager Bound', 'Simulated BER');
title('Gallager Bound vs. Simulated BER for M-ary Orthogonal Signals in AWGN');
