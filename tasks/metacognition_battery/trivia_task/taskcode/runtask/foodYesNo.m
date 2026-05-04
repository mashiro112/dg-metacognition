function [results] = foodYesNo(p, results)

lengthList = length(p.list_food.list_food_complete);

randomisedList = randperm(lengthList, lengthList);
randomisedList = randomisedList';

for i =1:lengthList
    
    position = randomisedList(i);
    
    image_str = strcat('./Food/', p.list_food.list_food_complete{position, 2});
    im = imread(image_str); food = Screen('MakeTexture',p.window, im);
    food_name = p.list_food.list_food_complete{position, 1};
    
    
    
    Screen('TextSize',p.window,p.textSize);
    DrawUTF8(p.window, '你熟悉这种食物吗？', 'center', 150, p.textColor);
    DrawUTF8(p.window, '是', p.screenXpixels .* .25, p.textYpos + 50, p.textColor);
    DrawUTF8(p.window, '否', p.screenXpixels .* .75, p.textYpos + 50, p.textColor);
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, food, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawUTF8(p.window, food_name, 'center', p.textYPosfam, p.textColor);
    
    t = Screen(p.window, 'Flip');
    
    FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k, respTime, keyName] = ptbCheckKey({'LeftArrow', 'RightArrow', 'ESCAPE'});
        if strcmpi(keyName,'LeftArrow') || strcmpi(keyName,'RightArrow')
            trialComplete = true;
            
            RT = 1000.*(respTime - t);
        elseif strcmpi(keyName,'ESCAPE')
            Screen('CloseAll')
            RT = 0;
            return
        end
    end
    
    response = keyName;
    
    
    Screen('TextSize',p.window,p.textSize);
    DrawUTF8(p.window, '你熟悉这种食物吗？', 'center', 150, p.textColor);
    DrawUTF8(p.window, '是', p.screenXpixels .* .25, p.textYpos + 50, p.textColor);
    DrawUTF8(p.window, '否', p.screenXpixels .* .75, p.textYpos + 50, p.textColor);
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, food, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawUTF8(p.window, food_name, 'center', p.textYPosfam, p.textColor);
    
    Screen('TextSize',p.window,48);
    if strcmp(response, 'LeftArrow')
        DrawUTF8(p.window,'*', p.screenXpixels .* .25, p.screenYpixels - 80, p.textColor);
    elseif strcmp(response, 'RightArrow')
        DrawUTF8(p.window,'*', p.screenXpixels .* .75,p.screenYpixels - 80, p.textColor);
    end
    Screen(p.window, 'Flip');
    WaitSecs(0.4);
    
    results.FoodFamiliarity.FoodItem{i} = food_name;
    results.FoodFamiliarity.Familiarity{i} = response;
    results.FoodFamiliarity.Type = 'Yes/No';
    
    save(p.filename, 'results');
    
    
    
end


end
