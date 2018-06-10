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
audio = audio(1:n*floor(length(audio)/n));
audio = reshape(audio,[n,floor(length(audio)/n)]); %原audio竖着排列，一列1600个样点
%二维DWT，取低频分量
%DCT，取前1/4
%SVD，取对角阵，水印嵌入
%逆变换