[r_zc,i_zc,tx,sequence_r, sequence_i] = tx_gen_v2(64,1,1, 200000, 20000);

figure(1)
plot(r_zc)
title("Real ZC")

figure(2)
plot(i_zc)
title("Imaginary ZC")