function report = generate_food_cn_list(excelFile, sourceImageDir, outputDir, nPracticePairs)
% generate_food_cn_list Build localized Chinese food stimulus lists.
%
% The generated list is sorted by kcal/100g in descending order because the
% existing trivia task treats smaller item indices as higher-calorie items.
% Both whole foods and processed foods are retained when kcal and image
% information are available.

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fullfile(scriptDir, '..', '..', '..', '..', '..');

if nargin < 1 || isempty(excelFile)
    excelFile = fullfile(projectRoot, 'food-pic database_508_XGAO.xlsx');
end

if nargin < 2 || isempty(sourceImageDir)
    sourceImageDir = fullfile(projectRoot, 'food_pic_508');
    nestedImageDir = fullfile(sourceImageDir, 'food_pic_508');
    if exist(nestedImageDir, 'dir')
        sourceImageDir = nestedImageDir;
    end
end

if nargin < 3 || isempty(outputDir)
    outputDir = fullfile(scriptDir, 'Food_CN');
end

if ~exist(sourceImageDir, 'dir') && exist(outputDir, 'dir')
    sourceImageDir = outputDir;
end

if nargin < 4 || isempty(nPracticePairs)
    nPracticePairs = 3;
end

if ~exist(excelFile, 'file')
    error('FoodCN:MissingExcel', 'Excel file not found: %s', excelFile);
end

if ~exist(sourceImageDir, 'dir')
    error('FoodCN:MissingImageDir', 'Source image directory not found: %s', sourceImageDir);
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

raw = readcell(excelFile, 'Sheet', 'data');
headers = raw(3, :);
data = raw(4:end, :);

colImageNo = findHeader(headers, 'Image_No');
colName = findHeader(headers, 'Item_Chinese_description');
colFoodType = findHeader(headers, 'food');
colFlavor = findHeader(headers, 'flavor');
colCategory = findHeader(headers, 'category');
colKcal = findHeader(headers, 'kcal/100g');
colCalorieLabel = findHeader(headers, 'calorie');

records = struct('imageNo', {}, 'name', {}, 'imageFile', {}, 'sourcePath', {}, ...
    'foodType', {}, 'flavor', {}, 'category', {}, 'kcal', {}, 'calorieLabel', {});
missingKcal = 0;
missingImage = 0;
blankName = 0;

for iRow = 1:size(data, 1)
    imageNo = normalizeImageNo(data{iRow, colImageNo});
    name = normalizeText(data{iRow, colName});
    kcal = normalizeNumber(data{iRow, colKcal});
    foodType = normalizeNumber(data{iRow, colFoodType});

    if isempty(name)
        blankName = blankName + 1;
        continue
    end

    if isnan(kcal)
        missingKcal = missingKcal + 1;
        continue
    end

    [sourcePath, imageFile] = findImageFile(sourceImageDir, imageNo);
    if isempty(sourcePath)
        missingImage = missingImage + 1;
        continue
    end

    records(end+1).imageNo = imageNo; %#ok<AGROW>
    records(end).name = name;
    records(end).imageFile = imageFile;
    records(end).sourcePath = sourcePath;
    records(end).foodType = foodType;
    records(end).flavor = normalizeNumber(data{iRow, colFlavor});
    records(end).category = normalizeNumber(data{iRow, colCategory});
    records(end).kcal = kcal;
    records(end).calorieLabel = normalizeNumber(data{iRow, colCalorieLabel});
end

if isempty(records)
    error('FoodCN:NoUsableRecords', 'No usable food records remained after kcal/image filtering.');
end

kcalValues = [records.kcal]';
[~, sortIdx] = sort(kcalValues, 'descend');
records = records(sortIdx);

nPracticeItems = min(nPracticePairs * 2, numel(records));
if mod(nPracticeItems, 2) == 1
    nPracticeItems = nPracticeItems - 1;
end

nLow = floor(nPracticeItems / 2);
nHigh = nPracticeItems - nLow;
practiceIdx = unique([1:nHigh, (numel(records)-nLow+1):numel(records)]);
formalIdx = setdiff(1:numel(records), practiceIdx, 'stable');

practiceRecords = records(practiceIdx);
formalRecords = records(formalIdx);

copyRecordsToOutput([formalRecords, practiceRecords], outputDir);

[list_food_complete, numList, food_cn_table] = recordsToTaskArrays(formalRecords);
[list_food_practice_complete, practiceNumList, food_cn_practice_table] = recordsToTaskArrays(practiceRecords); %#ok<ASGLU>

matFile = fullfile(scriptDir, 'list_food_cn_complete.mat');
practiceMatFile = fullfile(scriptDir, 'list_food_cn_practice.mat');

save(matFile, 'list_food_complete', 'numList', 'food_cn_table', ...
    'list_food_practice_complete', 'practiceNumList', 'food_cn_practice_table');
save(practiceMatFile, 'list_food_practice_complete', 'practiceNumList', 'food_cn_practice_table');

report = struct();
report.excelFile = excelFile;
report.sourceImageDir = sourceImageDir;
report.outputDir = outputDir;
report.matFile = matFile;
report.practiceMatFile = practiceMatFile;
report.totalExcelRows = size(data, 1);
report.formalItems = numel(formalRecords);
report.practiceItems = numel(practiceRecords);
report.missingKcalRows = missingKcal;
report.missingImageRows = missingImage;
report.blankNameRows = blankName;
report.formalFoodType = 'whole food + processed food';
report.practicePairs = nPracticeItems / 2;
report.maxFormalKcal = max([formalRecords.kcal]);
report.minFormalKcal = min([formalRecords.kcal]);
report.maxPracticeKcal = max([practiceRecords.kcal]);
report.minPracticeKcal = min([practiceRecords.kcal]);

reportFile = fullfile(scriptDir, 'food_cn_generation_report.mat');
save(reportFile, 'report');

fprintf('Generated Chinese food stimulus list.\n');
fprintf('Formal items: %d\n', report.formalItems);
fprintf('Practice items: %d\n', report.practiceItems);
fprintf('Removed for missing kcal: %d\n', report.missingKcalRows);
fprintf('Removed for missing image: %d\n', report.missingImageRows);
fprintf('Practice pairs: %d\n', report.practicePairs);
fprintf('Saved: %s\n', matFile);
fprintf('Saved: %s\n', practiceMatFile);
end

function col = findHeader(headers, pattern)
col = [];
for iCol = 1:numel(headers)
    text = normalizeText(headers{iCol});
    if ~isempty(text) && ~isempty(strfind(lower(text), lower(pattern))) %#ok<STREMP>
        col = iCol;
        return
    end
end
error('FoodCN:MissingHeader', 'Could not find header containing: %s', pattern);
end

function text = normalizeText(value)
if ismissingValue(value)
    text = '';
elseif isstring(value)
    text = char(value);
elseif ischar(value)
    text = value;
elseif isnumeric(value)
    text = num2str(value);
else
    text = char(string(value));
end
text = strtrim(text);
end

function tf = ismissingValue(value)
tf = isempty(value);
if tf
    return
end

try
    missingMask = ismissing(value);
    if any(missingMask(:))
        tf = true;
        return
    end
catch
end

tf = (isnumeric(value) && isscalar(value) && isnan(value)) || ...
    (isstring(value) && strlength(value) == 0);
end

function number = normalizeNumber(value)
if ismissingValue(value)
    number = NaN;
elseif isnumeric(value)
    number = double(value);
else
    number = str2double(normalizeText(value));
end
end

function imageNo = normalizeImageNo(value)
if isnumeric(value)
    imageNo = sprintf('%04d', round(value));
else
    imageNo = normalizeText(value);
    numericValue = str2double(imageNo);
    if ~isnan(numericValue)
        imageNo = sprintf('%04d', round(numericValue));
    end
end
end

function [sourcePath, imageFile] = findImageFile(sourceImageDir, imageNo)
extensions = {'.jpg', '.jpeg', '.JPG', '.JPEG'};
sourcePath = '';
imageFile = '';
for iExt = 1:numel(extensions)
    candidate = [imageNo extensions{iExt}];
    candidatePath = fullfile(sourceImageDir, candidate);
    if exist(candidatePath, 'file')
        sourcePath = candidatePath;
        imageFile = candidate;
        return
    end
end
end

function copyRecordsToOutput(records, outputDir)
for iRecord = 1:numel(records)
    destinationPath = fullfile(outputDir, records(iRecord).imageFile);
    if ~exist(destinationPath, 'file')
        copyfile(records(iRecord).sourcePath, destinationPath);
    end
end
end

function [list_food_complete, numList, foodTable] = recordsToTaskArrays(records)
nRecords = numel(records);
list_food_complete = cell(nRecords, 8);
numList = zeros(nRecords, 1);

imageNo = cell(nRecords, 1);
name = cell(nRecords, 1);
imageFile = cell(nRecords, 1);
foodType = nan(nRecords, 1);
flavor = nan(nRecords, 1);
category = nan(nRecords, 1);
kcal = nan(nRecords, 1);
calorieLabel = nan(nRecords, 1);

for iRecord = 1:nRecords
    list_food_complete{iRecord, 1} = records(iRecord).name;
    list_food_complete{iRecord, 2} = records(iRecord).imageFile;
    list_food_complete{iRecord, 3} = records(iRecord).imageNo;
    list_food_complete{iRecord, 4} = records(iRecord).category;
    list_food_complete{iRecord, 5} = records(iRecord).kcal;
    list_food_complete{iRecord, 6} = records(iRecord).calorieLabel;
    list_food_complete{iRecord, 7} = records(iRecord).foodType;
    list_food_complete{iRecord, 8} = records(iRecord).flavor;

    numList(iRecord, 1) = records(iRecord).kcal;

    imageNo{iRecord} = records(iRecord).imageNo;
    name{iRecord} = records(iRecord).name;
    imageFile{iRecord} = records(iRecord).imageFile;
    foodType(iRecord) = records(iRecord).foodType;
    flavor(iRecord) = records(iRecord).flavor;
    category(iRecord) = records(iRecord).category;
    kcal(iRecord) = records(iRecord).kcal;
    calorieLabel(iRecord) = records(iRecord).calorieLabel;
end

foodTable = table(imageNo, name, imageFile, foodType, flavor, category, kcal, calorieLabel);
end
