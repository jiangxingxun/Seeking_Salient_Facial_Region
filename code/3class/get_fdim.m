function fdim = get_fdim(feature_string, num)
    if strcmp(feature_string,'LBPSIP')
        fdim = 1700/num;
    end
    if strcmp(feature_string,'LBPTOP')
        fdim = 15045/num;
    end
    if strcmp(feature_string,'LPQTOP')
        fdim = 65280/num;
    end  
end