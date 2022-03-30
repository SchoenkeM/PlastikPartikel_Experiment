function [f1,Pf]= raPsd2d_BA(img,res)
% function raPsd2d(img,res)
%
% Computes and plots radially averaged power spectral density (power
% spectrum) of image IMG with spatial resolution RES.
%
% (C) E. Ruzanski, RCG, 2009

mask= isnan(img);
img(mask)=0;

%% Process image size information
[N,M] = size(img);
 
%% Compute power spectrum
%imgf = fftshift(fft2(img));
% imgfp = (abs(imgf)/(N*M)).^2;                                               % Normalize

      H_tilde= fftshift(fft2(img));
      A = N*res*M*res;
  imgfp = (A/(M*N)^2)*abs(H_tilde).^2;    % Eq(4)
  
  
%% Adjust PSD size
dimDiff = abs(N-M);
dimMax = max(N,M);
% Make square
if N > M                                                                    % More rows than columns
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(N,dimDiff/2) imgfp NaN(N,dimDiff/2)];                  % Pad columns to match dimensions
    else                                                                    % Odd difference
        imgfp = [NaN(N,floor(dimDiff/2)) imgfp NaN(N,floor(dimDiff/2)+1)];
    end
elseif N < M                                                                % More columns than rows
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(dimDiff/2,M); imgfp; NaN(dimDiff/2,M)];                % Pad rows to match dimensions
    else
        imgfp = [NaN(floor(dimDiff/2),M); imgfp; NaN(floor(dimDiff/2)+1,M)];% Pad rows to match dimensions
    end
end

halfDim = floor(dimMax/2) + 1;                                              % Only consider one half of spectrum (due to symmetry)



%% MyFunction Inbuild
   
    fs_x= 1/res; % Sampling frequency in x
    fs_y= 1/res; % Sampling frequency in y

    fq_x=GetFreqVec(dimMax,fs_x); % frequency vector in x
    fq_y=GetFreqVec(dimMax,fs_y); % frequency vector in y
    fq_y=fq_y'; % convert row to column vector
    
    
   [Fq_x, Fq_y]= meshgrid(fq_x,fq_y); % Frequency as grid
   [~,K] = cart2pol(Fq_x, Fq_y);                                               % Convert to polar coordinate axes
%     rho = round(rho);
%     figure(1)
%     loglog(


%% Compute radially average power spectrum
[X, Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
[~,rho] = cart2pol(X, Y);                                               % Convert to polar coordinate axes
rho = round(rho);



i = cell(floor(dimMax/2) + 1, 1);
for r = 0:floor(dimMax/2)
    i{r + 1} = find(rho == r);
end
Pf = zeros(1, floor(dimMax/2)+1);
for r = 0:floor(dimMax/2)
    Pf(1, r + 1) = nanmean( imgfp( i{r+1} ) );
end

k = zeros(1, floor(dimMax/2)+1);
for r = 0:floor(dimMax/2)
    k(1, r + 1) = nanmean( K( i{r+1} ) );
end



%% Setup plot

% maxX = 10^(ceil(log10(halfDim.*res)));
% f1 = linspace(1/maxX,1/(res*2),length(Pf));        % Set abscissa


% try
maxX = sqrt(( N*res)^2+( M*res)^2);
f1 = linspace(1/maxX,1/(res*2),length(Pf));  

% Find axes boundaries
xMin = 0;                                                                   % No negative image dimension
xMax = ceil(log10(halfDim));
xRange = (xMin:xMax);
yMin = floor(log10(min(Pf)));
yMax = ceil(log10(max(Pf)));
yRange = (yMin:yMax);

% Create plot axis labels
xCell = cell(1,length(xRange));
for i = 1:length(xRange)
    xRangeS = num2str(10^(xRange(i))*(res*2));
    xCell(i) = cellstr(xRangeS);
end

yCell = cell(1,length(yRange));
for i = 1:length(yRange)
    yRangeS = num2str(yRange(i));
    yCell(i) = strcat('10e',cellstr(yRangeS));
end

%% Generate plot

% f1(1)=[];
% Pf(1)=[];
% figure
% lowerBoundary=min(imgfp(:));
% upperBoundary=max(imgfp(:));
% loglog(K(:),imgfp(:),'k.')
% hold on 
% for i = 1:length(k)
%    loglog([k(i) k(i)],[lowerBoundary upperBoundary],'r');    
%         
% end
% loglog(k,Pf,'r-','LineWidth',1.0)
% title('By raPsd2d function ')
 
%%  original

loglog(1./k,Pf,'k')
fontSize = 14;
set(gcf,'color','white')
set(gca,'FontSize',fontSize,'FontWeight','bold','YMinorTick','off',...
    'XGrid','on','YAxisLocation','right','XDir','reverse'); %'XDir','reverse'
xlabel('Wavelength (m)','FontSize',fontSize,'FontWeight','Bold');
ylabel('Power','FontSize',fontSize,'FontWeight','Bold');
title('Radially averaged power spectrum','FontSize',fontSize,'FontWeight','Bold')
% ylim([10^-4 10^-2])
