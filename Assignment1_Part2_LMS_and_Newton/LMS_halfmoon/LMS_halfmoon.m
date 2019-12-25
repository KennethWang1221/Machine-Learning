function LMS_halfmoon()
    
    clc;

    dimension = 2;
    bias = 0;
    
    n_train = 1000;
    n_test = 2000;
    
    [~,data_train] = halfmoon(10,6,0,n_train);
    [~,data_test] = halfmoon(10,6,0,n_test);
    
    data_train = normalize_data(data_train);
    %data_test = normalize_data(data_test);
    
    weight = zeros(dimension, 1);
    
    epoch = 300;            % the upper bound of the number of epoch
    %actual_epoch = epoch;   % the number of actual meaningful 
                            % execuated epoches
    figure_epoch = epoch;   % draw at most 10 more epoches after
                            % the training error is decreased to 0
    %eta = 0.1;    % learning rate
    %eta_list = zeros(epoch);
    eta_list = linspace(0.1, 1e-4, epoch);
    
    %weight_list = zeros(dimension, epoch);
    err_nums_train = zeros(1, epoch);
    err_nums_test  = zeros(1, epoch);
    
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
        
        % train by LMS
        [weight, err_nums_train(i)] = lms_train(data_train, weight, eta, false);       
        [~, err_nums_test(i)] = lms_train(data_train, weight, eta, true);
        
        % train by Newton's Method
        %[weight, err_nums_train(i)] = newton_train(data_train, weight, eta, false);       
        %[~, err_nums_test(i)] = newton_train(data_train, weight, eta, true);
        
        
        % adjust eta, let log2(eta) == log10(training_error_ratio)
        %eta = min([1, (err_cnt / n_train) .^ log10(2)]); 
        %eta = min([1, (err_cnt / n_train)]);
        %eta = 1;
        
        % record actual_epoch when the traing error number is 0
        % and prepare to end the training
        if (err_nums_train(i) / n_train) < 1e-4 && figure_epoch >= epoch
            actual_epoch = i;
            %figure_epoch = min([epoch, actual_epoch + 10]);
            figure_epoch = actual_epoch;
        end
    end
    
    % display the final weight result
    disp('the final weight vector = ');
    disp(weight);
    
    % training & test error ratio
    figure(1);
    hold on;
    title('error rate & eta');
    xlabel('epoch number');
    ylabel('training & test error rate');
    
    train_er = err_nums_train(1:figure_epoch) * 100 / n_train;
    test_er = err_nums_test(1:figure_epoch) * 100 / n_test;
    
    ytickformat('percentage');
    plot(1:figure_epoch, train_er, '--b');
    plot(1:figure_epoch, test_er, '-r');
    
    yyaxis right;
    ylabel('learning rate eta');
    plot(1:figure_epoch, eta_list(1:figure_epoch), ':k');

    legend('training error rate','test error rate', 'eta');
    hold off;
    
    % category test samples by lable and classification info
    postive_samples = data_test(:,data_test(dimension+1,:)>0);
    negtive_samples = data_test(:,data_test(dimension+1,:)<0);
    
    % whether correctly classified mark
    for i=1:size(postive_samples,2)
        x = postive_samples(1:2,i);
        postive_samples(dimension+2,i) = int8(x' * weight > 0);
    end
    
    for i=1:size(negtive_samples,2)
        x = negtive_samples(1:2,i);
        negtive_samples(dimension+2,i) = int8(x' * weight <= 0);
    end
    
    % the distribution of data points
    figure(2);
    hold on;
    title('sample distribution');
    %plot(postive_samples(1,:), postive_samples(2,:), 'or');
    %plot(negtive_samples(1,:), negtive_samples(2,:), 'xb');
    
    pos_correct_samples = postive_samples(:,postive_samples(dimension+2,:) > 0);
    pos_wrong_samples = postive_samples(:,postive_samples(dimension+2,:) <= 0);
    neg_correct_samples = negtive_samples(:,negtive_samples(dimension+2,:) > 0);
    neg_wrong_samples = negtive_samples(:,negtive_samples(dimension+2,:) <= 0);
    
    plot(pos_correct_samples(1,:), pos_correct_samples(2,:), 'or');
    plot(pos_wrong_samples(1,:), pos_wrong_samples(2,:), 'om');
    plot(neg_correct_samples(1,:), neg_correct_samples(2,:), 'xb');
    plot(neg_wrong_samples(1,:), neg_wrong_samples(2,:), 'xg');
    
    boundary_x = min(data_test(1,:)) : max(data_test(1,:));
    boundary_y = -(bias + boundary_x * weight(1)) / weight(2);
    plot(boundary_x, boundary_y, '-k');
    
    legend('upper moon (correctly classified)', ...
           'upper moon (misclassified)', ...
           'lower moon (correctly classified)', ...
           'lower moon (misclassified)', ...
           'decision boundary');
    hold off;
    
    % delta_weight
    %{
    figure(3);
    plot(1:actual_epoch, weight_list(1, 1:actual_epoch), 'b');
    yyaxis right;
    plot(1:actual_epoch, weight_list(2, 1:actual_epoch), 'm');
    %}
end
