clear;
clc;

%% modification
% source: CASME2  % instead
% dist: SMIC_HS   % instead
% feature: LBPTOP % line23: feature_flag

%% load data
load ../../data/3class/CrossCorpus_LBPSIP_R3_CASME2_112by112
load ../../data/3class/CrossCorpus_LBPSIP_R3_SMIC_HS_112by112

database_source_features = CASME2_micro_feature;%(:,177*21+1:177*85);
database_source_labels = CASME2_micro_label;
database_target_features = SMIC_HS_micro_feature;%(:,177*21+1:177*85);
database_target_labels = SMIC_HS_micro_label;

%% hyper-parameter
%num
num = 85;

% _feature_LBPSIP
% _feature_LBPSIP
% _feature_LBPTOP
% _feature_LPQTOP

%feature_flag
feature_flag = 'LBPSIP';
if strcmp(feature_flag,'LBPSIP')
    fdim = 1700/num;
end
if strcmp(feature_flag,'LBPTOP')
    fdim = 15045/num;
end
if strcmp(feature_flag,'LPQTOP')
    fdim = 65280/num;
end

% channel_num and lambda
[start_channel_num, end_channel_num, gap_channel_num] = get_channel_data();
[start_lambda, end_lambda, gap_lambda] = get_lambda_data();


%% program
Y_s = database_source_features; %source
Y_s = Y_s';
X_s_label = database_source_labels;

Y_te = database_target_features;%target
Y_te = Y_te';
X_te_label = database_target_labels;

Ls = zeros(3,length(X_s_label));
nbclass = unique(X_s_label);
for i = 1:length(nbclass)
    % label format : number ->one hot
    labels = (X_s_label' == nbclass(i));
    labels = double(labels);
    Ls(i,:) = labels;
end

num= 85;
cnt = 0;
for channel_num = start_channel_num:gap_channel_num:end_channel_num
    for lambda = start_lambda:gap_lambda:end_lambda
        cnt = cnt + 1
        disp(['channel_num = ',num2str(channel_num)]);
        C = TransferISLSR(Ls,Y_s,Y_te,num,fdim,lambda,channel_num);
        pred = C'*Y_te;
        [~,te_label] = max(pred);
        war_acc = WAR(X_te_label,te_label);
        [~,meanF1] = compute_f1(X_te_label,te_label);
        Acc(cnt,1) = channel_num;
        Acc(cnt,2) = lambda;
        Acc(cnt,3) = war_acc;
        Acc(cnt,4) = meanF1;
    end
end

[max_war_acc_value, max_war_acc_index] = max(Acc(:,3));
[max_meanF1_value, max_meanF1_index] = max(Acc(:,4));

Acc_max_war = Acc(max_war_acc_index,:);
Acc_max_meanF1 = Acc(max_meanF1_index, :);

save ../../Acc/3class/Acc_record_3class_CASME2_SMIC_HS_feature_LBPSIP Acc Acc_max_war Acc_max_meanF1; 




