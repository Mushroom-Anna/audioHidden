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
audio = audio(1:n*floor(length(audio)/n));
audio = reshape(audio,[n,floor(length(audio)/n)]); %ԭaudio�������У�һ��1600������
%��άDWT��ȡ��Ƶ����
[cA,cD] = dwt(audio(:,50),'haar');
[cA2,cD2] = dwt(cA,'haar');
%DCT��ȡǰ1/4
Y = dct(cA2);
Y = Y(1:100,:);
jsi = reshape(Y,[10,10]);
[U,S,V] = svd(jsi);
%SVD��ȡ�Խ���ˮӡǶ��
%��任