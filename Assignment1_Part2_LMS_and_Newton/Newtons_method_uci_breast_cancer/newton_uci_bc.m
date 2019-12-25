function newton_uci_bc()
    
    clc;

    filename = 'breast-cancer.data';
    data = load_data(filename);
    [data_train, data_test] = split_data(data, 0.5, true);
    
    data_train = normalize_data(data_train);
    %data_test = normalize_data(data_test);
    
    [dimension, n_train] = size(data_train);
    [~, n_test] = size(data_test);
    dimension = dimension - 1;
    
    %bias = 0;
    weight = zeros(dimension, 1);
    delta_weight_thres = 1e-6;
    
    epoch = 10;            % the upper bound of the number of epoch
    %actual_epoch = epoch;   % the number of actual meaningful 
                            % execuated epoches
    figure_epoch = epoch;   % draw at most 10 more epoches after
                            % the training error is decreased to 0
    %eta = 0.1;    % learning rate
    %eta_list = zeros(epoch);
    eta_list = linspace(0.1, 1e-4, epoch);
    
    %weight_list = zeros(dimension, epoch);
    err_nums_train = zeros(1, epoch);
    err_nums_test = zeros(1, epoch);
    
    for i = 1:epoch
        if mod(i, 100) == 0
            disp(['current epoch: ', num2str(i)]);
        end
        
        if i > figure_epoch
            break
        end
        
        shuffle_seq = randperm(n_train);
        data_train = data_train(:,shuffle_seq);
    
        % train & test
        eta = eta_list(i);
        
        previous_weight = weight;
        [weight, err_nums_train(i)] = ...
        newton_train(data_train, weight, eta, false);       
        [~, err_nums_test(i)] = ...
        newton_train(data_train, weight, eta, true);
        
        % record actual_epoch when the traing error number is 0
        % and prepare to end the training
        if i > 1 && ...
           norm(weight - previous_weight) < delta_weight_thres && ...
           figure_epoch >= epoch
            actual_epoch = i;
            figure_epoch = actual_epoch + 2;
        end
    end
    
    % display the final weight result
    disp('the final weight vector = ');
    disp(weight);
    
    % training & test error ratio
    figure(1);
    hold on;
    title('training & test error rate');
    xlabel('epoch number');
    ylabel('training & test error rate');
    
    train_er = err_nums_train(1:figure_epoch) * 100 / n_train;
    test_er = err_nums_test(1:figure_epoch) * 100 / n_test;
    
    ytickformat('percentage');
    plot(1:figure_epoch, train_er, '--b');
    plot(1:figure_epoch, test_er, '-r');

    legend('training error rate','test error rate');
    hold off;
    
    % delta_weight
    %{
    figure(3);
    plot(1:actual_epoch, weight_list(1, 1:actual_epoch), 'b');
    yyaxis right;
    plot(1:actual_epoch, weight_list(2, 1:actual_epoch), 'm');
    %}
end
