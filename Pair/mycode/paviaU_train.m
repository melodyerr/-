
%==============================
% Part 2-2
%�������֣�������ض�
%==============================
%��0���Ǳ��������ã�ɾ����

list = ls([path1,'*.mat']);
% [fileNum,ig] = size(list);

%������
ClassNum = 9;
BandNum = 103;
Sample_In_Class = 200;
Sample_In_Pair = 200*199;
RandSelectNum = 3;

%�����ͬ������ض�
Sample = zeros(Sample_In_Pair,BandNum*2);
for i=1:ClassNum
    filename = strtrim(list(i,:))
	load([path1,filename]);
	TC=1;
	for P1=1:200
	    for P2=1:200
		    if(P1~=P2)
			    Sample(TC,1:103) = Ab_Sample(P1,:);
                Sample(TC,104:206) = Ab_Sample(P2,:);
                TC=TC+1;
            end
        end
    end
	path2='C:\Users\�Ұ�������\Desktop\�߹���Ŀ��̽��ͷ���\����\all\pair\'
	SaveName = [path2,'Class',num2str(i),'_pair', '.mat'];
	save(SaveName,'Sample');
end	
%=================================
	
%���0������ض�
fils = ls([path1,'*.mat']);
Sample = zeros(43200,206);
cc = 1;
for i = 1:ClassNum  % 9
    filename1 = fils(i,:)
    load([path1,filename1])
    NowData = Ab_Sample;
    for j = 1:ClassNum  % 9
        if(i~=j)
            filename2 = fils(j,:);
            load([path1,filename2]);
            RData = Ab_Sample;
            RandId = randperm(200);
            Selected = RData(RandId(1:3),:);
            for s1 = 1:200
                for s2 = 1:3
                    Sample(cc,1:103) = NowData(s1,:);
                    Sample(cc,104:206) = Selected(s2,:);
                    cc = cc+1;
                end
            end
        end
    end
end
SaveName = [path2,'Class0_pair', '.mat'];
save(SaveName,'Sample');
cc  %43201
%======================================
% .matת.csv
a=1:206;
list = ls([path2,'*.mat']);
for i=1:ClassNum+1
    filename = strtrim(list(i,:))
	load([path2,filename]);
    b=Sample;
    a=[a;b];
end
csvwrite('pair_data.csv',a);
b=zeros(401401,1);  % 200*199*9+8*9*3*200+1=401401
b(1)=1;  %list��
t=39800;
n=cc;
for i=1:ClassNum
    b(n+1:n+t)=i;
    n=n+t;
end
csvwrite('pair_label.csv',b);