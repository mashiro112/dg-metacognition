function [scaledX, RT_Conf] = Confidence_Scale(p, practice)
KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');

% Define response keys 
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
respKey = KbName('RightShift');

% Set the amount we want our square to move on each button pr ess
pixelsPerPress = 5;

% Line
buttomLine = p.yCenter;
lineWidth = 4;
startLine = p.xCenter - 500;
endLine = p.xCenter + 500;


% initialDotPos = randi([startLine, endLine]); 
initialDotPos = p.xCenter;
dotX = initialDotPos;

while 1
    
% Text - top of the screen
if ~practice
   textLine =  ['现在的信心程度如何？'];
elseif practice
    textLine = ['使用左右方向键移动绿色圆点，并按下左 Shift 键确认' '\n \n 现在的信心程度如何？'];
end     
   
Screen('TextSize',p.window,40);    
DrawUTF8(p.window,textLine,'center',p.yCenter - 250,p.white);


% Static line - bottom
Screen('DrawLine', p.window, p.white, startLine , buttomLine, p.xCenter + 500, buttomLine, lineWidth);
Screen('DrawLine', p.window, p.white, startLine, buttomLine - 10, startLine, buttomLine + 10, lineWidth);
Screen('DrawLine', p.window, p.white, endLine, buttomLine - 10, endLine, buttomLine + 10, lineWidth);
Screen('DrawLine', p.window, p.white, p.xCenter, buttomLine - 10, p.xCenter, buttomLine + 10, lineWidth);

Screen('TextSize',p.window,30);
% Text - bottom
DrawUTF8(p.window,'非常不确定',p.xCenter - 560,buttomLine + 60,p.white);
% DrawUTF8(p.window,'50% 信心','center',buttomLine + 60,p.white);
DrawUTF8(p.window,'完全确定',p.xCenter + 470,buttomLine + 60,p.white);


[keyIsDown, respSecs, keyCode] = KbCheck;

% responses (keyCode)
if keyCode(leftKey)
    dotX = dotX -  pixelsPerPress;
elseif keyCode(rightKey)
    dotX = dotX + pixelsPerPress;
end

if dotX < startLine     % do not move outside the limit
    dotX = startLine;    % keep it at the limit!
elseif dotX > endLine
    dotX = endLine;
end


% draw the dot
Screen('DrawDots', p.window, [dotX buttomLine], 20, p.green, [], 2);

scaledX = mapfun(dotX, startLine, endLine, 1, 100);
scaledX = fix(scaledX);

% scaledXstr = num2str(scaledX);
% DrawUTF8(p.window,scaledXstr,p.xCenter - 20,buttomLine + 260,p.white);

t=Screen(p.window,'Flip');



FlushEvents;
[keyIsDown, sec, keyCode] = KbCheck;


if keyIsDown
    if keyCode(respKey)
%         endTime = GetSecs();
        RT_Conf = 1000.*(sec - t);
        break;
        
    elseif keyCode(escKey)
        ShowCursor;
        RT_Conf = 0;
        Screen('CloseAll');
        return;
    end
end

end

Screen('TextSize',p.window,40);    
DrawUTF8(p.window,textLine,'center',p.yCenter - 250,p.white);



% Static line - bottom
Screen('DrawLine', p.window, p.white, startLine , buttomLine, p.xCenter + 500, buttomLine, lineWidth);
Screen('DrawLine', p.window, p.white, startLine, buttomLine - 10, startLine, buttomLine + 10, lineWidth);
Screen('DrawLine', p.window, p.white, endLine, buttomLine - 10, endLine, buttomLine + 10, lineWidth);
Screen('DrawLine', p.window, p.white, p.xCenter, buttomLine - 10, p.xCenter, buttomLine + 10, lineWidth);


Screen('TextSize',p.window,30);
% Text - bottom
DrawUTF8(p.window,'非常不确定',p.xCenter - 560,buttomLine + 60,p.white);
% DrawUTF8(p.window,'50% 信心','center',buttomLine + 60,p.white);
DrawUTF8(p.window,'完全确定',p.xCenter + 470,buttomLine + 60,p.white);

Screen('DrawDots', p.window, [dotX buttomLine], 20, p.blue, [], 2);

Screen(p.window,'Flip');


end






