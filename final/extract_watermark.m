%��ȡ��ˮӡ��Ƶ
n=1600; %�ֶγ���
[audio,fs] = audioread('output.wav');
audio = reshape(audio,[n,length(audio)/n]);
[audio1,fs1] = audioread('input.wav');   %����ԭʼ��Ƶ�����������
audio1 = reshape(audio1,[n,length(audio1)/n]);

%%%����Ƶ���й���
%��Ӹ�˹����
%audio_awng = awgn(audio,20);

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

%����ֶ�ƽ�������
for j=1:length(audio)
    if(audio(:,i)==audio1(:,i))
        SNR(i)=100;
    else
        o = 1/n*sum((audio1(:,i)-mean(audio1(:,i))).^2);
        d = 1/n*sum((audio1(:,i)-audio(:,i)).^2);
        SNR(i)=10*log10(o/d);
    end
end
aveSNR = 1/length(SNR)*sum(SNR)



