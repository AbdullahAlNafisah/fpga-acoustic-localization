clc;

%numberOfElements = 64;

%BPSKSymbolPercent = 50;
%BPSKSymbolCount   = round(numberOfElements * BPSKSymbolPercent / 100);

%BPSKsignal = [1, -1, 1, 1, -1, -1, repmat(1, 20, 1)', repmat(-1, 20, 1)', repmat(1,18,1)'];
f_carr = 5000;
fs = 200000;
t = (0:4096-1)/fs;
sig = cos(2*pi*f_carr*t);
%y = filter(Hd, 1, sig);
% 
% samples_per_bit = 64;
% 
% if samples_per_bit > 1
%    BPSKsignal2=repmat(BPSKsignal, samples_per_bit, 1);
%    BPSKsignal2 = BPSKsignal2(:);
% end
% 
% tempTime = (0:length(BPSKsignal2)-1)/fs;

% seq_cos = real(BPSKsignal2'.*cos(2*pi*f_carr*tempTime));  % Carrier 1
% seq_sin = imag(BPSKsignal2'.*-sin(2*pi*f_carr*tempTime)); % Carrier 2
% 
% tx = seq_cos+seq_sin; 

tx = sig;
tx_pos = tx - min(tx); %% all between 0 and 2
tx_norm = (tx_pos/(max(tx_pos))).*(2^12 - 1); %% all between 0 and 4095
tx_round = round(tx_norm);
tx_bin = dec2bin(tx_round,12);
%-0.0120842646381230,-0.000660688553083337,0.0173128362365790,0.0502282690623629,0.0939468897933707,0.138821215165519,0.172644947068508,0.185237870113668,0.172644947068508,0.138821215165519,0.0939468897933707,0.0502282690623629,0.0173128362365790,-0.000660688553083337,-0.0120842646381230