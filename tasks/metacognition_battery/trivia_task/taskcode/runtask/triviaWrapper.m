 %%%%%%%%%%%%%%%%%%%TRIVIAMETACOGNITIONTASK%%%%%%%%%%%% %%%%%%%% %%%%%%% %

 function out = triviaWrapper(sID)

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

save(p.filename, 'results');
exportTriviaResults(p.filename, results, p);

sca;       

out = [];

 end









 
