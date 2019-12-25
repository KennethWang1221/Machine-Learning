%{
function preprocess_data()
    filename = 'breast-cancer.data';
    data = load_data(filename);
    [data_train, data_test] = split_data(data, 0.5, true);
    size(data_train)
    size(data_test)
end
%}

function data = load_data(filename)
    [cell_data, ~] = importdata(filename);
    string_data = string(cell_data);
    sample_num = size(string_data, 1);

    % mapping attributes to double numbers
    attribute_map = containers.Map('KeyType','char','ValueType','double');
    
    % missing data
    attribute_map('?') = 0;
    
    % Class
    attribute_map('no-recurrence-events') = -1;
    attribute_map('recurrence-events') = 1;

    % age
    attribute_map('10-19') = -4;
    attribute_map('20-29') = -3;
    attribute_map('30-39') = -2;
    attribute_map('40-49') = -1;
    attribute_map('50-59') = 0;
    attribute_map('60-69') = 1;
    attribute_map('70-79') = 2;
    attribute_map('80-89') = 3;
    attribute_map('90-99') = 4;

    % menopause
    attribute_map('premeno') = -1;
    attribute_map('lt40') = 0;
    attribute_map('ge40') = 1;

    % tumor-size
    attribute_map('0-4') = -5;
    attribute_map('5-9') = -4;
    attribute_map('10-14') = -3;
    attribute_map('15-19') = -2;
    attribute_map('20-24') = -1;
    attribute_map('25-29') = 0;
    attribute_map('30-34') = 1;
    attribute_map('35-39') = 2;
    attribute_map('40-44') = 3;
    attribute_map('45-49') = 4;
    attribute_map('50-54') = 5;
    attribute_map('55-59') = 6;

    % inv-nodes
    attribute_map('0-2') = -6;
    attribute_map('3-5') = -5;
    attribute_map('6-8') = -4;
    attribute_map('9-11') = -3;
    attribute_map('12-14') = -2;
    attribute_map('15-17') = -1;
    attribute_map('18-20') = 0;
    attribute_map('21-23') = 1;
    attribute_map('24-26') = 2;
    attribute_map('27-29') = 3;
    attribute_map('30-32') = 4;
    attribute_map('33-35') = 5;
    attribute_map('36-39') = 6;

    % node-caps & irradiat
    attribute_map('yes') = 1;
    attribute_map('no') = -1;

    % deg-malig
    attribute_map('1') = -1;
    attribute_map('2') = 0;
    attribute_map('3') = 1;

    % breast
    attribute_map('left') = -1;
    attribute_map('right') = 1;

    % breast-quad
    attribute_map('left_up') = -2;
    attribute_map('left_low') = -1;
    attribute_map('right_up') = 2;
    attribute_map('right_low') = 1;
    attribute_map('central') = 0;

    data = zeros(sample_num, 10);
    for i = 1:sample_num
        line = strsplit(string_data(i), ',');
        for j = 1:size(line, 2)
            data(i,j) = attribute_map(line(j));
        end
    end
    data = data(:, [2:end, 1])';
end