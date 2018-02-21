

% sequence = 'come bid bat cap';
sequence1 = 'tape bug bike team';
sequence2 = 'lamp fish fork lest';

%% First practice round (with all the instructions)
j = 1;
pr_training.sequence{j} = sequence1;
pr_trials.sequence{j} = sequence1;

%% Training 1
% Without time deadline
% With stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;

InstructionsScreen(w,black,gray,['First you will practice on a few trials. ']);

InstructionsScreen(w,black,gray,['A sequence of words will appear on the screen. |' ...
    'You should copy them (including spaces) at your own pace. ' ...
    'Press Return when you are done. ']);


% WriteCentered(w,sequence1,xcen,yup, black);
Screen('DrawText',w,sequence1,xcen-2*xoff,yup,[], [], 1);
vbl = Screen('Flip',w);

KbQueueStart;

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
%             WriteCentered(w,sequence1,xcen,yup, black);
            Screen('DrawText',w,sequence1,xcen-2*xoff,yup,[], [], 1); % leave stimulus on the screen
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
%         pr_training1.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
       
        if eventkey.Keycode == 13
            outtrial = 1;
        end

    end
end
   

KbQueueStop;
% pr_training1.nfl(j) = KbQueueFlush;
% pr_training1.key{j} = key;
% pr_training1.kp{j} = kp;

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);

%% Training 2
% Without time deadline
% Without stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;

InstructionsScreen(w,black,gray,['The same sequence of words will appear on the screen. ' ...
    'This time, you will be asked to type them from memory. |' ...
    'When the words appear on the screen, you should memorize them. ' ...
    'When they disappear, you will hear a beep after which you should start typing. ' ...
    'You can type at your own pace and press Return when you are done typing. ']);


% WriteCentered(w,sequence1,xcen,ycen, black);
Screen('DrawText',w,sequence1,xcen-2*xoff,ycen,[], [], 1);
vbl = Screen('Flip',w);
WaitSecs(2);


PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

pr_training.biponset(j) = GetSecs + 0.2 - slack;
Screen('Flip',w, pr_training.biponset(j)); 
PsychPortAudio('Start',pahandle,1,pr_training.biponset(j)); 
PsychPortAudio('Stop',pahandle,1); 


KbQueueStart;

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
%         pr_training2.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
        
        if eventkey.Keycode == 13
            outtrial = 1;
        end
            
    end
end
    

KbQueueStop;
% pr_training2.nfl(j) = KbQueueFlush;
% pr_training2.key{j} = key;
% pr_training2.kp{j} = kp;

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);



%% Experimental trials
% With time deadline (add beep/boop)
% Without stimulus on screen
% Repeat 4 times

InstructionsScreen(w,black,gray,['Now, you will be asked to type the same sequence of words ' ...
    'as fast and as accurately as possible. '...
    'The sequence will appear once more on the screen. |' ...
    'Once it disappears you will have to type the sequence four times in a row. ' ...
    'Each time, you should wait until the beep to start typing ' ...
    'and try to type as fast as you can before you hear a boop. |' ...
    'Press Return whenever you are done typing each sequence. ']);


WriteCentered(w,'Ready?',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(1);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);


Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

% WriteCentered(w,sequence1,xcen,ycen, black);
Screen('DrawText',w,sequence1,xcen-2*xoff,ycen,[], [], 1);
vbl = Screen('Flip',w);
WaitSecs(2);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

for ii = 1:nrep
    
k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;

Screen('DrawText',w,'+',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

Screen('DrawText',w,'',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

pr_trials.biponset(j,ii) = GetSecs + 0.2 - slack;
Screen('Flip',w, pr_trials.biponset(j,ii)); 
PsychPortAudio('Start',pahandle,1,pr_trials.biponset(j,ii)); 
PsychPortAudio('Stop',pahandle,1); 

booptime = GetSecs + timeout;
incasetime = GetSecs + timeoutincase;

KbQueueStart;

PsychPortAudio('FillBuffer', pahandle, boop);
PsychPortAudio('Start',pahandle,1,booptime); 

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
        pr_trials.nrem(j,k,ii) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
            
        if eventkey.Keycode == 13
            outtrial = 1;
        end
    end
    
    if GetSecs > incasetime
        outtrial = 1;
        
    end
end

KbQueueStop;

Screen('DrawText',w,'',xcen,ycen, [], [], 1);
pr_trials.vbl(j,ii) = Screen('Flip',w); 
PsychPortAudio('Stop',pahandle,1); 

% sav in trial structure
pr_trials.nfl(j,ii) = KbQueueFlush;
pr_trials.key{j,ii} = key;
pr_trials.kp{j,ii} = kp;

WaitSecs(1);

end




%% Second practice round (with less instructions)

InstructionsScreen(w,black,gray,['Let''s practice once more. ']);

j = 2;
pr_training.sequence{j} = sequence2;
pr_trials.sequence{j} = sequence2;


%% Training 1
% Without time deadline
% With stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;


WriteCentered(w,'Practice the following sequence. ',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(2);

% WriteCentered(w,sequence2,xcen,yup, black);
Screen('DrawText',w,sequence2,xcen-2*xoff,yup,[], [], 1);
vbl = Screen('Flip',w);

KbQueueStart;

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
%             WriteCentered(w,sequence2,xcen,yup, black);
            Screen('DrawText',w,sequence2,xcen-2*xoff,yup, [], [], 1);
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
%         training1.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
       
        if eventkey.Keycode == 13
            outtrial = 1;
        end

    end
end
   

KbQueueStop;
% training1.nfl(j) = KbQueueFlush;
% training1.key{j} = key;
% training1.kp{j} = kp;

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);

%% Training 2
% Without time deadline
% Without stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;


WriteCentered(w,'Start typing after the beep',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(2);

% Display of sequence should be different
% WriteCentered(w,sequence2,xcen,ycen, black);
Screen('DrawText',w,sequence2,xcen-2*xoff,ycen, [], [], 1);
vbl = Screen('Flip',w);
WaitSecs(2);


PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

pr_training.biponset(j) = GetSecs + 0.2 - slack;
Screen('Flip',w, pr_training.biponset(j)); 
PsychPortAudio('Start',pahandle,1,pr_training.biponset(j)); 
PsychPortAudio('Stop',pahandle,1); 


KbQueueStart;

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
%         training2.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
        
        if eventkey.Keycode == 13
            outtrial = 1;
        end
            
    end
end
    

KbQueueStop;
% training2.nfl(j) = KbQueueFlush;
% training2.key{j} = key;
% training2.kp{j} = kp;

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);



%% Experimental trials
% With time deadline (add beep/boop)
% Without stimulus on screen
% Repeat 4 times


WriteCentered(w,'Ready?',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(1);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);


WriteCentered(w,'Type the whole sequence before the boop!',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(2);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

% WriteCentered(w,sequence2,xcen,ycen, black);
Screen('DrawText',w,sequence2,xcen-2*xoff,ycen, [], [], 1);
vbl = Screen('Flip',w);
WaitSecs(2);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

for ii = 1:nrep
    
k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;

Screen('DrawText',w,'+',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

Screen('DrawText',w,'',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

pr_trials.biponset(j,ii) = GetSecs + 0.2 - slack;
pr_trials.vbl(j,ii) = Screen('Flip',w, pr_trials.biponset(j,ii)); 
PsychPortAudio('Start',pahandle,1,pr_trials.biponset(j,ii)); 
PsychPortAudio('Stop',pahandle,1); 

booptime = GetSecs + timeout;
incasetime = GetSecs + timeoutincase;

KbQueueStart;

PsychPortAudio('FillBuffer', pahandle, boop);
PsychPortAudio('Start',pahandle,1,booptime); 

while ~outtrial
    
    [eventkey, nremaining] = KbEventGet; 
    
    if ~isempty(eventkey) 
        k = k+1; %increment for every event (press & release)
        
        if eventkey.Pressed == 1
        % Store only keypresses
            p = p+1;
            if p == 1, kp = eventkey;
            else kp(p) = eventkey;
            end
            
        % Draw it on the screen! edit GetEchoStringFreeResponse
        % with backspace correction
            if eventkey.Keycode == 8
            echo = echo(1:(length(echo)-1));
            else
            echo = [echo lower(char(eventkey.Keycode))];
            end
            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
            Screen('Flip',w); 
        end
        
        pr_trials.nrem(j,k,ii) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
            
        if eventkey.Keycode == 13
            outtrial = 1;
        end
    end
    
    if GetSecs > incasetime
        outtrial = 1;
        
    end
end

KbQueueStop;

Screen('DrawText',w,'',xcen,ycen, [], [], 1);
pr_trials.vbl(j,ii) = Screen('Flip',w); 
PsychPortAudio('Stop',pahandle,1); 

% sav in trial structure
pr_trials.nfl(j,ii) = KbQueueFlush;
pr_trials.key{j,ii} = key;
pr_trials.kp{j,ii} = kp;

WaitSecs(1);

end



