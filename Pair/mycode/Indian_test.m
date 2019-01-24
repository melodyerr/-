%======================================
% Part 3-2
%不含200个
load Indian_pines_gt.mat;
load Indian_pines_corrected.mat;
gt_size=size(indian_pines_gt);  %145x145
data_size=size(indian_pines_corrected);  %145x145x200

%获取唯一值
LabelValues = unique(indian_pines_gt);
LabelLength = size(LabelValues); %[17 1]

%去除较少样本的类
for i=[1,4,7,9,13,15,16]
	indian_pines_gt(indian_pines_gt==i)=0;
end

load randId.mat;
%标记下200个用于训练的数据
Rand_id=zeros(gt_size(1),gt_size(2));
k=0;
for i=[0 2 3 5 6 8 10 11 12 14];
    k=k+1;
    c=0;
    c1=0;
    ClassLog = (indian_pines_gt==i);
    for i=1:gt_size(1)
        for j=1:gt_size(2)
		    if(ClassLog(i,j)==1)
			    c=c+1;
				if(sum(c==randId(k,:))==1)
                    c1=c1+1;
	                Rand_id(i,j)=1;
				end
			end
		end
    end
    c
    c1
end

%对indian_pines_corrected进行归一化处理
for i=1:gt_size(1)
    for j=1:gt_size(2)
        b=indian_pines_corrected(i,j,:);
	    mx=max(b);
        mn=min(b);
        b=(b-mn)/(mx-mn);
        indian_pines_corrected(i,j,:)=b;
    end
end
Rand_id_new=zeros(gt_size(1)+2,gt_size(2)+2);
indian_pines_corrected_new=zeros(data_size(1)+2,data_size(2)+2,data_size(3));
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
        Rand_id_new(i,j)= Rand_id(i-1,j-1);
	    for k = 1:data_size(3)
		    indian_pines_corrected_new(i,j,k)=indian_pines_corrected(i-1,j-1,k);
        end
    end
end
%======================================	  
Test_In_Pair = 145*145-200*10;
BandNum = 200;

Sample1 = zeros(Test_In_Pair*8,BandNum*2);
T=0;
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
        if(Rand_id_new(i,j)==0)
	        c=0;
	        while c<8
                c=c+1;
	            Sample1(T*8+c,1:200) = indian_pines_corrected_new(i,j,:);
			    if(c==1)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i-1,j,:);
                end
			    if(c==2)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i-1,j-1,:);
                end
			    if(c==3)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i,j-1,:);
                end
			    if(c==4)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i-1,j+1,:);
                end
			    if(c==5)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i,j+1,:);
                end
			    if(c==6)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i+1,j+1,:);
                end
			    if(c==7)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i+1,j,:);
                end
			    if(c==8)
	                Sample1(T*8+c,201:400) = indian_pines_corrected_new(i+1,j-1,:);
                end
            end
            T=T+1;
        end
	end
end
T
path4='C:\Users\我爱吃鱿鱼\Desktop\高光谱目标探测和分类\分类\all\test-\'
SaveName = [path4,'test2', '.mat'];
save(SaveName,'Sample1');
%======================================
% .mat转.csv
a=1:400;
list = ls([path4,'*.mat']);
filename = strtrim(list(1,:))
load([path4,filename]);
a=[a;Sample1];
csvwrite('test2.csv',a);