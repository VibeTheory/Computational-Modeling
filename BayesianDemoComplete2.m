% A simple Bayesian model

clear all; clc; close all;

%% Consider all possible hypotheses

% define possible theta values for hypothesis
stepsize = 0.00001      ;
theta    = 0:stepsize:1 ;

%% Compute the likelihood term P(D|h) for each possible hypothesis
% define data
Nh = 100 ;
Nt = 20  ; 

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
Vh   = 100  ;
Vt   = 100  ; 
aval = Vh+1 ;
bval = Vt+1 ;

% compute the prior distribution  ( beta() in matlab )
prior = ((theta.^(aval-1)).*((1-theta).^(bval-1)))/beta(aval, bval) ;

% prior1 = betapdf(theta,aval,bval); does the same thing

% plot the prior distribution
figure('Name','Prior')            ;
plot  (theta, prior)              ; 
xlabel('\theta'); ylabel('Prior') ;
% sum(prior*0.05); checks that prior is calculated correctly (should = 1)


%% compute the posterior distribution P(h|D) by combining likelihood and prior
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
% same time, however, a smaller stepsize allows for more accuracy in
% describing a continuous variable. (distribution plots also get smoother).
