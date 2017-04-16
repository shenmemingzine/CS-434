function w = Batgrad(X, Y, N, w0, r)
% Apply Batch gradient decent
%
% In N interation, if the lost is less than the setting threshold
% stop computing the optimal weight;
% if the lost is still greater than the setting threshold,
% set the last w as optimal weight.

% initialize optimal weight vector
[samples, features] = size(X);
w = w0; %obtain initial w

wNorm = zeros(N, 1); % store the norm of weight in each interation

% lost differences
dif_loss = 0;

for iter = 1:N
    delta = zeros(features, 1); % initialize error
    
    for n = 1:samples
        h = sigmoid(X(n, :)*w); % hypothese function  
        delta = delta + (Y(n) - h)*X(n, :)';
    end
    w = w + r*delta; % update optimal weight vector
    wNorm(iter) = norm(w, 2);
    loss = LossFunc(X, Y, w); % apply the new w to compute the lost
        
    if abs(loss - dif_loss)/loss <= 0.0001 % threshold 
        break;
    end
    dif_loss = loss;    
end

figure
plot(1:N, wNorm, '-')
ylabel('Weight Norm');
xlabel('Iteration')
title('Batch Gradient Decent')
hold off

end