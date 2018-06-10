close all;
%����ˮӡͼƬ������
cuc = imread('cuc.jpeg');
cuc = rgb2gray(cuc);
cuc = imbinarize(cuc);   %��ֵ��
imshow(cuc);
[M,N] = size(cuc);
cuc = reshape(cuc,[1,M*N]);   %ת��Ϊ1ά
%������Ƶ���ֶ�
[audio,fs] = audioread('У԰����һ������İ���.wav');
audio = audio(:,1);
n = 1600; %�ֶγ���
len = n*floor(length(audio)/n);%��������Ƶ����
audio = audio(1:len);
audio = reshape(audio,[n,floor(length(audio)/n)]); %ԭaudio�������У�һ��1600������

delta = 0.5;%ˮӡ����
%for i=1:floor(length(audio)/n)
    %һά����DWT��ȡ��Ƶ����
    [cA,cD] = dwt(audio(:,50),'haar');
    [cA2,cD2] = dwt(cA,'haar');
    %DCT��ȡǰ1/4
    cA2dct = dct(cA2);
    Y = cA2dct(1:100,:);
    jsi = reshape(Y,[10,10]);
    [U,S,V] = svd(jsi);
    %SVD��ȡ�Խ��󣬶�ÿ��S(1,1)����ˮӡǶ��
    %����D����ż�Խ���ˮӡǶ��
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
    %��任
    Y1 = U*S*V';
    Y1 = reshape(Y1,[100,1]);
    cA2dct(1:100) = Y1;  %��Y1�滻ԭcA2dctǰ1/4
    Calw = idct(cA2dct);  %dct��任
    cA = idwt(Calw,cD2,'haar');
    audio(:,50) = idwt(cA,cD,'haar');
%end
    audio = reshape(audio,[1,len]);