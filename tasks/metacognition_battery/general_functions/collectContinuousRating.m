function [value, RT] = collectContinuousRating(windowPtr, center, widthPx, prompt, leftLabel, rightLabel, minVal, maxVal, arrowWidthPx, yOffset)
% collectContinuousRating Display a continuous slider and collect a rating.
%   [value, RT] = collectContinuousRating(windowPtr, center, widthPx, prompt,
%   leftLabel, rightLabel, minVal, maxVal, arrowWidthPx, yOffset) shows a
%   horizontal scale controlled by the left/right arrows and confirmed with
%   the space bar. The returned VALUE is scaled linearly between MINVAL and
%   MAXVAL. RT is measured from scale onset to confirmation.

if nargin < 10 || isempty(yOffset)
    yOffset = 0;
end

keys = [KbName('LeftArrow') KbName('RightArrow') KbName('Space')];

halfWidth = widthPx / 2;
max_x = center(1) + halfWidth;
min_x = center(1) - halfWidth;
range_x = max_x - min_x;
xpos = center(1);

arrowheight = arrowWidthPx * 2;

start_time = GetSecs;
confirmed = false;
while ~confirmed
    WaitSecs(0.01);
    [~, response_time, keyCode] = KbCheck;
    if sum(keyCode) == 1
        direction = find(keyCode(keys));
        if direction == 1
            xpos = xpos - 8;
        elseif direction == 2
            xpos = xpos + 8;
        elseif direction == 3
            confirmed = true;
        end

        if xpos > max_x
            xpos = max_x;
        elseif xpos < min_x
            xpos = min_x;
        end
    end

    Screen('FillRect', windowPtr, [0 0 0]);
    % Draw scale line and anchors
    Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset, center(1) + halfWidth, center(2) + yOffset);
    Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset + 20, center(1) - halfWidth, center(2) + yOffset);
    Screen('DrawLine', windowPtr, [255 255 255], center(1) + halfWidth, center(2) + yOffset + 20, center(1) + halfWidth, center(2) + yOffset);

    DrawUTF8(windowPtr, prompt, 'center', center(2) + yOffset + 60, [255 255 255]);
    DrawUTF8(windowPtr, leftLabel, center(1) - halfWidth, center(2) + yOffset + 45, [255 255 255]);
    DrawUTF8(windowPtr, rightLabel, center(1) + halfWidth - 60, center(2) + yOffset + 45, [255 255 255]);

    arrowPoints = [([-0.5 0 0.5]' .* arrowWidthPx) + xpos ([1 0 1]' .* arrowheight) + center(2) + yOffset];
    Screen('FillPoly', windowPtr, [255 255 255], arrowPoints);
    Screen('Flip', windowPtr);
end

value = ((xpos - min_x) ./ range_x) .* (maxVal - minVal) + minVal;
RT = response_time - start_time;

% Confirmation flash
Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset, center(1) + halfWidth, center(2) + yOffset);
Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset + 20, center(1) - halfWidth, center(2) + yOffset);
Screen('DrawLine', windowPtr, [255 255 255], center(1) + halfWidth, center(2) + yOffset + 20, center(1) + halfWidth, center(2) + yOffset);
DrawUTF8(windowPtr, prompt, 'center', center(2) + yOffset + 60, [255 255 255]);
DrawUTF8(windowPtr, leftLabel, center(1) - halfWidth, center(2) + yOffset + 45, [255 255 255]);
DrawUTF8(windowPtr, rightLabel, center(1) + halfWidth - 60, center(2) + yOffset + 45, [255 255 255]);
arrowPoints = [([-0.5 0 0.5]' .* arrowWidthPx) + xpos ([1 0 1]' .* arrowheight) + center(2) + yOffset];
Screen('FillPoly', windowPtr, [255 0 0], arrowPoints);
Screen('Flip', windowPtr);
WaitSecs(0.25);

