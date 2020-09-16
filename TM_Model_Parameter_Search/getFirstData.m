function result = getFirstData(data, numScenarios, nRepl, numSpecies, nPoints)

result = struct2cell(cell2mat(struct2cell(data)));

[r,c] = size(result);

for i = 1:r*c
   temp = result{i};
   result{i} = temp(1,:);
end