# denoise-graph-laplacian
Copyright (C) 2011-2021 Francois G. Meyer <FMeyer@Colorado.Edu>

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  a. Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.

  b. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

  c. Neither the name of the copyright holders nor the names of any
     contributors to this software may be used to endorse or promote products
     derived from this software without specific prior written permission.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS on an
"AS IS" basis. THE COPYRIGHT HOLDERS AND CONTRIBUTORS MAKE NO
REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED.  BY WAY OF EXAMPLE, BUT
NOT LIMITATION, THE COPYRIGHT HOLDERS AND CONTRIBUTORS MAKE NO AND
DISCLAIMS ANY REPRESENTATION OR WARRANTY OF MERCHANTABILITY OR FITNESS FOR
ANY PARTICULAR PURPOSE OR THAT THE USE OF THIS SOFTWARE WILL NOT INFRINGE
ANY THIRD PARTY RIGHTS.

THE COPYRIGHT HOLDERS AND CONTRIBUTORS SHALL NOT BE LIABLE TO LICENSEE OR
ANY OTHER USERS OF THIS SOFTWARE FOR ANY INCIDENTAL, SPECIAL, OR
CONSEQUENTIAL DAMAGES OR LOSS AS A RESULT OF MODIFYING, DISTRIBUTING, OR
OTHERWISE USING THIS SOFTWARE, OR ANY DERIVATIVE THEREOF, EVEN IF ADVISED
OF THE POSSIBILITY THEREOF.
________________________________________________________________________

This software implements the algorithm described in "Perturbation of
the Eigenvectors of the Graph Laplacian: Application to Image
Denoising", F.G. Meyer & X. Shen, Applied and Computational Harmonic
Analysis, 2014, http://dx.doi.org/10.1016/j.acha.2013.06.004

You should be able to reproduce Table 1, and the images included in
the supplementary material.

This software uses the fast Approximate Nearest Neighbors (ANN)
Version: 1.1.2, (http://www.cs.umd.edu/~mount/ANN/) written by David
Mount & Sunil Arya. I use the MATLAB wrapper written by Shai Bagon
http://www.wisdom.weizmann.ac.il/~bagon.

HOW TO USE THE SOFTWARE

You will need to compile the ann library if you are not using  a 64 bit
Mac (this is the version that is provided in this archive). This is a
straightforward affair: just follow the instructions in 
./ann_wrapper/README.txt.

Once the ann library is compiled, in MATLAB, type 
>> [cleaned_image,l2] = demo ('barbara',40);

The denoised image will be returned in cleaned_image. The noise level
is 40, and the clean image is 'barbara'.

Please forward any bug, or comment to fmeyer@colorado.edu

Contact:
Francois Meyer
E-mail: fmeyer@colorado.edu
http://ecee.colorado.edu/~fmeyer
