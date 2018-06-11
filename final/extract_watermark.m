%��ȡ��ˮӡ��Ƶ
n=1600; %�ֶγ���
[audio,fs] = audioread('output.wav');
audio = reshape(audio,[n,length(audio)/n]);

delta = 0.5;
len = 73*73;
for i=1:len
    %1ά2��DWT
    [cA1,cD1] = dwt(audio(:,i),'haar');
    [cA2,cD2] = dwt(cA1,'haar');
    cA2dct = dct(cA2);
    Y = cA2dct(1:100);
    jsi = reshape(Y,[10,10]);
    [U,S,V] = svd(jsi);
    if(mod(round(S(1,1)/(S(2,2)*delta)),2)==0)
        watermark(i)=0;
    else
        watermark(i)=1;
    end
end
watermark = reshape(watermark,[73,73]);
imshow(watermark');
imwrite(watermark','extract_cuc.jpg');
