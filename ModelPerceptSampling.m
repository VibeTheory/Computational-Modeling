clear all; close all; 

%% 
% ###################################
% ########    PARAMETERS    #########
% ###################################

% For defining the range of possible locations
tmin = -20;      % minimum t
tmax =  20;      % maximum t
stepsize = 0.1; 

% Prior
Mprior = 0;     % mean (represent what your prior belief is)
SDprior = 8;    % standard deviation (represents uncertainty in the prior belief)

% Observation
x = [7 3 -1 8];          % observed location (represent signal from your sensor)
SDx = 4;        % standard deviation for observation (represents uncertainty in the sensor)

%%
% % ##########################
% % #####   Discretize-space method   #####
% % ##########################

% % 1. Define the range of all possible target locations (hypothesis space)
T = tmin : stepsize : tmax; % T: from tmin to tmax, with spacing = stepsize


% % 2. Compute prior probabilities for each hypothesized location
% %     and normalize them
prior = normpdf(T, Mprior, SDprior) ;
prior = prior/sum(prior*stepsize)   ;


% % 3. Compute the likelihood of obtaining the current observation,
% %     for each hypothesized location
% likelihood1 = normpdf(x(1), T, SDx) ;   % likelihood of location 1
% likelihood2 = normpdf(x(2), T, SDx) ;   % likelihood of location 2
% likelihood3 = normpdf(x(3), T, SDx) ;   % likelihood of location 3
% likelihood4 = normpdf(x(4), T, SDx) ;   % likelihood of location 4

for i = 1:length(x)
    likelihoodLoc(i, :) = normpdf(x(i), T, SDx) ; % four rows of observations, 401 steps each
end
likelihood = prod(likelihoodLoc, 1);

% likelihoodMat = normpdf(x', T, SDx) ;
% likelihood = prod(likelihoodMat, 1) ;

%likelihood = likelihood1 .* likelihood2 .* likelihood3 .* likelihood4     ;


% % 4. Compute posterior probabilities for each bypothesized location
% %     by multiplying priors and likelihoods, and then normalize the products
%post = prior .* likelihood1 .* likelihood2 .* likelihood3 .* likelihood4  ;

post = prior .* likelihood      ;
post = post/sum(post*stepsize)  ;

% % 5. Obtain an estimate from the posterior
% %    This time, we use the expected value of the posterior.
% %      i.e., E(t) = Integrate {t * P( t | x )} dt
% %    We're approximating this integral using summation (the Riemann sum)
% %       Integration --> Summation
% %                dt --> stepsize
Estimate1 = sum(T.*post)*stepsize         ;
disp('Estimate Mean = '); disp(Estimate1) ;

% compute estimated value 
% would normally require integrating over x*f(x)*stepsize


% % =================================
% % 6. Plotting
% % =================================
% % plot prior and posterior
figure
plot(T, prior, 'b', 'linewidth', 3)        ; hold on;
plot(T, post, 'g', 'linewidth', 3)         ; hold on;
legend('prior', 'posterior')               ;
xlabel('location \theta')                  ;


% % plot likelihood
figure
plot(T, likelihood, 'r', 'linewidth', 3)   ; 
legend('likelihood')                       ;
xlabel('location \theta') 