% A perception exercise with three observations

% Priors follows a specialized distribution

clear all; close all; clc;

%% 
% ###################################
% ########    PARAMETERS    #########
% ###################################

% Prior
m1 = -3;     % first peak in prior
m2 = 7;      % second peak in prior 
s = 2;       % standard deviation (represents uncertainty in the prior belief)

% Observation
x = [3 3.4 2.6];  % observed location (represent signal from your sensor)
sx = 2;           % standard deviation for observation (represents uncertainty in the sensor)

% Number of samples (for the Sampling method)
N = 10000;

%% 
% ########################
% #####   SAMPLING   #####
% ########################

% =============================================================
% Step 1:
% Goal: Sample from the prior distribution
% 1. Define the range of all possible target locations
tmin = -20;     % minimum t
tmax = 20;      % maximum t
stepsize = .01; 
t = tmin : stepsize : tmax; % T: from tmin to tmax, with spacing = stepsize

% 2. Compute prior probabilities for each possible location

Prior = normpdf(t,m1,s) + normpdf(t,m2,s) ;
PriorSampleWeight = Prior/sum(Prior);
% prior = sum(prior*stepsize) ;

% 3: draw random samples according to the prior distribution

PriorSample = randsample(t, N, true, PriorSampleWeight) ;
hist(PriorSample, 200)

% =============================================================
% Step 2:
% Goal: Compute the likelihood for each sampled t(i) using normpdf(X,M,SD) function
% At observation x, we assume the likelihood probability
%  to be obtained from a normal distribution at x, 
%  with mean = t(i) and standard deviation = SDx

for i = 1:length(x)
    LikelihoodSampleIndv(i,:) = normpdf(x(i),PriorSample,sx) ; % observation has to be first input arg. for likelihood
end                                                            % not every location has an equal probability - prior sample
LikelihoodSample = prod(LikelihoodSampleIndv,1) ;                

% easier than multiplying each likelihood by hand

% Likelihoodmat = normpdf(x', PriorSample,sx) ;
% Likelihood = prod(likelihoodmat, 1)

% =============================================================
% Step 3:
% Goal: Compute the weight for each sampled t(i)

% MATLAB syntax:
% Simply divide each likelihood by the sum of all likelihoods,
%  and assign the output to a vector called Weights, or anything you like.


Weights = LikelihoodSample ./ sum(LikelihoodSample) ;

% =============================================================
% Step 4:
% Goal: Resample from all t's, based on Weights computed in Step 3.
% This step is equivalent to sampling from the posterior distribution.
% 

% MATLAB syntax:
% To obtain samples from an existing vector, 
%  use the randsample() function.
% E.g.,    randsample(SOURCE, K, true, W)
%  draws K random samples from all elements in vector SOURCE
%   with each element being weighted by the weight vector W


PosteriorSample = randsample(PriorSample, N, true, Weights) ;
% pool of samples comes from priors, weights come from likelihood

% =============================================================
% Step 5:
% Goal: Obtain an  estimate from the posterior samples
%  To be consistent with the Analytical method, 
%  we use the mean of the posterior distribution as an estimate.

% MATLAB syntax:
% Use the mean() function
% E.g.,  mean(S)  returns the mean across all elements in vector S
% Use the median() function
% E.g.,  median(S)  returns the median across all elements in vector S


% ##################################
% ##### (2)REPORTING RESULTS   #####
% ##################################

EstMeanSampling   = mean   (PosteriorSample) ;
EstMedianSampling = median (PosteriorSample) ;

% ##################################
% #####  (3)DISTRIBUTION PLOT  #####
% ##################################
% Define figure properties
figure('Name','Model Results');     % open a new figure window, with the name "Model Results"
plotrow = 3;                        % number of rows of plots in the figure
plotcol = 1;                        % number of columns of plots in the figure
a = zeros(1,plotrow*plotcol);       % declare vector a, for storing all axis indices for later formatting


a(1) = subplot(plotrow,plotcol,1); % define subplot location
% Plot the HISTOGRAM of all samples from the Prior sampling
% This should resemble the prior distribution

% Fill in the blank: a vector containing samples from the PRIOR distribution
hist(PriorSample,200);
ylabel('Prior');

a(2) = subplot(plotrow,plotcol,2); % define subplot location
% Plot the likelihood computed for each prior sample
% This should resemble the likelihood probabilities from analytical method

% X axis: the vector containing samples from the PRIOR distribution
% Y axis: the vector containing LIKELIHOOD probabily for each sample
plot(PriorSample, LikelihoodSample,'.');
ylabel('Likelihood');



a(3) = subplot(plotrow,plotcol,3); % define subplot location
% Plot the HISTOGRAM for the posterior sampling
% This should resemble the posterior distribution

% Fill in the blank: a vector containing samples from the POSTERIOR distribution
hist(PosteriorSample,200);
ylabel('Posterior');

% ...........................
% ... Formatting the axis ...
% ...........................

% Set X axis limits to [tmin tmax], for all axes indexed in a
set(a,'Xlim',[tmin tmax]);


% #####################################
% #####   (4)COMPUTE PROBABILITY  #####
% #####################################
% use the posterior samples to compute the relative frequency that samples
% take values with the range of 3 to 5.


indx = (PosteriorSample > 3 & PosteriorSample < 5) ;
rstsample = sum(indx)/N ;
fprintf('prob(3<X<5) = %f\n', rstsample);

% ########################################
% #####   (5)COMPUTE MODEL EVIDENCE  #####
% ########################################
% use the likelihoods for samples to compute model evidence


% average probability to observe the data
Prob_data = sum(LikelihoodSample)/N;
disp('Model evidence P(data):'); disp(Prob_data);

disp('Mean estimate:')  ; disp(EstMeanSampling)  ;
disp('Median estimate:'); disp(EstMedianSampling);