

% sequence = 'come bid bat cap';
sequences = {'tape bug bike team';'lamp fish fork lest';...
    'more wrap rain mouse'; 'soap good gum sound'; 'hand white watch home' };

% sequence0 = 'tape bug bike team';
% sequence1 = 'tape bug bike team';
% sequence2 = 'lamp fish fork lest';
% sequence3 = 'lamp fish fork lest';
% sequence4 = 'lamp fish fork lest';
% sequence5 = 'lamp fish fork lest';

yeskey = KbName('j');
nokey = KbName('f');

InstructionsScreen(w,black,gray,['First you will practice on a few trials. ']);

%% First demo & practice rounds (with all the instructions)
% j = 1;

for j = 1:2
pr_training.sequence{j} = sequences{j};
pr_trials.sequence{j} = sequences{j};

sequence1 = sequences{j};
% %% First practice round (with all the instructions)
% j = 1;
% pr_training.sequence{j} = sequence1;
% pr_trials.sequence{j} = sequence1;

%% Training 1
% Without time deadline
% With stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;


InstructionsScreen(w,black,gray,['A sequence of words will appear on the screen. |' ...
    'You should read them out loud slowly. ']);


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
%             Screen('DrawText',w,sequence1,xcen-2*xoff,yup,[], [], 1); % leave stimulus on the screen
%         % with backspace correction
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
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
    'This time, you will be asked to say them from memory. |' ...
    'When the words appear on the screen, you should memorize them. ' ...
    'When they disappear, you will hear a beep after which you should start speaking. ' ...
    'You can speak at your own pace.']);


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
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
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

InstructionsScreen(w,black,gray,['Now, you will be asked to say the same sequence of words ' ...
    'as fast and as accurately as possible. '...
    'The sequence will appear once more on the screen. |' ...
    'Once it disappears you will have to say the sequence four times in a row. ' ...
    'Each time, you should wait until the beep to start speaking ' ...
    'and try to finish before you hear a boop. ']);


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
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
        end
        
        pr_trials.nrem(j,k,ii) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
            
%         if eventkey.Keycode == 13
%             outtrial = 1;
%         end
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


end


%% Second practice round (with less instructions)

InstructionsScreen(w,black,gray,['Let''s practice some more. ']);

trainout = 0;
j = 3;
% j = 2;
% pr_training.sequence{j} = sequence2;
% pr_trials.sequence{j} = sequence2;

while ~trainout

pr_training.sequence{j} = sequences{j};
pr_trials.sequence{j} = sequences{j};

sequence2 = sequences{j};


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
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
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


WriteCentered(w,'Start speaking after the beep',xcen,yup, black);
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
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
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


WriteCentered(w,'Say the whole sequence before the boop!',xcen,yup, black);
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
%         % with backspace correction
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
        end
        
        pr_trials.nrem(j,k,ii) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
            
%         if eventkey.Keycode == 13
%             outtrial = 1;
%         end
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

WaitSecs(0.2);

end

% Some way to get out of training!!
RestrictKeysForKbCheck([yeskey, nokey]);

WriteCentered(w, 'Let''s practice once more ',xcen,ycen, black); 
Screen('Flip', w);

keyisdown = 0;
while ~keyisdown
    [keyisdown, ~, keyCode] = KbCheck;
    WaitSecs(.01);
end;

keypressed = find(keyCode);

if keypressed == nokey
    trainout = 1; %leave training
elseif keypressed == yeskey
    trainout = 0;
    j = j+1;
end;

if j == 5
     trainout = 1;
end   

RestrictKeysForKbCheck([]);

end


% PsychPortAudio('Close', pahandle);
% KbQueueRelease([]);
% Priority(0);
% ShowCursor;
% sca;
