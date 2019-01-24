
%======================================
% Part 3-1
%test配对
load Salinas_gt.mat;
load Salinas_corrected.mat;
gt_size=size(salinas_gt);  %[512 217]
data_size=size(salinas_corrected);  %[512 217 204]
LabelValues = unique(salinas_gt);
LabelLength = size(LabelValues); %[17 1]
LabelsNum = LabelLength(1,1)-1;

load randId.mat;
%标记下200个用于训练的数据
Rand_id=zeros(gt_size(1),gt_size(2));
for k=0:LabelsNum;
    c=0;
    c1=0;
    ClassLog = (salinas_gt==k);
    for i=1:gt_size(1)
        for j=1:gt_size(2)
		    if(ClassLog(i,j)==1)
			    c=c+1;
				if(sum(c==randId(k+1,:))==1)
                    c1=c1+1;
	                Rand_id(i,j)=1;
				end
			end
		end
    end
    c
    c1
end

%对salinas_corrected进行归一化处理
for i=1:gt_size(1)
    for j=1:gt_size(2)
        b=salinas_corrected(i,j,:);
	    mx=max(b);
        mn=min(b);
        b=(b-mn)/(mx-mn);
        salinas_corrected(i,j,:)=b;
    end
end

Rand_id_new=zeros(gt_size(1)+2,gt_size(2)+2);
salinas_corrected_new=zeros(data_size(1)+2,data_size(2)+2,data_size(3));
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
        Rand_id_new(i,j)= Rand_id(i-1,j-1);
	    for k = 1:data_size(3)
		    salinas_corrected_new(i,j,k)=salinas_corrected(i-1,j-1,k);
        end
    end
end
%======================================
Test_In_Pair = 512*217-200*17;
BandNum = 204;

Sample = zeros(Test_In_Pair*8,BandNum*2);
T=0;
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
        if(Rand_id_new(i,j)==0)
	        c=0;
	        while c<8
                c=c+1;
	            Sample(T*8+c,1:204) = salinas_corrected_new(i,j,:);
			    if(c==1)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i-1,j,:);
                end
			    if(c==2)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i-1,j-1,:);
                end
			    if(c==3)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i,j-1,:);
                end
			    if(c==4)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i-1,j+1,:);
                end
			    if(c==5)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i,j+1,:);
                end
			    if(c==6)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i+1,j+1,:);
                end
			    if(c==7)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i+1,j,:);
                end
			    if(c==8)
	                Sample(T*8+c,205:408) = salinas_corrected_new(i+1,j-1,:);
                end
            end
		    T=T+1;
        end
	end
end
T
path3='C:\Users\我爱吃鱿鱼\Desktop\高光谱目标探测和分类\分类\all\test+\'
SaveName = [path3,'test', '.mat'];
save(SaveName,'Sample');

%======================================
% .mat转.csv
a=1:408;
list = ls([path3,'*.mat']);
filename = strtrim(list(1,:))
load([path3,filename]);
a=[a;Sample];
csvwrite('test.csv',a);


