close all;
%����ˮӡͼƬ������
cuc = imread('cuc.jpeg');
cuc_resize = imresize(cuc,[73,73]); %��С
cuc_resize = rgb2gray(cuc_resize);
cuc = imbinarize(cuc_resize);   %��ֵ��
imshow(cuc_resize);
[M,N] = size(cuc_resize);
cuc_resize = reshape(cuc_resize,[1,M*N]);   %ת��Ϊ1ά
%������Ƶ���ֶ�
[audio,fs] = audioread('У԰����һ������İ���.wav');
audio = audio(:,1);
figure(2);
subplot(2,1,1);plot(audio);ylim([-1.5 1.5]);
n = 1600; %�ֶγ���
len = n*floor(length(audio)/n);%��������Ƶ����
audio = audio(1:len);
audio_reshape = reshape(audio,[n,floor(length(audio)/n)]); %ԭaudio�������У�һ��1600������

delta = 0.5;%ˮӡ����
audio1 = audio_reshape;
for i=1:size(cuc_resize)
    %һά����DWT��ȡ��Ƶ����
    [cA1,cD1] = dwt(audio_reshape(:,i),'haar');
    [cA2,cD2] = dwt(cA1,'haar');
    %DCT��ȡǰ1/4
    cA2dct = dct(cA2);
    Y = cA2dct(1:100,:);
    jsi = reshape(Y,[10,10]);
    [U,S,V] = svd(jsi);
    S1 = S;
    %SVD��ȡ�Խ��󣬶�ÿ��S(1,1)����ˮӡǶ��
    %����D����ż�Խ���ˮӡǶ��
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
    %��任
    jsi1 = U*S1*V';
    Y1 = reshape(jsi1,[100,1]);
    cA2dct1 = cA2dct;
    cA2dct1(1:100) = Y1;  %��Y1�滻ԭcA2dctǰ1/4
    cA21 = idct(cA2dct1);  %dct��任
    cA11 = idwt(cA21,cD2,'haar');
    audio1(:,i) = idwt(cA11,cD1,'haar');
end
audio1 = reshape(audio1,[len,1]);
subplot(2,1,2);plot(audio1); ylim([-1.5 1.5]);
audiowrite('output.wav',audio1,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ˮӡǶ�����

