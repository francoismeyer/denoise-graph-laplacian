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
%_Author: Francois Meyer, 2012
%___________________________________________________________
%_Header
%
%___________________________________________________________
%_Module_Name : 
%
%_Description : A: N rows by M columns image starting at (1,1),
%               patches of size n x m  are extracted if we think
%               about the center of the patch as being the
%               representative pixels, this means that we really start
%               at voxel (n/2,m/2, p/2), and end at (N-n/2, M-m/2,
%               p/2)
%
%               We extract a total of (N-n+1)*(M-m+1) overlapping
%               patches from the image A
%               The patches are stored row by row in the matrix boxes
%
%
%                This is programmed in MATLAB using the value-based
%                indexing. We create a matrix of indices of the
%                size (N*M) x (n*m). Each entry in this matrix is
%                a linear index to the image A, and tells us where
%                to fetch the value of A that will be copied into
%                the matrix boxes (of size (N*M) x (n*m)) at the
%                corresponding location.
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


function [boxes,allBlck] = image2patch (A,...
                                        N,...    % number of rows in data
                                        M,...    % number of cols in data
                                        n,...    % number of rows in a block
                                        m,...       % number of cols in a block
                                        locweight) % influence of
                                                   % the coordinates
    
    Nb = N - n + 1;                     % number of rows of patch world
    Mb = M - m + 1;                     % number of cols of patch world
    
    % the following lines of code build linear indices for the
    % locations of the patch values inside the matrix A

    rowIndex   = (0:n-1)';
    shiftIndex = 1:Nb;

    %  col1col1 is the matrix of linear indices in A of the entries in the
    %  first column of each block with its upper-left corner in the first
    %  column of A


    col1col1 = rowIndex(:,ones(Nb,1)) + shiftIndex(ones(n,1),:); 

    clear rowIndex shiftIndex

    %  col1col1 is the matrix of linear indices in A of the entries in
    %  all the columns of each block with its upper-left corner in the
    %  first column of A

    col1Blck = zeros(n*m,Nb);

    rows = 1:n;

    %  for each column in a block with its upper-left corner in the
    %  first column of A:
    %    insert the matrix col1col1 (shifted by N*i) every n rows
    %

    for i=0:m-1
        col1Blck(i*n + rows,:) = col1col1 + N*i;
    end

    clear col1col1 rows;

    %  allBlck is the matrix of linear indices in A of the entries in
    %  all the columns of all blocks


    allBlck = zeros(n*m, Nb*Mb);
    pixloc  = zeros(2, Nb*Mb);

    cols = 1:Nb;

    % insert the matrix col1Blck (shifted by N*j) every Nb columns

    for j=0:Mb-1
        allBlck (1:n*m,j*Nb+cols) = col1Blck + N*j;
        pixloc (1,j*Nb+cols) = cols;
        pixloc (2,j*Nb+cols) = j+1;
    end

    clear cols col1Blck slc1Blck;

    %
    % value-based indexing: the matrix boxes will have the size
    % determined by allBlck. Entry boxes (i,j) is given by 
    %              A((linear index) allBlck(i,j)) 

    boxes= zeros(n*m + 2, Nb*Mb);
    boxes (1:n*m,:) = A (allBlck);
    boxes (n*m+1:n*m+2,:) = locweight*pixloc;

    boxes = boxes';
