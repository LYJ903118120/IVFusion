
% Just run the file directly

% If our thesis ideas are helpful to you, please help us light up the stars in Github, Thank you!
% If you use these code in your research, please cite:
% @conference{
%	author = {Guofa Li,Yongjie Lin,Xingda Qu},
%	title  = {An infrared and visible image fusion method based on Multi-scale Transformation and Norm Optimization},
%	booktitle = {Information Fusion},
%	year = {2021}
% }
clc;
close all;
if isempty(gcp('nocreate'))
    parpool;
end

%Parameter settings£º[50,75,100,125,150,175];
% This parameter can be adjusted to the best state according to the actual application scenario. 
% The parameter in the paper is 175.
ParaSet=100;

tic;
for i = 1:12 %Here are 12 fused images that appeared in the paper
     % Path setting
     PathIr           = [ 'input\' ,        num2str(i-1) ,        'ir.jpg' ]; 
     PathVis          = [ 'input\' ,        num2str(i-1) ,       'vis.jpg' ];
     FusionPath       = [ 'output\Ours-',   num2str(i-1) ,          '.jpg' ];
     PreFusionPath    = [ 'output\Ours-PreFus',   num2str(i-1) ,          '.jpg' ];
     WeightFusionPath = [ 'output\Ours-Weight',   num2str(i-1) ,          '.jpg' ];
     
     % Read images
     ImgIr  = imread(PathIr);  
     ImgVis = imread(PathVis);  
     
     % Convert to single channel
     if size(ImgIr, 3)~=1
         ImgIr  = rgb2gray(ImgIr);
     end
     if size(ImgVis, 3)~=1
         ImgVis = rgb2gray(ImgVis);
     end
     
     % Start fusion
     image = main(double(ImgIr),double(ImgVis),ParaSet,FusionPath,PreFusionPath,WeightFusionPath);
     
     fprintf('done!!!')

end
toc;
