% One popular application of Bayesian inference is to make inference based 
% on previously observed items. In this program, we'll implement both 
% nonparametric and parametric methods for a categorization task. Suppose 
% we’ve observed RT measurements from 50 normal words, and from 50 taboo 
% words in a word recognition experiment. These data can be used to learn 
% the two categories, response to normal words and to taboo words, in the 
% phase of category learning. Now a new observation of RT is given, and the 
% categorization model needs to decide the probability that this 
% measurement is from a normal word.

% Input:
% RTNorm.mat contains a vector, NormRT, which store the RT data for 50 
% normal words. RTTaboo.mat contains a vector, TabooRT, which store the RT 
% data for 50 taboo words. Load these MAT files at the beginning of your 
% script.

clear all; 

load('RTNorm.mat');
load('RTTaboo.mat');

%1. Define a range of possible feature values
stepsize = 0.1; % stepsize
T = 1:stepsize:1000; % from 0 to 1000

% Width of Gaussian kernel
h = 20; 

% ######################################
% #####  NON-PARAMETRIC INFERENCE  #####
% ######################################

% Nonparametric method:
% We will use Gaussian kernel method that we implemented in the 
% non-parametric categorization example to compute two probability 
% distributions: P(RT | Normal words) and P(RT | Taboo words)

 % NORMAL RT

    % 2. Apply the Gaussia kernel for each observation
    for i = 1:length(NormalRT)
        % Apply the Gaussian kernel
        KernVals(i,:) = exp((-(T-NormalRT(i)).^2)/(2*h^2));   
    end

    % 3. Sum up kernel values over all observations
    K = sum(KernVals,1); % sum across the first dimension

    % 4. Normalization to approximate P(RT|Category)
    CatDist1 = K/sum(K*stepsize);                            % P(RT|Normal)

 % TABOO RT  

    % 2. Apply the Gaussia kernel for each observation
    for i = 1:length(TabooRT)
        % Apply the Gaussian kernel
        KernVals(i,:) = exp((-(T-TabooRT(i)).^2)/(2*h^2));   
    end

    % 3. Sum up kernel values over all observations
    K = sum(KernVals,1); % sum across the first dimension

    % 4. Normalization to approximate P(RT|Category)
    CatDist2 = K/sum(K*stepsize);                            % P(RT|Taboo)

%5. Compute the probability of a test trial showing a normal word, P(category 1 | RT). 
priorcat1 = 0.5;
priorcat2 = 1-priorcat1;

testval = [200,  460, 560, 600, 763];


for i = 1:length(testval)

    NormLikelihood(i)  = CatDist1(find(T==testval(i))) ; % P(normal|RT)
    TabooLikelihood(i) = CatDist2(find(T==testval(i))) ; % P(taboo |RT)

end 

NormPost  = NormLikelihood  * priorcat1 ;
TabooPost = TabooLikelihood * priorcat2 ;

NormProb_NonP  = NormPost  ./ (NormPost + TabooPost) ; % probability of X belonging to category 1
TabooProb_NonP = 1 - NormProb_NonP                   ;

% ######################################
% #####  PARAMETRIC INFERENCE  #####
% ######################################

% We assume that the two categories can be represented using Gaussian 
% distributions centered at the prototypical RTs. The parametric method 
% estimates the mean and the variance to form the prototype representation 
% of categories. We compute sample mean and sample standard deviation 
% using the exemplars

%%1. Assume Gaussian distribution for each category. Use the sample mean and
%% the sample variance from exemplars to compute P(RT | Category)

NormMean  = mean(NormalRT) ; NormStd   = std(NormalRT) ;
TabooMean = mean(TabooRT ) ; TabooStd  = std(TabooRT ) ;

NormLikelihood2  = normpdf(T, NormMean , NormStd ) ; % P(RT|normal)
TabooLikelihood2 = normpdf(T, TabooMean, TabooStd) ; % P(RT|taboo)

%2. Compute the probability of a test trial showing a normal word, P(category 1 | RT). 
for i = 1:length(testval)

    prob1 = normpdf(testval(i), NormMean , NormStd ) ; % P(normal|RT)
    prob2 = normpdf(testval(i), TabooMean, TabooStd) ; % P(taboo |RT)

    NormProb_Para(i) = prob1*priorcat1 ./ ((prob1*priorcat1) + (prob2*priorcat2)) ; % probability of X belonging to category 1
end

NormProb_Para

% ######################
% #####  PLOTTING  #####
% ######################
% Plotting parameters
figure('Name','Parametric inference');
bins = 10;
xrange = [min(T) max(T)];

%% The exemplar RTs from Normal word category
subplot(2,2,1);
hist(NormalRT,bins);
h = findobj(gca,'Type','patch'); h.FaceColor = 'r';h.EdgeColor = 'w';
ylabel('RT histogram (Normal)');
xlim(xrange);

%% The exemplar RTs from Taboo word category
subplot(2,2,2);
hist(TabooRT,bins); 
h = findobj(gca,'Type','patch'); h.FaceColor = 'b';h.EdgeColor = 'w';
ylabel('RT histogram (Taboo)');
xlim(xrange);
% 

% P(RT|category) from nonparametric method
subplot(2,2,3);
plot(T,CatDist1,'r'); hold on;        % red  = normal
plot(T,CatDist2,'b');                 % blue = taboo
ylabel('P( RT | Category )');
title('NonParametric');
xlim(xrange);

%% P(RT|category) from parametric method
subplot(2,2,4);
plot(T,NormLikelihood2,'r'); hold on;
plot(T,TabooLikelihood2,'b'); 
ylabel('P( RT | Category )');
title('Parametric');
xlim(xrange);
