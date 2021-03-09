clc;clear;

files = dir('data/*.mat');

for i = 1:length(files)
    A = load(files(i).name);
    electrodes = A.F0Electrodes;
    
   
    
end
