clear; 

%% FLOYD UNFILTERED
[y, Fs] = audioread('Floyd.m4a');
trgnr = length(y)/Fs; % record time in seconds
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Comfortable Numb');
%p8 = audioplayer(y(1:length(y)/5),Fs); playblocking(p8);

L= trgnr;
n=length(y); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 

k=(1/L)*[0:n/2 -n/2:-1];ks=fftshift(k);
%%
a = 100;
tau = 0:.2:L/2;
notes = zeros(1, length(tau));
for j = 1:length(tau)
    g = exp(-a*(t-tau(j)).^2);
    Sg = g.*y';
    Sgt = fft(Sg);
    Sgt_spec(:,j) = fftshift(abs(Sgt));
    
end 

%%

figure(2)
pcolor(tau, ks, log(abs(Sgt_spec)+1));
shading interp
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (HZ)')
title('FloydUnfiltered')
ylim([0,1000])

