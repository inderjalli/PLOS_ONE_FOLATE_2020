% getParamObjects.m
% Author: Timothy Shih for the Nijhout Laboratory at Duke University
% 
% Input: obj - Simbiology model object 
%        paramNames - cell array of parameter names to be found
%
% Output: paramObjs - Simbiology Parameter Objects with the names specified
%                     in paramNames
function paramObjs = getParamObjects(obj, paramNames)

%Preallocate cell array
paramObjs = cell(length(paramNames), 1);

%For each parameter named
for i = 1:length(paramNames)
    
    %Find the parameter object in the model object
    paramObjs{i} = sbioselect(obj, 'Name',paramNames{i});
    
    %Check if the result returned nothing
    if paramObjs{i} == []
        error(['Parameter ' paramNames{i} ' not found'])
    end
    
    %Check if the result returned multiple names. If so, return error. 
    if length(paramObjs(i)) > 1
        error('Parameter and another object found to have same name')
    end
end