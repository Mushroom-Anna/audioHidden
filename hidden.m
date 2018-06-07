close all;

[x,fs]=audioread('test1.wav');
x=x(1:65000)
subplot(4,1,1);plot(x);title('原test');

%音频x_offset,????offset1,offset2,??a
offset1 = 10;
offset2 = 15;
for j=1:offset1
    x_offset(j)=0;
end
for i=1:length(x)
    x_offset(i+offset1)=x(i);
end
a=0.5;
x_offset = x_offset*a;

%待隐藏数据长度n，数据vm
n = 20;
vm = [1,0,1,0,0,1,0,1,1,0,0,0,1,1,0,1,1,0,0,1];
subplot(4,1,2);imshow(vm);title('待隐藏数据')

%分段长度m
m = 1500;
x_echoded = x;
for j=1:n
    if vm(j) == 0
        for i=m*(j-1)+1 : m*(j-1)+m-offset1
            x_echoded(i)=x(i)+a*x(i+offset1);
        end
    else
        for i=m*(j-1)+1 : m*(j-1)+m-offset2
            x_echoded(i)=x(i)+a*x(i+offset2);
        end
    end
end
subplot(4,1,3);plot(x_echoded);title('echoded test');
audiowrite('output.wav',x_echoded,fs);

C=rceps(x_echoded(1:m));
if C(offset1+1)>C(offset2+1)
    vm0(1)=0;
else
    vm0(1)=1;
end
for j=2:n
    C=rceps(x_echoded(m*(j-1):m*j));
    if C(offset1+1)>C(offset2+1)
        vm0(j)=0;
    else
        vm0(j)=1;
    end
end
subplot(4,1,4);imshow(vm0);title('vm0');
