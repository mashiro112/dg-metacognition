function [response, RT] = collectLikertMouse(windowPtr, prompt, anchors)
% collectLikertMouse Present a 7-point Likert scale and collect a mouse click.

if nargin < 3 || isempty(anchors)
    anchors = {'1','2','3','4','5','6','7'};
end

Screen('TextSize', windowPtr, 28);
[screenX, screenY] = Screen('WindowSize', windowPtr);
centerY = screenY/2;
startX = screenX*0.2;
endX = screenX*0.8;
xPositions = linspace(startX, endX, numel(anchors));
boxWidth = (endX-startX)/(numel(anchors))*0.6;
boxHeight = 80;
boxes = nan(numel(anchors), 4);

for i = 1:numel(anchors)
    boxes(i,:) = CenterRectOnPointd([0 0 boxWidth boxHeight], xPositions(i), centerY+60);
end

start_time = GetSecs;
response = NaN;
while isnan(response)
    Screen('FillRect', windowPtr, [0 0 0]);
    DrawUTF8(windowPtr, prompt, 'center', centerY-60, [255 255 255]);
    for i = 1:numel(anchors)
        Screen('FrameRect', windowPtr, [255 255 255], boxes(i,:), 2);
        DrawUTF8(windowPtr, anchors{i}, boxes(i,1)+boxWidth/2-10, boxes(i,2)+boxHeight/2-15, [255 255 255]);
    end
    Screen('Flip', windowPtr);

    [mx, my, buttons] = GetMouse(windowPtr);
    if any(buttons)
        for i = 1:numel(anchors)
            if IsInRect(mx, my, boxes(i,:))
                response = i;
                RT = GetSecs - start_time;
                Screen('FillRect', windowPtr, [0 0 0]);
                DrawUTF8(windowPtr, prompt, 'center', centerY-60, [255 255 255]);
                Screen('FrameRect', windowPtr, [255 0 0], boxes(i,:), 4);
                DrawUTF8(windowPtr, anchors{i}, boxes(i,1)+boxWidth/2-10, boxes(i,2)+boxHeight/2-15, [255 0 0]);
                Screen('Flip', windowPtr);
                WaitSecs(0.25);
                break
            end
        end
    end
end

