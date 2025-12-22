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

if isstring(prompt)
    prompt = char(join(prompt, newline));
elseif iscell(prompt)
    prompt = char(strjoin(prompt, '\n'));
end

if isstring(leftLabel)
    leftLabel = char(leftLabel);
end
if isstring(rightLabel)
    rightLabel = char(rightLabel);
end

% Split the prompt into wrapped UTF-8 lines so DrawUTF8 can render reliably
wrapAt = 36;
wrappedLines = wrapPromptText(prompt, wrapAt);

Screen('TextColor', windowPtr, [255 255 255]);

keys = [KbName('LeftArrow') KbName('RightArrow') KbName('Space')];

halfWidth = widthPx / 2;
max_x = center(1) + halfWidth;
min_x = center(1) - halfWidth;
range_x = max_x - min_x;
xpos = center(1);

arrowheight = arrowWidthPx * 2;
rect = Screen('Rect', windowPtr);
promptY = center(2) + yOffset - 120;
ticks = linspace(min_x, max_x, 6);
tickLabels = {'20%','40%','60%','80%'};
tickLabelPositions = ticks(2:5);

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
    % Draw scale line, ticks, and anchors
    Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset, center(1) + halfWidth, center(2) + yOffset);
    for i_tick = 1:numel(ticks)
        Screen('DrawLine', windowPtr, [255 255 255], ticks(i_tick), center(2) + yOffset + 15, ticks(i_tick), center(2) + yOffset - 15);
    end
    for i_label = 1:numel(tickLabelPositions)
        DrawUTF8(windowPtr, tickLabels{i_label}, tickLabelPositions(i_label) - 15, center(2) + yOffset + 30, [255 255 255]);
    end

    drawWrappedUTF8(windowPtr, wrappedLines, rect, promptY);
    DrawUTF8(windowPtr, leftLabel, center(1) - halfWidth - 20, center(2) + yOffset + 45, [255 255 255]);
    DrawUTF8(windowPtr, rightLabel, center(1) + halfWidth - 40, center(2) + yOffset + 45, [255 255 255]);

    arrowPoints = [([-0.5 0 0.5]' .* arrowWidthPx) + xpos ([1 0 1]' .* arrowheight) + center(2) + yOffset];
    Screen('FillPoly', windowPtr, [255 255 255], arrowPoints);
    Screen('Flip', windowPtr);
end

value = ((xpos - min_x) ./ range_x) .* (maxVal - minVal) + minVal;
RT = response_time - start_time;

% Confirmation flash
Screen('DrawLine', windowPtr, [255 255 255], center(1) - halfWidth, center(2) + yOffset, center(1) + halfWidth, center(2) + yOffset);
for i_tick = 1:numel(ticks)
    Screen('DrawLine', windowPtr, [255 255 255], ticks(i_tick), center(2) + yOffset + 15, ticks(i_tick), center(2) + yOffset - 15);
end
for i_label = 1:numel(tickLabelPositions)
    DrawUTF8(windowPtr, tickLabels{i_label}, tickLabelPositions(i_label) - 15, center(2) + yOffset + 30, [255 255 255]);
end
drawWrappedUTF8(windowPtr, wrappedLines, rect, promptY);
DrawUTF8(windowPtr, leftLabel, center(1) - halfWidth - 20, center(2) + yOffset + 45, [255 255 255]);
DrawUTF8(windowPtr, rightLabel, center(1) + halfWidth - 40, center(2) + yOffset + 45, [255 255 255]);
arrowPoints = [([-0.5 0 0.5]' .* arrowWidthPx) + xpos ([1 0 1]' .* arrowheight) + center(2) + yOffset];
Screen('FillPoly', windowPtr, [255 0 0], arrowPoints);
Screen('Flip', windowPtr);
WaitSecs(0.25);

end

function wrappedLines = wrapPromptText(prompt, wrapAt)
% wrapPromptText Break UTF-8 prompt into cell array of lines at wrapAt width.

if isempty(prompt)
    wrappedLines = {''};
    return;
end

lines = regexp(prompt, '\n', 'split');
wrappedLines = {};
for i_line = 1:numel(lines)
    current = string(lines{i_line});
    while strlength(current) > wrapAt
        wrappedLines{end+1} = char(extractBefore(current, wrapAt + 1)); %#ok<AGROW>
        current = extractAfter(current, wrapAt);
    end
    wrappedLines{end+1} = char(current); %#ok<AGROW>
end
end

function drawWrappedUTF8(windowPtr, wrappedLines, rect, startY)
% drawWrappedUTF8 Render wrapped lines centered with UTF-8 drawing.

    lineHeight = 28;
    for i_line = 1:numel(wrappedLines)
        % Estimating width avoids Screen('TextBounds') crashes on some UTF-8 strings
        % by assuming an average 8 px character width for centering.
        approxWidth = length(wrappedLines{i_line}) * 8;
        [centerX, ~] = RectCenter(rect);
        x = centerX - (approxWidth / 2);
        y = startY + ((i_line - 1) * lineHeight);
        DrawUTF8(windowPtr, wrappedLines{i_line}, x, y, [255 255 255]);
    end
end

