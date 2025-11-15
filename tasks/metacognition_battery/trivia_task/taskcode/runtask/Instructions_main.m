function Instructions_main(p, list_countries_complete, list_food_complete, countriesfood, foodcountries)



countries_1_pos = 1; %London
countries_2_pos = 2; %Paris

%loading images
im_left = Screen('MakeTexture', p.window, list_countries_complete{countries_1_pos, 3});
im_right = Screen('MakeTexture', p.window, list_countries_complete{countries_2_pos, 3});
%  Assigning the word for the countries
word_left = list_countries_complete(countries_1_pos, 1);
word_right = list_countries_complete(countries_2_pos, 1);
word_left = char(word_left);
word_right = char(word_right);

Screen('TextSize',p.window,p.textSize);
DrawUTF8(p.window,['在本任务中，你将看到两个国家的图片和名称，如下所示。'...
    '\n\n每一试次请判断哪个国家的人口更多。'],...
    'center',p.screenYpixels * 0.15, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawUTF8(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawUTF8(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawUTF8(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

WaitSecs(3);
Screen('TextSize',p.window,20);
DrawUTF8(p.window,'按任意键继续……',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(2);

KbWait;

Screen('TextSize',p.window,p.textSize);
DrawUTF8(p.window,'现在请按下左箭头或右箭头进行练习选择。',...
    'center',p.screenYpixels * 0.15, p.textColor);
DrawUTF8(p.window,'你认为哪个国家的人口更多？',...
    'center',p.screenYpixels * 0.25, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawUTF8(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawUTF8(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawUTF8(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('Flip', p.window);
WaitSecs(1);



FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k respTime keyCode] = KbCheck();
        if strcmp(KbName(keyCode),'LeftArrow') | strcmp(KbName(keyCode),'RightArrow')
            trialComplete = true;
        elseif strcmp(KbName(keyCode),'ESCAPE')
            Screen('CloseAll')
            return
        end
    end
    
response = KbName(keyCode);

Screen('TextSize',p.window,p.textSize);
DrawUTF8(p.window,'现在请按下左箭头或右箭头进行练习选择。',...
    'center',p.screenYpixels * 0.15, p.textColor);
DrawUTF8(p.window,'你认为哪个国家的人口更多？',...
    'center',p.screenYpixels * 0.25, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawUTF8(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawUTF8(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawUTF8(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('TextSize',p.window,48);
if strcmp(response, 'LeftArrow')
    DrawUTF8(p.window,'*', p.xCenter - 400, p.yCenter+250, p.textColor);
    resp = 1;
elseif strcmp(response, 'RightArrow')
    DrawUTF8(p.window,'*', p.xCenter + 350, p.yCenter+250, p.textColor); 
    resp = 2;
end
Screen(p.window, 'Flip');

WaitSecs(1.5);



Screen('TextSize',p.window,p.textSize);
DrawUTF8(p.window,['当你完成选择后，我们会请你评估自己对该决定的信心。' '\n \n 使用方向键选择，并按下空格键确认。'],...
    'center',p.screenYpixels * 0.40, p.textColor);


Screen('TextSize',p.window,20);
DrawUTF8(p.window,'按任意键继续……',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;

WaitSecs(0.5);
practice = 1;
[scaledX, RT_Conf] = Confidence_Scale(p, practice);

scaledXstr = num2str(scaledX);
Screen('TextSize',p.window,p.textSize);
DrawUTF8(p.window,['你觉得自己对该决定的信心为 ' scaledXstr '%'],...
    'center',p.screenYpixels * 0.45, p.textColor);
if resp==1
    DrawUTF8(p.window,['你答对了！伦敦的人口多于巴黎。'],...
    'center',p.screenYpixels * 0.55, p.textColor);
elseif resp==2
    DrawUTF8(p.window,['很遗憾，这次不正确。伦敦的人口多于巴黎。'],...
    'center',p.screenYpixels * 0.55, p.textColor);
end

Screen('TextSize',p.window,20);
DrawUTF8(p.window,'按任意键继续……',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;


Screen('TextSize',p.window,p.textSize); 
DrawUTF8(p.window,['现在准备开始正式任务！' '\n \n 屏幕会依次呈现一对对国家，每次选择后都需要报告你的信心程度。'...
    '\n \n 在任务过程中不会提供正确答案反馈。'...
    '\n \n 如果有任何疑问，请向实验员提问。' '\n \n 准备好后按任意键开始。' '\n \n 祝你好运！'],...
    'center',p.screenYpixels * 0.30, p.textColor);
Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;

end