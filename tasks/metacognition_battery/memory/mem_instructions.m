function exitNow = mem_instructions(window, parameters, roundNum)

structName='parameters';
unpackStructFields

sx=120;
sy='center';
wrapat=60;

    %% write text
if (roundNum == 1)


    i=1;
    pg{i} = ['欢迎参加本实验！\n',...
    '在本任务中，你将完成一个词汇记忆测验。\n',...
    '屏幕上会呈现 50 个英文单词，\n'...
    '你将拥有 30 秒到 1.5 分钟的时间来学习和记忆它们。\n\n'...
    '请尽可能多地记住这些单词！\n\n'...
    '当本轮只剩 10 秒时，我们会提醒你。\n\n'...
    '时间结束后，你需要辨认刚才学过的单词。\n\n'];

    nextpg{i}   = '__________\n\n按任意键继续。';
    waitTime(i) = 1;

    i=i+1;
    pg{i} = ['记忆测试\n\n' ...
        '屏幕上会出现两个单词，一个来自你刚学习的列表，另一个没有出现过。\n\n'...
        '如果你认为左边的单词在列表中，请按左箭头键。\n\n'...
        '如果你认为右边的单词在列表中，请按右箭头键。\n'...
        '本阶段没有时间限制。\n\n'];

    nextpg{i}   = '__________\n\n按任意键继续。\n按左箭头返回上一页。';
    waitTime(i) = 1;
    
    i=i+1;
    pg{i} = ['记忆测试\n\n' ...
    '当你做出选择后，\n' ...
    '屏幕上会出现一个滑动刻度，帮助你评价是否选对了。\n\n'...
    '你可以使用左右方向键移动指示器，并按下空格键确认评分。\n'...
    '刻度左端表示比平时更不自信，\n'...
    '刻度右端表示比平时更自信。\n\n'...
    '请记住任务很困难——很少会非常自信！\n'...
    '我们关心信心的相对变化，请尽量使用整个刻度。\n\n'];

    nextpg{i}   = ['__________\n\n接下来先在没有学习列表的情况下练习作答。\n\n'...
        '按任意键查看一些练习示例！'];
    waitTime(i) = 1;

elseif (roundNum == 2)
   
    i=1;
    pg{i} = ['记忆测试\n\n' ...
    '接下来你将拥有 30 秒到 1.5 分钟\n' ...
    '来学习一组新的单词。\n\n\n'...
    '请尽全力，加油！\n\n'];

    nextpg{i}   = '__________\n\n按任意键开始学习。';
    waitTime(i) = 1;

end

oldTextSize = Screen('TextSize',window,28);

exitNow = 0;

% waitTime = zeros(size(waitTime));



%% present instructions

j=1;
while j <= length(pg)
    DrawUTF8(window,pg{j},sx,sy,0,wrapat);
    Screen('Flip',window);
    
    WaitSecs(waitTime(j));
    [nx ny] = DrawUTF8(window,pg{j},sx,sy,0,wrapat);
    DrawUTF8(window,nextpg{j},sx,ny);
    Screen('Flip',window);
    keyName = ptbWaitForKey({exitKey, 'LeftArrow', 'space', 'Space', 'RightArrow'});
    
    waitTime(j) = .5;
    
    switch keyName
        case exitKey, exitNow = 1; break;
        
        case 'LeftArrow'
            if j > 1, j=j-1; end
            
        otherwise
            % incremenet page counter
            j=j+1;
    end
end
