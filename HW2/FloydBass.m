clear; 

%% FLOYD BASS
[y, Fs] = audioread('Floyd.m4a');
trgnr = length(y)/Fs; % record time in seconds
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Comfortable Numb');
%p8 = audioplayer(y(1:length(y)/5),Fs); playblocking(p8);

%%

%rect = @(x, a, b) ones(1, numel(x)).*(a < abs(x)<b);


vec = y.';

L= trgnr;
n=length(y); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 

k=(1/L)*[0:n/2 -n/2:-1];ks=fftshift(k);

%filterBelow = rect(ks, 0, 250);
filter = exp(-3e-6*(ks).^2);
vec_ft = fft(vec);
vec_filter = vec_ft.*fftshift(filter);
y = ifft(vec_filter);

%%
a = 200;
tau = 0:.05:L/8;
notes = zeros(1, length(tau));
for j = 1:length(tau)
    g = exp(-a*(t-tau(j)).^2);
    Sg = g.*y;
    Sgt = fft(Sg);
    [M, I] = max(Sgt);
    notes(1, j) = abs(k(I));
    Sgt_spec(:,j) = fftshift(abs(Sgt));
end 

%%

figure(4)
pcolor(tau, ks, Sgt_spec);
shading interp
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (HZ)')
title('FloydBass 2nd ')
ylim([0,250])
%%

plot(tau, notes, 'o', 'MarkerFaceColor', 'b');
title('music score')
ylabel('frequency hz')
xlabel('time')
yline(110, 'b', '110: A')
yline(125, 'b', '125: b')





