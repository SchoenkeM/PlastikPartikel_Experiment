function ULS200Verbose(txt,varin,varunit)

LineStart='\n\t\t';  
strSize  =80; %valid Strtinge length
strTaper ='..............................................................';

n1=length(txt);

if isnumeric(varin)
    n3=length(num2str(varin));
else
    n3=length(varin);
end


n=n1+n3; 
m=strSize-n;

if isnumeric(varin)
    
    if length(varin)==1 | isempty(varin)==1
        if (varin-floor(varin))== 0
            
           fprintf([LineStart '%s%-*.*s %d %s'],...
           txt,m,m,strTaper,varin,varunit)
       
        elseif  isempty(varin)==1
            
           fprintf([LineStart '%s%-*.*s %d %s'],...
           txt,m-5,m-5,strTaper,varin,varunit)

        else
           n=n1+4; % 00.00 predefined format -> 5 digits
           m=strSize-n; 
           fprintf([LineStart '%s%-*.*s %' '02.2f %s'],...
           txt,m,m,strTaper,varin,varunit) 
          
        end 

    else
        if (varin(1)-floor(varin(1)))== 0 && (varin(2)-floor(varin(2)))== 0 
          fprintf([LineStart '%s%-*.*s %d-%d %s'],...
          txt,m+1,m+1,strTaper,varin(1),varin(2),varunit)  
      
        elseif (varin(1)-floor(varin(1)))>0 && (varin(2)-floor(varin(2)))==0 
          fprintf([LineStart '%s%-*.*s %' '02.2f | %d %s'],...
          txt,m+7,m+7,strTaper,varin(1),varin(2),varunit)  
      
        elseif (varin(1)-floor(varin(1)))== 0 && (varin(2)-floor(varin(2)))>0
          fprintf([LineStart '%s%-*.*s %d | %02.2f %s'],...
          txt,m+7,m+7,strTaper,varin(1),varin(2),varunit)  
      
        else
           n=n1+12; % 00.00 predefined format -> 5 digits
           m=strSize-n;            
           fprintf([LineStart '%s%-*.*s %' '02.2f | %02.2f %s'],...
           txt,m+1,m+1,strTaper,varin(1),varin(2),varunit)      
        end
    end
           
else
    
    fprintf([LineStart '%s%-*.*s %s %s'],...
    txt,m,m,strTaper,varin,varunit)
end
    
end