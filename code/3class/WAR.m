function [accuracy,c] = WAR(gtruth,pLbl)
%% WAR£ºthe sum of correctly classified divided by total number of test samples.
%
% This fucntion is going to calculate weighted average recall.  WAR is
% equal to the sum of correctly classified divided by total number of test 
% samples. This function will work for n % number of classes.
% 
% accuracy = WAR(gtruth,pLbl);
% 
% accuracy = WAR
%
% gtruth = true labels
% pLbl = predicted labels
% 
% 
% Written by Ali Hassan (ah07r@ecs.soton.ac.uk)
% Date: 20 Dec 2009

gtruth = double(gtruth);
pLbl = double(pLbl);

c = confusionmat(gtruth, pLbl);

accuracy = sum(diag(c))/sum(sum(c));

