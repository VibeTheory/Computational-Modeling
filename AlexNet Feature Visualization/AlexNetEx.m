% In this program, we use one pre-trained model, AlexNet, to recognize
% objects in a few images, and then, we extract features to examine 
% image similarities.



clear all; close all; 

% load pre-trained model
net = alexnet;                       % make an instance of alexnet
net.Layers                           % print out alexnet's layers
inputSize = net.Layers(1).InputSize  % input image size: 227 * 227 * 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: classify an image using AlexNet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% testimg = imread('img1.png');
% testimginput = testimg(1:inputSize(1),1:inputSize(2),1:inputSize(3)); % make image the same size as network input
% [label_testimg,scores] = classify(net,testimginput);                  % pass in the network and cropped test image to classify 
% figure                                                                % image as a label and get scores for every category
% imshow(testimginput)
% title([label_testimg num2str(max(scores))])

% The first output argument shows the label of object category that 
% produces the highest score for recognition. The second output argument 
% includes the recognizing scores (the output of the CNN model) for the 
% 1000 categories.

% *score is probability out of 1000 categories (chance is 0.001 for each)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % step 2: Feature extraction using AlexNet, and then use MDS show the similarity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Second, we use some Matlab build-in functions to extract features in 
% different layers, and then use MDS to show the locations of images in a 
% 2D space. 
%  (1) Use "activations" function to extract feature vectors for each test image
%  (2) Use "pdist" function to compute the cosine distances of pairwise 
%      feature vectors, which can yield the distance matrix for all test images
%  (3) Run nonmetric MDS to display images in a 2D space. Use "mdscale" function.
%  (4) Show the MDS result plot

unzip('MerchData.zip'); 

% read in dataset
imds = imageDatastore('MerchData', ...      % grabs all the images from MerchData folder and subfolders
    'IncludeSubfolders',true, ...            
    'LabelSource','foldernames');           % foldernames become our labels
numImagesTrain = numel(imds.Labels);        % number of images we have
labellist = cellstr(imds.Labels);           % confer labels to strings

% display some sample images from the data set
indx = 3:3:numImagesTrain;
for i = 1:length(indx)
    I{i} = readimage(imds,indx(i));      % read in images and put in vector
end
figure
imshow(imtile(I));  % displays images in tiled format


% Test dataset
augimdsdata = augmentedImageDatastore(inputSize(1:2),imds); % crop images according to network input size

figure('name','MDSresult');

allLayers = {'conv2' 'conv5' 'fc7'} ;

for iLayer = 1:length(allLayers)   % for each layer

    layer = allLayers{iLayer} ;  
    
    % extract feature vectors from AlexNet layer
    featureVecs{iLayer} = activations(net,augimdsdata,layer,'OutputAs','rows'); % network, images, layers we want activation data from
    
    % featureVecs: 3 cells -> 75 images x 4096 feature values in each

    % part A: MDS
    % use pdist function to compute cosine distances
    distvec = pdist(featureVecs{iLayer}, 'cosine'); % gives distance between all pairs in vector format
    DistMat = squareform(distvec);          % matrix distance format, can be used in MDS

    % use nonmetric MDS
    [Ymsd,eigvals] = mdscale(DistMat, 2);

    % Plotting
    subplot(1,length(allLayers), iLayer)
    %figure('Name', ['Layer' layer])
    colorindx = kron([1 2 3 4 5],ones(1,15));
    colorvec = {'r','g','b','m','k'};
    for iLabel = 1:length(labellist)
        plot(Ymsd(iLabel,1),Ymsd(iLabel,2),'x','MarkerEdgeColor',colorvec{colorindx(iLabel)}); hold on;
    end
    title(layer);
    
    for iLabel = 1:15:length(labellist)
        text(Ymsd(iLabel,1)+0.01,Ymsd(iLabel,2),labellist{iLabel}(11:end),'Color',colorvec{colorindx(iLabel)});
    end

    axis auto square;
 
end

% This program extracts features for each image (with ALexNet), then tries 
% to visualize them in lower dimensions (nonmetric MDS in 2 dimensions). 
% Images belonging to the same category are nicely clustered together, 
% telling us what the network has tried to learn.

% Earlier layers like conv2 are only detecting low level features like 
% edges, corners, color, and size, so the classification task likely can't 
% be performed well yet at this stage. We can see that there isn't a clear 
% separation of clusters after this second convolutional layer, and those
% formed are based on just color or size.

% By the fifth convolutional layer, we see some separation of clusters,
% though features have similar values (clusters are crunched together).
% Variation within clusters hasn't been figured out as much yet.

% By the 7th fully connected layer, (right before making a decision), we 
% see very separated clusters, with pretty accurate intracluster variance.
% We see much smaller variablity in screwdriver and playing cards
% categories, while the cube and cap are much more variable (as they're
% seen from different angles and such in the test data, whereas the torch
% is only seen from one angle and in one position). The model has
% transformed the information in a way such that it's fully separable for
% the object recognition task.

% Conv2 -> sensitive to color and size 
%          (perhaps somewhat like V2?)

% Conv5 -> getting a little better, captures higher level visual features / 
%          parts or features about the object itself like a dog's face 
%          (object recognition like IT?)

% Fc7   -> whole object representation in a fully separable space
%          (like decision area in frontal lobe)