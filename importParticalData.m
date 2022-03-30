function [Data]= importParticalData(Data)


  % Open *.csv-file of CLS data type for reading process
     fileID = fopen(Data.FullName,'r');   
  % checks if file is readable or prints message and skips data set
    if fileID < 1
         fprintf('failed. Unable to open file');
    else         

      % reads Header section from *.xyz files    
        clsHeader = GetCLSHeaderData(fileID);

      % create default header  
        Data.Header = GetBlankCLSHeader;   
        Data.Header = AddCLSHeader2Struct(Data.Header,clsHeader);

        dataArray = GetCLSData(fileID);

        Data.raw.x = dataArray(:,1);
        Data.raw.y = dataArray(:,2);
        Data.raw.z = dataArray(:,3);

      % Adds the scan run number to the data points   
        Data.ProcHandel.idxOfScanRun=ones(size(dataArray(:,1)));
        Data.ProcHandel.NrOfScanRun=1;
        Data= UpdateProcHandel(Data);

      % close reading file after reading header
        fclose('all'); 
      % Saves each individual scan as .mat file

       save([Data.FullName(1:end-4) '.mat'],'-struct','Data')          
       fprintf('completed.');
    end
end
      
function [BlankHeader]= GetBlankCLSHeader
        
      % Info  
        BlankHeader.SystemName=[];
        BlankHeader.Source=[];
        BlankHeader.DataType=[];
        BlankHeader.X_resolutionXcv=[];
        BlankHeader.Y_resolutionYcv=[];    
       
        BlankHeader.Xunit=[];
        BlankHeader.Yunit=[];
        BlankHeader.Zunit=[];

        BlankHeader.XCalibration=[];
        BlankHeader.YCalibration=[];  
        BlankHeader.ZCalibration=[];
        BlankHeader.Step=[];
      % Filtering   
        BlankHeader.DataSetting=[];

end


function  S = AddCLSHeader2Struct(S,xyzHeader)

      % Info  
        S.SystemName=xyzHeader{1, 2}{1, 1};
        S.Source=xyzHeader{1, 2}{2, 1};
        S.DataType=xyzHeader{1, 2}{3, 1};
        S.X_resolutionXcv=xyzHeader{1, 2}{4, 1};
        S.Y_resolutionYcv=xyzHeader{1, 2}{5, 1};   
       
        S.Xunit=xyzHeader{1, 2}{6, 1};
        S.Yunit=xyzHeader{1, 2}{7, 1};
        S.Zunit=xyzHeader{1, 2}{8, 1};

        S.XCalibration=xyzHeader{1, 2}{9, 1};
        S.YCalibration=xyzHeader{1, 2}{10, 1}; 
        S.ZCalibration=xyzHeader{1, 2}{11, 1};
        S.Step=xyzHeader{1, 2}{13, 1};
      % Filtering   
        S.DataSetting=xyzHeader{1, 2}{14, 1};


end