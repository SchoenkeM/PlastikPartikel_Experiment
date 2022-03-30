function [List]=GetAllFilesFromDir(InputDir,ext)

currentPath=pwd;
%ext='*.s7k'; % default
cd(InputDir); fileList = dir(ext);
name = {fileList.name}.'; folder = {fileList.folder}.';
% FileList=cell2mat(fullfile(folder,name));
List=name; 
cd(currentPath);

end