function [f1Scores,meanF1] = compute_f1(groudtruth,predlabel)
%% º∆À„f1-Score ∫Õ meanF1
groudtruth = double(groudtruth);
predlabel = double(predlabel);

cm = confusionmat(groudtruth,predlabel);
% cm = cm(1:2,1:2);
precision = diag(cm)./sum(cm,2);

recall = diag(cm)./sum(cm,1)';

f1Scores = 2*(precision.*recall)./(precision+recall);

for i = 1:length(f1Scores)
    if isnan(f1Scores(i))
        f1Scores(i)=0;
    end
end

meanF1 = mean(f1Scores);