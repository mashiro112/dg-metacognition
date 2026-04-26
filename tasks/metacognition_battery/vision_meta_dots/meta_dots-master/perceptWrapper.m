function perceptWrapper(sID, measureType)
% Dots task for perceptual metacognition
% Sebastien Massoni, modified by SF 2013


clc
addpath('mypsychtoolbox')

baseDir = fileparts(mfilename('fullpath'));
generalDir = fullfile(baseDir, '..', '..', 'general_functions');
addpath(generalDir);
KbName('UnifyKeyNames');
PsychJavaTrouble()
%% Parameters
p = perceptGetParams(sID);

windowPtr = p.frame.ptr;
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

Screen('TextFont',  windowPtr, font);
Screen('TextStyle', windowPtr, 0);
Screen('TextSize',  windowPtr, 28);
Screen('TextColor', windowPtr, [255 255 255]);

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
%% Introduct ion
DrawUTF8(p.frame.ptr, ['欢迎参加本实验！' newline newline ...
    '按下空格键以了解任务内容！'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

%% Example stimul i

DrawUTF8(p.frame.ptr,['屏幕上会出现两个圆圈，每个圆圈里都有一些点。\n'...
    '你的任务是判断哪个圆圈中的点数更多。\n'...
    '随后我们会请你为自己的决定给出信心评分。\n\n'...
    '请按下空格键继续。'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(2);
WaitAnyPress(KbName('space'));

DrawUTF8(p.frame.ptr,'下面是一些示例刺激', 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(1.0);

n=[40 60];
drawDots(p, n);
DrawUTF8(p.frame.ptr,'40 对 60', 'center', p.my+p.stim.diam+50);
t=Screen('Flip', p.frame.ptr);
WaitSecs(3);

n=[50 30];
drawDots(p, n);
DrawUTF8(p.frame.ptr,'50 对 30', 'center', p.my+p.stim.diam+50);
t=Screen('Flip', p.frame.ptr);
WaitSecs(3);

n=[53 58];
drawDots(p, n);
DrawUTF8(p.frame.ptr,'53 对 58', 'center', p.my+p.stim.diam+50);
t=Screen('Flip', p.frame.ptr);
WaitSecs(3);

n=[35 25];
drawDots(p, n);
DrawUTF8(p.frame.ptr,'35 对 25', 'center', p.my+p.stim.diam+50);
t=Screen('Flip', p.frame.ptr);
WaitSecs(3);

DrawUTF8(p.frame.ptr,['任务的第一部分是选择哪个圆圈包含的点数更多。\n'...
    '你将使用左右方向键做出选择。\n'...
    '接下来我们会带你熟悉这一部分的流程。\n'...
    '即使感觉像是在猜测也别担心——这是个很难的任务！\n\n'...
    '请按下空格键继续。'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(2);
WaitAnyPress(KbName('space'));

DrawUTF8(p.frame.ptr,['练习开始！' newline newline '按下空格键开始'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

Screen('FrameOval',p.frame.ptr,p.white,p.stim.rectL,p.stim.pen_width);
Screen('FrameOval',p.frame.ptr,p.white,p.stim.rectR,p.stim.pen_width);
t=Screen('Flip', p.frame.ptr);

%% Training on task, no confidence rating
% put into function with arguments feedback, confidence,
% converge or continuous

feedback = 1;
conf = 0;
ntrials = Inf;
staircase_reversal = 8;
stepsize = 4;
adapt  = 1;
start_x = round(.5*p.stim.REF); % start at REF+50%REF
results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x);
xc=median(results.contrast(results.i_trial_lastreversal:end)); % contrast at end of block

%% Training on task with confidence rating
DrawUTF8(p.frame.ptr, ['现在我们来练习如何使用信心量表。\n\n当你做出左右选择后，\n' ...
    '屏幕上会出现一个滑动刻度，帮助你评估自己是否选对了。\n\n'...
    '你可以使用左右方向键移动刻度上的指示器，\n'...
    '按下空格键即可确认你的信心评分。\n'...
    '刻度左端表示“比平时更不自信”，\n'...
    '刻度右端表示“比平时更自信”。\n\n'...
    '请记住任务很困难——很少会非常自信！\n'...
    '我们关注的是信心的相对变化，请尽量使用整个刻度。\n\n' ...
    '接下来将不会再提示你的回答对错！\n\n' ...
    '请按下空格键继续。'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

feedback = 0;
conf = 1;
ntrials = 10;
staircase_reversal = Inf;
start_x = xc;
stepsize = 1;
adapt = 0;
results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x);

ratingCenter = [p.mx p.my];
scaleWidth = p.stim.VASwidth_inPixels;
arrowWidth = p.stim.arrowWidth_inPixels;
offset = p.stim.VASoffset_inPixels;

switch measureType
    case 'taskBelief'
        [metaRatings.taskBeliefPre, metaRatings.taskBeliefPreRT] = collectContinuousRating(p.frame.ptr, ratingCenter, scaleWidth, ...
            ['视觉感知测试中，每一轮测试都会要求你观察两组点阵，随后判断哪一组的点数更多。' newline ...
            '测试共计 200 轮。请预估你在该视觉测试中答对的总百分比(1–100%)：'], ...
            '答对1%', '答对100%', 1, 100, arrowWidth, offset);
    case 'socialRank'
        [metaRatings.socialRankPre, metaRatings.socialRankPreRT] = collectContinuousRating(p.frame.ptr, ratingCenter, scaleWidth, ...
            ['视觉感知测试中，每一轮测试都会要求你观察两组点阵，随后判断哪一组的点数更多。' newline ...
            '测试共计 200 轮。想象一下：现在需要将100位与你身份相似的同龄人，按照知觉领域能力强弱进行排序，你认为自己在这100人中能排在第几名(1-100)？'], ...
            '第1名', '第100名', 1, 100, arrowWidth, offset);
        [metaRatings.socialManipCheckPre, metaRatings.socialManipCheckPreRT] = collectLikertMouse(p.frame.ptr, ...
            '刚刚回答的过程中，我有把自己置于同群体中进行想象，并进行了比较。请按 1-7 选择。');
end

DATA = struct([]);
save(p.filename, 'metaRatings', 'DATA');

%% Main task blocks (8 blocks of 25 trials)
Screen('TextColor', p.frame.ptr, [255 255 255]);
DrawUTF8(p.frame.ptr, ['接下来请完成 8 个区块，每个区块 25 个试次，与练习相同。\n\n' ...
    '如果有任何疑问，请现在向实验员提问！\n\n' ...
    '准备好后请按下空格键开始……'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));
nblocks = 8;
feedback = 0;
conf = 1;
ntrials = 25;
staircase_reversal = Inf;
stepsize = 1;
adapt = 0;
for b = 1:nblocks
    start_x = xc;
    results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x);
    if isfield(results, 'i_trial_lastreversal') && ~isempty(results.i_trial_lastreversal)
        start_idx = results.i_trial_lastreversal;
    else
        start_idx = numel(results.contrast);
    end
    start_idx = min(max(start_idx, 1), numel(results.contrast));
    xc = round(median(results.contrast(start_idx:end))); % contrast at end of block
    DrawUTF8(p.frame.ptr, ['休息一下！\n\n' ...
        '准备好后按下空格键开始下一段……'], 'center', 'center');
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    WaitAnyPress(KbName('space'));
    DATA(b).results = results;

    save(p.filename,'DATA','metaRatings');
end

switch measureType
    case 'taskBelief'
        [metaRatings.taskBeliefPost, metaRatings.taskBeliefPostRT] = collectContinuousRating(p.frame.ptr, ratingCenter, scaleWidth, ...
            ['在视觉感知测试中，你已观察了两组点阵，随后判断了哪一组的点数更多。' newline ...
            '请预估你在视觉测试中答对了的总百分比(1–100%):'], ...
            '答对1%', '答对100%', 1, 100, arrowWidth, offset);
    case 'socialRank'
        [metaRatings.socialRankPost, metaRatings.socialRankPostRT] = collectContinuousRating(p.frame.ptr, ratingCenter, scaleWidth, ...
            ['视觉感知测试中，你已观察了两组点阵，随后判断了哪一组的点数更多。' newline ...
            '想象一下：现在需要将100位与你身份相似的同龄人，按照知觉能力强弱进行排序，你认为自己在这100人中能排在第几名(1-100)？'], ...
            '第1名', '第100名', 1, 100, arrowWidth, offset);
        [metaRatings.socialManipCheckPost, metaRatings.socialManipCheckPostRT] = collectLikertMouse(p.frame.ptr, ...
            '刚刚回答的过程中，我有把自己置于同群体中进行想象，并进行了比较。请按 1-7 选择。');
end

save(p.filename,'DATA','metaRatings');

%% Save the data and exit
Screen('Closeall')
