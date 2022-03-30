function clsHeader = GetCLSHeaderData(fileID)

    % TEXTSCAN format specifiers
      delimiter = '=';
%       startRow = 18;
      endRow = 14;
      formatSpec = '%s%s%[^\n\r]';
      frewind(fileID)
    
    % Scan document  
      clsHeader  = textscan(fileID, formatSpec, endRow, ...
                   'Delimiter',delimiter, 'MultipleDelimsAsOne',...
                   true, 'ReturnOnError', false);
    
     
end