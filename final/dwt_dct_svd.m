close all;
%载入水印图片，处理
cuc = imread('cuc.jpeg');
cuc_resize = imresize(cuc,[73,73]); %变小
cuc_resize = rgb2gray(cuc_resize);
cuc = imbinarize(cuc_resize);   %二值化
imshow(cuc_resize);
[M,N] = size(cuc_resize);
cuc_resize = reshape(cuc_resize,[1,M*N]);   %转换为1维
%载入音频，分段
[audio,fs] = audioread('校园里有一排年轻的白杨.wav');
audio = audio(:,1);
figure(2);
subplot(2,1,1);plot(audio);ylim([-1.5 1.5]);
n = 1600; %分段长度
len = n*floor(length(audio)/n);%保留的音频长度
audio = audio(1:len);
audio_reshape = reshape(audio,[n,floor(length(audio)/n)]); %原audio竖着排列，一列1600个样点

delta = 0.5;%水印参数
audio1 = audio_reshape;
for i=1:size(cuc_resize)
    %一维二级DWT，取低频分量
    [cA1,cD1] = dwt(audio_reshape(:,i),'haar');
    [cA2,cD2] = dwt(cA1,'haar');
    %DCT，取前1/4
    cA2dct = dct(cA2);
    Y = cA2dct(1:100,:);
    jsi = reshape(Y,[10,10]);
    [U,S,V] = svd(jsi);
    S1 = S;
    %SVD，取对角阵，对每个S(1,1)进行水印嵌入
    %根据D的奇偶性进行水印嵌入
    D = floor(S(1,1)/(S(2,2)*delta)); 
    if(mod(D,2) == 0)
        if (cuc_resize(i) == 1)                                       
            S1(1,1) = S(2,2)*delta*(D+1);  
        else   
            S1(1,1) = S(2,2)*delta*D;  
        end  
    else                                   
        if (cuc_resize(i) == 1)  
            S1(1,1) = S(2,2)*delta*D; 
        else  
            S1(1,1) = S(2,2)*delta*(D+1);  
        end  
    end  
    %逆变换
    jsi1 = U*S1*V';
    Y1 = reshape(jsi1,[100,1]);
    cA2dct1 = cA2dct;
    cA2dct1(1:100) = Y1;  %用Y1替换原cA2dct前1/4
    cA21 = idct(cA2dct1);  %dct逆变换
    cA11 = idwt(cA21,cD2,'haar');
    audio1(:,i) = idwt(cA11,cD1,'haar');
end
audio1 = reshape(audio1,[len,1]);
subplot(2,1,2);plot(audio1); ylim([-1.5 1.5]);
audiowrite('output.wav',audio1,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入完毕

