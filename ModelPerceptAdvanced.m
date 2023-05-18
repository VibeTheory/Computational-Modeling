clear all; close all; clc;

%% 
% ###################################
% ########    PARAMETERS    #########
% ###################################

% For defining the range of possible locations
tmin = -20;     % minimum t
tmax = 20;      % maximum t
stepsize = .1; 

% Prior
Mprior = 0;     % mean (represent what your prior belief is)
SDprior = 8;    % standard deviation (represents uncertainty in the prior belief)

% Observation
x = [7 3 -1 8];  % observed location (represent signal from your sensor)
SDx = 4;         % standard deviation for observation (represents uncertainty in the sensor)

% Number of samples (for the Sampling method)
N = 10000;

%%
% ##################################
% #####   DISCRETIZE-SPACE   #####
% ##################################

% 1. Define the range of all possible target locations
T = tmin : stepsize : tmax; % T: from tmin to tmax, with spacing = stepsize


% 2. Compute prior probabilities for each bypothesized location
%     and normalize them
Prior = normpdf(T,Mprior,SDprior); % normpdf for values in T, with mean = Mprior and SD = SDprior
Prior = Prior/sum(Prior*stepsize); % normalizing the prior densities


% 3. Compute the likelihood of obtaining the current observation,
%     for each bypothesized location
for i = 1:length(x)
    Likelihoodloc(i,:) = normpdf(x(i),T,SDx); % normpdf for x, with mean = all values in T and SD = SDprior
end;
Likelihood = prod(Likelihoodloc,1);

% Likelihoodmat = normpdf(x',T,SDx);
% Likelihood = prod(Likelihoodmat,1);

% 4. Compute posterior probabilities for each bypothesized location
%     by multiplying priors and likelihoods, and then normalize the products
Posterior = Prior.*Likelihood; % P(t|x) proportional to P(x|t)P(t)
Posterior = Posterior/sum(Posterior*stepsize); % normalizing the posterior densities


% 5. Obtain an estimate from the posterior
%    This time, we use the expected value of the posterior, Mean
%      i.e., E(t) = Integrate {t P( t | x )} dt
%    We're approximating this integral using summation (the Riemann sum)
%       Integration --> Summation
%                dt --> stepsize
Est1 = sum((T.*Posterior)*stepsize); 
disp('EstMean = '); disp(Est1);

%% 
% ########################
% #####   SAMPLING   #####
% ########################


% =============================================================
% Step 1:
% Goal: Sample from the prior distribution
% We assume the prior distribution to be a normal distribution
%  with mean = Mprior and SD = SDprior

% MATLAB syntax:
% To obtain samples from a normal distribution, we used the randn() function.
% E.g.,        SD*randn(1,N) + M
%  gives you N samples from a normal distribution 
%    with mean = M and standard deviation = SD

PriorSample = SDprior*randn(1,N) + Mprior     ;
%PriorSample = normrnd(Mprior, SDprior, 1, N) ; does the same thing

% =============================================================
% Step 2:
% Goal: Compute the likelihood for each sampled t(i)
% At observation x, we assume the likelihood probability
%  to be obtained from a normal distribution at x, 
%  with mean = t(i) and standard deviation = SDx

% MATLAB syntax:
% To obtain a probability density value from a normal distribution
% we used the normpdf() function.
% E.g.,        normpdf(X,M,SD)
%  gives you the probability density 
%   at X, with mean = M and standard deviation = SD,
% [You can plug in a vector for M, while leaving X and SD as one single number]


for i = 1:length(x)                     % for each observation,
    LikelihoodSampleloc(i,:) = ...
    normpdf(x(i), PriorSample, SDx)   ; % compute the likelihood for each particular sample
end                                     % instead of considering 400 possible locations              

LikelihoodSample = prod(LikelihoodSampleloc,1) ;
                                                                                         
% =============================================================
% Step 3:
% Goal: Compute the weight for each sampled t(i)
% Mathematically, w(i) = likelihood(i)/sum(likelihood)

% MATLAB syntax:
% Simply divide each likelihood by the sum of all likelihoods,
%  and assign the output to a vector called Weights, or anything you like.

Weights = LikelihoodSample ./ sum(LikelihoodSample) ;

% =============================================================
% Step 4:
% Goal: Resample from all t's, based on Weights computed in Step 3.
% This step is equivalent to sampling from the posterior distribution.


% MATLAB syntax:
% To obtain samples from an existing vector, 
%  use the randsample() function.
% E.g.,    randsample(SOURCE, K, true, W)
%  draws K random samples from all elements in vector SOURCE
%   with each element being weighted by the weight vector W
%   [i.e., The result is a vector with K elements]
%   [      W(i) is the weight for SOURCE(i)]
%   [      SOURCE and W must have the same length]
%  The 3rd parameter must be [true] for our purpose.
%  Check out HELP to see what that means.

PostSample = randsample(PriorSample, N, true, Weights) ;

% =============================================================
% Step 5:
% Goal: Obtain a estimate from the posterior samples
%  To be consistent with the Analytical method, 
%  we use the mean of the posterior distribution as an estimate.

% MATLAB syntax:
% Use the mean() function.
% E.g.,  mean(S)  returns the mean across all elements in vector S

EstSampling = mean(PostSample) ;

%%
% #################################
% #####   REPORTING RESULTS   #####
% #################################
 
% report estimates in the Command Window

% Define figure properties
figure('Name','Model Results');     % open a new figure window, with the name "Model Results"
plotrow = 3;                        % number of rows of plots in the figure
plotcol = 2;                        % number of columns of plots in the figure
a = zeros(1,plotrow*plotcol);       % declare vector a, for storing all axis indices for later formatting

 
% =================================
% For the Analytical method
% =================================

a(1) = subplot(plotrow,plotcol,1); % create tiled plots within one figure window, see HELP
% Plot Prior against T (the range of all possible targer locations)
plot(T, Prior);        % do the plotting
title('Analytical');   % give title to the current plot
ylabel('Prior');       % name the Y axis of the current plot
 
a(3) = subplot(plotrow,plotcol,3); % define subplot location
% Plot Likelihood against T
plot(T, Likelihood);
ylabel('Likelihood');

a(5) = subplot(plotrow,plotcol,5); % define subplot location
% Plot Posterior against T
plot(T, Posterior);
ylabel('Posterior');
 
 
 
% =================================
% For the sampling method
% =================================

a(2) = subplot(plotrow,plotcol,2); % define subplot location
% Plot the HISTOGRAM of all samples from the Prior sampling
% This should resemble the prior distribution

% Fill in the blank: a vector containing samples from the PRIOR distribution
hist(PriorSample,length(T));
title('Sampling');
ylabel('Prior');

a(4) = subplot(plotrow,plotcol,4); % define subplot location
% Plot the likelihood computed for each prior sample
% This should resemble the likelihood probabilities from analytical method

% X axis: the vector containing samples from the PRIOR distribution
% Y axis: the vector containing LIKELIHOOD probabily for each sample
plot(PriorSample, LikelihoodSample,'.'); % plot each point as a dot "."
ylabel('Likelihood');

 a(6) = subplot(plotrow,plotcol,6); % define subplot location
% Plot the HISTOGRAM for the posterior sampling
% This should resemble the posterior distribution

% A vector containing samples from the POSTERIOR distribution
hist(PostSample,length(T));
ylabel('Posterior')            ;




% ...........................
% ... Formatting the axis ...
% ...........................
 
% Set X axis limits to [tmin tmax], for all axes indexed in a
% set(a,'Xlim',[tmin tmax]);



