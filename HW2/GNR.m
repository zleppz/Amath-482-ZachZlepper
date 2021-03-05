clear; 

%%GNR GUITAR
figure(1)
[y, Fs] = audioread('GNR.m4a');
trgnr = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Sweet Child');
% p8 = audioplayer(y,Fs); playblocking(p8);

%%
% rect = @(x, a) ones(1, numel(x)).*(abs(x)<a/2);

L= trgnr;
n=length(y); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(1/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

% vec = y';

% filter = rect(ks, 2000);
% vec_ft = fft(vec);
% vec_filter = vec_ft.*fftshift(filter);
% y = ifft(vec_filter);
% p8 = audioplayer(y,Fs); playblocking(p8);
%%
a = 20;
tau = 0:.05:L;
beta = 1;
notes = zeros(1, length(a));
for j = 1:length(tau)
    g = exp(-a*(t-tau(j)).^2);
    Sg = g.*y';
    Sgt = fft(Sg);
    Sgt_spec(:,j) = fftshift(abs(Sgt));
    
end 

%%

figure(1)
pcolor(tau, ks, Sgt_spec);
shading interp
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (HZ)')
title('GNR')
ylim([0 1000]);
