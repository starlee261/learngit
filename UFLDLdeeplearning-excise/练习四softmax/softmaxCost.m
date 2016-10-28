function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize); %10*(28*28)

numCases = size(data, 2);

groundTruth = full(sparse(labels, 1:numCases, 1));
cost = 0;

thetagrad = zeros(numClasses, inputSize); %10*(28*28)

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.


M = bsxfun(@minus,theta*data,max(theta*data, [], 1));% max(theta*data, [], 1)返回theta*data每一列的最大值，返回值为行向量
                                                     % theta*data的每个元素值都减去其对应列的最大值，即：把每一列的最大值都置为0了
                                                     % 这一步的目的是防止下一步计算指数函数时溢出
M = exp(M);
p = bsxfun(@rdivide, M, sum(M));
cost = -1/numCases * groundTruth(:)' * log(p(:)) + lambda/2 * sum(theta(:) .^ 2);
thetagrad = -1/numCases * (groundTruth - p) * data' + lambda * theta; 










% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = [thetagrad(:)];
end

