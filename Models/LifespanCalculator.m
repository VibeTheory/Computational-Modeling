clear all; close all; clc;


% ########################################################
% ###########                              ###############
% ###########          INTRODUCTION        ###############
% ###########                              ###############
% ########################################################
% Human's Task:
% A person is now t years old, how many years in total (ttotal) will he/she live?

% The Model's Goal:
% Given a number t, estimate the ttotal from human prediction

% Model specifications
% - Likelihood:   P( t | ttotal ) = 1/ttotal
% - Prior:        P( ttotal ) = normal distribution on ttotal, with a certain mean and s.d.



% ########################################################
% ##############                            ##############
% ##############     Step-by-step Guide     ##############
% ##############                            ##############
% ########################################################

% ************************************************************************
% 1. Define input t (the current age of the person)

T = 1:80 ;

% ************************************************************************
% 2. Define vector ttotal (stores all possible estimates)
%    [Hint: values smaller than t must be impossible]
%    [      So, ttotal should be from t to a reasonably large value]
%     i) Define the maximum value for ttotal
%    ii) Define stepsize
%   iii) Define ttotal as an evenly spaced vector, from t to ttotalmax


ttotalmax = 150;                % largest age you'd consider
stepsize = 0.5;
ttotal = 1:stepsize:ttotalmax;  % 299 possible values



% ************************************************************************
% 3. Compute Prior probaility for each value in ttotal
%       Prior = P( ttotal )
%      i)  Define mean lifespan (Suggestion: m = 78)
%     ii)  Define standard deviation of lifespan (Suggestion: sd = 13)


m = 78 ; % mean lifespan
sd = 13 ; % standard deviation of lifespan

prior = normpdf(ttotal,m,sd) ;

%    iii)  Prior = normal pdf computed for all ttotal, based on mean and s.d.
%           - use normpdf(ttotal, mean lifespan, standard deviation of lifespan)


%     iv)  Normalize prior distribution
%           - Reason: Because prior is a probability density function (pdf)
%           - Goal: to make sum(Prior*stepsize) = 1
%           - Method: 
%              a) Compute the current value for sum(Prior*stepsize)
%              b) Divide current Prior by the sum computed in a)
%                   to obtian a normalized Prior


prior = prior/(sum(prior*stepsize));  % height * stepsize, added up
figure('Name','Prior');
plot(ttotal,prior);

% ************************************************************************
% !! Checkpoint: Try running the script and see if everything works!!
% ************************************************************************

% 4. Compute Likelihood on a given t for all possible ttotal values
%       Likelihood = P( t | ttotal )
%    We use the likelihood function below:
%     P(t|ttotal) = 0, if t>total
%     P(t|ttotal) = 1/ttotal, if t<=total,


%likelihood will change
for di = 1:length(T)
    t = T(di);


likelihood1 = (1./ttotal).*(ttotal>=t) ;
% figure('Name', 'Likelihood1');
% plot(ttotal, likelihood1)    ;

% ************************************************************************

% 5. Compute the posterior probability distribution over all possible
%      ttotal values:     Posterior = P( ttotal | t)
%
%      i) Posterior = Likelihood * Prior, element-wise


%     ii) Normalize Posterior (because Posterior is a pdf)
%           a) Compute the current value for sum(Posterior*stepsize)
%           b) Divide current Posterior by the sum computed in a)
%               to obtian a normalized Posterior
%           c) Plot ttotal on the x-axis and the normalized posterior on
%           the y-axis


posterior = likelihood1.*prior ;

normpost = posterior/sum(posterior*stepsize) ;

% figure('Name', 'Posterior')
% plot(ttotal,normpost)

% ************************************************************************
% 6. Obtain Median of Posterior as T_Estimate
%
%       i) Compute the cumulative probabilities (CP) for Posterior
%          PosteriorCP should be a cumulative sum of Posterior*stepsize]


posteriorCP = cumsum(normpost)*stepsize;
[min_postval, minID] = min(abs(posteriorCP-0.5)) ;
Modelpred(di) = ttotal(minID);

end

figure('Name','Modelpred')
plot(T,Modelpred)

