

function [bld1,bld2,bld3,bld4,bld5] = Auto_ljBox(initial_time,A1,final_time,base_name1,Channel,type)

%% OAM_1807 double checking by autcorr that signals are real signals and not some random noise
% 
% Inputs/Vargin: 
% time inteval
% initial_time=1; % initial timepoint
% final_time=20; % final timepoint
% 
% % image bondaries
% A1(1,1)=210;%up
% A1(1,2)=240;%down
% A1(2,1)=290;%right
% A1(2,2)=340;%left
% 
% base_name1=[cd '\img_']; % path to the images
% 
% %channel to test
% Channel=C_NG;  % or any of the below mentioned:
% C_615='615 nm_000';
% C_CyOFP1='470 GFP_000';
% C_BF='BrightField_000';
% C_NG='505 mNG_000';
% C_Ru='555 mRuby3_000';
% C_mKOk='555 new_mKok_000';
% C_mTFP1='470 mTFP_000';

% type='.tif';% image format


%% loading the images and making images a vector
% cd;
mat_length=(length(A1(1,1):A1(1,2))*length(A1(2,1):A1(2,2)));
Pixl_mat=zeros(mat_length,length(initial_time:final_time));

for c_time=initial_time:final_time  
   
if c_time<100 && c_time>=10
    image_number=['0000000' num2str(c_time) '_'];
elseif c_time<10
    image_number=['00000000' num2str(c_time) '_'];
else
    image_number=['000000' num2str(c_time) '_'];
end

    Image= [base_name1 image_number Channel type];
    Ima=imread(Image);
    Ima=Ima(A1(1,1):A1(1,2),A1(2,1):A1(2,2));
    mat_length=size(Ima,1)*size(Ima,2);
    
    for ik=1:mat_length
Pixl_mat(ik,c_time)=Ima(ik);
    end
end

% figure(1)
% imagesc(Ima)
% figure(2)
% imagesc(Pixl_mat);% raw=pixels, column=time point
% colorbar;colormap(jet)

% %look at residuals fro specific time points
% npixel=600;
% bar(Pixl_mat(npixel,:)-mean(Pixl_mat(npixel,:)))

auto_matrix=zeros(mat_length,length(initial_time:final_time));
 for ik=1:mat_length
[acf,~,bounds,~]=autocorr(Pixl_mat(ik,:),'NumSTD',3);
auto_matrix(ik,:)=acf;
close 
 end
   
% figure(3)
% imagesc(auto_matrix);
% colorbar;colormap(jet)
% caxis([-0.5 1])

[n,~]=find(auto_matrix(:,2:end)<=bounds(2) | auto_matrix(:,2:end)>=bounds(1));
pixsig=unique(n);
Ima2=zeros(size(Ima));
Ima2(pixsig)=1;
bld1=Ima2;
f0=figure(4);
imagesc(Ima2);colorbar;colormap(gray);title('mostly likely pixels with signals');xlabel('X pixels');ylabel('Y pixels')
bld2=Ima;
 saveas(f0,'bld0')
f1=figure(5);
imagesc(Ima);colorbar;colormap(jet);title('original');xlabel('X pixels');ylabel('Y pixels')
saveas(f1,'bld1')
f2=figure(6);
bld3=(uint16(Ima2).*Ima);
imagesc(bld3);title('pixels with signals');xlabel('X pixels');ylabel('Y pixels')
saveas(f2,'bld2')
% using the Liubox test
 liubox=zeros(mat_length,2);
 for ik=1:mat_length
 [h,pValue]=lbqtest(Pixl_mat(ik,:)-mean(Pixl_mat(ik,:)));
liubox(ik,:)=[h,pValue];
 end
 
 Ima3=zeros(size(Ima));
 Ima4=zeros(size(Ima));
 for ikk=1:mat_length
     Ima3(ikk)=liubox(ikk,1);
     Ima4(ikk)=liubox(ikk,2);
 end
 
%  figure(7)
%  imagesc(Ima3);title('Liubox null hypotesis, res');xlabel('X pixels');ylabel('Y pixels');% according to null hypothesis
%  figure(8)
%  imagesc(Ima4);title('Liubox p Values, res');xlabel('X pixels');ylabel('Y pixels');% according to p Value

liubox2=zeros(mat_length,2);
 for ik=1:mat_length
 [h,pValue]=lbqtest(auto_matrix(ik,:));
liubox2(ik,:)=[h,pValue];
 end

 Ima5=zeros(size(Ima));
 Ima6=zeros(size(Ima));
 for ikk=1:mat_length
     Ima5(ikk)=liubox2(ikk,1);
     Ima6(ikk)=liubox2(ikk,2);
 end
 
 bld4=Ima5;
 f4=figure(9);
 imagesc(Ima5);colorbar;title('Liubox null hypotesis, autocorr');xlabel('X pixels');ylabel('Y pixels');% according to null hypothesis
saveas(f4,'bld4')
 bld5=Ima6;
 f5=figure(10);
 imagesc(Ima6);colorbar;title('Liubox p Values, autocorr');xlabel('X pixels');ylabel('Y pixels');% according to p Value
saveas(f5,'bld5')
 
% B2=bwareaopen(Ima5,10,4);
% imagesc(B2)
% B2=~B2;
% 
% Ima8=bwdist(B2);
% imagesc(Ima8)
% 
% 
%  imagesc(B2)
% SE = strel('disk',6);
% B2=imclose(Ima5,SE);
% imagesc(B2);
% B2c=imclose(B2,ones(p5,p5)); %som
end