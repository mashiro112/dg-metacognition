function p = triviaGetParams(inArg)
% Params for trivia metacognition task
% GM 2019

%% Load Mat files

p.list_countries = load('list_countries_complete.mat');
p.list_food = load('list_food_complete.mat');

%%  Subject Parameters

if nargin < 1
    
p.subID = inputdlg('请输入被试编号', '被试编号');
    
    
else
    p.subID = inArg;

end

p.filename = ['triviaData_' p.subID '.mat'];

if IsWin
    dataDir = [pwd '\triviaData\'];
else
    dataDir = [pwd '/triviaData/'];
end

if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end

p.filename = [dataDir p.filename];


%% instruction texts

p.instruction_text{1} = ['在本任务中，你将针对不同的食物和国家做出判断。\n', ...
                      ' 例如，判断两个国家中哪一个的经济水平更高（以人均国内生产总值衡量），\n'...
                      ' 以及判断两种食物中哪一种热量更高。\n'...
                      ' 每次试次都请尽量又快又准地使用左右方向键做出决定，\n'...
                      ' 然后评估自己对该决定的信心程度。\n\n按下空格键继续。\n\n'];

p.instruction_text{2} = ['在许多试次中，你可能会对正确答案感到不确定；\n' ...
                       ' 请尽力给出最准确的判断，并认真评估自己的信心。\n' ...
                       ' 通常情况下，请尽量使用整个信心量表\n' ...
                       ' 来反映你的主观不确定度。按下空格键即可确认评分。\n\n按下空格键继续。\n\n'];
              
p.instruction_text{3} = ['我们先进行一段简短的练习，以便熟悉如何作答。\n' ...
                       ' 练习结束后，如果对任务还有疑问，请告知实验员。\n' ...
                       ' \n\n按下空格键进入练习。\n\n'];



%% Windows parameters
p.gray = [127 127 127 ]; p.white = [255 255 255]; p.black = [0 0 0];
p.red = [250 0 0]; p.green = [0 250 50]; p.blue = [50 0 250];
p.bgcolor = p.black;
p.textColor = p.white;
p.textSize = 40;
p.countriesTextSize = 24;

%p.screensize = [0 0 2000 2000];
p.screensize = [];

p.screenNum = 0;

%PsychDebugWindowConfiguration(0, 0.5)
% Skip synchronization tests to avoid hard failures on systems without VBL sync.
Screen('Preference', 'SkipSyncTests', 1);
[p.window, p.rect] = Screen('OpenWindow', p.screenNum, p.black, p.screensize);
Screen('FillRect', p.window, p.bgcolor);
[p.xCenter, p.yCenter] = RectCenter(p.rect);
[p.screenXpixels, p.screenYpixels] = Screen('WindowSize', p.window);

%[p.screenXpixels, p.screenYpixels] = Screen('WindowSize', [0 0 500 500]);
% Screen(p.window, 'Flip');

%% Task Parameters
p.totalNumPracticeTrial = 20;
% Number of conditions
p.nConditions = 2;

% Number of blocks
p.numberOfBlocks = 5;

%Number of trials per block per condition, the total number of trials will be (p.trialsPerCondit * p.nConditions * p.numberOfBlocks)
p.trialsPerCondit = 20; 

p.trialsPerBlock = p.trialsPerCondit * p.nConditions;

p.totalNumTrial = p.trialsPerBlock * p.numberOfBlocks;


%% trial timings

p.Stimtime = 0.25;
p.ConfWait = 0.25;
p.RespWait = 0.25;
p.FBWait = 0.25 ;

%% staircase parameters

% condition 1 stepsizes
p.stepsize(1,1) = 0.5; % in log(GDP) units
p.stepsize(1,2) = 0.25;
p.stepsize(1,3) = 0.125; 

% condition 2 stepsizes
p.stepsize(2,1) = 100; % calories
p.stepsize(2,2) = 50;
p.stepsize(2,3) = 25; 


p.countries_srange = [0.1 5];
p.food_srange = [1 500];

p.thisDifferenceTarget_gdp = 1; % initial difference target
p.thisDifferenceTarget_calories = 200; % initial difference target


p.S(1) = SetupStaircase(1, [p.thisDifferenceTarget_gdp], p.countries_srange, [2,1]);
p.S(2) = SetupStaircase(1, [p.thisDifferenceTarget_calories], p.food_srange, [2,1]);

%% countries Image and Text parameters

p.xposition_left = p.screenXpixels * .25;
p.xposition_right = p.screenXpixels * .75;

scaling = 500;

% Image Position
imBase = [0 0 300+scaling 200+scaling];
p.imPos_left = CenterRectOnPointd(imBase, p.xposition_left, p.screenYpixels/2);
p.imPos_right = CenterRectOnPointd(imBase, p.xposition_right, p.screenYpixels/2);
p.imPos_center = CenterRectOnPointd(imBase, p.screenXpixels/2, p.screenYpixels/2 - 60);


% Frame Position
frameBase = [0 0 305+scaling 205+scaling];
p.framePos_left = CenterRectOnPointd(frameBase, p.xposition_left, p.screenYpixels/2);
p.framePos_right = CenterRectOnPointd(frameBase, p.xposition_right, p.screenYpixels/2);
p.framePos_center = CenterRectOnPointd(frameBase, p.screenXpixels/2, p.screenYpixels/2 - 60);



% Text Position

% p.textXpos_left = p.screenXpixels * .15;
% p.textXpos_right = p.screenXpixels * .70;

%p.textYpos = p.yCenter + 200;


p.textYpos = p.yCenter + 400;



p.textYPosfam = p.yCenter + 300;



%% for discrete confidence scale

[p.mx,p.my] = RectCenter(p.rect);
p.sittingDist = 40;

% confidence scale
p.stim.scaleType = 'discrete'; % discrete or continuous
p.stim.VASwidth_inDegrees = 15;
p.stim.VASheight_inDegrees = 2;
p.stim.VASoffset_inDegrees = 0;
p.stim.arrowWidth_inDegrees = 0.5;

p.stim.VASwidth_inPixels = degrees2pixels(p.stim.VASwidth_inDegrees, p.sittingDist);
p.stim.VASheight_inPixels = degrees2pixels(p.stim.VASheight_inDegrees, p.sittingDist);
p.stim.VASoffset_inPixels = degrees2pixels(p.stim.VASoffset_inDegrees, p.sittingDist);
p.stim.arrowWidth_inPixels = degrees2pixels(p.stim.arrowWidth_inDegrees, p.sittingDist);

p.times.confDuration_inSecs = 4;
p.times.confFBDuration_inSecs = 0.250;

%% Create a matrix of all the pairwise differences
p.diff_square = cell(2,1);

% Food  



%%


% countries
% 
% Create a matrix of all the pairwise differences - RANK FROM ORDER
gdp = log(p.list_countries.numList);
diff_square = [];

for r = 1:length(gdp)
    for c = 1:length(gdp)
        diff_square(r,c) = gdp(r) - gdp(c);
    end
end

p.diff_square{1}=round(diff_square, 3, 'significant'); 

%% calories


calories = round(p.list_food.numList(:,1));
diff_square =[];

for r = 1:length(calories)
    for c = 1:length(calories)
        diff_square(r,c) = calories(r) - calories(c);
    end
end

p.diff_square{2}=diff_square; 



%% initialize usage counters for all stimuli

p.countries_repeat_list = zeros(1,length(gdp));
p.foods_repeat_list = zeros(1,length(calories));
p.repeat_threshold = 4;


end
