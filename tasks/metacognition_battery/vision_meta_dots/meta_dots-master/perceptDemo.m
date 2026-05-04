        function perceptWrapper
% Dots task for perceptual metacognition
% Sebastien Massoni, modified by SF 2013

clear all
clc

baseDir = fileparts(mfilename('fullpath'));
myPsychtoolboxDir = fullfile(baseDir, 'mypsychtoolbox');
if exist(myPsychtoolboxDir, 'dir')
    addpath(myPsychtoolboxDir)
end

generalDir = fullfile(baseDir, '..', '..', 'general_functions');
addpath(generalDir);
forcePTBCompatibilityMode();
PsychJavaTrouble()
%% Parameters
p = perceptGetParams;

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
%% Introduct ion
DrawUTF8(p.frame.ptr, ['欢迎参加本实验！' newline newline ...
    '按下空格键以了解任务内容！'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

%% Example stimul i

DrawUTF8(p.frame.ptr, ['屏幕上会出现两个圆圈，每个圆圈里都有一些点。' newline newline ...
    '你的任务是判断哪个圆圈里包含的点数更多。' newline newline ...
    '随后我们会请你对自己的选择给出“信心程度”的评分。' newline newline ...
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

%% Main task blocks (8 blocks of 25 trials)
DrawUTF8(p.frame.ptr, '请按下空格键开始……', 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));
nblocks = 1;
feedback = 0;
conf = 1;
ntrials = 10;
staircase_reversal = Inf;
stepsize = 1;
adapt = 0;
for b = 1:nblocks
    start_x = 4;    % hardcode a starting offset of 4 dots
    results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x);
    xc=median(results.contrast(results.i_trial_lastreversal:end)  ); % contrast at end of block
    DrawUTF8(p.frame.ptr, '本段结束，可以短暂休息！', 'center', 'center');
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    WaitAnyPress(KbName('space'));    
    DATA(b).results = results;
    
    save(p.filename,'DATA');
end

%% Save the data and exit
Screen('Closeall')
