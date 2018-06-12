close all
%读取含水印音频
n=1600; %分段长度
[output,fs] = audioread('output.wav');
output = reshape(output,[n,length(output)/n]);
audio = output;
[audio1,fs1] = audioread('input.wav');   %载入原始音频，计算信噪比
audio1 = reshape(audio1,[n,length(audio1)/n]);

%计算分段平均信噪比(有水印，未受到攻击的音频和无水印音频)
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

%%%对音频进行攻击
%audio = awgn(audio,20);%添加高斯白噪

%audio_resample = resample(audio, fs/2, fs);
%audio = resample(audio_resample, fs, fs/2);%重采样，先变为fs/2，再变回fs

%[B1,B2]=butter(6,11025/(fs/2),'low'); %截止频率为11025Hz的低通滤波
%audio = filter(B1,B2,audio);

%[audio16bit,fs16bit] = audioread('output16bit.wav'); %重量化16bit-8bit-16bit
%audio = reshape(audio16bit,[n,length(audio16bit)/n]);

%[audio32kbs,fs32kbs] = audioread('output32kbs.mp3'); %32kbit/smp3压缩
%audio = reshape(audio32kbs,[n/4,length(audio32kbs)/(n/4)]);

%[audio64kbs,fs64kbs] = audioread('output64kbs.mp3'); %64kbit/smp3压缩
%audio = reshape(audio64kbs,[n/2,length(audio64kbs)/(n/2)]);

%[audio128kbs,fs128kbs] = audioread('output128kbs.mp3'); %128kbit/smp3压缩
%audio = reshape(audio128kbs,[n,length(audio128kbs)/(n)]);

delta = 0.5;
len = 73*73;
for i=1:len
    %1维2级DWT
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

%计算NC值和误码率
origin_watermark = imread('origin_watermark.jpg');
origin_watermark = double(origin_watermark); %读入时为unit8，无法参与下一步计算
NC = corrcoef(watermark,origin_watermark);
NC = NC(2,1)  %(1,1)和(2,2)自相关(1,2)(2,1)互相关
[number,ratio] = symerr(watermark,origin_watermark) 


