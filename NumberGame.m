% Q1: concept learning for the number game
clear all; 

% define hypothesis space
% type 1: Mathematical properties (24 hypotheses): 
% Odd, even, square, cube, prime numbers
h{1} = 1:2:99; 
h{2} = 2:2:100;
h{3} = (1:10).^2;
h{4} = (1:4).^3;
h{5} = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

% Multiples of small integers,1,2,3,4,5,6,7,8,9,10
h{6} = 1:100;
h{7} = 2*[1:50];
h{8} = 3*[1:floor(100/3)]; 
h{9} = 4*[1:floor(100/4)]; 
h{10} = 5*[1:floor(100/5)]; 
h{11} = 6*[1:floor(100/6)]; 
h{12} = 7*[1:floor(100/7)]; 
h{13} = 8*[1:floor(100/8)]; 
h{14} = 9*[1:floor(100/9)]; 
h{15} = 10*[1:floor(100/10)]; 

% Powers of small integers,2,3,4,5,6,7,8,9,10 
h{16} = 2.^[1:6]; % trial 1 should think of this concept, but [2 4 8 16 32 64]
h{17} = 3.^[1:4]; 
h{18} = 4.^[1:3]; 
h{19} = 5.^[1:2]; 
h{20} = 6.^[1:2]; 
h{21} = 7.^[1:2]; 
h{22} = 8.^[1:2]; 
h{23} = 9.^[1:2]; 
h{24} = 10.^[1:2]; 

% Type 2: Raw magnitude (5050 hypotheses): 
% All intervals of integers with endpoints between 1 and 100.
hcount = 24;
for i=1:100
    for j = i:100
        hcount= hcount+1;
        h{hcount} = [i:j];
    end
end

% Type 3: Approximate magnitude (10 hypotheses):
% Decades (1-10, 10-20, 20-30, …)
h{5075} = [1:10];
h{5076} = [10:20];
h{5077} = [20:30];
h{5078} = [30:40];
h{5079} = [40:50];
h{5080} = [50:60];
h{5081} = [60:70];
h{5082} = [70:80];
h{5083} = [80:90];
h{5084} = [90:100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WRITE YOUR OWN CODE BELOW %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input three learning trials

trial1 = [64]             ;
trial2 = [8 2 16 64]      ;
trial3 = [58 64 60 72 66] ;

X = {trial1 ; trial2 ; trial3} ;

% compute prior probability for each h -> 5084 prior distributions

priorSlice = 1/3 ;   % each hypothesis subspace has a 1/3 chance
                     % of being the right type of hypothesis

priors = zeros(1, length(h)) ; % initialize empty cell array for storing 
                               % each hypothesis' prior probability

priors(1:24)      = priorSlice/24   ; % math properties priors
priors(25:5074)   = priorSlice/5050 ; % raw magnitude priors
priors(5075:5084) = priorSlice/10   ; % approx. magnitude priors


%*************************************************************************


% Part a and Part b

%part a: compute the posterior distribution and plot a bar graph to show
%the top 20 hypotheses with highest posterior probability

%likelihoods
%use the lecture slide below part a for likelihood calculation for each hyp


likelihoods = cell(3,1) ; % initialize a 3x1 cell array to store likelihood
                          % vectors for each of the three trials

for iTrial = 1:length(X)     % for each trial

    n = length(X{iTrial}) ;  % n = number of examples in training set

    likelihoodTrial = zeros(1, length(h)) ; % initialize vector to store 
                                            % likelihood of each hypothesis

    for iHyp = 1:length(h)             % for every hypothesis

        hypothesis = h{iHyp}       ;   % get current hypothesis as an array
        hsize = length(hypothesis) ;   % current hypothesis size

        if ~all(ismember(X{iTrial}, hypothesis)) % if there is any case where the elements 
                                                 % of the current trial aren't in current h,
            likelihoodTrial(iHyp) = 0 ;          % the likelihood of that trial is 0

        else
            likelihoodTrial(iHyp) = (1/hsize)^n ; % otherwise, likelihood increases with trial
                                                  % size and decreases with hypothesis size
        end

    end

    likelihoods{iTrial} = likelihoodTrial ; % update likelihoods cell array with the 
                                            % likelihood vector from the current trial
end

posteriors = zeros(3,length(h)) ; % initialize 3x5084 matrix to store 
                                  % posteriors for each of the three trials

sortedPost = zeros(3,length(h)) ; % initialize 3x20 matrix to store the
                                  % top 20 hypotheses w/ greatest posterior
                                  % probability in each trial
top20s     = zeros(3,20)        ;

sortedID   = zeros(3,length(h)) ; 
top20ID      = zeros(3,20)        ;

for iTrial = 1:length(X)                                    % for each trial
    posteriors(iTrial,:) = priors .* likelihoods{iTrial}  ; % compute posterior distribution
    posteriors(iTrial,:) = posteriors(iTrial,:)/sum(posteriors(iTrial,:)) ; % normalize that posterior distribution
    [sortedPost(iTrial,:), sortedID(iTrial,:)] = sort(posteriors(iTrial,:), 'descend')  ; % get the top 20 values from it and their positions

    top20s(  iTrial,:) = sortedPost(iTrial,1:20) ;
    top20ID( iTrial,:) = sortedID(  iTrial,1:20)  ;
end


% maxID_Trial1 = sort(categorical(maxID(1,:)))  ;
% maxID_Trial2 = sort(categorical(maxID(2,:)))  ;
% maxID_Trial3 = sort(categorical(maxID(3,:)))  ;
% 
% cell_IDs = {maxID_Trial1 ; maxID_Trial2 ; maxID_Trial3} ;

for iTrial = 1:length(X)
    figure('Name', ['Trial ' num2str(iTrial) ': Top 20 Hypotheses'])
    bar(top20s(iTrial,:));
    xticks(1:20);
    xticklabels((top20ID( iTrial,:)));
%   saveas(gcf,['fig' num2str(iTrial) '.jpeg'])     % optional: save graphs
end


%write a short paragraph to summarize what concept(s) the model infers from
%the positive examples for each trial, and insert the bar graph for each
%trial


%Trial 1: [64]

% The model most strongly inferred that hypothesis 22 (powers of 8) fit the
% training data for trial 1, with hypothesis 18 following it at a steep
% decline. (Plotting posterior 'need' probabilities for the 20 strongest 
% hypotheses, as shown above, seems to indicate a power function in the 
% strength of possible hypotheses, such that hypothesis 22 is much stronger
% than the next probable hypothesis (18), but differences between these 
% hypothesis strengths get smaller and smaller as you observe less probable
% hypotheses). It makes sense that the model showed so much confidence in 
% h22, because hypotheses 19-24 are the shortest hypotheses in the problem
% space, each having only 2 values, making the likelihood of this concept 
% being instantiated much higher than for other hypotheses that might also 
% contain 64. For example, the next most likely hypothesis is h18 (powers
% of 4), which seems to make just as much logical sense as h22, but because
% that hypothesis has 3 values, it's slightly less probable that an
% observed instance of 64 refers to that concept. The next most probable
% hypothesis, h4, refers to 'all cubes', and is, again, another very likely
% logical concept (overlapping conceptually with 'powers of 4' in humans),
% held back by it's hypothesis size (containing 4 values). Though all of
% this so far seems to fit pretty well with human judgments, the next most
% probable hypothesis, h5081 ('interval from 60-70') is probably not so
% highly rated among humans. In this case, the model assumes a lower
% likelihood than a human probably would for other options, namely the
% simple math properties like powers of 2 (h16), squares (h3), and 
% multiples of 8, 4 and 2 (h13, h9, h7), due to the fact that hypotheses in
% the approximate magnitudes subspace that h5081 was drawn from all
% contain only 10 values, which is much less than what most of those other 
% hypotheses contain. In humans, concepts of simple math properties are
% deeply engrained from childhood, and if given just one number like this
% and told to find a pattern, we probably would look to explore all the
% simple math properties that apply before looking to apply the concepts of
% any kind of interval. The model, however, assigns need probability in
% this trial to hypotheses based solely on hypothesis size, as long as the
% hypothesis contains 64, because every hypothesis that contains 64
% contains just as much of the training data as the next.


%Trial 2: [8 2 16 64]

% The model's results for trial 2 also seemed to follow human judgments
% pretty well, assuming that h16 ('powers of 2') was the only really viable
% concept to be learned. Like in human judgments, concepts 2 and 7 ('even
% numbers' and 'multiples of 2') receive a little activation, but they're
% probability is far outweighed by seeings so many examples from the 
% 'powers of 2' category fulfilled out of what's possible. Where the model
% begins to deviate from common human judgment is perhaps in assuming that 
% the training data refers to a concept of raw interval so highly. Beyond
% hypotheses 2, 7, and 6 ('even numbers', 'multiples of 2', and 'multiples 
% of 1'), the model starts to predict exclusively intervals of raw
% magnitude as being the next most probable. As humans, who grow up
% focusing our math studies on simple properties, and who often don't spend
% much time studying properties of series, it makes sense that we don't
% expect to learn concepts of interval as much as we do concepts of basic
% math properties from a set of numbers like this, especially because the
% concept most activated by this set ('powers of 2') brings to mind other
% math properties. Personally, I would extend a much higher posterior
% judgment to math properties that don't entirely fit the bill, such as
% multiples and powers of 4 or 8, before I'd look to apply concepts of
% interval. Again, though, due to the way we define our priors here, the
% model's behavior is rational.


%Trial 3: [58 64 60 72 66]

% Trial 3 saw a much steadier decline in the model's top 20 posterior
% judgments than Trial 1. Nearly every hypothesis among those most probably
% instantiated by the training data was one of raw magnitude (H2), which
% makes sense because there isn't too much to assume in terms of simple
% math properties here, and those properties that one could observe (h2 and
% h7, 'evens' and 'multiples of 2') seem less salient in the grand scheme
% than the fact that the data is constrained to an interval. These most
% probable hypotheses assumed by the model are those raw intervals centered 
% around 58-72, and the model doesn't rate any intervals of approximate
% magnitude among the top 20 most probable, as none of those 10-element
% hypotheses would be able to capture the entirety of this data (for
% example, the approx. magnitude interval 60-70 doesn't capture all of the 
% set, but many raw magnitude intervals like 55-75 would, and this 
% intuition is reflected in the model's behavior). 


%part b: for each trial, after learning the concept from the positive
%exemplars, the model makes generalization judgments for new numbers. use
%hypothesis averaging to make the generalization judgment by computing the
%probability that each number between 1 and 100 instsantiates the same
%concept as the positive examples provided in each trial

%draw a bar graph to show the generalization judgments for each trial

%use lecture slide below part b to implement the generalization judgment

numJudgments = 100    ;

judgments = cell(3,1) ; % initialize a 3x1 cell array to store probability
                        % judgments for 100 nums for each hypothesis for each trial

for iTrial = 1:length(X)     % for each trial

    judgmentTrial = zeros(length(h), numJudgments) ; % initialize 5084x100 matrix

    for iHyp = 1:length(h)   % for each hypothesis

        hypothesis = h{iHyp} ;

        for iJudge = 1:numJudgments   % for each integer judgement between 1 and 100

            if ~all(ismember(iJudge, hypothesis))   % if there is any case where the current 
                                                    % new object isn't in the current h, the 
                judgmentTrial(iHyp, iJudge) = 0 ;   % probability that C applies to new object is 0

            else                                                         % otherwise
                judgmentTrial(iHyp, iJudge) = posteriors(iTrial,iHyp) ;  % prob = 1 x post
            end

        end
    end
    hsum = sum(judgmentTrial, 1) ; % sum of every hypothesis' judgment vector (1x100 vector)
    hsum = hsum/sum(hsum)        ; % normalize it if you feel like it
    judgments{iTrial} = hsum     ;
end 


% PLOT GENERALIZATION JUDGMENTS FOR EACH TRIAL (need prob over trials)
for iTrial = 1:length(X)
    figure('Name', ['Trial ' num2str(iTrial) ': Generalization Judgments'])
    bar(judgments{iTrial})
%   saveas(gcf,['fig' num2str(iTrial+3) '.jpeg'])   % optional: save graphs
end
