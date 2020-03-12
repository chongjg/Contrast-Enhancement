function [output] = CACHE_RG(img, Display)
%% Contrast Accumulated Histogram Equalization
if ~exist('Display', 'var')
    Display = false;
end
if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

[n, m] = size(img);
output = ones(n, m);

L = 4;
S = 256;
eps = 1e-3;

A = cell(1, L);
phi = cell(1, L);

img = im2double(img);

for i = 1 : L
    A{i} = imresize(img, [S, round(m * S / n)]);
    S = S / 2;
end

to = [1, 0; -1 0; 0 1; 0 -1];
for l = 1 : L
    [N, M] = size(A{l});
    phi{l} = zeros(N, M);
    for i = 1 : N
        for j = 1 : M
            if(i - 1 >= 1 && i + 1 <= N)
                phi{l}(i, j) = phi{l}(i, j) + abs(A{l}(i + 1, j) - A{l}(i - 1, j));
            end
            if(j - 1 >= 1 && j + 1 <= M)
                phi{l}(i, j) = phi{l}(i, j) + abs(A{l}(i, j + 1) - A{l}(i, j - 1));
            end
        end
    end
    output = output .* max(imresize(phi{l}, [n, m]), eps);
end

if(Display)
    figure;
    set(gcf, 'outerposition', get(0, 'screensize'));
    colormap('hot');
    for k = 1 : 4
        subplot(2, 2, k);
        imagesc(phi{k});
    end
end

output = output .^ (1 / L);