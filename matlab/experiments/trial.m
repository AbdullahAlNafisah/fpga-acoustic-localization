clc;

fs = 200000;
f_carr = 20000;
N = 63;
M = 1;
samples_per_bit = 1;
b_len = N*samples_per_bit; % block length
n_block = 1;
tempTime = (0:b_len*n_block-1)/fs;

x = cos(2*pi*f_carr*tempTime);
signal = zadoffChuSeq(M,N);
figure(1)
subplot(1,2,1)
plot(x)
title("cos")

subplot(1,2,2)
plot(real(signal))
title("ZC Real Part")

L = length(signal);
Y = fft(real(signal));
P2 = abs(Y/L);
P1 = P2(1:(L+1)/2);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;

figure(2)

plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")


% 
% re_part_mod = signal.* cos(2*pi*f_carr*tempTime).';
% re_part_demod = re_part_mod.* cos(2*pi*f_carr*tempTime).';
% 
% figure(1)
% subplot(1,3,1)
% plot(abs(fft(signal)))
% title("FFt of Original Signal")
% 
% subplot(1,3,2)
% plot(abs(fft(re_part_mod)))
% title("FFt of Modulated Signal")
% 
% subplot(1,3,3)
% plot(abs(fft(re_part_demod)))
% title("FFt of Deodulated Signal")
% 
% figure(2)
% plot(signal)