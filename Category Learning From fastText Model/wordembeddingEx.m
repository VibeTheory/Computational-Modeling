% We used the fastText model (developed by Facebook research group, now 
% included in MATLAB Text Analytics Toolbox) to get word embeddings with 
% 300-dim features for 15 fruit words, 15 vegetable words, and 5 more words
% for the categorization task

% The input file wordsinput.mat contains the name list in the cell-array 
% "wordlist", and word embeddings saved in the matrix “wordvec” with the 
% size of 30 by 300. Rows correspond to words, and columns are 300 
% embedding features. The file testwordsinput.mat gets the input for the 
% five test words with the name list in "testwordlist" and embeddings in 
% “testwordvec”.

clear all; close all;

load('wordsinput.mat'); 
load('testwordsinput.mat');

cat1num = 15;  % # of exemplars for fruit category
cat2num = 15;  % # of exemplars for vegetable category

% part A: MDS

% First we run the MDS algorithm. We compute the distance matrix based on 
% the provided word embedding inputs, and we use the matlab function 
% pdist() to compute pairwise cosine distances. We take the computed 
% distance matrix (with size of 35 by 35) as the input to run the nonmetric 
% multidimensional scaling method and compute the coordinates for each 
% object in a 2-dimensional space. We then plot all the objects in the 2D 
% space computed by MDS

% use pdist function to compute cosine distances
wordinput = [wordvec; testwordvec];
distvec = pdist(wordinput,'cos');
distmat = squareform(distvec);

% use nonmetric MDS
[Ymsd,eigvals] = mdscale(distmat,2);

% Plotting
figure('name','MDSresult');
plot(Ymsd(1:cat1num,1),Ymsd(1:cat1num,2),'.r'); hold on;
plot(Ymsd(cat1num+1:cat1num+cat2num,1),Ymsd(cat1num+1:cat1num+cat2num,2),'.b'); hold on;
plot(Ymsd(cat1num+cat2num+1:end,1),Ymsd(cat1num+cat2num+1:end,2),'+g'); hold on;
for i = 1:size(wordinput,1)
    if i<cat1num+1
        text(Ymsd(i,1)+0.01,Ymsd(i,2),wordlist{i},'Color','r');
    elseif i<cat1num+cat2num+1
        text(Ymsd(i,1)+0.01,Ymsd(i,2),wordlist{i},'Color','b'); 
    else
        text(Ymsd(i,1)+0.01,Ymsd(i,2),testwordlist{i-30},'Color','g');   
    end
end
axis auto square;


% Part B: categorization with parametric method of prototype theory

% Category learning: Compute P(X|category) for the fruit and vegetable 
% categories based on provided exemplars. We use the MDS-calculated 2D 
% coordinates as the feature representation of each object for inputs. We 
% implement a categorization model with the parametric method of prototype 
% theory, using 15 exemplars for fruit category and 15 exemplars for 
% vegetable category.

% input 2d feature data of 15 exemplars in each category
cat1data = Ymsd(1:cat1num,:);                   % fruits
cat2data = Ymsd(cat1num+1:cat1num+cat2num,:);   % veg.
testdata = Ymsd(cat1num+cat2num+1:end,:);       % test data
 
% learn prototype representaions from exemplars
catmean1 = mean(cat1data); 
catmean2 = mean(cat2data); 

catcov1 = cov(cat1data); 
catcov2 = cov(cat2data); 


% Part C: Categorization task for test data

% Categorization task: compute the probability of new objects belonging to 
% the fruit category. The test words are “plum”, “tomato”, “asparagus”, 
% "fruit", Wvegetable". We use the learned category representations to 
% determine the probability that each test word belongs to the fruit 
% category. We assume the prior probabilities are 0.5 for the fruit and the
% vegetable category.

priorcat1 = 0.5;
priorcat2 = 1-0.5;

for ti = 1:size(testdata,1)  % for all 5 test words
    probcat1 = mvnpdf(testdata(ti,:),catmean1, catcov1); % 3d likelihood for category 1
    probcat2 = mvnpdf(testdata(ti,:),catmean2, catcov2); % 3d likelihood for category 2
    
    postprobcat1(ti) = probcat1*priorcat1 / (probcat1*priorcat1 + probcat2*priorcat2); 
end

disp('Test words:') ;
testwordlist
disp('Post. prob of each test word belonging to Category 1')
postprobcat1
