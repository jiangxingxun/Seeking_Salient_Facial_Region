clear all;clc;
%% hyper-parameter
class_string = '3class';
num = 85;

%% parameter
feature_list = cell(1,3);
feature_list{1} = 'LBPSIP'; feature_list{2} = 'LBPTOP'; feature_list{3} = 'LPQTOP';

database_list = cell(1,3);
database_list{1} = 'CASME2'; database_list{2} = 'SAMM'; database_list{3} = 'SMIC_HS';
%database_list{4} = 'SMIC_VIS'; database_list{5} = 'SMIC_NIR';


%% program
feature_index = 1;
for feature_list_index = feature_index
%for feature_list_index = 1:length(feature_list)
    database_count = 0;
    database_count_total = length(database_list)*length(database_list)-length(database_list);
    for database_list_index_1 = 1:length(database_list)
        for database_list_index_2 = 1:length(database_list)
            if database_list_index_1 ~= database_list_index_2
                database_count = database_count + 1;
                feature_string = feature_list{feature_list_index};
                data_source_string = database_list{database_list_index_1};
                data_dist_string = database_list{database_list_index_2};
                ex_benchmark_exp_source_dist_ISLSR;
            end
        end
    end
end
