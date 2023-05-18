% This programs calls the function Lifespanfunc.m to estimate lifespan for
% a range of observed age. This file will yield a plot of the lifespan
% estimates as a function of observed age.

% 1. Define a vector T, storing a range of possible input values t

T = 1:100;

% 2. Write a FOR loop to obtain an estimate from your model for each value 
% in T by calling the function of Lifespanfunc

ModelPred = zeros(1, length(T)) ; % initialize vector for model predictions

for i = 1:length(T)
    % Define input t(the current age of the person)
    t = T(i);
    ModelPred(i) = Lifespanfunc(t);
end

figure('Name', 'Lifespan Estimates')
plot(T, ModelPred)
xticks([0:10:100]); yticks([0:20:150]);
xlim([1, 100]); ylim([0 150]);
xlabel('Observed age'); ylabel('Model predicted lifespan')