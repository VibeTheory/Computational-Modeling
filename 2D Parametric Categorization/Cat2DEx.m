% Parametric categorization method applied on a two-dimensional problem

% Suppose you are given 50 exemplars from one of the two categories. Each 
% exemplar is represented using two feature values. In the input file 
% inputdata.mat, the exemplars are saved in two variables “cat1data” and 
% "cat2data”. We first learn the two categories using parametric method, 
% and then use the learned representations to categorize three new cases 
% with feature values of [1, -2]; [2, 0]; [3, 2.5] respectively

clear all; close all; clc;

% load in the inputdata, exemplars for two categories
load('inputdata.mat'); 

% learning exemplars and test examples
testdata = [1 -2;
            2 0;
            3 2.5];
figure('Name','Input data');         
plot(cat1data(:,1), cat1data(:,2),'xr'); hold on
plot(cat2data(:,1), cat2data(:,2),'xb'); hold on;
plot(testdata(:,1),testdata(:,2),'og','MarkerFaceColor','g');
xlim([-5 10]); ylim([-10 10]); axis square; 


% step 1: Define a 2D hypothesis space
dx = 0.5;            % stepsize for the X dimension
dy = 0.5;            % stepsize for the Y dimension
AllX = -10:dx:10;    % 1D line for X
AllY = -10:dy:10;    % 1D line for Y

% Obtain a "joint space"
[Hx Hy] = meshgrid(AllX, AllY);
H = [Hx(:) Hy(:)];


%% step 2: category learning with parametric method to learn prototypical representations
catmean1 = mean(cat1data) ; catcov1 = cov(cat1data) ; % catmean is a 2-value vector
catmean2 = mean(cat2data) ; catcov2 = cov(cat2data) ;



%% step 3: compute and plot P(X|cat)

probdist1 = mvnpdf(H, catmean1, catcov1) ;
probdist2 = mvnpdf(H, catmean2, catcov2) ;

figure;
Plotprob1 = reshape(probdist1,size(Hx));
mesh(Hx, Hy, Plotprob1); % 3D plot of a "meshed-surface" 
hold on;

Plotprob2 = reshape(probdist2,size(Hx));
mesh(Hx, Hy, Plotprob2); % 3D plot of a "meshed-surface" 
colorbar; % show color bar on figure;

%% step 4: categerization task with new casess    
priorcat1 = 0.5   ;
priorcat2 = 1-0.5 ;

% compute the probability of each of the three test cases belonging to cat1

% testprob1 = mvnpdf(testdata(1,:), catmean1, catcov1)
% testprob2 = mvnpdf(testdata(2,:), catmean1, catcov1)
% testprob3 = mvnpdf(testdata(3,:), catmean1, catcov1)

for ti = 1:size(testdata,1)
    probcat1 = mvnpdf(testdata(ti,:), catmean1, catcov1);
    probcat2 = mvnpdf(testdata(ti,:), catmean2, catcov2);
    postcat(ti) = probcat1*priorcat1 / (probcat1*priorcat1+probcat2*priorcat2) ;
end

disp('Post. prob of belonging to Category 1') ;
postcat
