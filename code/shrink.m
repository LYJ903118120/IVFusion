function [Output]=shrink(m,n,img,Flag)
% m,n are the row and column of the image to be modified, img input image.
% Flag, 1 and 2 represent the expansion of the image into square matrix, 1 represents the expansion of 1, 2 represents the expansion of 0.
% The 3 represents recovery.

if Flag ==1%I
    if max(m,n) == m
        Output=ones(m,m);
        Output(: ,1:n)=img;
    else
        Output=ones(n,n);
        Output(1:m, :)=img;
    end
end

if Flag ==2
    if max(m,n) == m
        Output=zeros(m,m);
        Output(: ,1:n)=img;
    else
        Output=zeros(n,n);
        Output(1:m, :)=img;
    end
end

if Flag ==3
    if max(m,n) == m
        Output=zeros(m,n);
        Output=img(:,1:n);
    else
        Output=zeros(m,n);
        Output=img(1:m,:);
    end
end

end