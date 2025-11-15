function DrawText(wPtr, txt, align)
    if exist('DrawUTF8', 'file') ~= 2
        baseDir = fileparts(mfilename('fullpath'));
        generalDir = fullfile(baseDir, '..', '..', 'general_functions');
        addpath(generalDir);
    end

    if nargin < 3 || isempty(align)
        align = 'c';
    end
    if iscell(txt)
        txt = strjoin(cellfun(@char, txt, 'UniformOutput', false), '\n');
    else
        txt = char(txt);
    end

    x = 'center';
    y = 'center';

    if isnumeric(align)
        if numel(align) >= 1
            x = align(1);
        end
        if numel(align) >= 2
            y = align(2);
        end
    elseif ischar(align) || isstring(align)
        if strcmpi(align(1), 'l')
            x = 'left';
        elseif strcmpi(align(1), 'r')
            x = 'right';
        end
        if numel(align) > 1
            if strcmpi(align(2), 't')
                y = 'top';
            elseif strcmpi(align(2), 'b')
                y = 'bottom';
            end
        end
    end

    DrawUTF8(wPtr, txt, x, y);
end
