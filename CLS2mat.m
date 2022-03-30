function data=CLS2mat(fpath)
% fpath=InputDir;

    FileList = dir(fullfile(fpath, '**', '*.csv')); 
    
%    FileList = dir(fullfile('C:\Users\Mischa\OneDrive\Shared_Folder\Mischa_Janika\confocal_laser_scanning\20130213\18M','**', '*.csv')); 
    formatSpecData = '%*s';
    for n = 1: 1024
    formatSpecData = [formatSpecData '%f'];
    end
    formatSpecData = [formatSpecData '%[^\n\r]'];

 
    N= length(FileList);
    for n = 1:N
        

        fname = fullfile(FileList(n).folder, FileList(n).name);
            

        fileID = fopen(fname,'r'); 
        frewind(fileID)

      % Scan document Header
        delimiter = ',';
        startRow = 1;
        endRow = 15;
        formatSpecHeader = '%s%[^\n\r]';
        Header = textscan(fileID, formatSpecHeader,endRow-startRow,...
               'Delimiter', delimiter, 'MultipleDelimsAsOne', true, ...
               'ReturnOnError',false, 'EndOfLine', '\r\n'); 


        
      % Scan document Data
        frewind(fileID)
        delimiter = ',';
        startRow = 16;
        endRow = inf;
       
        txtdata = textscan(fileID, formatSpecData,endRow-startRow,...
               'headerLines', 14,'Delimiter', delimiter, 'MultipleDelimsAsOne', true, ...
               'ReturnOnError',false, 'EndOfLine', '\r\n');

          z= nan(1025,1024);
          for m=1:1024
              z(:,m)=txtdata{1,m};
          end

          data(n).name=FileList(n).name;
          data(n).header=Header{:,1};
          data(n).X=z(1,:)';
          data(n).Y=z(1,:)';
          data(n).Z=z(2:end,:);
          
    end



%     data=struct2table(data);
    


 







end