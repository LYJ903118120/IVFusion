function [score] = ssim(img1, img2)

%接下来开始处理
img1 = double(img1);
img2 = double(img2);

C1 = 162.5625;
C2 = 162.5625;
window =        [0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156
                 0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156    0.0156];

mu1   = filter2(window, img1, 'valid');
mu2   = filter2(window, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;

sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;


ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));


score = mean2(ssim_map);

return





