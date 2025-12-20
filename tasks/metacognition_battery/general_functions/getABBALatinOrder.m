function order = getABBALatinOrder(idString)
% getABBALatinOrder Return balanced ABBA-style task/measurement order.

templates(1).name = 'vision_taskBelief__trivia_socialRank';
templates(1).sequence = {struct('task','vision','measure','taskBelief'), struct('task','trivia','measure','socialRank')};

templates(2).name = 'vision_socialRank__trivia_taskBelief';
templates(2).sequence = {struct('task','vision','measure','socialRank'), struct('task','trivia','measure','taskBelief')};

templates(3).name = 'trivia_taskBelief__vision_socialRank';
templates(3).sequence = {struct('task','trivia','measure','taskBelief'), struct('task','vision','measure','socialRank')};

templates(4).name = 'trivia_socialRank__vision_taskBelief';
templates(4).sequence = {struct('task','trivia','measure','socialRank'), struct('task','vision','measure','taskBelief')};

numericID = str2double(idString);
if isnan(numericID)
    numericID = sum(double(idString));
end

whichTemplate = mod(numericID-1, numel(templates)) + 1;
order = templates(whichTemplate);

