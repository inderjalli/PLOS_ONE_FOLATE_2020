function result = reshapeData(data, numScenarios, nRepl, numSpecies, nPoints)

result = cell(1, numScenarios * nRepl);

AoS = cell2mat(struct2cell(data));

for i = 1:numScenarios
    mats = cell2mat(struct2cell(AoS(i)));
    for j = 1:nRepl
       result{(i-1)*nRepl + j} = reshape(mats(:,j), nPoints,numSpecies);
    end
end

result = vertcat(result{1:end});

end