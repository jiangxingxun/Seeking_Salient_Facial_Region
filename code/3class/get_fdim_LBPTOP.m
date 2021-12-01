function fdim = get_fdim_LBPTOP(feature_string, num, feature_parameter)
    if strcmp(feature_string,'LBPSIP')
        fdim = 1700/num;
    end
    if strcmp(feature_string,'LBPTOP')
        if strcmp(feature_parameter, 'R3P8')
            fdim = 15045/num;
        end
        if strcmp(feature_parameter, 'R3P4')
            fdim = 3825/num;
        end
        if strcmp(feature_parameter, 'R1P8')
            fdim = 15045/num;
        end
        if strcmp(feature_parameter, 'R1P4')
            fdim = 3825/num;
        end
    end
    if strcmp(feature_string,'LPQTOP')
        fdim = 65280/num;
    end  
end