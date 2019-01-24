%=================================
% part 1:imshow indian_pines_gt

load Indian_pines_gt.mat;
gt_size=size(indian_pines_gt);  %145x145

%去除较少样本的类
for i=[1,4,7,9,13,15,16]
	indian_pines_gt(indian_pines_gt==i)=0;
end
k0=-1; 
% m=[[0 0 0];
%     [1 1 1];
%     [1 0 0];
%     [0 1 0];
%     [0 0 1];
%     [1 1 0];
%     [1 0 1];
%     [0 1 1];
%     [2/3 0 1];
%     [1 1/2 0];
%     [1/2 0 0];
%     [1/2 1/2 1/2]];

I = [115,82,69;                    %标准24色卡值     
    204,161,141;     
    101,134,179;     
    89,109,61;     
    141,137,194;     
    132,228,208;     
    249,118,35;     
    80,91,182;     
    222,91,125;     
    91,63,123;     
    173,232,91;     
    255,164,26;     
    44,56,142;     
    74,148,81;     
    179,42,50;     
    250,226,21;     
    191,81,160;     
    6,142,172;     
    252,252,252;     
    230,230,230;     
    200,200,200;     
    143,143,142;     
    100,100,100;     
    50,50,50];
I=I/255;
k0=0;
color=zeros(gt_size(1),gt_size(2),3);
kk=[0 2 3 5 6 8 10 11 12 14];
for k=kk
    k0=k0+1;
    for i=1:gt_size(1)
        for j=1:gt_size(2)
            if(indian_pines_gt(i,j)==k)
                color(i,j,1)=I(k0,1);
                color(i,j,2)=I(k0,2);
                color(i,j,3)=I(k0,3);
            end
        end
    end
end
subplot(1,3,1)
imshow(color)
%=================================
% part 2:imshow test
B = load('Result1.csv');   %前两行去掉

t=2;
indian_pines_test=zeros(gt_size(1),gt_size(2));
for i=1:gt_size(1)
    for j=1:gt_size(2)
        indian_pines_test(i,j)=mode(B(t+1:t+8,2));   
        t=t+8;
    end
end

color1=zeros(gt_size(1),gt_size(2),3);
for k=0:9
    for i=1:gt_size(1)
        for j=1:gt_size(2)
            if(indian_pines_test(i,j)==k)
                color1(i,j,1)=I(k+1,1);
                color1(i,j,2)=I(k+1,2);
                color1(i,j,3)=I(k+1,3);
            end
        end
    end
end
subplot(1,3,2)
imshow(color1)
%=================================
% part 3:imshow test-200
B1 = load('Result2.csv');   %前两行去掉

load Indian_pines_gt.mat;
gt_size=size(indian_pines_gt);  %145x145
%去除较少样本的类
for i=[1,4,7,9,13,15,16]
	indian_pines_gt(indian_pines_gt==i)=0;
end
%手贱把 randId.mat 删了

load randId.mat;
%标记下200个用于训练的数据
Rand_id=ones(gt_size(1),gt_size(2))*(-1);
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
	                Rand_id(i,j)=k-1;
				end
			end
		end
    end
end

t1=2;
indian_pines_test2=zeros(gt_size(1),gt_size(2));
for i=1:gt_size(1)
    for j=1:gt_size(2)
        if(Rand_id(i,j)==(-1))
            indian_pines_test2(i,j)=mode(B1(t1+1:t1+8,2));  
            t1=t1+8;
        end
        if(Rand_id(i,j)~=(-1))
            indian_pines_test2(i,j)=Rand_id(i,j);  
        end
    end
end

color2=zeros(gt_size(1),gt_size(2),3);
for k=0:9
    for i=1:gt_size(1)
        for j=1:gt_size(2)
            if(indian_pines_test2(i,j)==k)
                color2(i,j,1)=I(k+1,1);
                color2(i,j,2)=I(k+1,2);
                color2(i,j,3)=I(k+1,3);
            end
        end
    end
end
subplot(1,3,3)
imshow(color2)

