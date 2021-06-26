%___________________________________________________________
%                                                   
% Copyright (C) 2013 University of Colorado
% All rights reserved.
% This is UNPUBLISHED PROPRIETARY SOURCE CODE of the 
% University of Colorado; the contents of this file may not be 
% disclosed to third parties, copied or duplicated in any form, 
% in whole or in part, without the prior written permission of 
% the University of Colorado.
%
%
%_Author: Francois Meyer, 2011
%
%___________________________________________________________
%
%_Header
%
%___________________________________________________________
%
%_Module_Name : demo.m
%
%_Description : demo (image, std) adds white Gaussian noise of
%               standard deviation std, and then denoises the noisy
%               image using the eigenvectors of the graph Laplacian.
%               Details about the algorithm can be found here:
%               http://arxiv.org/abs/1202.6666
%               
%_Call : demo (imageX, std) where std = 40 or 60
%
%_References: http://arxiv.org/abs/1202.6666
%
%_I/O :
%
%_System : Unix
%_Remarks : None
%
%_Author :                 Francois G. Meyer
%_Revisions History:
%
%___________________________________________________________
%_end

function [rec2,l2] = demo (image,...
                           level)

addpath ('./ann_wrapper/');

% load a clean image 

switch (image)

  case {'fgr'}
    ima = imread('data/fgr.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 40:39+N;
    ypos = 64:63+N;
    clean = double(ima(xpos,ypos));
    clear ima;
    
  case {'penta'}
    ima = imread('data/pentagon.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 80:79+N;
    ypos = 64:63+N;
    clean = double(ima(xpos,ypos));
    clear ima;
    
  case {'couple'}
    ima = imread('data/couple.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 64:63+N;
    ypos = 1:N;
    clean = double(ima(xpos,ypos));
    clear ima;
    
  case {'feathers'}
    ima = imread('data/feathers.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 32:31+N;
    ypos = 32:31+N;
    clean = double(ima(xpos,ypos));
    clear ima;
    
  case {'camera'}
    ima = imread('data/cameraman.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    clean = double(ima);
    clear ima;
    
  case {'house'}
    ima = imread('data/house.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    clean = double(ima);
    clear ima;
    
  case {'airplane'}
    ima = imread('data/F16.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 60:59+N;
    ypos = 30:29+N;
    clean = double(ima(xpos, ypos));
    clear ima;
    
  case {'boats'}
    ima = imread('data/boats.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 80:79+N;
    ypos = 128:127+N;
    clean = double(ima(xpos, ypos));
    clear ima;
    
  case {'goldhill'}
    ima = imread('data/goldhill.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 96:95+N;
    ypos = 32:31+N;
    clean = double(ima(xpos, ypos));
    clear ima;
    
  case {'lenna', 'lena'}
    ima = imread('data/lena','pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 78:77+N;
    ypos = 30:29+N;
    clean = double(ima(xpos, ypos));
    clear ima
    
  case 'mandrill'
    ima = imread('data/mandrill.pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 2:N+1;
    ypos = 2:N+1;
    clean = double(ima(xpos, ypos));
    clear ima
    
  case 'barbara'
    ima = imread('data/barbara.png');
    N = 128;
    xpos = 10:N+9;
    ypos = 3*N-50:4*N-51;
    clean = double(ima(xpos, ypos));
    clear ima
    
  case 'clown'
    ima = imread('data/clown.pgm','pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 78:77+N;
    ypos = 30:29+N;
    clean = double(ima(xpos, ypos));
    clear ima
    
  case 'roof'
    ima = imread('data/tibet.pgm','pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 118:117+N;
    ypos = 50:49+N;
    clean = double(ima(xpos, ypos));
    clear ima
    
  case 'peppers'
    ima = imread('data/peppers.pgm','pgm');
    ima = imresize(ima, 0.5, 'bicubic');
    N = 128;
    xpos = 32:31+N;
    ypos = 32:31+N;
    clean = double(ima(xpos, ypos));
    clear ima

  otherwise
    N = 64;
    clean = zeros (N,N);
end

nrow= size (clean,1); ncol =size(clean,2);

% add some white Gaussian noise

rng('shuffle', 'twister');

dirty   = clean + level.*randn(size(clean));

%
%  set the parameters for the graph Laplacian
% assign noise dependent parameters

nu      = 7; scale   = 1;  lambda1 = -1;
weight2 = 1; scale2  = 1;

gamma =0.2;

% now assign image dependent parameters

switch (image)
    
  case {'airplane'}
    nbasis  = 180; nbasis2 = 650;
    knn    = 16; nu  = 5; weight  = 5; 
    knn2   =  8; nu2 = 3; weight2 = 3; lambda2 = 10000;
    
  case 'barbara'
    nbasis = 115; nbasis2 = 425;
    knn    = 32; nu  = 7; weight  = 5; 
    knn2   = 8;  nu2 = 5; weight2 = 1; lambda2 = 10000;
    
  case 'boats'
    nbasis  = 205;  nbasis2 = 610; 
    knn    = 16; nu  = 7; weight  = 5; 
    knn2   =  8; nu2 = 3; weight2 = 3; lambda2 = 10000;
    
  case 'camera'
    nbasis  = 180; nbasis2 = 680; 
    knn  = 16; nu  = 5; weight  = 5; 
    knn2 =  8; nu2 = 3; weight2 = 3; lambda2 = 10000;
    
  case 'clown'
    nbasis  = 410; nbasis2 = 875; 
    knn    = 8; nu  = 7; weight = 5;  
    knn2   = 4; nu2 = 3; weight2 = 3;  lambda2 = 10000;

  case {'couple'}

    nbasis  = 230; nbasis2 = 700; 
    knn  =  16;  nu  = 7;  weight  = 5; 
    knn2 =   4;  nu2 = 3;  weight2 = 3; lambda2 = 10000;

  case 'feathers'
    nbasis  = 175; nbasis2 = 900;
    knn    = 40; nu   = 7;  weight  = 7; 
    knn2   = 4;  nu2  = 3;  weight2 = 5; lambda2 = 10000;
    
  case 'fgr'
    nbasis = 160; nbasis2 = 620;
    knn    = 16; nu  = 5; weight  = 3; 
    knn2   =  8; nu2 = 3; weight2 = 1; lambda2 = 10000;

  case {'goldhill'}
    nbasis = 145; nbasis2 = 500; 
    knn    = 16; nu  = 7; weight  = 5; 
    knn2   =  8; nu2 = 3; weight2 = 3; lambda2 = 10000;
    
  case 'house'
    nbasis  = 205; nbasis2 = 170; 
    knn    = 64; nu  = 7;  weight = 10;
    knn2   = 8;  nu2 = 3; lambda2 = 10000;

  case {'lenna', 'lena'}
    nbasis = 155;  nbasis2 = 275; 
    knn    = 32; nu  = 7; weight  = 5;  
    knn2   =  4; nu2 = 3; weight2 = 1; lambda2 = 10000;
    
  case 'mandrill'
    nbasis = 135; nbasis2 = 350; 
    knn    = 16; nu  = 7; weight  = 3; 
    knn2   =  8; nu2 = 3; weight2 = 1; lambda2 = 10000;
    
  case 'penta'
    nbasis  = 325; nbasis2 = 800; 
    knn    = 16; nu  = 7; weight  = 5; 
    knn2   =  8; nu2 = 3; weight2 = 3; lambda2 = 10000;
    
  case 'peppers'
    nbasis = 167;  nbasis2 = 170; 
    knn    = 40; nu  = 7; weight = 10;
    knn2   = 8;  nu2 = 3; lambda2 = 10000;
    
  case 'roof'
    nbasis  = 130; nbasis2 = 480;

    knn    = 16; nu  = 5; weight  = 3; 
    knn2   =  8; nu2 = 3; weight2 = 1; lambda2 = 10000;

  otherwise                         % these are lena's parameters
    nu  = 7; knn    = 16;  weight = 1; nbasis = 165; 
    nu2 = 3; knn2   = 4;   nbasis2 = 320; lambda2 = 10000;
    
end

nvec  = nbasis;
nvec2 = nbasis2;


% compute the eigenvectors of the graph Laplacian

[basis,boxes,iboxes] = image2eig (dirty, nvec, knn, scale, nu,weight);

if (lambda1 == -1)
    v=var(boxes')';lambda1 = mean (v) + 3*std(v);
end

% denoise patch space in the basis of eigenvectors

rec= kleen (basis, boxes, iboxes, nrow, ncol, nu, nbasis, lambda1);
mse (rec,clean);

% push back some of the features of the original image

rec1  = gamma*dirty + (1-gamma)*rec;

%
% this is the second iteration 

[basis2,boxes2,iboxes2] = image2eig (rec1, nvec2, knn2, scale2, nu2,weight2);

if (lambda2 == -1)
    v=var(boxes2')'; lambda2 = mean (v) + 3*std(v)
end

rec2= kleen (basis2, boxes2, iboxes2, nrow, ncol, nu2, nbasis2, lambda2);

l2=mse (rec2,clean);
psnr = 10*log10((255.^2)/l2)

% Display
DISPLAY = 0;
if (DISPLAY == 1)
    figure,imagesc(clean),colormap gray,axis square, axis off,title('clean image')
    figure,imagesc(dirty),colormap gray,axis square, axis off;
    title(['dirty image mse = ',num2str(mse(clean,dirty))]);
    figure,imagesc(rec),colormap gray,axis square, axis off;
    title(['1st iteration mse = ',num2str(mse(clean,rec))]);
    figure,imagesc(rec2),colormap gray,axis square, axis off;
    title(['2nd iteration mse = ',num2str(mse(clean,rec2))]);
end

return;


function r = mse(clean,dirty)

r = sum ((clean(:)-dirty(:)).^2);

r= r/length(clean(:));

return