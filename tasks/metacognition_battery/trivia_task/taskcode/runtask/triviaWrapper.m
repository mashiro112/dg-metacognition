 %%%%%%%%%%%%%%%%%%%TRIVIAMETACOGNITIONTASK%%%%%%%%%%%% %%%%%%%% %%%%%%% %

 function out = triviaWrapper(sID, measureType)

triviaDir = fileparts(mfilename('fullpath'));
generalDir = fullfile(triviaDir, '..', '..', '..', 'general_functions');
addpath(generalDir);
 
KbName ('UnifyKeyNames');  
KbCheck;

p = triviaGetParams(sID);

Screen('Preference','TextRenderer', 1);
Screen('Preference','TextEncodingLocale','UTF-8');

try
    fonts = Screen('Fonts');
    font = 'Microsoft YaHei';
    if ~any(strcmpi(fonts, font))
        font = 'SimHei';
    end
catch
    font = 'Microsoft YaHei';
end

Screen('TextFont',  p.window, font);
Screen('TextStyle', p.window, 0);
Screen('TextSize',  p.window, 28);
Screen('TextColor', p.window, [255 255 255]);

Screen('TextSize', p.window, p.textSize);
HideCursor;

if nargin < 2 || isempty(measureType)
    measureType = 'taskBelief';
end

metaRatings = struct(...
    'assignedMeasure', measureType,...
    'taskBeliefPre', NaN, 'taskBeliefPreRT', NaN,...
    'taskBeliefPost', NaN, 'taskBeliefPostRT', NaN,...
    'socialRankPre', NaN, 'socialRankPreRT', NaN,...
    'socialRankPost', NaN, 'socialRankPostRT', NaN,...
    'socialManipCheckPre', NaN, 'socialManipCheckPreRT', NaN,...
    'socialManipCheckPost', NaN, 'socialManipCheckPostRT', NaN);



% Introduction
DrawUTF8(p.window,['欢迎参加本实验！' '\n \n 按任意键继续。'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
KbWait;


%% initialize a dummy results
results = struct;

results.S(1) = p.S(1); % condition 1 staircase 
results.S(2) = p.S(2); % condition 2 staircase

results.nreversals = [0 0]; % n columns per conditions 
results.step_level = [1 1]; % step levels for each condition
results.stepsize = p.stepsize; 


results.countries_repeat_list = p.countries_repeat_list;
results.foods_repeat_list = p.foods_repeat_list;
results.repeat_threshold = p.repeat_threshold;




%% practice block
feedback = 1;
confidence =  1; 
enablePlotting = 1; 
trial_counter = 0; 
WaitSecs(1);
blockNumber = 1;
trivia_instructions(p.window, p);

[results, trial_counter] = runPracticeBlock(p,confidence, feedback, blockNumber, results, trial_counter);


DrawUTF8(p.window,['太好了！如有任何问题，请向实验员提问。'...
                            '\n \n 否则按任意键继续。'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
KbWait;

%% initialize a real results

results = struct;

results.S(1) = p.S(1); % condition 1 staircase
results.S(2) = p.S(2); % condition 2 staircase

results.nreversals = [0 0]; % n columns per conditions 
results.step_level = [1 1]; % step levels for each condition
results.stepsize = p.stepsize; 


results.countries_repeat_list = p.countries_repeat_list;
results.foods_repeat_list = p.foods_repeat_list;
results.repeat_threshold = p.repeat_threshold;

results.taskBeliefPre = NaN;
results.taskBeliefPost = NaN;
results.socialRankPre = NaN;
results.socialRankPost = NaN;
results.socialManipCheckPre = NaN;
results.socialManipCheckPost = NaN;
results.taskBeliefPreRT = NaN;
results.taskBeliefPostRT = NaN;
results.socialRankPreRT = NaN;
results.socialRankPostRT = NaN;
results.socialManipCheckPreRT = NaN;
results.socialManipCheckPostRT = NaN;
results.assignedMeasure = measureType;

ratingCenter = [p.mx p.my];
scaleWidth = p.stim.VASwidth_inPixels;
arrowWidth = p.stim.arrowWidth_inPixels;
offset = p.stim.VASoffset_inPixels;

switch measureType
    case 'taskBelief'
        [metaRatings.taskBeliefPre, metaRatings.taskBeliefPreRT] = collectContinuousRating(p.window, ratingCenter, scaleWidth, ...
            ['在趣味知识问答测试中，你需要对各类事实做出判断。' newline ...
            '例如，你要判断两个国家中哪一个在过去的十年间的平均国内生产总值更高，' newline ...
            '或是判断两份食物中哪一份的热量更高。' newline ...
            '其中，国内生产总值相关判断和食物相关判断各有 100 轮测试，' newline newline ...
            '请预估你在趣味知识问答测试中答对的总百分比(1–100%)：'], ...
            '答对1%', '答对100%', 1, 100, arrowWidth, offset);
        results.taskBeliefPre = metaRatings.taskBeliefPre;
        results.taskBeliefPreRT = metaRatings.taskBeliefPreRT;
    case 'socialRank'
        [metaRatings.socialRankPre, metaRatings.socialRankPreRT] = collectContinuousRating(p.window, ratingCenter, scaleWidth, ...
            ['在趣味知识问答测试中，你需要对各类事实做出判断。' newline ...
            '例如，你要判断两个国家中哪一个在过去的十年间的平均国内生产总值更高，' newline ...
            '或是判断两份食物中哪一份的热量更高。' newline ...
            '其中，国内生产总值相关判断和食物相关判断各有 100 轮测试。' newline newline ...
            '想象一下：现在需要将100位与你身份相似的同龄人，按照语义知识领域能力强弱进行排序，' newline newline ...
            '你认为自己在这100人中能排在第几名(1-100)？'], ...
            '第1名', '第100名', 1, 100, arrowWidth, offset);
        [metaRatings.socialManipCheckPre, metaRatings.socialManipCheckPreRT] = collectLikertMouse(p.window, ...
            '刚刚回答的过程中，我有把自己置于同群体中进行想象，并进行了比较。请按 1-7 选择。');
        results.socialRankPre = metaRatings.socialRankPre;
        results.socialRankPreRT = metaRatings.socialRankPreRT;
        results.socialManipCheckPre = metaRatings.socialManipCheckPre;
        results.socialManipCheckPreRT = metaRatings.socialManipCheckPreRT;
end

results.metaRatings = metaRatings;

save(p.filename, 'results', 'metaRatings');


%% Real Block
feedback = 0;
confidence =  1; 
enablePlotting = 1; 
trial_counter = 0; 
WaitSecs(1);
%expStart = tic;

for blockNumber = 1 : p.numberOfBlocks

    [results, trial_counter] = runBlock(p,confidence, feedback, blockNumber, results, trial_counter);
    
    string = ['第 ' num2str(blockNumber) ' 段，共 ' num2str(p.numberOfBlocks) ' 段'];
    DrawUTF8(p.window,[string '\n \n 按任意键继续。'], 'center', 'center', p.textColor);
    Screen('Flip', p.window);
    KbWait;
    
    WaitSecs(.5);

end
%expEnd = toc;

switch measureType
    case 'taskBelief'
        [metaRatings.taskBeliefPost, metaRatings.taskBeliefPostRT] = collectContinuousRating(p.window, ratingCenter, scaleWidth, ...
            ['在趣味知识问答测试中，你判断了两个国家里哪一个在过去十年间的平均国内生产总值更高，' newline ...
            '同时也判断了两份食物中哪一份的热量更高。' newline newline ...
            '请预估你在趣味知识问答测试中答对了的总百分比（1–100%）：'], ...
            '答对1%', '答对100%', 1, 100, arrowWidth, offset);
        results.taskBeliefPost = metaRatings.taskBeliefPost;
        results.taskBeliefPostRT = metaRatings.taskBeliefPostRT;
    case 'socialRank'
        [metaRatings.socialRankPost, metaRatings.socialRankPostRT] = collectContinuousRating(p.window, ratingCenter, scaleWidth, ...
            ['在趣味知识问答测试中，你对各类事实做出了判断。' newline ...
            '比如，你判断了两个国家中哪一个在过去的十年间的平均国内生产总值更高，' newline ...
            '也判断了两份食物中哪一份的热量更高。' newline newline ...
            '想象一下：现在需要将100位与你身份相似的同龄人，按照语义知识领域能力强弱进行排序，' newline newline ...
            '你认为自己在这100人中能排在第几名(1-100)？'], ...
            '第1名', '第100名', 1, 100, arrowWidth, offset);
        [metaRatings.socialManipCheckPost, metaRatings.socialManipCheckPostRT] = collectLikertMouse(p.window, ...
            '刚刚回答的过程中，我有把自己置于同群体中进行想象，并进行了比较。请按 1-7 选择。');
        results.socialRankPost = metaRatings.socialRankPost;
        results.socialRankPostRT = metaRatings.socialRankPostRT;
        results.socialManipCheckPost = metaRatings.socialManipCheckPost;
        results.socialManipCheckPostRT = metaRatings.socialManipCheckPostRT;
end

results.metaRatings = metaRatings;

save(p.filename, 'results', 'metaRatings');

%% FAMILIARITY SCALE
%
% likert = 1; % 0 == YES/NO questions; 1 == likert scale
% [results]=familiarityQuestions(p, results, likert);
% 

%% End
Screen('TextSize', p.window, p.textSize);
DrawUTF8(p.window,['实验结束！' '\n \n 感谢你的参与。'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
WaitSecs(2);

sca;       

out = [];

 end









 