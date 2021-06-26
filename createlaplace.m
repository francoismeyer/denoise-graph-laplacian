%___________________________________________________________
%                                                   
% Copyright (C) 2008-2013 University of Colorado
% All rights reserved.
% This is UNPUBLISHED PROPRIETARY SOURCE CODE of the 
% University of Colorado; the contents of this file may not be 
% disclosed to third parties, copied or duplicated in any form, 
% in whole or in part, without the prior written permission of 
% the University of Colorado.
%
%
%_Author: Francois Meyer, 2008
%
%___________________________________________________________
%
%_Header
%
%___________________________________________________________
%
%_Module_Name : 
%
%_Description : Given  N points in d dimensions, build the graph
%               using knn nearest neighbors. The parameter scale
%               is used to scale the Gaussian kernel.
%               The function computes the diffusion matrix  and
%               returns it in the variable diffusion. The matrix of
%               degrees is also returned. This matrix is used to
%               normalize the eigenvectors.
%_Call :
%
%_References :
%
%_I/O :
%
%_System : Unix
%_Remarks : None
%
%_Author :                 Francois G. Meyer
%_Revisions History:
%
%
%___________________________________________________________
%_end
function [diffusion,degree] = createlaplace(data,... % N samples x ndimension
                                            knn,...  % # of nearest neigbors 
                                            scale)   % in the Gaussian weight 

%__________________________________________________________________
% createlaplace - Calculate the eigenfunctions on the NN-manifold.
%
% FUNCTION:
%
%   [eigvec, eigval] =  createlaplce(data,knn,scale)
%
%

npoints =size(data,1);

DISPLAY = 0;

%__________________________________________________________________
%
%   Graph construction
%__________________________________________________________________

% calculate nearest neighbors (will work along rows)
if (DISPLAY)
    disp ('computing nearest neighbor, relax...');
end

%
% indices:   array of indices of the nearest neighbors:   knn x N
% distances: array of distances to the nearest neighbors: knn x N

timex= cputime;
annhand = ann(data');
[indices,distances] = ksearch (annhand, data', knn+1, 1.0);
fprintf(1,'ksearch took %g s\n', cputime -timex);
annhand = close(annhand);

%
%  columns of indices/distances =  indices/distance to nearest neighbors

indices   = indices';
distances = distances';

nz      = distances ~= 0;
minDist = min(distances (nz));
maxd    = max(distances (nz));
mnd     = mean(distances (nz));

% remove sqrt if you use the other wrapper
if (DISPLAY)
    disp(['Minimum distance is ',num2str(sqrt(minDist))])
    disp(['Maximum distance is ',num2str(sqrt(maxd))])
    disp(['Mean distance    is ',num2str(sqrt(mnd))])
end

clear nz;

if (DISPLAY)
    disp ('nearest neighbor computed...');
end

% scale the exponential according to the local distance

delta = mnd * scale.^2;

% generate the weights using a Gaussian kernel
% weight is a N x knn matrix

W = exp(-distances./delta);

clear distances;

DISPLAY = 0;
if (DISPLAY)
  figure ; hist(W(:),50);
  figure ; imagesc (W);  colormap(jet);colorbar;title ('distance');
end


% create a sparse matrix

xind = [1:npoints]';
xind = xind(:,ones(1,size(indices,2)));
weight = sparse (xind(:),...
                 double(indices(:)),...
                 double(W),...
                 npoints,...
                 npoints);

clear xind indices W;

% The matrix W is typically not symmetric. We make it symmetric

weight = (weight + weight')*.5;

%__________________________________________________________________
%
%   We now have a symmetric weight matrix W that describes the graph
%   topology and weights. Out next step consists in normalizing
%   this matrix in order for the diffusion to capture the geometry
%   of the manifold, and be independent of the point sampling
%   density. The density is estimated through the degree matrix. We
%   can use two normalizations: one that will result in the
%   convergence of the scheme toward the Laplace-Beltrami
%   operator. The other corresponds to a Focker-Plank equations on
%   the manifold.
%__________________________________________________________________

% compute the degree of each node, sum across the rows

deg = sum (weight,2);                  

% make the degrees along the diagonal

degree = speye (length (deg));

% set the diagonal of degree to the (deg)^{-1}
% we do this by looking at the matrix as a linear array, and
% advancing by exactly nColumns +1, so that at each time we hit the
% diagonal. 


degree(1:npoints+1:end) = 1./deg(deg ~= 0);

% We now have a kernel that represents the diffusion, and is
% independent of the samping density. We still need to normalize
% this kernel so that it becomes row stochastic.

kernel = degree*weight*degree;

clear deg weight;

% Compute D for the new density-normalized kernel.

deg = sum (kernel,2);

% Normalized Beltrami Laplacian

degree (1:npoints+1:end) = 1./sqrt(deg(deg ~= 0));

% Calculate the diffusion matrix
% The matrix corresponds to a kernel version of the probality transition
% matrix P = D^-1 K, and is defined by 
% D^{1/2}PD^{-1/2} = D^{-1/2}K D^{-1/2}

diffusion = degree * kernel * degree;

clear kernel deg;

% in principle, it should be symmetric a this point of the game,
% but we can enforce this numerically.

diffusion = (diffusion + diffusion')*.5;


return;