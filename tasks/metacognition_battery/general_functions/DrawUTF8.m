function varargout = DrawUTF8(win, str, varargin)
% DrawUTF8  Safely render UTF-8 encoded text via DrawFormattedText.
%   This helper accepts char arrays, strings, or cell arrays of text and
%   converts them to UTF-8 bytes before dispatching to DrawFormattedText.

    % Normalize input to char array
    if iscell(str)
        str = strjoin(cellfun(@char, str, 'UniformOutput', false), newline);
    else
        str = char(str);
    end

    % Convert to UTF-8 encoded uint8 payload
    utf8Bytes = unicode2native(str, 'UTF-8');

    % DrawFormattedText's 7th optional argument is line spacing. Use a
    % roomier default for multi-line Chinese prompts unless callers set it.
    if numel(varargin) < 7
        varargin{7} = 1.5;
    elseif isempty(varargin{7})
        varargin{7} = 1.5;
    end

    % Forward to DrawFormattedText using the encoded payload
    [varargout{1:nargout}] = DrawFormattedText(win, utf8Bytes, varargin{:});
end
