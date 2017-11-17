clear all
clc
load chirp
word_length = 24;
fraction_length = 23;
fir_ord = 10;
passband = 0.48;
window_len = fir_ord + 1;
sidelobe_attenuation = 30; %decibels
%[y,Fs] = audioread('speech_dft.wav');
t = (0:length(y)-1)/Fs;

blo = fir1(fir_ord, passband,chebwin(window_len,sidelobe_attenuation));
figure(1)
plot(blo)
outlo = filter(blo,1,y);

wvtool(blo)

figure(2)
subplot(2,1,1)
plot(t,y)
title('Original Signal')
ys = ylim;

subplot(2,1,2)
plot(t,outlo)
title('Lowpass Filtered Signal')
xlabel('Time (s)')
ylim(ys)

struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [word_length fraction_length];
q = quantizer(struct);

%koeficijenti filtra
fileIDb = fopen('coef.txt','w');
for i=1:fir_ord+1
    fprintf(fileIDb,num2bin(q,blo(i)));
    fprintf(fileIDb,'\n');
end
fclose(fileIDb);

fileIDb = fopen('input.txt','w');
for i=1:length(y)
    fprintf(fileIDb,num2bin(q,y(i)));
    fprintf(fileIDb,'\n');
end
fclose(fileIDb);

fileIDb = fopen('expected.txt','w');
for i=1:length(outlo)
    fprintf(fileIDb,num2bin(q,outlo(i)));
    fprintf(fileIDb,'\n');
end
fclose(fileIDb);
