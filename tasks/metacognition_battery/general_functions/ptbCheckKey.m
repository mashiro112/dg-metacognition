function [keyIsDown, secs, keyName, keyCode] = ptbCheckKey(preferredKeys)
% ptbCheckKey Robust KbCheck wrapper that returns one prioritized key name.

try
    [keyIsDown, secs, keyCode] = KbCheck(-1);
catch
    [keyIsDown, secs, keyCode] = KbCheck();
end

if keyIsDown
    keyName = ptbKeyName(keyCode, preferredKeys);
else
    keyName = '';
end

end
