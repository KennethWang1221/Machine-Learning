function normalized_data = normalize_data(data)

    [dimension, ~] = size(data);
    dimension = dimension - 1;
    normalized_data = data;

    % subtract mean_value
    for i = 1:dimension
        mean_value = mean(data(i,:));
        normalized_data(i,:) = data(i,:) - mean_value;
    end
    
    % scale coordinates' value to [0,1]
    for i = 1:dimension
        max_abs_value = max(abs(normalized_data(i,:)));
        normalized_data(i,:) = normalized_data(i,:) / max_abs_value;
    end
    