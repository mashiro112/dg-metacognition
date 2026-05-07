function report = validate_food_cn_materials(matFile, imageDir)
% validate_food_cn_materials Check localized Chinese food task materials.

scriptDir = fileparts(mfilename('fullpath'));

if nargin < 1 || isempty(matFile)
    matFile = fullfile(scriptDir, 'list_food_cn_complete.mat');
end

if nargin < 2 || isempty(imageDir)
    imageDir = fullfile(scriptDir, 'Food_CN');
end

if ~exist(matFile, 'file')
    error('FoodCN:MissingMatFile', 'MAT file not found: %s', matFile);
end

if ~exist(imageDir, 'dir')
    error('FoodCN:MissingImageDir', 'Image directory not found: %s', imageDir);
end

materials = load(matFile);
requiredFields = {'list_food_complete', 'numList'};
for iField = 1:numel(requiredFields)
    if ~isfield(materials, requiredFields{iField})
        error('FoodCN:MissingField', 'MAT file is missing field: %s', requiredFields{iField});
    end
end

formal = validateSet(materials.list_food_complete, materials.numList, imageDir, 'formal');

if isfield(materials, 'list_food_practice_complete') && isfield(materials, 'practiceNumList')
    practice = validateSet(materials.list_food_practice_complete, materials.practiceNumList, imageDir, 'practice');
else
    practice = struct('label', 'practice', 'items', 0, 'ok', true, ...
        'missingImages', {{}}, 'sortedDescending', true, ...
        'wholeFoodRows', 0, 'processedFoodRows', 0);
end

overlapImageFiles = {};
if isfield(materials, 'list_food_practice_complete')
    formalImages = materials.list_food_complete(:, 2);
    practiceImages = materials.list_food_practice_complete(:, 2);
    overlapImageFiles = intersect(formalImages, practiceImages);
end

report = struct();
report.matFile = matFile;
report.imageDir = imageDir;
report.formal = formal;
report.practice = practice;
report.overlapImageFiles = overlapImageFiles;
report.hasFormalPracticeOverlap = ~isempty(overlapImageFiles);
report.ok = formal.ok && practice.ok && ~report.hasFormalPracticeOverlap;

fprintf('Chinese food material validation\n');
fprintf('Formal items: %d\n', formal.items);
fprintf('Practice items: %d\n', practice.items);
fprintf('Formal missing images: %d\n', numel(formal.missingImages));
fprintf('Practice missing images: %d\n', numel(practice.missingImages));
fprintf('Formal sorted descending: %d\n', formal.sortedDescending);
fprintf('Practice sorted descending: %d\n', practice.sortedDescending);
fprintf('Formal whole food rows: %d\n', formal.wholeFoodRows);
fprintf('Formal processed food rows: %d\n', formal.processedFoodRows);
fprintf('Practice whole food rows: %d\n', practice.wholeFoodRows);
fprintf('Practice processed food rows: %d\n', practice.processedFoodRows);
fprintf('Formal/practice overlap: %d\n', numel(overlapImageFiles));
fprintf('Overall OK: %d\n', report.ok);

reportFile = fullfile(scriptDir, 'food_cn_validation_report.mat');
save(reportFile, 'report');
end

function setReport = validateSet(list_food_complete, numList, imageDir, label)
if isempty(list_food_complete)
    setReport = struct('label', label, 'items', 0, 'ok', false, ...
        'missingImages', {{}}, 'missingKcalRows', [], 'duplicateImageFiles', {{}}, ...
        'duplicateNames', {{}}, 'sortedDescending', false, 'minKcal', NaN, ...
        'maxKcal', NaN, 'medianKcal', NaN, 'maxPairDifference', NaN, ...
        'wholeFoodRows', 0, 'processedFoodRows', 0);
    return
end

names = list_food_complete(:, 1);
imageFiles = list_food_complete(:, 2);
kcalFromList = cell2numeric(list_food_complete(:, 5));
kcalFromNumList = numList(:, 1);
foodType = cell2numeric(list_food_complete(:, 7));

missingImages = {};
for iItem = 1:numel(imageFiles)
    imagePath = fullfile(imageDir, char(imageFiles{iItem}));
    if ~exist(imagePath, 'file')
        missingImages{end+1, 1} = char(imageFiles{iItem}); %#ok<AGROW>
    end
end

missingKcalRows = find(isnan(kcalFromList) | isnan(kcalFromNumList));
listNumMismatchRows = find(abs(kcalFromList - kcalFromNumList) > 1e-9);
duplicateImageFiles = findDuplicates(imageFiles);
duplicateNames = findDuplicates(names);
sortedDescending = all(diff(kcalFromNumList) <= 0);

setReport = struct();
setReport.label = label;
setReport.items = size(list_food_complete, 1);
setReport.missingImages = missingImages;
setReport.missingKcalRows = missingKcalRows;
setReport.listNumMismatchRows = listNumMismatchRows;
setReport.wholeFoodRows = sum(foodType == 1);
setReport.processedFoodRows = sum(foodType == 2);
setReport.duplicateImageFiles = duplicateImageFiles;
setReport.duplicateNames = duplicateNames;
setReport.sortedDescending = sortedDescending;
setReport.minKcal = min(kcalFromNumList);
setReport.maxKcal = max(kcalFromNumList);
setReport.medianKcal = median(kcalFromNumList);
setReport.maxPairDifference = max(kcalFromNumList) - min(kcalFromNumList);
setReport.ok = isempty(missingImages) && isempty(missingKcalRows) && ...
    isempty(listNumMismatchRows) && isempty(duplicateImageFiles) && sortedDescending;
end

function values = cell2numeric(cellValues)
values = nan(numel(cellValues), 1);
for iValue = 1:numel(cellValues)
    value = cellValues{iValue};
    if isnumeric(value)
        values(iValue) = double(value);
    else
        values(iValue) = str2double(char(value));
    end
end
end

function duplicates = findDuplicates(values)
asText = cell(numel(values), 1);
for iValue = 1:numel(values)
    asText{iValue} = char(values{iValue});
end

[uniqueValues, ~, idx] = unique(asText);
counts = accumarray(idx, 1);
duplicates = uniqueValues(counts > 1);
end
