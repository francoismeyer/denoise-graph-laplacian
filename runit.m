function [psnrAll] = runit (image,level)


    nrun = 40;
    psnrAll = zeros(nrun,1);

    for (i = 1:1:nrun)
        disp (i)

        [kleen,l2] = demo (image,level);
        
        mseAll(i) = l2;
        psnrAll(i) = 10*log10((255.^2)/l2);
    end

    return
end
