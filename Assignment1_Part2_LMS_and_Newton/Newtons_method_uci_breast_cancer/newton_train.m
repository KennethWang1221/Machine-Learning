function [weight, err_cnt] = newton_train(data, weight, ~, test_flag)
% A function to train or test the weight vector on given data
% where Input:
%         data - training or test data matrix, label information is located
%                in the last column
%       weight - weight vector of the perceptron algorithm
%          eta - learning rate (omit)
%    test_flag - equals true when this call is a test (weight vector 
%                won't be updated),otherwise equals false 
%       Output:
%       weight - updated weight vector
%      err_cnt - the number of misclassified data points

    g_len_thres = 1e-6;

    [dimension, ~] = size(weight);
    [data_dimension, sample_num] = size(data);
    data_dimension = data_dimension - 1; % subtract the one label dimension
    
    % check dimension consistency
    if dimension ~= data_dimension
        error('dimension error, weight: %d, data: %d', ...
              dimension, data_dimension);
    end
    
    err_cnt = 0;
    for i = 1:sample_num
        x     = data(1:dimension,i);
        label = data(dimension + 1,i);
        
        % count error numbers
        if (x' * weight >  0 && label <= 0) || ...
           (x' * weight <= 0 && label >  0)
            err_cnt = err_cnt + 1;
        end
    end

    if ~test_flag
        x_mat = data(1:dimension,:);
        d_vec = data(dimension+1,:)';
        
        % create symbolic variables
        syms w [dimension, 1];
        e_vec = d_vec - x_mat' * (weight + w);
        cost_func = sum(e_vec.^2) / sample_num;
        H = hessian(cost_func, w);
        g_vec = subs(jacobian(cost_func, w), w.', zeros(1,dimension))';
        
        %{
        e_vec2 = d_vec - x_mat' * weight;
        for j = 1:sample_num
            x_mat(:,j) = x_mat(:,j) * e_vec2(j,1);
        end
        g_vec = (sum(-2 * x_mat') / sample_num)';
        
        if g_vec == ss
            disp('bingo!');
        end
        %}
        
        %delta_weight = -1 * (pinv(H)) * g_vec;
        if norm(g_vec) < g_len_thres
            delta_weight = zeros(dimension, 1);
        else
            delta_weight = -1 * (H \ g_vec);
        end
        weight = weight + delta_weight;
    end
end