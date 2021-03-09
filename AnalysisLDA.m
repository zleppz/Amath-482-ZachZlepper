%%
clear all; clc; close all;
%%
[images, labels] = mnist_parse('train-images-idx3-ubyte', 'train-labels-idx1-ubyte');
%% 
%Two Digit Test Set
[imagesTest, labelsTest] = mnist_parse('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte');
conversionTest = zeros(784, 10000);
for c = 1:10000
    conversionTest(:, c) = im2double(reshape(imagesTest(:,:,c),784,1));
end

LDAtest = conversionTest;
conversion = zeros(784, 60000);
for c = 1:60000
    conversion(:, c) = im2double(reshape(images(:,:,c),784,1));
end 

LDAtrain = conversion;
%standardizing conversion
[m,n]=size(conversion); % compute data size
mn=mean(conversion,2); % compute mean for each row
conversion = conversion-repmat(mn,1,n);% subtract mean

%standardizing converiontest
%standardizing conversion
[m,n]=size(conversionTest); % compute data size
mn=mean(conversionTest,2); % compute mean for each row
conversionTest = conversionTest-repmat(mn,1,n);% subtract mean

%%
[U, S, V] = svd(conversion, 'econ');
lambda = diag(S).^2;
figure();
plot(1:784, lambda/sum(lambda)*100,'ko');
title('Singular Values conversion');
xlabel('ith Singular Value')
ylabel('Percent of Energy')
%%
total = 0;
all = sum(lambda);
for c = 1:154
    total = lambda(c)/all + total;
end 
%154 features gives 95% of energy


projection_training = U(:, 1:154)'*conversion;
projection_test = U(:, 1:154)'* conversionTest;



%%

Proj = S*V';

figure
scatter3(Proj(1, labels ==7), Proj(2, labels ==7),Proj(3, labels ==7), 'b', 'filled')
hold on 
scatter3(Proj(1, labels ==3), Proj(2, labels ==3),Proj(3, labels ==3), 'r', 'filled')
scatter3(Proj(1, labels ==5), Proj(2, labels ==5),Proj(3, labels ==5), 'k', 'filled')
legend('3', '5', '7')
title('Projection onto V modes')
xlabel('Mode 1')
ylabel('Mode 2')
zlabel('Mode 3')



%%

feature = 154;
dog = LDAtrain(:, labels == 0);
cat = LDAtrain(:, labels == 1);

[UD,SD,VD,threshold,w,sortdog,sortcat] = dc_trainer(dog,cat,feature);


%Two Digit Success Rates
TestNum = size(LDAtest(:, labelsTest == 0 | labelsTest == 1),2); % wavelet transform
TestMat = UD'*LDAtest(:, labelsTest == 0 | labelsTest == 1); % PCA projection
TwoDigitTestLables  = labelsTest(labelsTest == 0 | labelsTest == 1);
TwoDigitTestLables(TwoDigitTestLables == 0) = 0;
TwoDigitTestLables(TwoDigitTestLables == 1) = 1;

pval = w'*TestMat;
ResVec = (pval > threshold);
err = abs(ResVec - TwoDigitTestLables');
err = err > 0; 
errNum = sum(err);
LDA2rrror = 1 - errNum/TestNum;
%%
%Three Digit Classification

Sample = projection_test(:, labelsTest == 1 | labelsTest == 2| labelsTest == 3);
X = projection_training(:, labels == 1 | labels == 2 | labels == 3);
Y = labels(labels == 1 | labels == 2 | labels == 3);
Mdl = fitcdiscr(X',Y','discrimType', 'diagLinear');
cMdl = crossval(Mdl);
classErrorLDA3 = kfoldLoss(cMdl);
LDA3Error = 1-classErrorLDA3;



%% TREE two
X = projection_training(:, labels == 1 | labels == 0 );
Y = labels(labels == 1 | labels == 0 );
tree = fitctree(X', Y', 'MaxNumSPlits', 200, 'CrossVal', 'on');
classErrorTree = kfoldLoss(tree);
TreeError = 1- classErrorTree;

%% SVM Two
TestNum = size(projection_training(:, labels == 1 | labels == 0 ),2);
X = projection_training(1:154, labels == 1 | labels == 0 );
Y = labels(labels == 1 | labels == 0 );
Mdl = fitcecoc(X',Y');
label_approx = predict(Mdl, projection_test(:, labelsTest == 1 | labelsTest == 0)');
hidden_labels = labelsTest(labelsTest == 1 | labelsTest == 0);

err = abs(label_approx - hidden_labels);
err = err > 0; 
errNum = sum(err);
sucRate2SVM = 1 - errNum/TestNum;

%%
figure();
confusionchart(hidden_labels,label_approx)
%% SVM TEN

TestNum = size(projection_training(:, :),2);
X = projection_training(:, :)./ max(projection_training(:, :));
Y = labels(:);
Mdl = fitcecoc(X',Y');
scaled_test = projection_test(:,:)./max(projection_test(:, :));
label_approx = predict(Mdl, scaled_test');
hidden_labels = labelsTest(:);

err = abs(label_approx - hidden_labels);
err = err > 0; 
errNum = sum(err);
sucRate10SVM = 1 - errNum/TestNum;
%%
figure();
confusionchart(hidden_labels,label_approx)

%% Tree 10
X = projection_training(:, : );
Y = labels(:);
tree = fitctree(X', Y', 'MaxNumSPlits', 200, 'CrossVal', 'on');
classErrorTree = kfoldLoss(tree);
TreeError10 = 1- classErrorTree;

