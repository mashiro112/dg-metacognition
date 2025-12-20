function order = getABBALatinOrder(idString)
% getABBALatinOrder Return balanced ABBA-style order info based on subject ID.

templates(1).name = 'ABBA';
templates(1).pre = {'taskBelief','socialRank'};
templates(1).post = {'socialRank','taskBelief'};

templates(2).name = 'BAAB';
templates(2).pre = {'socialRank','taskBelief'};
templates(2).post = {'taskBelief','socialRank'};

templates(3).name = 'AABB';
templates(3).pre = {'taskBelief','socialRank'};
templates(3).post = {'taskBelief','socialRank'};

templates(4).name = 'BBAA';
templates(4).pre = {'socialRank','taskBelief'};
templates(4).post = {'socialRank','taskBelief'};

numericID = str2double(idString);
if isnan(numericID)
    numericID = sum(double(idString));
end

whichTemplate = mod(numericID-1, numel(templates)) + 1;
order = templates(whichTemplate);

