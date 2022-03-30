%%
clear all
% S=load('C:\Users\misch\OneDrive\Shared_Folder\Mischa_Janika\confocal_laser_scanning\SCS_PP_9M_1_PreProc.mat');
fdir='C:\Users\Mischa\OneDrive\Shared_Folder\Mischa_Janika\confocal_laser_scanning\20130213';
ffolder='18M';
% fpath= [ pwd '\ExampleFile\4M\'];

fpath= [ fdir '\' ffolder];

% Liste=GetAllFilesFromDir(fpath,'*.csv');


data= CLS2mat(fpath);




%%




% factor= 50;
% % 
% L0=data(ID).Z(50,:);
% L1= movmedian(data(ID).Z(50,:),factor);
% L2=L0-L1;
% figure(5)
% plot(L0)
% hold on 
% plot(L1)
% 
% figure(6)
% plot(L2)


%%
ID= 31; 
runmeanZ=movmedian(data(ID).Z,70);
figure(ID)
subplot(2,3,1)
imagesc(data(ID).X,data(ID).Y,data(ID).Z)
title(['Raw data 2D: ' data(ID).name],'Interpreter','none')

subplot(2,3,2)
surf(data(ID).X,data(ID).Y,data(ID).Z)
shading flat
axis equal
title([ 'Raw data 3D: ' data(ID).name],'Interpreter','none')


subplot(2,3,3)
surf(data(ID).X,data(ID).Y,runmeanZ)
shading flat
axis equal
title(['Mean Surface: ' data(ID).name],'Interpreter','none')

subplot(2,3,4)
Zres=data(ID).Z-runmeanZ;
surf(data(ID).X,data(ID).Y,Zres)
shading flat
axis equal
title(['Resdiual Surface: ' data(ID).name],'Interpreter','none')
caxis([-0.5 0.5])


subplot(2,3,5)
Img2DFFt(Zres,0.25);
% Img2DFFt(runmeanZ,0.25);
caxis([0 0.05])
% 
% [f1,Pf]= raPsd2d_BA(Zres,0.25);

subplot(2,3,6)
% [f1,Pf]= raPsd2d_BA(runmeanZ,0.25);
[f1,Pf]= raPsd2d_BA(Zres,0.25);


% hold on
% plot3(S(ID).x,S(ID).,S(ID).z(idx1),'go')
% plot3(S.x(idx2),S.y(idx2),S.z(idx2),'r.','MarkerSize',50)
% xlabel('x [um]')
% ylabel('y [um]')
% title('raw data')
% hold off
% %%
% nx=1024;
% ny=1024;
% threshold=5;
% Z= reshape(S.z,1024,1024);
% figure(2)
% j=500;
% ztemp=Z(j,:);
% 
% subplot(2,1,1)
% plot(ztemp);
% hold on
% runmeanZ=movmedian(Z(j,:),70);
% 
% plot(runmeanZ);
% legend('raw data','moving median window length 70')
% xlabel('x [um]')
% ylabel('z [um]')
% hold off
% 
% subplot(2,1,2)
% x1=1:nx;
% ZCorr= ztemp-runmeanZ;
% outlier = ZCorr>threshold | ZCorr <-threshold;
% plot(ZCorr);
% hold on
% plot(x1(outlier),ZCorr(outlier),'ro')
% legend('difference movmedian and raw data','outlier with threshold mean +/- 5')
% xlabel('x [um]')
% ylabel('z [um]')
% hold off
%%
% winlength=70;
% threshold=3;
% flag = zeros(nx,ny);
% for j = 1:nx
%    ztemp=Z(j,:); 
%    runmeanZ=movmedian(Z(j,:),winlength); 
%    ZCorr= ztemp-runmeanZ; 
%    
%    outlier = ZCorr>threshold | ZCorr <-threshold;
%    flag(j,outlier)= 1; 
%    
% end

%%

% S.Outlier.Total(flag(:)==1)=1;
% S = AlignPtCloud(S);
% 
% %%
% 
% 
% %%
% figure(3)
% plot3(S.x,S.y,S.z,'.','Color',[0.4 0.4 0.4])
% hold on
% plot3(S.x(flag(:)==1),S.y(flag(:)==1),S.z(flag(:)==1),'or')
% title(S.ScanName,'Interpreter','none')
% xlabel('x [um]')
% ylabel('y [um]')
% zlabel('z [um]')
% legend('raw data','outlier')
%%

% 
% Z= reshape(S.z,1024,1024);
% MeanX= zeros(nx,ny);
% MeanY= zeros(nx,ny);
% winlength=100;
% for j = 1:nx
%  
%      MeanX(j,:)= movmedian(Z(j,:),winlength); 
%      MeanY(:,j)= movmedian(Z(:,j),winlength); 
%     
%     
% end
% 
% %%
% 
% meanZ=(MeanX(:)+MeanY(:))./2;
% %%
% figure(5)
% plot3(S.x,S.y,S.z,'.','Color',[0.4 0.4 0.4])
% hold on
% plot3(S.x,S.y,meanZ,'r.')
% hold off
% title('remove median')
% 
% %% remove offset
% % zeromean=mean(meanZ(:));
% % S.z=S.z-zeromean;
% % meanZ= meanZ-zeromean; 
% % S.z(flag(:)==1)=meanZ(flag(:)==1);
% % S.z=S.z-meanZ(:);
% 
% 
% %%
% S.x(flag==1)=[];
% S.y(flag==1)=[];
% S.z(flag==1)=[];
% %% Gridding
% 
% 
% X=0:0.25:220;
% Y=0:0.25:220;
% 
% [xq,yq] = meshgrid(X,Y);
% vz = griddata(S.x,S.y,S.z,xq,yq);
% %%
% 
% flag2= yq<55 & vz<65 & xq<145;
% xq(flag2==1)=nan;
% yq(flag2==1)=nan;
% vz(flag2==1)=nan;
% 
% % flag2= yq<5;
% % xq(flag2==1)=nan;
% % yq(flag2==1)=nan;
% % vz(flag2==1)=nan;
% 
% 
% figure(6)
% surf(xq,yq,vz)
% title(S.ScanName,'Interpreter','none')
% xlabel('x [um]')
% ylabel('y [um]')
% c=colorbar;
% c.Label.String='hight [um]';
% % c.Limits=[-2 2];
% axis equal
% shading flat
% set(gca,'XDir','reverse')
% % clim([-5 5])
%%
% figure
% imagesc(X,Y,vz)

