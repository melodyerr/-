%==============================
%Part 1
%第一部分：去掉训练样本较少的类并提取去除后的全部数据
path='C:\Users\我爱吃鱿鱼\Desktop\高光谱目标探测和分类\分类\all\allsample\'
%导入数据
load PaviaU_gt.mat;
load PaviaU.mat;
% whos paviaU_gt
% paviaU_gt(10:100,1:10)
% whos paviaU
% paviaU(10:100,1:10,1)

gt_size=size(paviaU_gt);  %610x340
data_size=size(paviaU);  %610x340x103
%获取唯一值
LabelValues = unique(paviaU_gt);
LabelLength = size(LabelValues); %[10 1]

%依次按类别生成样本
LabelsNum = LabelLength(1,1)-1;
ClassMask_size = [gt_size(1),gt_size(2),LabelLength(1,1)];
ClassMask = zeros(ClassMask_size);


for i=0:LabelsNum
    ClassLog = (paviaU_gt==i);
	%每一类的有标记的像素数量ClassNum
	ClassNum(i+1) = sum(sum(ClassLog));
	LabeledData = zeros(ClassNum(i+1),data_size(3));
	for k = 1:data_size(3)
	    clip = paviaU(:,:,k);
        clipdata = clip(ClassLog);
        LabeledData(:,k) = clipdata;
    end
    LabeledData =  mapminmax(LabeledData, 0, 1);
    SaveName = [path,'Class',num2str(i), '.mat'];
    save(SaveName,'LabeledData');
end	
%==============================
% Part 2-1
%第二部分：每类中随机挑选200个像素

list = ls([path,'*.mat']);
AbsorbNum = 200;
randId = zeros(10,200);
path1='C:\Users\我爱吃鱿鱼\Desktop\高光谱目标探测和分类\分类\all\sample200\'
for i=1:10
    filename = strtrim(list(i,:))
	load([path,filename]);
	[length,band] = size(LabeledData);
	allrandId = randperm(length);  % randperm(4)-> [1 4 3 2]
	randId(i,:) = allrandId(1:AbsorbNum);
	SaveName = [path1,'Class',num2str(i-1),'_200', '.mat'];
	Ab_Sample = LabeledData(randId(i,:),:);
	save(SaveName,'Ab_Sample');
end
SaveName = ['randId', '.mat'];
save(SaveName,'randId');
