% Human's Task:
% A person is now t years old, how many years in total (ttotal) will he/she live?

% The Model's Goal:
% Given a number t, estimate the ttotal from human prediction

function PredLifeSpan = Lifespanfunc(t)

% ************************************************************************
% 2. Define vector ttotal (stores all possible estimates)
maxage = 150;
stepsize = .5;
ttotal = 1:stepsize:maxage;


% ************************************************************************
% 3. Compute Prior probaility for each value in ttotal
m = 78;
sd = 13;

prior = normpdf(ttotal,m,sd);
prior = prior/(sum(prior*stepsize));


% 4. Compute Likelihood on a given t for all possible ttotal values
%       Likelihood = P( t | ttotal )

likelihood = 1./ttotal;
likelihood = likelihood.*(ttotal>=t);


% ************************************************************************

% 5. Compute the posterior probability distribution over all possible
%      ttotal values:     Posterior = P( ttotal | t)
posterior = likelihood.*prior;
posterior = posterior/(sum(posterior*stepsize));


% ************************************************************************
% 6. Obtain Median of Posterior as T_Estimate
PosteriorCP = cumsum(posterior*stepsize);
CPDiff = PosteriorCP - .5;
AbsCPDiff = abs(CPDiff);
[mindiff k] = min(AbsCPDiff);


%       v) The Median is given by the "k-th" value in the ttotal vector,
%           where k is the position obtained in iv)
% [WRITE YOUR CODES BELOW]
PredLifeSpan = ttotal(k); 
disp('Estimates lifespan (median):'); 
disp([PredLifeSpan]);

