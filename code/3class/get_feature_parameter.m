function feature_parameter = get_feature_parameter(feature_string)
    if strcmp(feature_string,'LBPSIP')
        feature_parameter = 'R3';
    end    
    if strcmp(feature_string,'LBPTOP')
        feature_parameter = 'R3P8';
    end   
    if strcmp(feature_string,'LPQTOP')
        feature_parameter = 'Cor01';
    end   
end