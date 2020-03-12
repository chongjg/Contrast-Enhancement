function [output] = GHE(img, Phi, Display)
%% Global Histogram Equalization
if ~exist('Display', 'var')
    Display = false;
end
if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

cnt = zeros(1, 256);
[n, m] = size(img);
for i = 1 : n
    for j = 1 : m
        cnt(img(i, j) + 1) = cnt(img(i, j) + 1) + Phi(i, j);
    end
end

index = zeros(1, 256);
D = sum(cnt, 'all') / 256 + 1e-5;
j = 0;
for i = 1 :256
    index(i) = floor(j / D);
    j = j + cnt(i);
end

output = uint8(index(img + 1));

if(~Display)
    return
end

%% figure
figure;
set(gcf, 'outerposition', get(0, 'screensize'));

subplot(2, 2, 1);
histogram(img);
axis([0 255 0 inf]);
title('histogram(origin)', 'FontSize', 18);
subplot(2, 2, 3);
imshow(img);
title('image(origin)', 'FontSize', 18);

subplot(2, 2, 2);
histogram(output);
axis([0 255 0 inf]);
title('histogram(GHE)', 'FontSize', 18);
subplot(2, 2, 4);
imshow(output);
title('image(GHE)', 'FontSize', 18);