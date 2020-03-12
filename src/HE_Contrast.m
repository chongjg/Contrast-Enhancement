function [output] = HE_Contrast(img, Phi, Display)
%% HE with Voting Metric and contrast difference metric
if ~exist('Display', 'var')
    Display = false;
end
if(numel(size(img)) > 2)
    img = rgb2gray(img);
end

VotingRadius = 1;
VotingLevel = (VotingRadius * 2 + 1) ^ 2;

Threshold = 10;
cnt_Rank = 3;

cnt = zeros(256, VotingLevel, cnt_Rank);
[n, m] = size(img);

Vote = ones(n, m);
RVote = zeros(n, m);
Lad = zeros(n, m);
Rad = zeros(n, m);

Rank_Contrast = zeros(n, m);

for i = 1 : n
    for j = 1 : m
        for ii = max(1, i - VotingRadius) : min(n, i + VotingRadius)
            for jj = max(1, j - VotingRadius) : min(m, j + VotingRadius)
                if(img(ii, jj) < img(i, j))
                    Vote(i, j) = Vote(i, j) + 1;
                    Lad(i, j) = Lad(i, j) + img(i, j) - img(ii, jj);
                elseif(img(ii, jj) > img(i, j))
                    RVote(i, j) = RVote(i, j) + 1;
                    Rad(i, j) = Rad(i, j) + img(ii, jj) - img(i, j);
                end
                if(Vote(i, j) > 1)
                    Lad(i, j) = Lad(i, j) / (Vote(i, j) - 1);
                end
                if(RVote(i, j) > 0)
                    Rad(i, j) = Rad(i, j) / RVote(i, j);
                end
                if(Lad(i, j) < Threshold && Threshold < Rad(i, j))
                    Rank_Contrast(i, j) = 1;
                elseif(Lad(i, j) > Threshold && Threshold > Rad(i, j))
                    Rank_Contrast(i, j) = 3;
                else
                    Rank_Contrast(i, j) = 2;
                end
            end
        end
        cnt(img(i, j) + 1, Vote(i, j), Rank_Contrast(i, j)) = cnt(img(i, j) + 1, Vote(i, j), Rank_Contrast(i, j)) + Phi(i, j);
    end
end

index = zeros(256, VotingLevel, cnt_Rank);
D = sum(cnt, 'all') / 256 + 1e-5;
k = 0;
for i = 1 :256
    for j = 1 : VotingLevel
        for r = 1 : cnt_Rank
            index(i, j, r) = floor(k / D);
            k = k + cnt(i, j, r);
        end
    end
end

for i = 1 : n
    for j = 1 : m
        output(i, j) = uint8(index(img(i, j) + 1, Vote(i, j), Rank_Contrast(i, j)));
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
title('histogram(HE Voting&Contrast Metric)', 'FontSize', 18);
subplot(2, 2, 4);
imshow(output);
title('image(HE Voting&Contrast Metric)', 'FontSize', 18);