function [results m] = memTest(subID, wPtr, rect, studyList, unstudiedList, studyTime, p, roundNum)

%get params for experiment
m = getMemParams(subID, studyList, unstudiedList);

if IsWin
    dataDir = [pwd '\memData\'];
else
    dataDir = [pwd '/memData/'];
end

if IsWin
    addpath([pwd '\functions']);
else
    addpath([pwd '/functions']);
end

KbName('UnifyKeyNames');

%initialize results struct
results.subID = m.subID;
results.studiedListNum = m.studiedListNum;
results.unstudiedListNum = m.unstudiedListNum;
results.studiedOrder = m.studiedPerm;
results.unstudiedOrder = m.unstudiedPerm;
results.studiedWordList = m.wordLists(results.studiedOrder,results.studiedListNum);
results.unstudiedWordList = m.wordLists(results.unstudiedOrder,results.unstudiedListNum);
results.studiedWord = {};
results.unstudiedWord = {};
results.studiedSide = {};
results.rtChoice = [];
results.rtConf = [];
results.responseChoice = {};
results.responseConf = [];

%screen center
[mx, my] = RectCenter(rect);
[p.mx,p.my] = RectCenter(rect);
%text positions
positions = [mx - 200, mx + 100];
fixCrossBlack = Screen('MakeTexture', wPtr, m.FixCrB);
fixCrossWhite = Screen('MakeTexture', wPtr, m.FixCrW);

%% Do some practice trials
if roundNum == 1
    Screen('TextSize',wPtr,24);
    DrawUTF8(wPtr, '按任意键查看练习示例…', 'center', 'center', m.textColor, [], [], [], 1.5);
    studyStart = Screen('Flip', wPtr);
    KbWait;
    
    practiceWords = {'TEA','RAISIN','PENGUIN','HEAVY','TOMORROW','MOONLIGHT','RUNNING','BICYCLE','HIGHWAY','BUFFALO','PAINTING','TODAY'};
    j=1;
    for i = 1:length(practiceWords)/2
        
        sidechoice = randperm(2);
        
        DrawUTF8(wPtr,practiceWords{j}, positions(sidechoice(1)), 'center', m.textColor);
        DrawUTF8(wPtr,practiceWords{j+1}, positions(sidechoice(2)), 'center', m.textColor);
        
        Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
        vbl = Screen('Flip',wPtr);
        
        FlushEvents;
        trialComplete = false;
        while ~trialComplete
            [k, respTime, keyName] = ptbCheckKey({'LeftArrow', 'RightArrow'});
            if strcmpi(keyName,'LeftArrow') || strcmpi(keyName,'RightArrow')
                trialComplete = true;
            end
        end
        response = keyName;
        rt = respTime - vbl;
        
        % show confirmation of response
        DrawUTF8(wPtr,practiceWords{j}, positions(sidechoice(1)), 'center', m.textColor);
        DrawUTF8(wPtr,practiceWords{j+1}, positions(sidechoice(2)), 'center', m.textColor);
        Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
        
        Screen('TextSize',wPtr,48);
        if strcmp(response, 'LeftArrow')
            DrawUTF8(wPtr,'*', positions(1), my-100, m.textColor);
        elseif strcmp(response, 'RightArrow')
            DrawUTF8(wPtr,'*', positions(2), my-100, m.textColor);
        end
        Screen('TextSize',wPtr,24);
        vbl = Screen('Flip',wPtr);
        pause(p.memConfirm_inSecs);
        
        if (k == 1)
            
            % now collect confidence
            [conf RT] = collectConfidenceDiscrete(wPtr,p);
            
        else
            DrawUTF8(wPtr,'未作答！','center','center');
            Screen('Flip',wPtr);
            pause(p.confFBDuration_inSecs + p.confDuration_inSecs);
            
        end
        j=j+2;
    end
end

%% Main experiment
% Get ready to see the display
Screen('TextSize',wPtr,24);
if roundNum == 1
    DrawUTF8(wPtr, '接下来请学习第一组单词……', 'center', my-200, m.textColor, [], [], [], 1.5);
else
    DrawUTF8(wPtr, '接下来请学习下一组单词……', 'center', my-200, m.textColor, [], [], [], 1.5);
end
DrawUTF8(wPtr, '按任意键开始学习！', 'center', 'center', m.textColor, [], [], [], 1.5);
studyStart = Screen('Flip', wPtr);
KbWait;

%display list to study
DrawUTF8(wPtr,m.studyListDisplay1, mx-450, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay2, mx-250, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay3, mx-50, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay4, mx+150, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay5, mx+350, 'center', m.textColor, [], [], [], 1.5);
studyStart = Screen('Flip', wPtr);
disp(studyStart);
disp(studyTime);
disp(studyStart + (studyTime - 10));
%WaitSecs(studyTime - 10);
DrawUTF8(wPtr,m.studyListDisplay1, mx-450, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay2, mx-250, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay3, mx-50, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay4, mx+150, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,m.studyListDisplay5, mx+350, 'center', m.textColor, [], [], [], 1.5);
DrawUTF8(wPtr,'还剩 10 秒……', 'center', my*2 - 200, m.textColor, [], [], [], 1.5);
thirtySecsLeft = Screen('Flip', wPtr, studyStart + (studyTime - 10));
%WaitSecs(10);

DrawUTF8(wPtr,m.instructions2, 'center', 'center', m.textColor);
Screen('Flip', wPtr, thirtySecsLeft + 10);
KbWait;

for i = 1:size(m.wordLists,1)
    
    sidechoice = randperm(2);
    
    DrawUTF8(wPtr,results.studiedWordList{i}, positions(sidechoice(1)), 'center', m.textColor);
    DrawUTF8(wPtr,results.unstudiedWordList{i}, positions(sidechoice(2)), 'center', m.textColor);
    Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
    vbl = Screen('Flip',wPtr);
    
    FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k, respTime, keyName] = ptbCheckKey({'LeftArrow', 'RightArrow', 'ESCAPE'});
        if strcmpi(keyName,'LeftArrow') || strcmpi(keyName,'RightArrow')
            trialComplete = true;
        elseif strcmpi(keyName,'ESCAPE')
            Screen('CloseAll')
            return
        end
    end
    response = keyName;
    rt = respTime - vbl;
    
    % show confirmation of response
    DrawUTF8(wPtr,results.studiedWordList{i}, positions(sidechoice(1)), 'center', m.textColor);
    DrawUTF8(wPtr,results.unstudiedWordList{i}, positions(sidechoice(2)), 'center', m.textColor);
    Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
    
    Screen('TextSize',wPtr,48);
    if strcmp(response, 'LeftArrow')
        DrawUTF8(wPtr,'*', positions(1), my-100, m.textColor);
    elseif strcmp(response, 'RightArrow')
        DrawUTF8(wPtr,'*', positions(2), my-100, m.textColor);
    end
    Screen('TextSize',wPtr,24);
    vbl = Screen('Flip',wPtr);
    pause(p.memConfirm_inSecs);
    
    %record results
    results.studiedWord{i} = results.studiedWordList{i};
    results.unstudiedWord{i} = results.unstudiedWordList{i};
    results.studiedSide{i} = m.positions(sidechoice(1));
    results.rtChoice(i) = rt;
    results.responseChoice{i} = response;
    
    if (k == 1)
        
        % now collect confidence
        [conf RT] = collectConfidenceDiscrete(wPtr,p);
        
        results.responseConf(i) = conf;
        results.rtConf(i) = RT;
    else
        DrawUTF8(wPtr,'未作答！','center','center');
        Screen('Flip',wPtr);
        pause(p.confFBDuration_inSecs + p.confDuration_inSecs);
        
        results.responseConf(i) = NaN;
        results.rtConf(i) = NaN;
    end
%     
%     if i == size(m.wordLists,1)/2   % give a break halfway through
%         DrawUTF8(wPtr, '请稍作休息！', 'center', my-150, m.textColor, [], [], [], 1.5);
%         DrawUTF8(wPtr, '按任意键回答本列表剩余的问题……', 'center', 'center', m.textColor, [], [], [], 1.5);
%         Screen('Flip', wPtr);
%         KbWait;
%     end
%     
end
