clc
clear all

n = 10;octave_config_info
W = 0.48;
freqz(fir1(n, W, "low"));