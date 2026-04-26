function csvPath = write_readable_csv(sourceMatPath, dataTable)
%WRITE_READABLE_CSV  Save a UTF-8 CSV copy of task results.
%   csvPath = WRITE_READABLE_CSV(sourceMatPath, dataTable) writes the
%   provided table next to the MAT file specified by sourceMatPath. The
%   CSV name is derived by appending "_readable" to the MAT filename.

if nargin < 2 || ~istable(dataTable)
    error('write_readable_csv requires a MAT file path and a table input.');
end

[folder, base] = fileparts(sourceMatPath);
if isempty(folder)
    folder = pwd;
end
if ~exist(folder, 'dir')
    mkdir(folder);
end

csvPath = fullfile(folder, [base '_readable.csv']);

try
    writetable(dataTable, csvPath, 'FileEncoding', 'UTF-8');
catch
    writetable(dataTable, csvPath);
end
end
