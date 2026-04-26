function exportTriviaResults(matFilePath, results, params)
%EXPORTTRIVIARESULTS Create a UTF-8 CSV alongside trivia MAT output.

trialCount = numel(results.trial);
subjectCol = repmat(string(params.subID), trialCount, 1);
blockCol = results.BlockNumber(:);
trialCol = results.trial(:);
conditionCol = results.WhichCondition(:);
pairCol = cellfun(@(pair) sprintf('%d,%d', pair(1), pair(2)), ...
    results.Pairs(:), 'UniformOutput', false);
responseCol = results.Responses(:);
correctCol = results.Corrects(:);
differenceCol = results.DifferenceTarget(:);
rtCol = results.RTS(:);

summaryTable = table(subjectCol, blockCol, trialCol, conditionCol, ...
    string(pairCol), responseCol, correctCol, differenceCol, rtCol, ...
    'VariableNames', {'SubjectID','Block','Trial','Condition', ...
    'StimulusPair','Response','Correct','DifferenceLevel','RT'});

if isfield(results, 'Confidence')
    summaryTable.Confidence = results.Confidence(:);
end

if isfield(results, 'RT_Confidence')
    summaryTable.ConfidenceRT = results.RT_Confidence(:);
end

write_readable_csv(matFilePath, summaryTable);
end
