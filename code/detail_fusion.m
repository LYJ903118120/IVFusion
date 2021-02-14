
% If our thesis ideas are helpful to you, please help us light up the stars in Github, Thank you!
% If you use these code in your research, please cite:
% @conference{
%	author = {Guofa Li,Yongjie Lin,Xingda Qu},
%	title  = {An infrared and visible image fusion method based on Multi-scale Transformation and Norm Optimization},
%	booktitle = {Information Fusion},
%	year = {2021}
% }

function [ Sal ] = detail_fusion( ImgTexture_1, ImgTexture_2, Weight )
% ImgTexture_1: Visble image Detail
% ImgTexture_2: Infared image Detail
% Weight: Balance Para
D_F=cell(1,4);
parfor j = 1:3
    
    gain1_matrix = ACE(ImgTexture_1{5-j});
    gain2_matrix = ACE(ImgTexture_2{5-j});
    D_F{5-j} = L2(gain1_matrix.*ImgTexture_1{5-j}, gain2_matrix.*ImgTexture_2{5-j}, Weight  );
    
end

sigma0 = 0.2;
w = floor(3*sigma0);
h = fspecial('gaussian', [2*w+1, 2*w+1], sigma0);   
C_0 = double(abs(ImgTexture_1{1}) < abs(ImgTexture_2{1}));
c_0 = imfilter(C_0, h, 'symmetric');
D_F{1} = c_0.*ImgTexture_2{1} + (1-c_0).*ImgTexture_1{1};

Sal = D_F{1}+D_F{2}+D_F{3}+ D_F{4};

end



