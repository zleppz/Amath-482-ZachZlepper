clear all; close all; clc;

%% Loading the videos, find sv spectrum 
ski = VideoReader('ski_drop_low.mp4');
video = read(ski);
frames = ski.NumFrames;
[n m h1 h2] = size(video);
dt = 1/ski.Framerate;
t = 0:dt:ski.Duration;
%%

for j = 1:frames(1)
    ski_reshape = double(reshape(video(:,:,1,j), n*m, 1));
    v_ski(:,j) = ski_reshape;
end


%%

%Reduce data size
rank = 10;

X1 = v_ski(:,1:end-1);
X2 = v_ski(:,2:end);

[u, s, v] = svd(X1,'econ');
U = u(:,1:rank); 
Sigma = s(1:rank, 1:rank);
V = v(:, 1:rank);

tilde = U'*X2*V*diag(1./diag(Sigma));
[eV, D] = eig(tilde); % compute eigenvalues + eigenvectors
mu = diag(D); % extract eigenvalues
omega = log(mu)/dt;
Phi = U*eV;

%%
figure()
hold on 
plot([-2 1], [0 0], 'k')
plot ([0 0], [-1.5 1.5], 'k')
plot(real(omega), imag(omega),'o')
title('Eigenvalues Plot')
%%
thresh = .001;
bg = find(abs(omega) < thresh);
omega_bg = omega(bg);
phi_bg = Phi(:,bg);
%%

y0 = phi_bg\X1(:,1);

mn1 = size(X1, 2);

t = (0:mn1-1)*dt;
u_modes = zeros(1,mn1);

for iter = 1:mn1
    u_modes(:,iter) = y0.*exp(omega_bg*t(iter));
end
u_dmd = phi_bg*u_modes;

%%
Xsparse = X1 - abs(u_dmd);

R = Xsparse.*(Xsparse<0);

X_bg = R + abs(u_dmd);
X_fg = Xsparse - R;

X_reconstructed =  X_fg + X_bg;

filterXS = uint8((Xsparse.*(Xsparse>500) - R)).* 5-uint8(50);
%%
figure(2)
    imshow(uint8(reshape(X_reconstructed(:,25), [], 960)))
    drawnow
    title("Full Video");
figure(3)
    imshow(uint8(reshape(X_bg(:,25), [], 960)))
    drawnow
    title("Background (R added)");
figure(4)
    imshow(uint8(reshape(X_fg(:,25), [], 960)))
    drawnow
    title("Foreground (R Subtracted)");
figure(5)
    fig = reshape(filterXS(:,25), [], 960);
    imshow(fig)
    drawnow
    title("Foreground with Filter");
figure(6)
    imshow(uint8(reshape(u_dmd(:,25), [], 960)))
    drawnow
    title("Low Rank (without R)");
    %%
figure(7)
    imshow(uint8(reshape(Xsparse(:,50), [], 960)))
    drawnow
    title("Sparse");
    
    
%%
figure(2)
for j = 1:100
    imshow(uint8(reshape(X_reconstructed(:,j), [], 960)))
    drawnow
end
%%
figure(3)
for j = 1:100
    imshow(uint8(reshape(X_bg(:,j), [], 960)))
    drawnow
end
%%
figure(4)
for j = 1:25
    imshow(uint8(reshape(X_fg(:,j), [], 960)))
    drawnow
end
%%
figure(2)
for j = 1:100
    fig = reshape(filterXS(:,j), [], 960);
    imshow(fig)
    drawnow
end
%%
figure(2)
for j = 1:10
    imshow(uint8(reshape(u_dmd(:,j), [], 960)))
    drawnow
end
%%
figure(2)
for j = 1:100
    imshow(uint8(reshape(Xsparse(:,j), [], 960)));
    drawnow
end