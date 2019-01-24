%=====================================================
% %第一部分：提取全部数据
% %保存路径
% path = 'F:\陈伟民Matlab\1024训练数据\allsample\'
% %导入数据
% load('PaviaU_gt.mat');
% load('PaviaU.mat');
% %获得唯一值
% gt_size = size(paviaU_gt);
% data_size = size(paviaU);
% LabelValues = unique(paviaU_gt);
% LabelLength = size(LabelValues);
% %依次按类别生成样本
% LabelsNum = LabelLength(1,1)-1;
% ClassMask_size = [gt_size(1),gt_size(2),LabelLength(1,1)];
% ClassMask = zeros(ClassMask_size);
% 
% 
% for i = 0:LabelsNum
%     ClassLog = (paviaU_gt==i);
%     %每一类的有标记的像素数量ClassNum
%     ClassNum(i+1) = sum(sum(ClassLog));
%     LabeledData = zeros(ClassNum(i+1),data_size(3));
%     for l = 1:data_size(3)
%         clip = paviaU(:,:,l);
%         clipdata = clip(ClassLog);
%         LabeledData(:,l) = clipdata;
%     end
%     LabeledData =  mapminmax(LabeledData, 0, 1);
%     SaveName = [path,'Class',num2str(i), '.mat'];
%     save(SaveName,'LabeledData');
% end
%======================================================
%第二部分：每一类中随机挑选200像素
% path = 'F:\陈伟民Matlab\1024训练数据\allsample\'
% list = ls([path,'*.mat']);
% [fileNum,ig] = size(list);
% AbsorbNum = 200;
% path2 = 'F:\陈伟民Matlab\1024训练数据\rand200\'
% for i = 1:10
%     filename = strtrim(list(i,:))
%     load([path,filename]);
%     [length,band] = size(LabeledData);
%     arr = 1:length;
%     allrandId = randperm(length);
%     randId = allrandId(1:AbsorbNum);
%     SaveName = [path2,'Class',num2str(i-1),'_200', '.mat'];
%     Ab_Sample = LabeledData(randId,:);
%     save(SaveName,'Ab_Sample');
% end
%=====================================================
%第三部分：组成像素对
%第0类是背景，就不用了，文件夹里删掉
path = 'F:\陈伟民Matlab\1024训练数据\rand200\'
list = ls([path,'*.mat']);
[fileNum,ig] = size(list);
%超参数
ClassNum = 9;
BandNum = 103;
Sample_In_Class = 200;
Sample_In_Pair = 200*199;
RandSelectNum = 3;
%组成本类别像素对
% Sample = zeros(Sample_In_Pair,BandNum*2);
% for i =1:9
%     filename = strtrim(list(i,:))
%     load([path,filename]);
%     TC = 1;
%     for P1 = 1:200
%         for P2 = 1:200
%             if(P1~=P2)
%                 Sample(TC,1:103) = Ab_Sample(P1,:);
%                 Sample(TC,104:206) = Ab_Sample(P2,:);
%                 TC = TC+1;
%             end
%         end
%     end
%     path3 = 'F:\陈伟民Matlab\1024训练数据\pair\'
%     SaveName = [path3,'Class',num2str(i),'_pair', '.mat'];
%     save(SaveName,'Sample');
% end
%组成0类别像素对
%预先计算每类中随机选几个像素与其他类别配对
path4 = 'F:\1024训练数据\1024训练数据\rand200\';
fils = ls([path4,'*.mat']);
Sample = zeros(43200,206);
cc = 1;
for i = 1:9
    filename1 = fils(i,:)
    load([path4,filename1])
    NowData = Ab_Sample;
    for j = 1:9
        if(i~=j)
            filename2 = fils(j,:);
            load([path4,filename2]);
            RData = Ab_Sample;
            RandId = randperm(200);
            Selected = RData(RandId(1:3),:);
            for s1 = 1:200
                for s2 = 1:3
                    Sample(cc
                    ,1:103) = NowData(s1,:);
                    Sample(cc,104:206) = Selected(s2,:);
                    cc = cc+1;
                end
            end
        end
    end
end
cc
