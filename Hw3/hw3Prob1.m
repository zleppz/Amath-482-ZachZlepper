clear all; clc; close all;
%%
load('cam1_1.mat'); load('cam2_1.mat'); load('cam3_1.mat')

%%
numFrames1 = size(vidFrames1_1,4);
numFrames2 = size(vidFrames2_1,4);
numFrames3 = size(vidFrames3_1,4);

%%

numFrames1 = size(vidFrames1_1, 4);
means1 = [];

for j = 1:numFrames1
    double1 = double(rgb2gray(vidFrames1_1(:,:,:,j)));
    light = double1 > 240;
    placement1 = find(light);
    [Y1, X1] = ind2sub(size(light),placement1);
    means1 = [means1; mean(Y1), mean(X1)];
end 

numFrames2 = size(vidFrames2_1, 4);
means2 = [];

for j = 1:numFrames2
    double2 = double(rgb2gray(vidFrames2_1(:,:,:,j)));
    light = double2 > 240;
    placement2 = find(light);
    [Y2, X2] = ind2sub(size(light),placement2);
    means2 = [means2; mean(Y2), mean(X2)];
end 


numFrames3 = size(vidFrames3_1, 4);
means3 = [];

for j = 1:numFrames3
    double3 = double(rgb2gray(vidFrames3_1(:,:,:,j)));
    light = double3 > 240;
    placement3 = find(light);
    [Y3, X3] = ind2sub(size(light),placement3);
    means3 = [means3; mean(Y3), mean(X3)];
end 

data2 = means2(1:length(means1), :);
data3 = means3(1:length(means1), :);
data1 = means1;

%%
bigMatrix = [data1';data2';data3'];

[m,n]=size(bigMatrix); % compute data size
mn=mean(bigMatrix,2); % compute mean for each row
bigMatrixmeanless = bigMatrix-repmat(mn,1,n); % subtract mean

[u,s,v]=svd(bigMatrixmeanless'/sqrt(n-1), 'econ'); % perform the SVD
lambda=diag(s).^2; % produce diagonal variances

Y= bigMatrixmeanless' * v; % produce the principal components projection

sig=diag(s);


%%
figure()
plot(1:6, lambda/sum(lambda), 'mo', 'Linewidth', 2);
title("Case 1: Energy of each Diagonal Variance");
xlabel("Diagonal Variances"); ylabel("Energy Captured");
figure()
plot(1:226, Y(:,1),1:226, Y(:,2),'r','Linewidth', 2)
ylabel("Displacement (pixels)"); xlabel("Time (frames)"); 
title("Case 1: Displacement across principal component directions");
legend("PC1", "PC2")

