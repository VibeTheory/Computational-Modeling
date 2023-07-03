% Assume that we know the functional form of the response time (RT) 
% distribution for normal monosyllabic words. By having this assumption, we
% make our inference task easy: instead of inferring the entire RT 
% distribution, we simply have to infer one parameter (in this case, 𝜇) in 
% the distribution for this category. Therefore, this method is also known 
% as a parametric method.

% In this program, we are going to look at a method in which we can 
% estimate the entire category distribution without knowing the exact 
% functional form of the category distribution, which is also known as a 
% non-parametric method for categorization

% Intuitively, every time you observe the RT of a new normal monosyllabic 
% word, you know a little more about how the underlying distribution is 
% like. How do we add up these bits of knowledge across observations? We do
% this by proposing a "kernel” function, which captures the “knowledge” 
% from each observation. 

% Let’s start with a Gaussian kernel, which has the following form:
% k( t(j), y(i) ) = e^( -( t(j) - y(i) )^2 / 2h^2 )

% y(i) is the RT for observation i, for i = 1,2, … , N, and t(j) is the jth
% value in the RT space we consider for the normal word RT distribution, 
% where j = 1,2, … ,10000 in this simulation. ℎ is a window parameter that 
% controls the width of the Gaussian kernel.

% For now, we set 𝑁 = 50 as we will have 50 exemplar observations, and 
% h = 20. For the RT space, we make a vector T = 1:stepsize:1000, where 
% stepsize = 0.1. RTNorm.mat contains a vector, NormRT, which store the RT 
% data for 50 normal words.

clear all; 

% load exemplar RT inputs
load('RTNorm.mat')  ;           % 50 RT observations stored in NormalRT

% Define a range of possible feature values
stepsize = 0.1      ; % stepsize
T = 1:stepsize:1000 ; % from 0 to 1000ms (possible RT times we consider)

% Width of Gaussian kernel
h = 20 ; 

% ########################################################
% #####  NON-PARAMETRIC INFERENCE  WITH KERNEL METHOD#####
% ########################################################

% 1. Apply the Gaussian kernel for each observation
for i = 1:length(NormalRT)
    kernels(i,:) = normpdf(T, NormalRT(i), h) ;
end

% 2. Sum up kernel values over all observations
K = sum(kernels, 1) ; % proportional to the target RT distribution we want to infer

% 3. Normalization for P(RT|normal word category)
CatDist = K/sum(K*stepsize) ; % probability corresponds to each T's likelihood

% 4. Compute mean and SD of your inferred distribution (select one option below)
% option 1: use equations
CatMean1 = sum((T.*CatDist)*stepsize) ; % multiply value of random variable (possible RTs) by corresponding probability value in the distribution
CatVar1  = sum(((T-CatMean1).^2).*CatDist*stepsize) ; % uses squared difference between value of mu and expected value

% option 2: use sampling method
CatDistWeights = CatDist/sum(CatDist) ; % re-normalize category distribution to add up to 1
N = 10000 ; % num samples to draw
CatSample = randsample(T, N, true, CatDistWeights) ; % draw 10000 samples from T based on P(RT|normal word category)

CatMean2 = mean(CatSample) ;
CatVar2  = var( CatSample) ;

% ######################
% #####  PLOTTING  #####
% ######################
% Plotting parameters
figure;
bins = 100;
xrange = [min(T) max(T)];

% The sampled RTs
subplot(2,1,1);
hist(NormalRT,bins);
ylabel('Histogram of exemplar RTs');
xlim(xrange);

% plot P(RT|normal word category)
subplot(2,1,2);
plot(T, CatDist);
ylabel('P( RT | Normal words )');
xlim(xrange);



