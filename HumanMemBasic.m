clear all; close all; home;

%% 
% ######################
% ##### Parameters #####
% ######################

% v/b = Average use rate
%   The default setting (v=2, b=100) assumes that, 
%   on average, items are used 2 times within 100 time units.

v = 2;
b = 100;

% Suppose an item has been used n times within the past t time units
n = 1;

% Decay rate: how fast desirability decays
% d = 0.4;

% T       = 1:100               ; 
% Mt      = zeros(1,length(T))  ;
% Elambda = zeros(1,length(T))  ;
% Decay   = zeros(1,length(T))  ;
% P_A_HA  = zeros(1,length(T))  ;
 
% for i = 1:length(T)                  % for 100 time steps
%     t = T(i)                       ; % at each time step
%     Mt(i)      = (1- exp(-d*t))/d  ; % exp(x) gives you e^x
%     Elambda(i) = (v+n)/(Mt(i)+b)   ; % expected value of lambda
%     Decay(i)   = exp(-d*t)         ; % decay rate
% 
%     P_A_HA(i)  = Elambda(i)*Decay(i)  ; % need probability (expected value of desireability * decay)
% end

% plot(T,P_A_HA) ;
% xlabel('Time') ; 
% ylabel('Need probability') ;

% item used v times within b time units
% n and t related to history of usage (characterize HA)
% d = decay rate
% M(t) = desirability can change over time (non-homogenous Poisson)

%%
% now, assume 1000 different decay rate values (from exponential distribution)
% for each decay rate, compute the need probability
% take the average of 1000 need probabilities --> your average

% parameters for exponential distribution

a = .4 ;
N = 1000 ;

dsample = exprnd(a, 1, N) ; % 1 x N vector of numbers sampled from an exponential distribution, with mean = a

T = 1:100 ;

% dRates = zeros(N, length(T)) ; % 1000x100 matrix to store decay rates for 1000 d's

for iDecay = 1:N
    d=dsample(iDecay);

    for i  = 1:length(T)               % for 100 time steps
        t  = T(i)                    ; % at each time step
        Mt = (1- exp(-d*t))/d        ; % exp(x) gives you e^x
        Elambda   = (v+n)/(Mt+b)     ; % expected value of lambda
        Decay     = exp(-d*t)        ; % decay rate

        dRates(i,iDecay) = Elambda*Decay    ; % update need prob vector for current d
    end
end

P_A_HA = sum(dRates, 2) ./ N ;

plot(T,P_A_HA) ;
xlabel('Time') ; 
ylabel('Need probability') ;