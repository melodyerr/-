
%======================================
% Part 3-1
%test���
load Indian_pines_gt.mat;
load Indian_pines_corrected.mat;
gt_size=size(indian_pines_gt);  %145x145
data_size=size(indian_pines_corrected);  %145x145x200

%��indian_pines_corrected���й�һ������
for i=1:gt_size(1)
    for j=1:gt_size(2)
        b=indian_pines_corrected(i,j,:);
	    mx=max(b);
        mn=min(b);
        b=(b-mn)/(mx-mn);
        indian_pines_corrected(i,j,:)=b;
    end
end

indian_pines_corrected_new=zeros(data_size(1)+2,data_size(2)+2,data_size(3));
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
	    for k = 1:data_size(3)
		    indian_pines_corrected_new(i,j,k)=indian_pines_corrected(i-1,j-1,k);
        end
    end
end
%======================================
%����200��	
Test_In_Pair = 145*145-200*10;
BandNum = 200;

Sample = zeros((Test_In_Pair+200*10)*8,BandNum*2);
T=0;
for i=2:gt_size(1)+1
    for j=2:gt_size(2)+1
	    c=0;
	    while c<8
            c=c+1;
	        Sample(T*8+c,1:200) = indian_pines_corrected_new(i,j,:);
			if(c==1)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i-1,j,:);
			end
			if(c==2)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i-1,j-1,:);
			end
			if(c==3)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i,j-1,:);
			end
			if(c==4)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i-1,j+1,:);
			end
			if(c==5)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i,j+1,:);
			end
			if(c==6)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i+1,j+1,:);
			end
			if(c==7)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i+1,j,:);
			end
			if(c==8)
	            Sample(T*8+c,201:400) = indian_pines_corrected_new(i+1,j-1,:);
            end
		end
		T=T+1;
	end
end
T
path3='C:\Users\�Ұ�������\Desktop\�߹���Ŀ��̽��ͷ���\����\all\test+\'
SaveName = [path3,'test1', '.mat'];
save(SaveName,'Sample');

%======================================
% .matת.csv
a=1:400;
list = ls([path3,'*.mat']);
filename = strtrim(list(1,:))
load([path3,filename]);
a=[a;Sample];
csvwrite('test1.csv',a);


