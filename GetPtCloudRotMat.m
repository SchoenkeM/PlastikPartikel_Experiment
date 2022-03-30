function [R,FitConfidence]= GetPtCloudRotMat(x,y,z,v)
% The functions computes the rotation matrix R to rotate the point cloud 
% defined by x,y,z to be rotated orthogonally to the imput vector
% v[x´,y´,z´]
%
% Version 0.1


    %  In the current case v= [0 0 -1] to rotate pt in horizontal 
    %  postition

    % Takes x,y,z data and plots evenly distributed points on the 
    % surface to thin out the dataset and improve computing performance
    
      tol= 0.05; % Two values, u and v, are within tolerance if
                    %(u-v) <= tol*max(abs(A(:)))                       
      XYZ= uniquetol([x y z],tol,'ByRows',true);

    % clear out nans    
      XYZ(isnan(XYZ(:,1)),:)=[]; 

    % Builds grid with 20 points from thinned scan set
       NumberOfNodes=40; 
       [X,Y] = meshgrid(linspace(min(XYZ(:,1)),...
                                 max(XYZ(:,1)),NumberOfNodes),...
                        linspace(min(XYZ(:,2)),...
                                 max(XYZ(:,2)),NumberOfNodes));            

    % Prepares Data for surface fitting toolbox
       [xData, yData, zData] = prepareSurfaceData(XYZ(:,1), ...
                                                  XYZ(:,2),...
                                                  XYZ(:,3));
    % Set up fittype and options.                                            
       ft = fittype( 'poly11' );

    % Fit model to data.
       [fitresult,gof2] = fit( [xData, yData], zData, ft );     
            
    % Extract plain coefficients Fit_z =@(x,y) a + b*x + c*y;
       a = fitresult.p00; b = fitresult.p10; c = fitresult.p01;
       
    % Extract goodness of fit
%        rmse = gof2.rmse; rsquare= gof2.rsquare;
       FitConfidence = [{'rmse'} {gof2.rmse};...
                         {'rsquare'} {gof2.rsquare}];
                     
    % Fit plain to get fittet x1 y 2 z1 data   
       FitPlain = @(x,y) a + b*x + c*y; % create funtion for plain fit
           zfit = FitPlain(X(:),Y(:)); % fit plain

    % compute grid to build matrix from plainfit function zfit
        Z = reshape(zfit,NumberOfNodes,NumberOfNodes);

    % extrakt Points from Marix        
        P1 = [X(end,1),Y(end,1),Z(end,1)];    
        P2 = [X(1,1),Y(1,1),Z(1,1)];
        P3 = [X(end,end),Y(end,end),Z(end,end)];

    % computes direction vector    
        P21=P1-P2;  P31=P1-P3;

    % computes cross product    
        normal = cross(P21, P31);

    % compute norm vector    
        n = normal./norm(normal).*-1;

    % cumputes rotation matrix
        R = fcn_RotationFromTwoVectors_v01( n, v);


end

function  R = fcn_RotationFromTwoVectors_v01(A, B)
% http://math.stackexchange.com/questions/180418/calculate-rotation
% -matrix-to-align-vector-a-to-vector-b-in-3d
%
% R*v1=v2
% v1 and v2 should be column vectors with 3x1 dimensions

%% Method 3
    v = cross(A,B);
    ssc = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    R = eye(3) + ssc + ssc^2*(1-dot(A,B))/(norm(v))^2;
end