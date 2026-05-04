function [keyName, secs, keyCode] = ptbWaitForKey(validKeys)
% ptbWaitForKey Wait for one valid key and ignore unrelated stuck keys.

if nargin < 1 || isempty(validKeys)
    validKeys = {};
end

keyName = '';
secs = NaN;
keyCode = [];

try
    KbReleaseWait(-1);
catch
    KbReleaseWait();
end

while isempty(keyName)
    [~, secs, candidate, keyCode] = ptbCheckKey(validKeys);
    if ~isempty(candidate) && (isempty(validKeys) || any(strcmpi(candidate, validKeys)))
        keyName = candidate;
    end
    WaitSecs(0.01);
end

try
    KbReleaseWait(-1);
catch
    KbReleaseWait();
end

end
