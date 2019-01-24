%==============================
%Part 1
%第一部分：去掉训练样本较少的类并提取去除后的全部数据
path='C:\Users\我爱吃鱿鱼\Desktop\高光谱目标探测和分类\分类\all\allsample\'
%导入数据
load Indian_pines_gt.mat;
load Indian_pines_corrected.mat;
%load Indian_pines.mat;
% whos indian_pines_gt  % 145x145
% indian_pines_gt(10:100,1:10)
% whos indian_pines  % 145x145x220
% indian_pines(10:100,1:10,1)
% load Indian_pines_corrected.mat;
% whos indian_pines_corrected  % 145x145x200
% indian_pines_corrected(10:100,1:10,1)

gt_size=size(indian_pines_gt);  %145x145
data_size=size(indian_pines_corrected);  %145x145x200
%获取唯一值
LabelValues = unique(indian_pines_gt);
LabelLength = size(LabelValues); %[17 1]

%去除较少样本的类
for i=[1,4,7,9,13,15,16]
	indian_pines_gt(indian_pines_gt==i)=0;
end
LabelValues = unique(indian_pines_gt);
LabelLength = size(LabelValues); %[10 1]

%依次按类别生成样本
LabelsNum = LabelLength(1,1)-1;
ClassMask_size = [gt_size(1),gt_size(2),LabelLength(1,1)];
ClassMask = zeros(ClassMask_size);

j=0;
m=[0 2 3 5 6 8 10 11 12 14];
for i=m
    ClassLog = (indian_pines_gt==i);
	%每一类的有标记的像素数量ClassNum
	ClassNum(j+1) = sum(sum(ClassLog));
	LabeledData = zeros(ClassNum(j+1),data_size(3));
	for k = 1:data_size(3)
	    clip = indian_pines_corrected(:,:,k);
        clipdata = clip(ClassLog);
        LabeledData(:,k) = clipdata;
    end
    LabeledData =  mapminmax(LabeledData, 0, 1);
    SaveName = [path,'Class',num2str(j), '.mat'];
    save(SaveName,'LabeledData');
    j=j+1;
end	

%==============================
% Part 2-1
%第二部分：每类中随机挑选200个像素

list = ls([path,'*.mat']);
% [fileNum,ig] = size(list);
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