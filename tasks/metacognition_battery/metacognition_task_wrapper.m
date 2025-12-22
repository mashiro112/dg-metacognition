    function out = metacognition_task_wrapper(task, sID)
%% wrapper function to execute the balanced metacognition tasks

%% setup inputs
setup_paths;

tasklist = {'metacognition_battery'};

if nargin < 1
    sID = inputdlg('请输入被试编号');
    sID = sID{:};
    [which_task] = listdlg('ListString',tasklist, 'SelectionMode', 'single');
    task = tasklist{which_task};
elseif nargin < 2
    sID = inputdlg('请输入被试编号');
    sID = sID{:};
end

%% execute task
switch task
    case 'metacognition_battery'
        clc
        fprintf('%%%%\n\n %%%% RUNNING %s TASK\n\n%%%%', task)
        orderInfo = getABBALatinOrder(sID);

        for i_seq = 1:numel(orderInfo.sequence)
            seq = orderInfo.sequence{i_seq};
            switch seq.task
                case 'vision'
                    addpath(genpath(visiondir))
                    cd(visiondir)
                    perceptWrapper(sID, seq.measure)
                    cd(parent_dir)
                    rmpath(genpath(visiondir))
                case 'trivia'
                    addpath(genpath(triviadir))
                    cd(triviadir)
                    triviaWrapper(sID, seq.measure)
                    cd(parent_dir)
                    rmpath(genpath(triviadir))
            end
        end

    otherwise
        errordlg('No task specified!')
end

%% clean up
out = [];
end
