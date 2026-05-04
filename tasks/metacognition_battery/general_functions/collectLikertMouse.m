function [response, RT] = collectLikertMouse(windowPtr, prompt, anchors)
% collectLikertMouse Present a 7-point Likert scale and collect key 1-7.

if nargin < 3 || isempty(anchors)
    anchors = {'Not at all','Almost none','A little','Moderate','Quite a bit','A lot','Very much'};
end

KbName('UnifyKeyNames');
numericKeys = [KbName('1!') KbName('2@') KbName('3#') KbName('4$') KbName('5%') KbName('6^') KbName('7&')];

Screen('TextSize', windowPtr, 24);
[screenX, screenY] = Screen('WindowSize', windowPtr);
centerY = screenY/2;
startX = screenX*0.15;
endX = screenX*0.85;
xPositions = linspace(startX, endX, numel(anchors));
boxWidth = 60;
boxHeight = 50;
boxes = nan(numel(anchors), 4);
promptLines = wrapLikertText(prompt, 34);

for i = 1:numel(anchors)
    boxes(i,:) = CenterRectOnPointd([0 0 boxWidth boxHeight], xPositions(i), centerY+60);
end

start_time = GetSecs;
response = NaN;
while isnan(response)
    drawLikertScreen(windowPtr, promptLines, anchors, boxes, xPositions, startX, endX, centerY, NaN);
    Screen('Flip', windowPtr);

    WaitSecs(0.01);
    try
        [~, ~, keyCode] = KbCheck(-1);
    catch
        [~, ~, keyCode] = KbCheck;
    end
    keyIdx = find(keyCode(numericKeys), 1);
    if ~isempty(keyIdx)
        response = keyIdx;
        RT = GetSecs - start_time;
        drawLikertScreen(windowPtr, promptLines, anchors, boxes, xPositions, startX, endX, centerY, response);
        Screen('Flip', windowPtr);
        WaitSecs(0.25);
    end
end

end

function drawLikertScreen(windowPtr, promptLines, anchors, boxes, xPositions, startX, endX, centerY, selected)
Screen('FillRect', windowPtr, [0 0 0]);
Screen('TextSize', windowPtr, 24);
drawLikertLines(windowPtr, promptLines, centerY-170, [255 255 255]);

for i = 1:numel(anchors)
    if isequal(i, selected)
        Screen('FrameRect', windowPtr, [255 0 0], boxes(i,:), 4);
        DrawUTF8(windowPtr, num2str(i), xPositions(i)-6, centerY+48, [255 0 0]);
    else
        Screen('FrameRect', windowPtr, [255 255 255], boxes(i,:), 2);
        DrawUTF8(windowPtr, num2str(i), xPositions(i)-6, centerY+48, [255 255 255]);
    end
end

Screen('TextSize', windowPtr, 22);
DrawUTF8(windowPtr, anchors{1}, startX-35, centerY+115, [255 255 255]);
DrawUTF8(windowPtr, anchors{4}, 'center', centerY+115, [255 255 255]);
DrawUTF8(windowPtr, anchors{7}, endX-35, centerY+115, [255 255 255]);
Screen('TextSize', windowPtr, 24);
end

function lines = wrapLikertText(text, wrapAt)
text = char(text);
rawLines = regexp(text, '\n', 'split');
lines = {};
for i = 1:numel(rawLines)
    current = rawLines{i};
    while length(current) > wrapAt
        lines{end+1} = current(1:wrapAt); %#ok<AGROW>
        current = current(wrapAt+1:end);
    end
    lines{end+1} = current; %#ok<AGROW>
end
end

function drawLikertLines(windowPtr, lines, startY, color)
lineHeight = 36;
for i = 1:numel(lines)
    DrawUTF8(windowPtr, lines{i}, 'center', startY + (i-1)*lineHeight, color);
end
end
