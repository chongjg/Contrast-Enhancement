function [output] = HE_Neighborhood(img, Display)
%% HE with Neighborhood Metric
if ~exist('Display', 'var')
    Display = false;
end

if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

NeighborRadius = 1;

[n, m] = size(img);

pixels = zeros(n * m, 4);
cnt = 1;

for i = 1 : n
    for j = 1 : m
        s = 0;
        for ii = max(1, i - NeighborRadius) : min(n, i + NeighborRadius)
            for jj = max(1, j - NeighborRadius) : min(m, j + NeighborRadius)
                if(img(ii, jj) < img(i, j))
                    s = s + img(i, j) - img(ii, jj);
                end
            end
        end
        pixels(cnt, :) = [double(img(i, j)), double(s), i, j];
        cnt = cnt + 1;
    end
end

pixels = sortrows(pixels);

D = n * m / 256 + 1e-5;
output = uint8(zeros(n, m));
output(pixels(1, 3), pixels(1, 4)) = 0;

for i = 2 : n * m
    if(pixels(i, 1) == pixels(i - 1, 1) && pixels(i, 2) == pixels(i - 1, 2))
        output(pixels(i, 3), pixels(i, 4)) = output(pixels(i - 1, 3), pixels(i - 1, 4));
    else
        output(pixels(i, 3), pixels(i, 4)) = floor(i / D);
    end
end

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
title('histogram(HE Neighborhood Metric)', 'FontSize', 18);
subplot(2, 2, 4);
imshow(output);
title('image(HE Neighborhood Metric)', 'FontSize', 18);