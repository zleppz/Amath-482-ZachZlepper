clear all; clc; close all;
%%
load('cam1_2.mat'); load('cam2_2.mat'); load('cam3_2.mat')

%%
numFrames1 = size(vidFrames1_2,4);
numFrames2 = size(vidFrames2_2,4);
numFrames3 = size(vidFrames3_2,4);


%%

numFrames1 = size(vidFrames1_2, 4);
means1 = [];
%Play video
width = 50;
filter = zeros(480,640);
filter(300-2.6*width:1:300+2.6*width, 350-width:1:350+2*width) = 1;

for j = 1:numFrames1
    double1 = double(rgb2gray(vidFrames1_2(:,:,:,j)));
    double1 = double1 .* filter; 
    light = double1 > 250;
    placement1 = find(light);
    [Y1, X1] = ind2sub(size(light),placement1);
    means1 = [means1; mean(Y1), mean(X1)];
end 

numFrames2 = size(vidFrames2_2, 4);
means2 = [];

width = 50;
filter = zeros(480,640);
filter(250-4*width:1:250+4.5*width, 290-2.5*width:1:290+2.7*width) = 1;

for j = 1:numFrames2
    double2 = double(rgb2gray(vidFrames2_2(:,:,:,j)));
    double2 = double2 .* filter;
    light = double2 > 250;
    placement2 = find(light);
    [Y2, X2] = ind2sub(size(light),placement2);
    means2 = [means2; mean(Y2), mean(X2)];
end 


width = 50;
filter = zeros(480,640);
filter(250-1*width:1:250+2.6*width, 360-2.5*width:1:360+2.7*width) = 1;
numFrames3 = size(vidFrames3_2, 4);
means3 = [];

for j = 1:numFrames3
    double3 = double(rgb2gray(vidFrames3_2(:,:,:,j)));
    double3 = double3 .* filter;
    light = double3 > 250;
    placement3 = find(light);
    [Y3, X3] = ind2sub(size(light),placement3);
    means3 = [means3; mean(Y3), mean(X3)];
end 
%%
means1 = rmmissing(means1, 1);
means2 = rmmissing(means2, 1);
means3 = rmmissing(means3, 1);
%%
data2 = means2(1:length(means3), :);
data3 = means3;
data1 = means1(1:length(means3), :);
%%
bigMatrix = [data1';data2';data3'];
[m,n]=size(bigMatrix); % compute data size
mn=mean(bigMatrix,2); % compute mean for each row
sub = repmat(mn,1,n);
bigMatrixmeanless = bigMatrix- sub; % subtract mean

[u,s,v]=svd(bigMatrixmeanless'/sqrt(n-1)); % perform the SVD
lambda=diag(s).^2; % produce diagonal variances

Y= bigMatrixmeanless' * v;% produce the principal components projection
sig=diag(s);


%%
figure()
plot(1:6, lambda/sum(lambda), 'mo', 'Linewidth', 2);
title("Case 2: Energy of each Diagonal Variance");
xlabel("Diagonal Variances"); ylabel("Energy Captured");
figure()
plot(1:304, Y(:,1),1:304, Y(:,2),'r','Linewidth', 2)
ylabel("Displacement (pixels)"); xlabel("Time (frames)"); 
title("Case 2: Displacement across principal component directions");
legend("PC1", "PC2")

