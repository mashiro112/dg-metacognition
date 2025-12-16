function exportMemoryResults(matFilePath, results, params, roundNum)
%EXPORTMEMORYRESULTS Write a human-readable CSV for the memory task.
%   Creates <matFilePath>_readable.csv using UTF-8 encoding.

trialCount = numel(results.rtChoice);
subjectCol = repmat(string(params.subID), trialCount, 1);
roundCol = repmat(roundNum, trialCount, 1);
trialCol = (1:trialCount).';
studiedWord = string(results.studiedWord(:));
unstudiedWord = string(results.unstudiedWord(:));
studiedSide = string(results.studiedSide(:));
responseChoice = string(results.responseChoice(:));
confidence = results.responseConf(:);
choiceRT = results.rtChoice(:);
confidenceRT = results.rtConf(:);

summaryTable = table(subjectCol, roundCol, trialCol, ...
    studiedWord, unstudiedWord, studiedSide, responseChoice, ...
    confidence, choiceRT, confidenceRT, ...
    'VariableNames', {'SubjectID','Round','Trial','StudiedWord', ...
    'UnstudiedWord','StudiedSide','ResponseChoice','Confidence', ...
    'ChoiceRT','ConfidenceRT'});

write_readable_csv(matFilePath, summaryTable);
end
