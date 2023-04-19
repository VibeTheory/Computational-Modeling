% A simple Bayesian model describing belief updating about the fairness of a coin in a game of heads or tails.
% Considers all possible hypotheses, plots likelihood, prior, and posterior probability distributions, and finds
% the maximum a posteriori (MAP) estimate for the probability that the coin will land heads up (0.5 = fair coin).

% Data observations (number of heads and tails seen in a single coin-flipping session, described by Nh and Nt), 
% priors (number of times you've seen the coin land heads and tails in the past, described by Vh and Vt), and
% stepsize (increments by which we define our continuous hypothesis space) can all be adjusted to see how these 
% factors are reflected in the "reasoning" of the model.

clear all; clc; close all;

%% Consider all possible hypotheses

% define possible theta values for hypothesis
stepsize = 0.00001      ;
theta    = 0:stepsize:1 ;

%% Compute the likelihood term P(D|h) for each possible hypothesis
% define data
Nh = 100 ;        % number of heads observed in the data
Nt = 20  ;        % number of tails observed in the data

% define likelihood
likelihood = (theta.^Nh).*((1-theta).^Nt) ;

% display the array of theta and corresponding likelhood values
[theta' likelihood']

% plot the likelihood as a function of theta
figure('Name','likelihood')             ;
plot  (theta, likelihood)               ;
xlabel('\theta'); ylabel('Likelilhood') ;


% MLE estimation
[MaxL MaxID] = max(likelihood)

% display the MLE estimate
disp('MLE estimate: theta =') ;
MLEest = theta(MaxID)         ;
disp(MLEest)                  ;

%% Compute the prior distribution P(h) for each possible hypothesis
% define parameters for priors
Vh   = 100  ;        % number of tails previously seen (a priori)
Vt   = 100  ;        % number of heads previously seen (a priori)
aval = Vh+1 ;        % alpha value
bval = Vt+1 ;        % beta value

% compute the prior distribution
prior = ((theta.^(aval-1)).*((1-theta).^(bval-1)))/beta(aval, bval) ;

% prior1 = betapdf(theta,aval,bval); does the same computation more efficiently

% plot the prior distribution
figure('Name','Prior')            ;
plot  (theta, prior)              ; 
xlabel('\theta'); ylabel('Prior') ;

% sum(prior*0.05)                 ; checks that prior is calculated correctly (should = 1)


%% Compute the posterior distribution P(h|D) by combining likelihood and prior
post = likelihood.*prior ;

% MAP estimate
[MaxPost MaxPostID] = max(post)

% display the MAP estimate
disp('MAP estimate: theta =') ;
MAPest = theta(MaxPostID)     ;
disp(MAPest)                  ;

% plot the posterior distribution
figure('Name','Posterior')            ;
plot(theta, post)                     ; 
xlabel('\theta'); ylabel('Posterior') ;

% from an implementation perspective, using a smaller stepsize is more
% computationally intensive than a larger stepsize, as you must generate
% more values between 0 and 1 the smaller the stepsize you have. at the
% same time, however, a smaller stepsize allows for more precision in
% describing the continuous variable theta. 
% (distribution plots also get smoother)
