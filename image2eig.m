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
%_Author: Francois Meyer, 2009
%
%___________________________________________________________
%
%___________________________________________________________
%
%_Header
%
%___________________________________________________________
%
%_Module_Name : image2eig
%
%_Description : given an image, construct patch world and
%               estimate the eigenvectors of the graph 
%               laplacian
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

function [eigvec,boxes,iboxes] = image2eig (orig,...
                                            nvec,...
                                            knn,...
                                            scale,...
                                            nu,...
                                            weight)

dim   = size(orig);
pad   = (nu-1)/2;
bgimg = extsym(orig, pad);


[boxes, iboxes] = image2patch(bgimg,...
                              dim(1) + 2*pad,...
                              dim(2) + 2*pad,...
                              nu,...
                              nu,...
                              weight);

timex=cputime;

[K2,DD2] =createlaplace (boxes,...
                         knn,...
                         scale);

fprintf(1,'createlaplace took %g s\n', cputime -timex);

[eigvec, eigval]= eiglaplace (K2, DD2, nvec);

%
% get rid of the spatial coordinates in boxes

boxes = boxes(1:size(boxes,1),1:size(boxes,2)-2);

return



function l_img = extsym(img,pad)
% Symmetric extension of image

dim   = size(img);

tr    = img (1:pad,:);
%br    = img (dim(1)-pad:dim(1),:);
br    = img (dim(1) - pad + 1:dim(1),:);

l_img = [flipud(tr);img;flipud(br)];
lc    = l_img(:,1:pad);
rc    = l_img(:,dim(2)-pad:dim(2));
l_img = [fliplr(lc),l_img,fliplr(rc)];

return