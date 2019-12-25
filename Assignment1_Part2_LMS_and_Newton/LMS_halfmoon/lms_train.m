function [weight, err_cnt] = lms_train(data, weight, eta, test_flag)
% A function to train or test the weight vector on given data
% where Input:
%         data - training or test data matrix, label information is located
%                in the last column
%       weight - weight vector of the perceptron algorithm
%          eta - learning rate
%    test_flag - equals true when this call is a test (weight vector 
%                won't be updated),otherwise equals false 
%       Output:
%       weight - updated weight vector
%      err_cnt - the number of misclassified data points

    [dimension, ~] = size(weight);
    [data_dimension, sample_num] = size(data);
    data_dimension = data_dimension - 1; % subtract the one label dimension
    
    % check dimension consistency
    if dimension ~= data_dimension
        error('dimension error, weight: %d, data: %d', ...
              dimension, data_dimension);
    end
    
    %w_list = zeros(dimension, sample_num+1);
    %w_list(:,1) = weight;
    
    err_cnt = 0;
    for i = 1:sample_num
        x     = data(1:dimension,i);
        label = data(dimension + 1,i);
        
        if (x' * weight > 0 && label == -1) || ...
           (x' * weight <= 0 && label == 1)
            err_cnt = err_cnt + 1;
        end
        
        delta_weight = eta * x * (label - x' * weight);
        %next_weight = (eye(dimension) - eta * (x * x')) * weight ...
        %              + eta * x * label;
        
        if ~test_flag && (norm(delta_weight) > 1e-4)
            weight = weight + delta_weight;
            %w_list(:,i+1) = weight;
        end
    end
    
    % plot weight updating cycle problem
    %{
    figure(1);
    hold on;
    plot(1:sample_num+1, w_list(1, 1:sample_num+1), ':bx');
    yyaxis right;
    plot(1:sample_num+1, w_list(2, 1:sample_num+1), '-mo');
    close(1);
    %}
end