clear; 

%%FLOYD GUITAR
[y, Fs] = audioread('Floyd.m4a');
trgnr = length(y)/Fs; % record time in seconds
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Comfortable Numb');
%p8 = audioplayer(y(1:length(y)/5),Fs); playblocking(p8);

%%

%rect = @(x, a, b) ones(1, numel(x)).* (a < abs(x)<b);



vec = y.';

L= trgnr;
n=length(y); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 

k=(1/L)*[0:n/2 -n/2:-1];ks=fftshift(k);
vec_ft = fft(vec);

filter = exp(-3e-6*(ks-300).^2);
%filtering out harmonics for 125
vec_filter = vec_ft.*fftshift(filter);
filter = 1-exp(-100*(ks-125).^2);
vec_filter = vec_filter.*fftshift(filter);
filter = 1-exp(-100*(ks-250).^2);
vec_filter = vec_filter.*fftshift(filter);
filter = 1-exp(-100*(ks-375).^2);

%filtering out harmonics for 110
vec_filter = vec_ft.*fftshift(filter);
filter = 1-exp(-100*(ks-110).^2);
vec_filter = vec_filter.*fftshift(filter);
filter = 1-exp(-100*(ks-220).^2);
vec_filter = vec_filter.*fftshift(filter);
filter = 1-exp(-100*(ks-330).^2);
vec_filter = vec_filter.*fftshift(filter);
filter = 1-exp(-100*(ks-440).^2);
vec_filter = vec_ft.*fftshift(filter);
y = ifft(vec_filter);

%%
a = 100;
tau = 0:.25:L/5;
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
figure(3)
pcolor(tau, ks, log(abs(Sgt_spec)+1));
shading interp
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (HZ)')
title('Floyd Guitar')
ylim([200,700])
% yline(220, 'w', '220: A')
% yline(277, 'w', '277.183: C#')
% yline(249, 'w', '249.228: G#')
% yline(554, 'w', '554.36 C#')
% yline(698, 'w', '698.456: F')

%%
figure(4)
plot(tau, notes, 'o', 'MarkerFaceColor', 'b');
title('music score')
ylabel('frequency hz')
xlabel('time')
