function forcePTBCompatibilityMode()
% forcePTBCompatibilityMode Configure PTB to run on less reliable displays.
%
% This project is often run on laptops and classroom machines where vertical
% blank synchronization is unavailable or misreported by the graphics driver.
% Keep this before any Screen('OpenWindow', ...) call.

try
    Screen('Preference', 'SkipSyncTests', 2);
catch
end

try
    Screen('Preference', 'VisualDebugLevel', 1);
catch
end

try
    Screen('Preference', 'Verbosity', 1);
catch
end

try
    KbName('UnifyKeyNames');
catch
end

end
