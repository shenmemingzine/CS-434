function [clust, infoMatrix] = SingleL(X)
% test example
% X = [1 1; 1.5 1.5; 5 5; 3 4; 4 4; 3 3.5];
% X = [1 2; 2.5 4.5; 2 2;4 1.5; 4 2.5];
% http://people.revoledu.com/kardi/tutorial/Clustering/Online-Hierarchical-Clustering.html

samples = size(X, 1);
clust = [];
c = samples; 
distance = pdist(X);
DistValue = squareform(distance);
sortDist = sort(distance);
DistMatrix = DistValue;
ite = 1;

infoMatrix = zeros(samples + 1, samples + 1);
infoMatrix(1, :) = 0:samples;
infoMatrix(2:end, 1) = 1:samples;
infoMatrix(2:end, 2:end) = DistMatrix;

while true
    minD = sortDist(ite);
    DistN = DistMatrix;
    DistN(triu(true(size(DistN)))) = NaN;
    [min_i, min_j] = find(DistN == minD,1);
    
    if size(min_i) ~= 0
        fprintf(['Min distance between ',num2str(min_i),' and ',...
            num2str(min_j), ' is ', num2str(minD),'\n'])
        
        c = c + 1;
        clust = [clust; {infoMatrix(1, min_i + 1),...
            infoMatrix(1, min_j + 1), minD}]; 
        infoMatrix(1, min_j + 1) = c;
        infoMatrix(min_j + 1, 1) = c;
        % Complete link
        % max_dist = max(DistM(:,min_i), DistM(:,min_j));
        min_dist = min(DistMatrix(:,min_i), DistMatrix(:,min_j));
        min_dist(min_j) = 0;
        DistMatrix(:,min_j) = min_dist;
        DistMatrix(min_j,:) = min_dist';
    end
    
    DistMatrix(min_i,:) = [];
    DistMatrix(:,min_i) = [];
    infoMatrix(min_i + 1,:) = [];
    infoMatrix(:,min_i + 1) = [];
    infoMatrix(2:end, 2:end) = DistMatrix;
    
    [m,n] = size(infoMatrix);
    if m == 2 && n == 2
        break;
    end
    display(infoMatrix)
    ite = ite + 1;
end

end