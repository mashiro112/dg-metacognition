function keyName = ptbKeyName(keyCode, preferredKeys)
% ptbKeyName Return one stable key name from a PTB keyCode vector.
%
% KbName(keyCode) can return a cell array when multiple keys/devices are
% active. That breaks strcmp/switch logic, so prioritize valid task keys.

keyName = '';

if nargin < 2
    preferredKeys = {};
end

pressed = find(keyCode);
if isempty(pressed)
    return
end

if ischar(preferredKeys)
    preferredKeys = {preferredKeys};
end

for i = 1:numel(preferredKeys)
    keyIndex = KbName(preferredKeys{i});
    if any(pressed == keyIndex)
        keyName = preferredKeys{i};
        return
    end
end

names = KbName(keyCode);
if iscell(names)
    keyName = names{1};
else
    keyName = names;
end

end
