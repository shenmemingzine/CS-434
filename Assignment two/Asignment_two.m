clc; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Train_data = load('usps-4-9-train.csv'); % load training data
Test_data = load('usps-4-9-test.csv'); % load testing data

[Train_samples, Train_features] = size(Train_data); % size of training data
[Test_samples, Test_features] = size(Test_data); % size of testing data

% Obtain all features of training data
X_train = [ones(Train_samples, 1) Train_data(:, 1:256)];
Y_train = Train_data(:, 257);

% Obtain all features of testing data
X_test = [ones(Test_samples, 1) Test_data(:, 1:256)]; 
Y_test = Test_data(:, 257); 

%% Problem One
learning_rate = (1:0.1:15)*1e-8;
num_lr = length(learning_rate); % obtain the number of learning rate 

% obtain the loss with different learning rate
loss = zeros(length(learning_rate), 1); 

% initial optimal weight
initial_w = zeros(size(X_train, 2), 1);

% initialize the first loss
pre_loss = 0;

for r = 1:num_lr
    w = Batgrad(X_train, Y_train, 100, initial_w, learning_rate(r), 0);
    loss(r) = LossFunc(X_train, Y_train, w);
    if abs(loss(r) - pre_loss) < 1e-3 
        break
    end
end

% obtain the minimun loss with the best learning rate
min_loss = min(loss); 
best_rate = learning_rate(loss == min_loss);

fprintf(['The minimum loss is %d', num2str(min_loss), '%d\n'])
fprintf(' ')
fprintf(['The best learning rate is %d', num2str(best_rate, '%d\n')])

figure
plot(learning_rate, loss, 'o-');
title('Batch Gradient Decent with Different Learning Rate')
xlabel('Learning Rate')
ylabel('Loss')
hold off

%% Problem Two
Iterations = [100 200 300 400 500];
num_ite = length(Iterations);

% store training accuracy and testing accuracy
train_accuracy = zeros(num_ite, 1);
test_accuracy = train_accuracy;

for i = 1:num_ite
    train_w = Batgrad(X_train, Y_train, Iterations(i),...
        initial_w, best_rate, 0);
    
    % Compute training accuracy
    train_pre = logclassify(sigmoid(X_train*train_w)); % Prediction on training data
    train_error = sum(abs(Y_train - train_pre));
    train_accuracy(i) = 1 - train_error/Train_samples;

    % Compute testing accuracy
    test_pre = logclassify(sigmoid(X_test*train_w)); % Prediction on testing data
    test_error = sum(abs(Y_test - test_pre));
    test_accuracy(i) = 1 - test_error/Test_samples;
end

figure
plot(Iterations, train_accuracy, 'ro-', Iterations, test_accuracy, 'bo-')
xlabel('Iterations')
ylabel('Accuracy')
legend('Training Accuracy', 'Testing Accuracy')
hold off

% When we increace the number of iterations, the accuracy of training data
% increase; however, the testing accuracy decrease.

%% Problem Three
%
% If we differentiate the loss function respect to w, we have
% $$\sum_{i=1}^m l(g(w^Tx^i,y^i))x^i+\lambda*w$$
%

%% Problem Four
Lambda = 10.^(-5:1:5);
Num_lam = length(Lambda);

% store training accuracy and testing accuracy with regularization term
re_train_accuracy = zeros(Num_lam, 1);
re_test_accuracy = re_train_accuracy;

for k = 1:Num_lam
    re_train_w = Batgrad(X_train, Y_train, 200, initial_w,...
        best_rate, Lambda(k));
    
    % Compute training accuracy
    re_train_pre = logclassify(sigmoid(X_train*re_train_w)); % Prediction on training data
    re_train_error = sum(abs(Y_train - re_train_pre));
    re_train_accuracy(k) = 1 - re_train_error/Train_samples;

    % Compute testing accuracy
    re_test_pre = logclassify(sigmoid(X_test*re_train_w)); % Prediction on testing data
    re_test_error = sum(abs(Y_test - re_test_pre));
    re_test_accuracy(k) = 1 - re_test_error/Test_samples;
end

figure
plot(Lambda, re_train_accuracy, 'ro-', Lambda, re_test_accuracy, 'bo-')
xlabel('Lambda')
ylabel('Accuracy')
legend('Training Accuracy', 'Testing Accuracy')
hold off
