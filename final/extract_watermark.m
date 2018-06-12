close all
%��ȡ��ˮӡ��Ƶ
n=1600; %�ֶγ���
[output,fs] = audioread('output.wav');
output = reshape(output,[n,length(output)/n]);
audio = output;
[audio1,fs1] = audioread('input.wav');   %����ԭʼ��Ƶ�����������
audio1 = reshape(audio1,[n,length(audio1)/n]);

%����ֶ�ƽ�������(��ˮӡ��δ�ܵ���������Ƶ����ˮӡ��Ƶ)
for j=1:length(output)
    if(output(:,j)==audio1(:,j))
        SNR(j)=100;
    else
        o = 1/n*sum((audio1(:,j)-mean(audio1(:,j))).^2);
        d = 1/n*sum((audio1(:,j)-output(:,j)).^2);
        SNR(j)=10*log10(o/d);
    end
end
aveSNR = 1/length(SNR)*sum(SNR)

%%%����Ƶ���й���
%audio = awgn(audio,20);%��Ӹ�˹����

%audio_resample = resample(audio, fs/2, fs);
%audio = resample(audio_resample, fs, fs/2);%�ز������ȱ�Ϊfs/2���ٱ��fs

%[B1,B2]=butter(6,11025/(fs/2),'low'); %��ֹƵ��Ϊ11025Hz�ĵ�ͨ�˲�
%audio = filter(B1,B2,audio);

%[audio16bit,fs16bit] = audioread('output16bit.wav'); %������16bit-8bit-16bit
%audio = reshape(audio16bit,[n,length(audio16bit)/n]);

%[audio32kbs,fs32kbs] = audioread('output32kbs.mp3'); %32kbit/smp3ѹ��
%audio = reshape(audio32kbs,[n/4,length(audio32kbs)/(n/4)]);

%[audio64kbs,fs64kbs] = audioread('output64kbs.mp3'); %64kbit/smp3ѹ��
%audio = reshape(audio64kbs,[n/2,length(audio64kbs)/(n/2)]);

%[audio128kbs,fs128kbs] = audioread('output128kbs.mp3'); %128kbit/smp3ѹ��
%audio = reshape(audio128kbs,[n,length(audio128kbs)/(n)]);

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

%����NCֵ��������
origin_watermark = imread('origin_watermark.jpg');
origin_watermark = double(origin_watermark); %����ʱΪunit8���޷�������һ������
NC = corrcoef(watermark,origin_watermark);
NC = NC(2,1)  %(1,1)��(2,2)�����(1,2)(2,1)�����
[number,ratio] = symerr(watermark,origin_watermark) 


