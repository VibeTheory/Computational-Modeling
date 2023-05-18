% Multidimensional Scaling model

clear all; % close all; home;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Colors %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the input of similarity data from human study

load('colour.mat') ;

% NON-METRIC MDS
[Y, stress] = mdscale(s,2); % non-metric MDS, similarity matrix as input

% Plotting
figure('name','color (non-metric MDS)');
plot(Y(:,1),Y(:,2),'.');
text(Y(:,1)+0.01,Y(:,2),labs) % how far away each text label is from each dot
axis auto square;

% CLASSIC MDS
[Y,eigvals] = cmdscale(s,2); % classic MDS method

% Plotting
figure('name','color (classic MDS)');
plot(Y(:,1),Y(:,2),'.');
text(Y(:,1)+0.01,Y(:,2),labs) % how far away each text label is from each dot
axis auto square;

% Your summary 

% The Classic MDS method is slightly more accurate to the distances between
% colors that we perceive, because the function assumes a continuous 
% exponential mapping between dissimilarity and distance, which is somewhat 
% idealistic in many domains, but we are very good at discriminating
% between colors and reproducing this function.

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sport%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the input of similarity data from human study

load('sport.mat') ;

% NON-METRIC MDS
[Y, stress] = mdscale(s,2); % non-metric MDS, similarity matrix as input

% Plotting
figure('name','sports (non-metric MDS)');
plot(Y(:,1),Y(:,2),'.');
text(Y(:,1)+0.01,Y(:,2),labs) % how far away each text label is from each dot
axis auto square;

% CLASSIC MDS
[Y2,eigvals] = cmdscale(s,2); % classic MDS method

% Plotting
figure('name','sports (classic MDS)');
plot(Y2(:,1),Y2(:,2),'.');
text(Y2(:,1)+0.01,Y2(:,2),labs) % how far away each text label is from each dot
axis auto square;


% Your summary 

% Classic MDS is probably more accurate for human judgments here because
% sports are high-level concepts. 
% The x dimension likely corresponds to either the medium of the sport
% (land w/ ball, land, water oriented) or whether it's played with a team
% or solo. The y dimension likely corresponds to the level of aggression or
% physical violence involved in the sport (chill, non-violent sports like
% golf to physically aggressive ones like boxing).


%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fruits%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the input of similarity data from human study

load('fruits.mat');

% NON-METRIC MDS
[Y, stress] = mdscale(s,2); % non-metric MDS, similarity matrix as input

% Plotting
figure('name','fruits (non-metric MDS)');
plot(Y(:,1),Y(:,2),'.');
text(Y(:,1)+0.01,Y(:,2),labs) % how far away each text label is from each dot
axis auto square;

% CLASSIC MDS
[Y2,eigvals] = cmdscale(s,2); % classic MDS method

% Plotting
figure('name','fruits (classic MDS)');
plot(Y2(:,1),Y2(:,2),'.');
text(Y2(:,1)+0.01,Y2(:,2),labs) % how far away each text label is from each dot
axis auto square;


% Your summary 

% Classic MDS is likely more accurate for these higher-order concepts.
% Fruit is at the center, meaning it has nearly the same distance to all
% the rest of the items (demonstrates hierarchical knowledge).
% The x-axis likely corresponds to size or color, whereas the y-axis might
% correspond to hardness.
% Tomato is probably an outlier -> most of us don't think of them as fruit.

