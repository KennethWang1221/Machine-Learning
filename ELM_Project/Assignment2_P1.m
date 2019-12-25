training = load("mnist_train.csv");
testing = load("mnist_test.csv");

%% 
[TrainingTime,TestingTime,TrainingAccuracy, TestingAccuracy]=ELM(training, testing, 1, 80, 'sigmoid');


