%___________________________________________________________
%                                                   
% Copyright (C) 2007-2013 University of Colorado
% All rights reserved.
% This is UNPUBLISHED PROPRIETARY SOURCE CODE of the 
% University of Colorado; the contents of this file may not be 
% disclosed to third parties, copied or duplicated in any form, 
% in whole or in part, without the prior written permission of 
% the University of Colorado.
%
%
%_Author: Francois Meyer, 2009
%___________________________________________________________
%
%_Header
%
%___________________________________________________________
%
%_Module_Name : eiglaplace.m
%
%_Description : compute the eigenvectors associated with the
%               diffusion matrix K
%               perform some normalization.
%               
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


function [eigvec,eigval] = eiglaplace (K,...
                                       D,...
                                       nvec)
    %__________________________________________________________________
    %
    %   solve eigenvalue problem
    %__________________________________________________________________

    disp ('computing eigenvectors...');

    % columns of eigvec are the eigenvectors

    opts.issym=1;                          
    opts.disp = 0; 
    opts.isreal = 1;

    timex=cputime;

    [eigvec, eigval]= eigs (K, nvec,'la',opts);

    fprintf(1,'eigenvectors computation took %g s\n', cputime -timex);

    %
    %  columns of eigvec = eigenvectors

    eigval = 1-diag(eigval);


    % Sort the eigenvalues from small to big, do the same on the
    % eigenvectors 

    [lTemp lIdx] = sort(eigval);
    eigvec = eigvec(:,lIdx);

    % perform post-normalization
    % eigevec is an eigenvector for D^{-1/2}K D^{-1/2}
    % but we really need an eigenvector of D^{-1}K 
    % so we multiply eigvec by D^{-1/2}

    eigvec = D*eigvec;

    % at this point eigvec no longer has a unit l2 norm,
    % so we renormalize

    for lk = 1:nvec
        eigvec(:,lk) = eigvec(:,lk)/norm(eigvec(:,lk));
    end;


    return