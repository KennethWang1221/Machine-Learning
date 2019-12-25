function [data_train, data_test] = split_data(data, proportion, shuffle)
    if ~(0 <= proportion && proportion <= 1)
        error('proportion error')
    end
    
    [n_row, ~] = size(data);
    %dimension = n_row - 1;
    
    postive_data = data(:, data(n_row, :) > 0);
    negtive_data = data(:, data(n_row, :) < 0);
    %size(postive_data)
    %size(negtive_data)
    
    [~, n_pos_col] = size(postive_data);
    [~, n_neg_col] = size(negtive_data);
    postive_data = postive_data(:, randperm(n_pos_col));
    negtive_data = negtive_data(:, randperm(n_neg_col));
    
    %t1 = postive_data(:, 1:fix(n_pos_col * proportion));
    %t2 = negtive_data(:, 1:fix(n_neg_col * proportion));
    %td = [t1, t2];
    data_train = [postive_data(:, 1:fix(n_pos_col * proportion)), ...
                  negtive_data(:, 1:fix(n_neg_col * proportion))];
    data_test = [postive_data(:, fix(n_pos_col * proportion) + 1:end), ...
                 negtive_data(:, fix(n_neg_col * proportion) + 1:end)];
    %disp(data_train);
    
    if shuffle
        data_train = data_train(:, randperm(size(data_train, 2)));
        data_test = data_test(:, randperm(size(data_test, 2)));
    end
end