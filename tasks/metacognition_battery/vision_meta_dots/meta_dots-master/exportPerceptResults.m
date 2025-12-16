function exportPerceptResults(matFilePath, dataBlocks, params)
%EXPORTPERCEPTRESULTS Save a readable CSV for the perceptual task.

summaryTable = table();

for b = 1:numel(dataBlocks)
    blockResults = dataBlocks(b).results;
    nTrials = numel(blockResults.response);
    if nTrials == 0
        continue
    end

    subjectCol = repmat(string(params.subID), nTrials, 1);
    blockCol = repmat(b, nTrials, 1);
    trialCol = (1:nTrials).';
    contrastCol = blockResults.contrast(1:nTrials).';
    responseCol = blockResults.response(:);
    correctCol = blockResults.correct(:);
    rtCol = blockResults.rt(:);

    if isfield(blockResults, 'responseConf')
        confidenceCol = blockResults.responseConf(:);
    else
        confidenceCol = nan(nTrials, 1);
    end

    if isfield(blockResults, 'rtConf')
        confidenceRTCol = blockResults.rtConf(:);
    else
        confidenceRTCol = nan(nTrials, 1);
    end

    blockTable = table(subjectCol, blockCol, trialCol, contrastCol, ...
        responseCol, correctCol, rtCol, confidenceCol, confidenceRTCol, ...
        'VariableNames', {'SubjectID','Block','Trial','Contrast','Response', ...
        'Correct','RT','Confidence','ConfidenceRT'});

    summaryTable = [summaryTable; blockTable]; %#ok<AGROW>
end

if ~isempty(summaryTable)
    write_readable_csv(matFilePath, summaryTable);
end
end
