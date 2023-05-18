clear all; close all; clc;

% Imagine you're a robot trying to detect the location of a target
% sensory system will tell you the current location of the target, but with
% some uncertainty (likelihood). you know the target can show up in two possible
% locations, give prior knowledge (priors). 

% Define the range of all possible locations, theta

stepsize = 0.1          ;
theta = -20:stepsize:20 ; % all possible locations of the target

% Define Prior as the sum of two Gaussians
%   [       Simply add up two normpdf()]
%   [       Remember to normalize it afterward]
%   [       To normalize a distribution P, divide it by sum(P*stepsize)]

m1 = -3 ; sd1 = 2 ;
m2 =  7 ; sd2 = 2 ;

prior = normpdf(theta, m1, sd1) + normpdf(theta, m2, sd2) ;
prior = prior/sum(prior*stepsize) ;

% Compute Likelihood based on the Gaussian distribution
%   [       Simply use the normpdf()]

x   = 3 ;   % output of sensory system
sdx = 2 ;   % sensor system's uncertainty (standard dev.)

likelihood = normpdf(x, theta, sdx) ; % another Gaussian distribution to 
                                      % model the uncertainty of the sensor
                                      % observation always comes first

% Compute Posterior
%   [       Multiply Prior with Likelihood, elementwise]
%   [       Normalize the Posterior afterward]

post = prior .* likelihood     ;
post = post/sum(post*stepsize) ;


% Plot Prior, Likelihood and Posterior on the same graph

% figure;   % To open a new figure window
% hold on;  % To enable multiple lines plotting on the same figure
% Then, just go ahead and plot them one by one:
%   plot(theta, WhateverYouWantToPlot);

% To use different colors for different lines, try this:
%   plot(X,Y,'r'); % plots the line in RED
%
%   Type "doc linespec" in the Command Window 
%       for more info on line specifications!

plot(theta, prior, 'b', 'linewidth', 3)      ; hold on;
plot(theta, likelihood, 'r', 'linewidth', 3) ; hold on;
plot(theta, post, 'g', 'linewidth', 3)       ; hold on;
legend('prior', 'likelihood', 'posterior')   ;
xlabel('location \theta')                    ;


% Find the maximum a poseteriori (MAP) estimate of location, theta
%   [       Use max() to find what and where the maximum value is in Posterior]
%   [       Retrieve the value in the theta vector corresponding to the MAP position]

[maxP maxID] = max(post)    ;
MAPest       = theta(maxID) ;

MAPest


% can change sd of the two prior distributions to reflect degrees of
% uncertainty in where the target tends to be

% can also change sd of the sensory system to reflect degree of uncertainty
% in the sensor's location info

% can also manipulate the distributions (multiply normalized distribution)
% to increase probability
