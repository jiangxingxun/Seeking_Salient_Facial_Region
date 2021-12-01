%% modification
% source: CASME2  % instead
% dist: SMIC_HS   % instead
% feature: LBPTOP % line23: feature_flag

%% load data
feature_parameter = get_feature_parameter(feature_string);

load (['../../data/',class_string,'/CrossCorpus_',feature_string,'_',feature_parameter,'_',data_source_string,'_112by112']);
load (['../../data/',class_string,'/CrossCorpus_',feature_string,'_',feature_parameter,'_',data_dist_string,'_112by112']);

database_source_features = eval([data_source_string,'_micro_feature']);%(:,177*21+1:177*85);
database_source_labels = eval([data_source_string,'_micro_label']);
database_target_features = eval([data_dist_string,'_micro_feature']);%(:,177*21+1:177*85);
database_target_labels = eval([data_dist_string,'_micro_label']);

%% hyper-parameter

%feature_flag
fdim = get_fdim(feature_string, num);

% channel_num and lambda
[start_channel_num, end_channel_num, gap_channel_num] = get_channel_data();
[start_lambda, end_lambda, gap_lambda] = get_lambda_data();


%% program

% train/test data/label
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

% main program

cnt = 0;
for channel_num = start_channel_num:gap_channel_num:end_channel_num
    for lambda = start_lambda:gap_lambda:end_lambda
        
        cnt = cnt + 1;
        channel_circle = get_circle(start_channel_num, end_channel_num, gap_channel_num);
        lambda_circle = get_circle(start_lambda, end_lambda, gap_lambda);
        total_circle = channel_circle * lambda_circle;
        
        disp([' ']); 
        disp(feature_list{feature_list_index});
        disp(['source:',data_source_string,',dist:',data_dist_string,'database_count:',num2str(database_count),'/',num2str(database_count_total)]);
        disp(['cnt_channel:',num2str(channel_num),',lambda:',num2str(lambda),'percent:',num2str(1.0*cnt/total_circle*100),'%']);
               
        
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

% the max parameter info
[max_war_acc_value, max_war_acc_index] = max(Acc(:,3));
[max_meanF1_value, max_meanF1_index] = max(Acc(:,4));

Acc_max_war = Acc(max_war_acc_index,:);
Acc_max_meanF1 = Acc(max_meanF1_index, :);

% save
save(['../../Acc/',class_string,'/Acc_record_',class_string,'_',data_source_string,'_',data_dist_string,'_feature_',feature_string],'Acc','Acc_max_war','Acc_max_meanF1'); 




