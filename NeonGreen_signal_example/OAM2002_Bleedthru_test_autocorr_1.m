%% this is a example of how to use the function Auto_liBox after deciding wichi region of an image to analyse

clearvars

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


