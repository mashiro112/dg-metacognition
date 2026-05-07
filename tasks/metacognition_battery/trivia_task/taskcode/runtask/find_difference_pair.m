function [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter)

if condition == 2 && isfield(p, 'list_food')
    [this_pair, results] = find_food_pair_with_category_control(differenceTarget, p, results, trial_counter);
    return
end
    
%% find stimulus pair
    [row, col] = find(p.diff_square{condition} == differenceTarget);
    
    %% create vector of suitable pairs
    
    coords = [row, col];
    
    
    %% if the stimulus pair is empty, find the nearest to the target
    if isempty(coords)
        
        matrix = p.diff_square{condition}; ref = differenceTarget;
        [value, ii] = min(abs(matrix(:)-ref));    %// linear index of closest entry
        [row, col] = ind2sub(size(matrix), ii);
        
        coords = [row, col];
        results.interp_trials(trial_counter) = 1;
    else
        
        results.interp_trials(trial_counter) = 0;
        
    end
    
    
    %% select random pair from all suitable - could be made more complex
    
    if size(coords,1) > 1
        this_pair = coords(randi(length(coords)),:);
    else
        this_pair = coords;
    end
    
end

function [this_pair, results] = find_food_pair_with_category_control(differenceTarget, p, results, trial_counter)
matrix = p.diff_square{2};
ref = differenceTarget;

candidateMask = matrix > 0;
candidateMask(eye(size(matrix)) == 1) = false;
candidateDiff = abs(matrix - ref);
candidateDiff(~candidateMask) = Inf;
nearestDiff = min(candidateDiff(:));

if isinf(nearestDiff)
    [this_pair, results] = fallback_food_pair(matrix, ref, results, trial_counter);
    return
end

tolerance = max(10, min(50, abs(ref) * 0.15));
coords = find(candidateDiff <= nearestDiff + tolerance);
if isempty(coords)
    [this_pair, results] = fallback_food_pair(matrix, ref, results, trial_counter);
    return
end

[rows, cols] = ind2sub(size(matrix), coords);
coords = [rows, cols];

categories = food_categories(p);
scores = zeros(size(coords, 1), 1);
for iPair = 1:size(coords, 1)
    pair = coords(iPair, :);
    catPair = sort(categories(pair));
    score = candidateDiff(pair(1), pair(2));

    if isfield(results, 'foods_repeat_list') && numel(results.foods_repeat_list) >= max(pair)
        score = score + 8 * sum(results.foods_repeat_list(pair));
    end

    if any(catPair == 9)
        score = score + nut_penalty(results);
    end

    if is_obvious_category_pair(catPair)
        score = score + 35;
    end

    if is_repeated_recent_category_pair(catPair, results)
        score = score + 25;
    end

    scores(iPair) = score;
end

bestScore = min(scores);
bestCoords = coords(scores == bestScore, :);
this_pair = bestCoords(randi(size(bestCoords, 1)), :);
results.interp_trials(trial_counter) = nearestDiff > 0;
results.selected_pair_absdiff(trial_counter) = abs(matrix(this_pair(1), this_pair(2)) - ref);
end

function categories = food_categories(p)
list = p.list_food.list_food_complete;
categories = nan(size(list, 1), 1);
for iItem = 1:size(list, 1)
    value = list{iItem, 4};
    if isnumeric(value)
        categories(iItem) = value;
    else
        categories(iItem) = str2double(char(value));
    end
end
end

function penalty = nut_penalty(results)
recentNutCount = 0;
if isfield(results, 'food_category_pair_history')
    history = results.food_category_pair_history;
    firstIdx = max(1, numel(history) - 9);
    for iHistory = firstIdx:numel(history)
        if any(history{iHistory} == 9)
            recentNutCount = recentNutCount + 1;
        end
    end
end
penalty = 15 + recentNutCount * 12;
end

function tf = is_obvious_category_pair(catPair)
lowCueCats = [1 2];
highCueCats = [8 9];
tf = any(catPair(1) == lowCueCats) && any(catPair(2) == highCueCats);
end

function tf = is_repeated_recent_category_pair(catPair, results)
tf = false;
if ~isfield(results, 'food_category_pair_history')
    return
end

history = results.food_category_pair_history;
firstIdx = max(1, numel(history) - 2);
for iHistory = firstIdx:numel(history)
    if isequal(history{iHistory}, catPair)
        tf = true;
        return
    end
end
end

function [this_pair, results] = fallback_food_pair(matrix, ref, results, trial_counter)
candidateDiff = abs(matrix - ref);
candidateDiff(matrix <= 0) = Inf;
candidateDiff(eye(size(matrix)) == 1) = Inf;
[~, ii] = min(candidateDiff(:));
[row, col] = ind2sub(size(matrix), ii);
this_pair = [row, col];
results.interp_trials(trial_counter) = 1;
end
