
function exitNow = trivia_instructions(window, p)


%% setup

sx=120;
sy='center';
wrapat=60;
pg = p.instruction_text;
Screen('TextSize', window,24);

j=1;
while j <= length(p.instruction_text)
    DrawUTF8(window,[pg{j}], 'center', 'center');
    Screen('Flip',window);
    WaitSecs(.5);
    keyName = ptbWaitForKey({'ESCAPE', 'LeftArrow', 'space', 'Space'});

    switch lower(keyName)
        case 'escape', exitNow = 1; break;
        
        case 'leftarrow'
            if j > 1, j=j-1; end
            
        case 'space'
            % increment page counter
            j=j+1;
    end
end



end
