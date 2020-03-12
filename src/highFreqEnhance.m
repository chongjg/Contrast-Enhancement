function [output] = highFreqEnhance(img)

if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

[n, m] = size(img);

img_fft = fftshift(fft2(img));

for i = 1 : n
    for j = 1 : m
        h(i, j) = (sqrt(((i - n / 2) / n * 2) ^ 2 + ((j - m / 2) / m * 2) ^ 2) + 1) / 2;
    end
end
img_fft = abs(ifft2(fftshift(img_fft .* h)));
img_fft = img_fft - min(img_fft, [], 'all');
img_fft = img_fft ./ max(img_fft, [], 'all');

output = uint8(round(img_fft * 255));