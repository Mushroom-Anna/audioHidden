close all;
%载入水印图片，处理
cuc = imread('cuc.jpeg');
cuc = rgb2gray(cuc);
cuc = imbinarize(cuc);   %二值化
imshow(cuc);
[M,N] = size(cuc);
cuc = reshape(cuc,[1,M*N]);   %转换为1维
%载入音频，分段
[audio,fs] = audioread('校园里有一排年轻的白杨.wav');
audio = audio(:,1);
n = 1600; %分段长度
len = n*floor(length(audio)/n);%保留的音频长度
audio = audio(1:len);
audio = reshape(audio,[n,floor(length(audio)/n)]); %原audio竖着排列，一列1600个样点

delta = 0.5;%水印参数
%for i=1:floor(length(audio)/n)
    %一维二级DWT，取低频分量
    [cA,cD] = dwt(audio(:,50),'haar');
    [cA2,cD2] = dwt(cA,'haar');
    %DCT，取前1/4
    cA2dct = dct(cA2);
    Y = cA2dct(1:100,:);
    jsi = reshape(Y,[10,10]);
    [U,S,V] = svd(jsi);
    %SVD，取对角阵，对每个S(1,1)进行水印嵌入
    %根据D的奇偶性进行水印嵌入
    D = floor(S(1,1)/(S(2,2)*delta)); 
    if(mod(D,2) == 0)
        if (cuc(50) == 1)                                       
            S(1,1) = S(2,2)*delta*(D+1);  
        else   
            S(1,1) = S(2,2)*delta*D;  
        end  
    else                                   
        if (cuc(50) == 1)  
            S(1,1) = S(2,2)*delta*D; 
        else  
            S(1,1) = S(2,2)*delta*(D+1);  
        end  
    end  
    %逆变换
    Y1 = U*S*V';
    Y1 = reshape(Y1,[100,1]);
    cA2dct(1:100) = Y1;  %用Y1替换原cA2dct前1/4
    Calw = idct(cA2dct);  %dct逆变换
    cA = idwt(Calw,cD2,'haar');
    audio(:,50) = idwt(cA,cD,'haar');
%end
    audio = reshape(audio,[1,len]);