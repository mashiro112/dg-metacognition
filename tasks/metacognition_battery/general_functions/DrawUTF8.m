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

    % Forward to DrawFormattedText using the encoded payload
    [varargout{1:nargout}] = DrawFormattedText(win, utf8Bytes, varargin{:});
end
