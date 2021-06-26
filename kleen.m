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
%_Author: Francois Meyer, 2013
%___________________________________________________________
%
%_Header
%
%_Department_of_Electrical_Engineering
%_University_of_Colorado_at_Boulder
%___________________________________________________________
%
%_Module_Name : kleen.m
%
%_Description : 
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
function [rec]= kleen (basis,...
                       boxes,...
                       iboxes,...
                       nrow,...
                       ncol,...
                       nu,...
                       ioi,...
                       lambda)

    % the following lines detect blocks with very high variance,
    % and set their contribution to zero
    %
    DISPLAY = 0;
    if (DISPLAY)
        disp ('variance');
    end
    
    wght = ones (size (boxes));
    wght ((var(boxes')' > lambda),:) = 0;
    
    %  re-order the basis vector according to their ability to
    %  approximate the image --> this does not improve the
    %  reconstruction, and has been commented out

    % proj= boxes(:,floor(nu*nu/2 +1))'*basis; 
    % [p idx] =sort(abs(proj),'descend'); 
    % basis3 = basis (:,idx);

    [coefs,kbox] = projectonto (basis, boxes, ioi);

    %    for t=1:nu*nu
    %    kbox (:,t) = kbox (:,t).*wght;
    %    end

    % apply the window to the reconstructed box

    kbox = kbox.*wght;
    
    x  = zeros((nrow + nu-1)*(ncol + nu-1),nu*nu);
    zx = zeros(size (x));

    for t=1:nu*nu
        x(iboxes(t,:),t) = kbox (:,t);
        zx (iboxes(t,:),t) = wght (:,t);
    end

    % we need the following lines because when lambda is small some
    % pixels may not be included in any valid blocks: i.e. all
    % surrounding blocks have large variance.
    
    azx = sum(zx,2);
    ax = sum(x,2);
    iznz = find (azx ~= 0);
    avex = zeros(size (x,1),1);
    
    avex (iznz)= ax(iznz)./azx(iznz);

    pad = floor (nu/2);

    rec = reshape(avex, nrow + 2*pad, ncol + 2*pad);
    rec = rec(1+pad:nrow+pad,1+pad:ncol+pad);

    return
    
function [coefs,pdata] = projectonto(v,...
                                     data,...
                                     numvec)
    basis = v(:,1:numvec);
    
    coefs = (basis'*basis)\(basis'*data);
    pdata = basis*diag(ones(numvec,1))*coefs;
    return