function [output] = HE_Voting(img, Phi, Display)
%% HE with Voting Metric
if ~exist('Display', 'var')
    Display = false;
end

if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

VotingRadius = 1;
VotingLevel = (VotingRadius * 2 + 1) ^ 2;

cnt = zeros(256, VotingLevel);
[n, m] = size(img);

Vote = ones(n, m);

for i = 1 : n
    for j = 1 : m
        for ii = max(1, i - VotingRadius) : min(n, i + VotingRadius)
            for jj = max(1, j - VotingRadius) : min(m, j + VotingRadius)
                if(img(ii, jj) < img(i, j))
                    Vote(i, j) = Vote(i, j) + 1;
                end
            end
        end
        cnt(img(i, j) + 1, Vote(i, j)) = cnt(img(i, j) + 1, Vote(i, j)) + Phi(i, j);
    end
end

index = zeros(256, VotingLevel);
D = sum(cnt, 'all') / 256 + 1e-5;
k = 0;
for i = 1 :256
    for j = 1 : VotingLevel
        index(i, j) = floor(k / D);
        k = k + cnt(i, j);
    end
end

for i = 1 : n
    for j = 1 : m
        output(i, j) = uint8(index(img(i, j) + 1, Vote(i, j)));
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
title('histogram(HE Voting Metric)', 'FontSize', 18);
subplot(2, 2, 4);
imshow(output);
title('image(HE Voting Metric)', 'FontSize', 18);