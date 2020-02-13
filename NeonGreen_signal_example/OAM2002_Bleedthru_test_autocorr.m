
%%% OAM_1807 double checking by autcorr that signals are real signals and not some random noise

clearvars
%% exmaples:

% something be NOT a sginal
X1=rand(3,100);
autocorr(X1(1,:),'NumSTD',3); % should give a strong peak at 0 

plot(X1(1,:))
% something be signal
t1 = (0:1:100);
supossed_signal = sin(t1);
plot(t1,supossed_signal);  % should give sevaral peaks  
autocorr(supossed_signal,'NumSTD',3);
%%
close all
%% loading the images
cd
base_name1=[cd '\img_'];

%chanel to test
C_615='615 nm_000';
C_CyOFP1='470 GFP_000';
C_BF='BrightField_000';
C_NG='505 mNG_000';
C_Ru='555 mRuby3_000';
C_mKOk='555 new_mKok_000';
C_mTFP1='470 mTFP_000';
type='.tif';

% tim interval
initial_time=1;
final_time=20;

% image bondaries
A1=210;%up
A2=240;%down
B1=290;%right
B2=340;%left

mat_length=(length(A1:A2)*length(B1:B2));
Pixl_mat=zeros(mat_length,length(initial_time:final_time));

Channel=C_NG;

for c_time=initial_time:final_time %:-1:1 ;%%alpha_add_t:-1:1 %c_time=alpha_add_t:-1:1  
   
if c_time<100 && c_time>=10
    image_number=['0000000' num2str(c_time) '_'];
elseif c_time<10
    image_number=['00000000' num2str(c_time) '_'];
else
    image_number=['000000' num2str(c_time) '_'];
end

    Image= [base_name1 image_number Channel type];
    Ima=imread(Image);
    Ima=Ima(A1:A2,B1:B2);
%     size(Ima)
    mat_length=size(Ima,1)*size(Ima,2);
    
    for ik=1:mat_length
Pixl_mat(ik,c_time)=Ima(ik);
    end
end

figure(1)
imagesc(Ima)
figure(2)
imagesc(Pixl_mat);% raw=pixels, column=time point
colorbar;colormap(jet)

% %look at residuals fro specific time points
% npixel=600;
% bar(Pixl_mat(npixel,:)-mean(Pixl_mat(npixel,:)))

auto_matrix=zeros(mat_length,length(initial_time:final_time));
 for ik=1:mat_length
[acf,~,bounds,~]=autocorr(Pixl_mat(ik,:),'NumSTD',3);
auto_matrix(ik,:)=acf;
close 
 end
   
figure(3)
imagesc(auto_matrix);
colorbar;colormap(jet)
caxis([-0.5 1])

[n,m]=find(auto_matrix(:,2:end)<=bounds(2) | auto_matrix(:,2:end)>=bounds(1));
pixsig=unique(n);
Ima2=zeros(size(Ima));
Ima2(pixsig)=1;
figure(4)
imagesc(Ima2);colorbar;colormap(gray);title('mostly likely pixels with signals');xlabel('X pixels');ylabel('Y pixels')
figure(5)
imagesc(Ima);colorbar;colormap(jet);title('original');xlabel('X pixels');ylabel('Y pixels')
figure(6)
imagesc(uint16(Ima2).*Ima);title('pixels with signals');xlabel('X pixels');ylabel('Y pixels')


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
 
 figure(7)
 imagesc(Ima3);title('Liubox null hypotesis, res');xlabel('X pixels');ylabel('Y pixels');% according to null hypothesis
 figure(8)
 imagesc(Ima4);title('Liubox p Values, res');xlabel('X pixels');ylabel('Y pixels');% according to p Value

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
 
 figure(9)
 imagesc(Ima5);title('Liubox null hypotesis, autocorr');xlabel('X pixels');ylabel('Y pixels');% according to null hypothesis

 figure(10)
 imagesc(Ima6);title('Liubox p Values, autocorr');xlabel('X pixels');ylabel('Y pixels');% according to p Value

