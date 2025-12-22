function [response, RT] = collectLikertMouse(windowPtr, prompt, anchors)
% collectLikertMouse Present a 7-point Likert scale and collect a key press (1-7).

if nargin < 3 || isempty(anchors)
    anchors = {'完全没有','几乎没有','有一点','中等程度','比较多','很多','非常多'};
end

KbName('UnifyKeyNames');
numericKeys = [KbName('1!') KbName('2@') KbName('3#') KbName('4$') KbName('5%') KbName('6^') KbName('7&')];

Screen('TextSize', windowPtr, 28);
[screenX, screenY] = Screen('WindowSize', windowPtr);
centerY = screenY/2;
startX = screenX*0.15;
endX = screenX*0.85;
xPositions = linspace(startX, endX, numel(anchors));
boxWidth = (endX-startX)/(numel(anchors))*0.9;
boxHeight = 90;
boxes = nan(numel(anchors), 4);

for i = 1:numel(anchors)
    boxes(i,:) = CenterRectOnPointd([0 0 boxWidth boxHeight], xPositions(i), centerY+70);
end

start_time = GetSecs;
response = NaN;
while isnan(response)
    Screen('FillRect', windowPtr, [0 0 0]);
    DrawUTF8(windowPtr, prompt, 'center', centerY-80, [255 255 255]);
    for i = 1:numel(anchors)
        Screen('FrameRect', windowPtr, [255 255 255], boxes(i,:), 2);
        try
            bbox = Screen('TextBounds', windowPtr, anchors{i});
            textW = bbox(3) - bbox(1);
            textH = bbox(4) - bbox(2);
        catch
            textW = length(anchors{i}) * 14;
            textH = 24;
        end
        textX = boxes(i,1) + (boxWidth - textW) / 2;
        textY = boxes(i,2) + (boxHeight - textH) / 2;
        DrawUTF8(windowPtr, anchors{i}, textX, textY, [255 255 255]);
    end
    Screen('Flip', windowPtr);

    WaitSecs(0.01);
    [~, ~, keyCode] = KbCheck;
    keyIdx = find(keyCode(numericKeys), 1);
    if ~isempty(keyIdx)
        response = keyIdx;
        RT = GetSecs - start_time;
        Screen('FillRect', windowPtr, [0 0 0]);
        DrawUTF8(windowPtr, prompt, 'center', centerY-80, [255 255 255]);
        Screen('FrameRect', windowPtr, [255 0 0], boxes(response,:), 4);
        try
            bbox = Screen('TextBounds', windowPtr, anchors{response});
            textW = bbox(3) - bbox(1);
            textH = bbox(4) - bbox(2);
        catch
            textW = length(anchors{response}) * 14;
            textH = 24;
        end
        textX = boxes(response,1) + (boxWidth - textW) / 2;
        textY = boxes(response,2) + (boxHeight - textH) / 2;
        DrawUTF8(windowPtr, anchors{response}, textX, textY, [255 0 0]);
        Screen('Flip', windowPtr);
        WaitSecs(0.25);
    end
end
