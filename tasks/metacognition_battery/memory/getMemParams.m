function params = getMemParams(subID, studyList, unstudyList)

params.subID = subID;

params.studiedListNum = studyList;

params.unstudiedListNum = unstudyList;

params.time = clock;

params.FixCrB=ones(20,20) * 127;
params.FixCrB(10:11,:)=0;
params.FixCrB(:,10:11)=0;

params.FixCrW=ones(20,20) * 127;
params.FixCrW(10:11,:)=80;
params.FixCrW(:,10:11)=80;


% params.rightPosition;
% params.leftPosition; 

params.positions = 'lr';

[notUsed, params.wordLists] = xlsread('wordLists.xls');
params.studiedPerm = randperm(size(params.wordLists,1));
params.unstudiedPerm = randperm(size(params.wordLists,1));


params.textColor = [0 0 0];
params.bgColor = [127 127 127];

                    
params.instructions1 = strcat('屏幕上会呈现 50 个单词。\n',...
                             '你将有 X 分钟左右的时间尽可能记住这些单词。\n',...
                             '时间结束后，我们会考查刚才列表中的单词。\n\n',...
                             '请尽量记住尽可能多的单词，祝你顺利！\n\n',...
                             '按任意键继续。单词列表会立即显示，\n',...
                             '并且在你按下按键的瞬间开始计时。');
                         

params.studyListDisplay1 = '';
params.studyListDisplay2 = '';
params.studyListDisplay3 = '';
params.studyListDisplay4 = '';
params.studyListDisplay5 = '';

for i = 1:10
        params.studyListDisplay1 = strcat(params.studyListDisplay1, params.wordLists{i,studyList}, '\n');
        params.studyListDisplay2 = strcat(params.studyListDisplay2, params.wordLists{i+10,studyList}, '\n');
        params.studyListDisplay3 = strcat(params.studyListDisplay3, params.wordLists{i+20,studyList}, '\n');
        params.studyListDisplay4 = strcat(params.studyListDisplay4, params.wordLists{i+30,studyList}, '\n');
        params.studyListDisplay5 = strcat(params.studyListDisplay5, params.wordLists{i+40,studyList}, '\n');
end                                        
                   
params.instructions2 = strcat('Time''s up!\n\n',...
    '请记得使用左右方向键指示哪个单词\n',...
    '出现在列表中。然后用相同的按键来移动并选择\n',...
    '信心刻度的评分。\n\n\n',...
    '按任意键开始测试。'); 
                       

% params.fileName=['memExpData' params.subID{1} '_' num2str(studyList) '.mat'];







