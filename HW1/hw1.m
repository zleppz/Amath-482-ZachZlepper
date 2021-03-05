clear all; close all; 
clc

load subdata.mat % Imports the data as the 262144x49 (space by time) matrix called subdata
L = 10; % spatial domain
n = 64; % Fourier modes
x2 = linspace(-L,L,n+1); 
x = x2(1:n); 
y =x; 
z = x;
k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1];
ks = fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

%Pt1 - averaging 

Ufave= zeros(n, n, n);
for j=1:49
    Un(:,:,:)=reshape(subdata(:,j),n,n,n);
    Uf = fftn(Un); %Frequency space 
    Ufave = Ufave + Uf;% add up all Frequencies
 end 
 Ufave = abs(fftshift(Ufave)/49); % Averages frequency space 
 

 [maximum_val, I] = max(Ufave(:)); %Finds the maximum frequency in Frequency space
 [xI, yI, zI] = ind2sub(size(Ufave),I); %Locates the maximum Frequency placement
 x0 = Kx(xI,yI,zI);
 y0 = Ky(xI,yI,zI);
 z0 = Kz(xI,yI,zI);
 
 
 filter = exp(-((Kx - x0).^2 + (Ky - y0).^2 + (Kz - z0).^2)); % Builds 3-D filter around Location of largest frequency
 coord = zeros(49 ,3);
 
 for j = 1:49
     Un(:,:,:)=reshape(subdata(:,j),n,n,n);
     Uf = fftn(Un);
     Uf = fftshift(Uf);
     Uf_filtered =  filter.* Uf; %Filters data in frequency space 
     Unif = ifftn(Uf_filtered);
     [maximum_val, I] = max(abs(Unif(:))); %Finds locaiton of the largest signal
     [xI, yI, zI] = ind2sub(size(Unif),I);
     coord(j,1) = X(xI,yI,zI);
     coord(j,2) = Y(xI,yI,zI);
     coord(j,3) = Z(xI,yI,zI);
 end
 
plot3(coord(:,1),coord(:,2),coord(:,3),'o','Linewidth',2);
grid on
title('Path of Sub Over Time')
xlabel('x');
ylabel('y');
zlabel('z');
axis([-20 20 -20 20 -20 20])
hold on
plot3(coord(end,1),coord(end,2),coord(end,3),'ro','MarkerFaceColor','r','Linewidth',2);

final = [coord(end,1),coord(end,2),coord(end,3)];

 
 
  
