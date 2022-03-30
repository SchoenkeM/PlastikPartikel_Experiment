function  S = AlignPtCloud(S)
% Function in the first step the uniquetol box reduces the data set, by 
% fitting a strongly reduced number of equally distributed intepolated and 
% unique values inside the point cloud. In a secound step polyfit box is 
% used to fit a plain inside the unique values from the first step.
% In a third step a rotation matrix R is derived by the normal vector from 
% the fitted plain and any vector lying on to the -z axis. The resulting 
% rotation matrix R is used to rotate the orignal x,y,z- point cloud values
% onto a plain parallel to the x axis. 
 
% Read x,y,z data from struct  

    alignmentVector = [0 0 -1]; % Normal vector of the compensation area 
                                  ...parallel to the alignment Vector
    
    temp_x= S.x; temp_y= S.y; temp_z= S.z;

    temp_x(S.Outlier.Total)=[];
    temp_y(S.Outlier.Total)=[];
    temp_z(S.Outlier.Total)=[];
    
%     figure 
%     plot3(temp_x,temp_y,temp_z,'.')
%     title('corr data')
% Fit plain throgh Point Cloud and compute rotation matrix between norm
% vector of the fitted plain and Z axis in negative direction.
 [R,FitConfidence]= GetPtCloudRotMat(temp_x,temp_y,temp_z,alignmentVector);

    S.ProcHandel.RotationMatrix     = R;
    S.ProcHandel.FitConfidence_rmse = FitConfidence{1,2};
    S.ProcHandel.FitConfidence_r2   = FitConfidence{2,2};
              
% Rot scans
% uses rotation matrix R to rotate x,y,z, data points and
% writes data points back to structure
    if strcmp(S.DataType,'.xyz')   
         [~,~,int] = DoRotationByRotationMatrix(S.x,S.y,S.intensity,R); 
         S.intensity=int;
    end
    
       [x,y,z] = DoRotationByRotationMatrix(S.x,S.y,S.z,R); 
       S.x=x; S.y=y; S.z=z;

% Providing Feedback for user       
    txt= '  - plain fit results for horizontal alignment';        
    varin =  [S.ProcHandel.FitConfidence_rmse ...
                    S.ProcHandel.FitConfidence_r2];   
    varunit = '[rmse] | [rsquare]';
    ULS200Verbose(txt,varin,varunit) 
end

function [X,Y,Z] = DoRotationByRotationMatrix(x,y,z,R)
% R : Rotation Matrix   

    X=  R(1,1).*x+ R(1,2).*y+ R(1,3).*z;
    Y=  R(2,1).*x+ R(2,2).*y+ R(2,3).*z;
    Z=  R(3,1).*x+ R(3,2).*y+ R(3,3).*z;

end
