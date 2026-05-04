function forcePTBCompatibilityMode()
% forcePTBCompatibilityMode Configure PTB to run on less reliable displays.
%
% This project is often run on laptops and classroom machines where vertical
% blank synchronization is unavailable or misreported by the graphics driver.
% Keep this before any Screen('OpenWindow', ...) call.

try
    Screen('Preference', 'SkipSyncTests', 2);
    Screen('Preference', 'VisualDebugLevel', 1);
    Screen('Preference', 'Verbosity', 1);
    Screen('Preference', 'VBLTimeStampingMode', -1);
catch
    % If Psychtoolbox is not loaded yet, callers will fail later with the
    % original PTB error. This helper should never mask that root cause.
end

try
    KbName('UnifyKeyNames');
catch
end

end
