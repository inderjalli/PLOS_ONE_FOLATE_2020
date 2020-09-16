function dataToClean = cleanDataBeanfcn(dataToClean, cToRemove, rToRemove)



% Specify indices of columns to remove.
% cToRemove = 2:9;
% rToRemove = [];

names = fieldnames(dataToClean);

%Loop through each scenario
for i = 1:numel(names)
   
    speciesNames = fieldnames(dataToClean.(names{i}));
    
    %Loop through each species
    for j = 1:numel(speciesNames)
        
%         %Remove specified columns (set them to empty matrices (Tim's
%         method)
           dataToClean.(names{i}).(speciesNames{j})(:, cToRemove) = [];
           dataToClean.(names{i}).(speciesNames{j})(rToRemove, :) = [];

         %Remove specified columns (set them to empty matrices (Inder's
         %attempt)
          % dataToClean.(names{i}).(speciesNames{j}) = dataToClean.(names{i}).(speciesNames{j})(:, 1:3);


    end
end
end