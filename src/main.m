clc;
clear all;
close all;

img = imread('dark_road_5.jpg');

% t1=clock();

img = highFreqEnhance(img);

%% (a)
% figure(1);
% set(gcf, 'outerposition', get(0, 'screensize'));
% histogram(img);
% axis([0 255 0 inf]);
% title('histogram of image', 'FontSize', 20);

%% (b)
% pic = GHE(img, ones(size(img)));
% imwrite(pic, 'results/b-1.jpg');
% figure;
% set(gcf, 'outerposition', get(0, 'screensize'));
% histogram(pic);
% axis([0 255 0 inf]);
% title('histogram of img1', 'FontSize', 20);

%% (c)

% Phi = ones(size(img));
Phi = Grad(img);
% Phi = logGrad(img);
% Phi = CACHE_BP(img);
% Phi = CACHE_RG(img);
% Phi = CACHE_DP(img);

pic = GHE(img, Phi, true);
% pic = HE_Voting(img, Phi);
% pic = HE_Contrast(img, Phi);
% pic = HE_Neighborhood(img);
% imwrite(pic, 'results/d-2.jpg');

% t2 = clock();
% etime(t2, t1)