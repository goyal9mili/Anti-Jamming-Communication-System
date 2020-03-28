[y, fs] = audioread("Music.wav");
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;

y_noise = awgn(y(:, 1), 20);        % addition of white noise
y_fft = fft(y(:, 1));
freq = 1./t;


% upsampling
% y = upsample(y, 5);
% fs2 = 5*fs;


% this gives us the plot for the original sound signal
% figure(1)
% plot(t, y)


figure(2)
plot(t, y_noise)

% reading another audio file
[y5, fs5] = audioread("no-thats-not-gonna-do-it.wav");  
y5 = y5(:, 1);
y5 = upsample(y5, 5);
y_mod = fmmod(y5, 1e4, fs2, 75000);
y_mod = y_mod(:, 1);
y_mod = [y_mod;y_mod;y_mod; y_mod; y_mod; y_mod; y_mod; y_mod; y_mod];
y_mod = [y_mod; y_mod];
% Method to remove white noise from the signal
% Wp = 1000/(fs/2);
% Ws = 1010/(fs/2);
% Rp =   20;                                               % Passband Ripple (dB)
% Rs = 30;                                               % Stopband Ripple (dB)
% [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
% [z,p,k] = cheby2(n,Rs,Ws,'low');                        % Filter Design
% [soslp,glp] = zp2sos(z,p,k);                            % Convert To Second-Order-Section For Stability
% filtered_sound = filtfilt(soslp, glp, y_noise);
% soundsc(filtered_sound, fs)

% Use of wavelet threshhold for noise removal 
y_filtered = wdenoise(y_noise, 4);      % posterior median threshold rule.

figure(3)
plot(t,y_filtered)

N = 10;     % This is the number of segments of the signal
carrier_array = [];
f1 = 1e4;
f2 = 1.5e4;
f3 = 2e4;
f4 = 15000;
f5 = 20000;
f6 = 2e4;
f7 = 2800000;
f8 = 3100000;
f9 = 3400000;
f10 = 3700000;
f11 = 4000000;
f12 = 4300000;
for n = 1:N
    c = randi(3, 1);
    switch(c)
        case(1)
            carrier_array = [carrier_array f1];
        case(2)
            carrier_array = [carrier_array f2];
        case(3)
            carrier_array = [carrier_array f3];
        case(4)
            carrier_array = [carrier_array f4];
        case(5)        
            carrier_array = [carrier_array f5];
        case(6)
            carrier_array = [carrier_array f6];
        case(7)
            carrier_array = [carrier_array f7];
        case(8)
            carrier_array = [carrier_array f8];
        case(9)
            carrier_array = [carrier_array f9];
        case(10)
            carrier_array = [carrier_array f10];
        case(11)
            carrier_array = [carrier_array f11];
        case(12)
            carrier_array = [carrier_array f12];
    end
end

% dividing the sound signal into N segments:
y2 = length(y)/N;
y2 = ceil(y2);
t1 = 1;
t2 = ceil(y2);
count = 1;
modulated_signal = [];
y = y(:,1);
% y = y+y_mod;
y_t = transpose(y);
% fs2 = 2.2*f12;

% this is to create the overlapping window
z = 50;

% modulation
while t1 < length(y)
    if count == 1
        y3 = y(t1:min(t2, length(y)));
    else
        y3 = y(t1-z:min(t2, length(y)));
    end
    modu = fmmod(y3,carrier_array(count),fs,5000);
    modulated_signal =  vertcat(modu, modulated_signal);
    t1 = t1+y2;
    t2 = t2+y2;
    count = count+1;
end

modulated_signal = modulated_signal ;%+ y_mod(1:4410000);
fft_modulated_capture = fft(modulated_signal);

 % demdulation
 td1 = 1;
 td2 = ceil(y2);
 countd = 1;
 demodulated_signal = [];
 while td1 < ceil(length(modulated_signal))
     
       if countd == 1
        y4 = modulated_signal(td1:min(td2, ceil(length(modulated_signal))));
       else  
        y4 = modulated_signal(td1:min(td2, ceil(length(modulated_signal))));
       end
     
     demodu = fmdemod(y4,carrier_array(countd),fs,5000);
     demodulated_signal = vertcat(demodu, demodulated_signal);
     td1 = td1+y2+z;
     td2 = td2+y2+z;
     countd = countd+1;
 end
 modulated_fft = fft(modulated_signal);
 demodulated_fft = fft(demodulated_signal);
 

 %  medfiltLoopVoltage = medfilt1(demodulated_signal,10);
 
% This is used to remove the spikes from the demodulated_signal
 
%  y_demod = fmdemod( demodulated_signal, 100000, 2.2*100000, 7500);
%  soundsc(medfiltLoopVoltage, fs);
%  rm_outliers = rmoutliers(demodulated_signal);

% hearing the received sound signal

 figure(4)
 
 t2 = 0:dt:(length(demodulated_signal)*dt)-dt;
 
 plot(t2, demodulated_signal);
 
%  demodulated_signal = downsample(demodulated_signal, 5);
 soundsc(demodulated_signal, fs);
 
 figure(5)
 plot(abs(modulated_fft));
 
 figure(6)
 demodulated_fft = fft(demodulated_signal);
 plot(abs(demodulated_fft));
 
 figure(7)
 plot(abs(fft_modulated_capture));
 
 figure(8)
 plot(modulated_signal);
 
 figure(9)
 plot(demodulated_signal);
