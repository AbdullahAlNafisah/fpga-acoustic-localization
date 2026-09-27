[r_zc,i_zc,tx,sequence_r, sequence_i] = zc_seq(64, 1, 1);

figure(1)
plot(r_zc)
title("Real ZC")

figure(2)
plot(i_zc)
title("Imaginary ZC")