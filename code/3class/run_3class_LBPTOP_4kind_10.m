clear all;clc;
%% hyper-parameter
class_string = '3class';
num = 85;

%% parameter
feature_list = cell(1,3);
feature_list{1} = 'LBPSIP'; feature_list{2} = 'LBPTOP'; feature_list{3} = 'LPQTOP';

database_list = cell(1,4);
database_list{1} = 'CASME2'; database_list{2} = 'SMIC_HS'; database_list{3} = 'SMIC_VIS'; database_list{4} = 'SMIC_NIR';

feature_parameter_list = cell(1,4);
feature_parameter_list{1} = 'R3P8';feature_parameter_list{2} = 'R3P4';
feature_parameter_list{3} = 'R1P8';feature_parameter_list{4} = 'R1P4';


%% program:CASME->SAMM
feature_index = 2;
for feature_list_index = feature_index
%for feature_list_index = 1:length(feature_list)
    database_count = 0;
    database_count_total = length(database_list)*length(database_list)-length(database_list);
    for feature_parameter_index = 1
        feature_parameter = feature_parameter_list{feature_parameter_index};
        for database_list_index_1 = 3
            for database_list_index_2 = 2
                if database_list_index_1 ~= database_list_index_2
                    database_count = database_count + 1;
                    feature_string = feature_list{feature_list_index};
                    data_source_string = database_list{database_list_index_1};
                    data_dist_string = database_list{database_list_index_2};
                    lambda_list = 3*10^(-3):10^(-3):3*10^(-1);
                    ex_benchmark_exp_source_dist_ISLSR_LBPTOP_4kind;
                end
            end
        end
    end
end
