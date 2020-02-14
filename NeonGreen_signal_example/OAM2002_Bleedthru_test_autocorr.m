
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
% tim interval
initial_time=1;
final_time=20;

% image bondaries
A1(1,1)=210;%up
A1(1,2)=240;%down
A1(2,1)=290;%right
A1(2,2)=340;%left

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
Channel=C_NG;

[bld1,bld2,bld3,bld4,bld5] = Auto_liBox(initial_time,A1,final_time,base_name1,Channel,type);
