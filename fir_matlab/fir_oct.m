close all;
clear all;
clf;


f1 = 400;
f2 = 4000;
delta_f = f2-f1;
Fs = 22050;
dB  = 38;
N = dB*Fs/(22*delta_f)

f =  [f1 ]/(Fs/2)
hc = fir1(round(N)-1, f,'low'); %filter coeficients

bb = round(hc*(2^24))
bin_bb = dec2bin(bb, 24)
fileIDbb=fopen('coef_oct.txt', 'w')
dlmwrite(fileIDbb, bin_bb, '');
fclose(fileIDbb);

figure
plot((-0.5:1/4096:0.5-1/4096)*Fs,20*log10(abs(fftshift(fft(hc,4096)))))
axis([0 20000 -60 20])
title('Filter Frequency Response - Filter coeficients')
grid on

n = 0:149;
x = 0.85*cos(2*pi*f1/Fs*n) + 0.2*cos(2*pi*f2/Fs*n);
%x = sin(2*pi*[1:1000]*5000/Fs) +  sin(2*pi*[1:1000]*2000/Fs) + sin(2*pi*[1:1000]*13000/Fs)  + sin(2*pi*[1:1000]*18000/Fs);

sig = 20*log10(abs(fftshift(fft(x,4096))));
xf = filter(hc,1,x);

figure
subplot(211)
plot(x)
title('Sinusoid with frequency components 2000, 5000, 13000, and 18000 Hz')


subplot(212)
plot(xf)
title('Filtered Signal')
xlabel('time')
ylabel('amplitude')


x= (x/sum(x))/20;
sig = 20*log10(abs(fftshift(fft(x,4096))));
xf = filter(hc,1,x);
