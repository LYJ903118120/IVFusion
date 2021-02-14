

function [ Enhance_weight ] = ACE( hight_img )

img = padarray(hight_img, [7,7], 'symmetric', 'both' );
[M,N]=size(img);
i = 1:M-15+1;
j = 1:N-15+1;
[I,J] = meshgrid(i,j);
parfor i = 1:numel(I)
    Img = img( (I(i)-1)*1+1:(I(i)-1)*1+15, (J(i)-1)*1+1:(J(i)-1)*1+15 );
    localmse(i) = mse(Img);
end
llocalmse = reshape(localmse,length(j),length(i));
Localmse  = transpose(llocalmse);

Globalmse = mse( hight_img );
Enhance_weight = (5.*Globalmse) ./ Localmse;
Enhance_weight(  Enhance_weight > 5.5 )   = 5.5;
Enhance_weight(  Enhance_weight < 4.5 )   = 4.5;
end

function [ MSE ] = mse( Image )
[m1,n1] = size( Image );
interim = (Image - Mean( Image )).^2;
MSE = sum(sum( interim )) / ( m1 * n1 );
MSE = MSE.^0.5;
end

function [ mean_value ] = Mean( image )
[ m2, n2 ] = size( image );
acc = sum(sum(image));
mean_value = acc / ( m2 * n2 );
end