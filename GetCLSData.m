function dataArray = GetCLSData(fileID)

% TEXTSCAN format specifiers

formatSpec = '%s%[^\n\r]';
delimiter = ',';
startRow = 16;

frewind(fileID)
% Scan document
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines',...
    startRow-1, 'ReturnOnError', false);

N = size(dataArray{1,1},1);
formatSpec = '%s';
for j = 1:N
    formatSpec = [formatSpec '%f'];
end
%    formatSpec = [formatSpec '%[^\n\r]'];
delimiter = ',';
startRow = 16;
frewind(fileID)
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines',...
    startRow-1, 'ReturnOnError', false);

dataArray(:,1)=[];

delimiter = ',';
startRow = 15;
endRow = 1;
frewind(fileID)

% Scan document
xydata  = textscan(fileID, formatSpec, endRow, ...
    'Delimiter',delimiter,'MultipleDelimsAsOne', true,...
    'EmptyValue' ,NaN,'HeaderLines',startRow-1,...
    'ReturnOnError', false);

xydata(:,1)=[];
xydata= cell2mat(xydata);

x_data = zeros(N,N);
y_data = zeros(N,N);
z_data = zeros(N,N);
for j = 1 : N
    x_data(j,:) = xydata;
    y_data(:,j) = xydata';
    z_data(:,j) = dataArray{1,j};
end

dataArray = [x_data(:) y_data(:) z_data(:)];



end