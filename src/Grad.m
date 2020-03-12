function [output] = Grad(img)
if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

kernal1 = [1 2 1
           0 0 0
          -1 -2 -1];
kernal2 = kernal1';

dif1 = conv2(img, kernal1);
dif2 = conv2(img, kernal2);

dif1 = dif1(2:end-1, 2:end-1);
dif2 = dif2(2:end-1, 2:end-1);

output = (dif1 .* dif1 + dif2 .* dif2) .^ 0.5;