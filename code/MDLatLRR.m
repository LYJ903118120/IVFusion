
% @article{li2020mdlatlrr,
% author = {Li, Hui and Wu, Xiao-Jun and Kittler, Josef},
% title = {MDLatLRR: A novel decomposition method for infrared and visible image fusion},
% note = {doi: 10.1109/TIP.2020.2975984},
% year = {2020},
% journal = {IEEE Transactions on Image Processing},
% publisher={IEEE}
% }

%4-scale,Lrr(1,1),salient(1,4)
function  [ Lrr, Salient ] = MDLatLRR(image)

load('L_16_detail_mix_2000_s1000.mat');

is_block = 0;
L = L_16;unit = 16;level = 4;stride = 1;

[h,w] = size(image);
Image = zeros(h,w);

if h>512 || w>512
    % get image block
    is_block = 1;
    [img1, img2, img3, img4] = getImgBlock(image);

end
                
if is_block == 1
    
   
  
    [B_1,D_1]       = vector_dec(img1, L, unit, level, stride);        %B_1(1,1),D_1(1,4)
    
    [B_2,D_2]       = vector_dec(img2, L, unit, level, stride);        %B_2(1,1),D_2(1,4)
  
    [B_3,D_3]       = vector_dec(img3, L, unit, level, stride);        %B_3(1,1),D_3(1,4)

    [B_4,D_4]       = vector_dec(img4, L, unit, level, stride);        %B_4(1,1),D_4(1,4)
    %Lrr = connect(Image,B_1,B_2,B_3,B_4);
  
    [Lrr,Salient]   = reconsFromBlock(Image,B_1, D_1, B_2, D_2, B_3, D_3, B_4, D_4);%Lrr(1,4),salient(1,1)
 
else
    if is_block == 0
        [Lrr,Salient]   = vector_dec(image, L, unit, level, stride);      %Lrr(1,4),salient(1,1)
    end

end

end

function [B,D] = vector_dec(imag, L, unit, level, stride)


B = imag;
D = cell(1,4);
for x = 1:level
   
    [D{x}, B] = vector_decomposition(B, L, unit, stride);
    
end
  

end



function [I_d,I_b] = vector_decomposition(img1, L, unit, stride)

[t1,t2] = size(img1);
h = t1;
w = t2;
s = stride;

% calculate image patch number, h_num and w_num

% resize input image
h_dis = ceil((t1-unit)/s)*(s) - (t1-unit);
w_dis = ceil((t2-unit)/s)*(s) - (t2-unit);
h = h_dis + t1;
w = w_dis + t2;
h_num = ceil((h-unit)/s)+1;
w_num = ceil((w-unit)/s)+1;


img = zeros(h, w);


img(1:t1, 1:t2) = img1(:,:);

if h_dis ~= 0
    img(t1:t1+h_dis, 1:t2) = img1(t1-h_dis:end, 1:end);
end

if w_dis ~= 0
    img(:, t2:t2+w_dis) = img(:, t2-w_dis:t2);
end

% salient parts by latlrr
I_d = zeros(h, w);
% the matrices for overlapping
count_matric = zeros(h, w);
ones_matric = ones(unit,unit);


    
c1 = 0;
    
for i=1:s:h-unit+1
    c2 = 0;
    c1 = c1+1;
    for j=1:s:w-unit+1
        c2 = c2+1;
        temp = img(i:(i+unit-1), j:(j+unit-1));
        temp_vector(:,(c1-1)*(w_num)+c2) = temp(:);
        % record the overlapping number
        count_matric(i:(i+unit-1), j:(j+unit-1)) =...
            count_matric(i:(i+unit-1), j:(j+unit-1)) + ones_matric(:, :);
                
    end
        
end

% img_vector = temp_vector;
% calculate features
I_d_v = L*temp_vector;
c1 = 0;
    
for ii=1:s:h-unit+1
    c2 = 0;
    c1 = c1+1;
    for jj=1:s:w-unit+1
        c2 = c2+1;
        temp = I_d_v(:, (c1-1)*(w_num)+c2);
        I_d(ii:(ii+unit-1), jj:(jj+unit-1)) = I_d(ii:(ii+unit-1), jj:(jj+unit-1)) + reshape(temp, [unit unit]);
    end
end

    
% average operation for overlapping position
I_d = I_d./count_matric;
% I_d = I_d(1:t1, 1:t2);


% base parts
I_b = img - I_d;

end




function [ lrr,salient ] = reconsFromBlock(Image, b_1, d_1, b_2, d_2, b_3, d_3, b_4, d_4)



lrr = connect(Image,b_1,b_2,b_3,b_4);


salient = cell(1,4);
for i = 1:4
    salient{i} = connect(Image, d_1{i},d_2{i},d_3{i},d_4{i});
end
    


end


function [Img_a] = connect(img_temp,img1,img2,img3,img4)

count = img_temp;
[h, w] = size(img_temp);
temp_ones = ones(h, w);
Img_a = ones(h, w);
h_cen = floor(h/2);
w_cen = floor(w/2);
% 
% Img_a(1:h_cen+2, 1:w_cen+2) = img1;
% Img_a(1:h_cen+2, w_cen+3:w) = img2;
% Img_a(h_cen+3:h, 1:w_cen+2) = img3;
% Img_a(h_cen+3:h, w_cen+3:w) = img4;

img_temp(1:h_cen+2, 1:w_cen+2)      = img_temp(1:h_cen+2, 1:w_cen+2)+img1;
count(1:h_cen+2, 1:w_cen+2)         = count(1:h_cen+2, 1:w_cen+2)+temp_ones(1:h_cen+2, 1:w_cen+2);
% % 
img_temp(1:h_cen+2, w_cen-1:w)      = img_temp(1:h_cen+2, w_cen-1:w)+img2;
count(1:h_cen+2, w_cen-1:w)         = count(1:h_cen+2, w_cen-1:w)+temp_ones(1:h_cen+2, w_cen-1:w);
% % 
img_temp(h_cen-1:h, 1:w_cen+2)      = img_temp(h_cen-1:h, 1:w_cen+2)+img3;
count(h_cen-1:h, 1:w_cen+2)         = count(h_cen-1:h, 1:w_cen+2)+temp_ones(h_cen-1:h, 1:w_cen+2);
% % 
img_temp(h_cen-1:h, w_cen-1:w)      = img_temp(h_cen-1:h, w_cen-1:w)+img4;
count(h_cen-1:h, w_cen-1:w)         = count(h_cen-1:h, w_cen-1:w)+temp_ones(h_cen-1:h, w_cen-1:w);
% 
Img_a = img_temp ./ count;

end


function [img1, img2, img3, img4] = getImgBlock(img)

[h, w] = size(img);
h_cen = floor(h/2);
w_cen = floor(w/2);

img1 = img(1:h_cen+2, 1:w_cen+2);
img2 = img(1:h_cen+2, w_cen-1:w);
img3 = img(h_cen-1:h, 1:w_cen+2);
img4 = img(h_cen-1:h, w_cen-1:w);


end