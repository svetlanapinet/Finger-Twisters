clc; clearvars; close all;


%Prompt for subject number and file
% ntest = 1; % how many trials for testing?
% ntest = input('How many trials?\n');
subj = input('Subject number?\n');
% ntest = 29;

letters = {'D', 'A', 'B', 'C'}; %mod(1:4,4)+1
list = ['list', letters{mod(subj,4)+1}];
 
dir = [pwd '/data/'];
filename = ['S' num2str(subj) '_' list '.mat'];
filenametxt = ['S' num2str(subj) '_' list '.txt'];

screenNumber = 0;
devnb = [];

% screenNumber = 1;
% devnb = 15;

gray=GrayIndex(screenNumber);
black=[0 0 0];
[w, wRect]=Screen('OpenWindow',screenNumber, gray);


%% Set up parameters

rng('shuffle');

Screen('TextSize', w, 32);
ifi = Screen('GetFlipInterval',w);
slack = ifi/2; 

xcen=wRect(3)/2;            %x center of the screen
ycen=wRect(4)/2;            %y center of the screen

yup=wRect(4)/3;            

timeout = 1.5;
timeoutincase = 2;
nrep = 4;

xoff=100;                   %some x offset value that centers the text for target and echo word
yoff=100;                   %some y offset value that centers the text for target word


freq = 44100;
channels = 1;
lat = 0.05;
beep = MakeBeep(500, 0.1, freq); 
boop = MakeBeep(310, 0.1, freq); 

HideCursor;
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

InitializePsychSound(1);
devices = PsychPortAudio('GetDevices'); %avoid MME
pahandle = PsychPortAudio('Open',devnb, 1, 1, freq, channels, [], lat); 

% PsychPortAudio('FillBuffer', pahandle, boop);
% PsychPortAudio('Start',pahandle,1); 
% PsychPortAudio('Stop',pahandle,1); 

% Get sequences from a textfile

% file = fopen('sequences.txt');
% wordlist = textscan(file,'%s%s%s%s');    % read in word list
% fclose(file);
% ntrials = size(wordlist,1);                   % randomize list
% wordlist = wordlist(randperm(ntrials),:);
% 
% file = fopen('listB.txt');
file = fopen([list '.txt']);
words = textscan(file,'%u%q%q');    % read in word list
fclose(file);

% file = fopen('carriers.txt');
file = fopen('carrierwords.txt');
carr = textscan(file,'%u%s%s');    % read in word list
fclose(file);

wordlist = [carr{2}, carr{3}, words{2}, words{3}];

% randomize list
ntrials = size(wordlist,1);
order = randperm(ntrials);
wordlist = wordlist(order,:);

% Save in data structure
trials.list = list;
trials.order = order;
trials.wordlist = wordlist;

% InstructionsScreen(w,black,gray,['Welcome!|In this experiment, you will ' ...
%     'be shown sequences of words and asked to type them as fast and as accurately as possible.|' ...
%     'You should look at the screen at all times. '...
%     'You will see what you are typing on the screen as you type it. '...
%     'If you make an error, try and refrain from correcting it. '], [], [], [], 1);
InstructionsScreen(w,black,gray,['Welcome!|In this experiment, you will ' ...
    'be shown sequences of words and asked to say them as fast and as accurately as possible.']);

a = GetSecs;

KbQueueCreate;

%% First some practice trials

FT_training_spoken

%% Experiment proper

% InstructionsScreen(w,black,gray,['Now you are ready to begin the experiment! | ' ...
%     'If you have any questions, now is the good time to ask the experimenter.'], [], [], [], 1);
InstructionsScreen(w,black,gray,['Now you are ready to begin the experiment! | ' ...
    'If you have any questions, now is the good time to ask the experimenter.']);

for j = 1:ntrials
% for j = 1:ntest

    
    % Break
if mod(j,15) == 0 %44
    WaitSecs(0.5)
%     InstructionsScreen(w,black,gray,['Take a few moments to have a break!'], [], [], [], 1);  
    InstructionsScreen(w,black,gray,['Take a few moments to have a break!']);  
    WaitSecs(0.5)
end
      
    
% Some time between trials
WriteCentered(w,'Get ready for the next trial. ',xcen,yup, black);
% Screen('DrawText',w,'Get ready for the next trial',xcen - 3*xoff,ycen-2*yoff, [], [], 1);
Screen('Flip',w); 
WaitSecs(5);

% Make the sequence for the trial
% sequence = [wordlist{j,1}{:} ' ' wordlist{j,2}{:} ' ' wordlist{j,3}{:} ' ' wordlist{j,4}{:}];

sequence = [wordlist{j,1} ' ' wordlist{j,2} ' ' wordlist{j,3} ' ' wordlist{j,4}];
training.sequence{j} = sequence;
trials.sequence{j} = sequence;


%% Training 1
% Without time deadline
% With stimulus on screen

k = 0;
p = 0;
echo = '';
kp = struct;
key = struct;
outtrial = 0;

% InstructionsScreen(w,black,gray,['First you will pratice on a few trials. ']);
% 
% InstructionsScreen(w,black,gray,['A sequence of words will appear on the screen. |' ...
%     'You should copy them at your own pace. ' ...
%     'Press Enter when you are done. ']);


% Screen('DrawText',w,'Practice the following sequence. ',xcen-3*xoff,ycen-2*yoff, [], [], 1);
WriteCentered(w,'Practice the following sequence. ',xcen,yup, black);
Screen('Flip',w); 
WaitSecs(2);

% WriteCentered(w,sequence,xcen,yup, black);
Screen('DrawText',w,sequence,xcen-2*xoff,yup, [], [], 1); % leave stimulus on the screen
vbl = Screen('Flip',w);
% WaitSecs(5);

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
%             WriteCentered(w,sequence,xcen,yup, black);
%             Screen('DrawText',w,sequence,xcen-2*xoff,yup, [], [], 1); % leave stimulus on the screen
%         % with backspace correction
%             if eventkey.Keycode == 8
%             echo = echo(1:(length(echo)-1));
%             else
%             echo = [echo lower(char(eventkey.Keycode))];
%             end
% %             WriteCentered(w,echo,xcen,ycen, black);
%            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
        end
        
        training1.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
       
        if eventkey.Keycode == 13
            outtrial = 1;
        end

    end
end
   
% make this training trial end with last keystroke (press return?)

KbQueueStop;
training1.nfl(j) = KbQueueFlush;
training1.key{j} = key;
training1.kp{j} = kp;

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

% InstructionsScreen(w,black,gray,['The same sequence of words will appear on the screen. ' ...
%     'This time, you will be asked to type them from memory. |' ...
%     'When the words appear on the screen, you should memorize them. ' ...
%     'When they disappear, you will hear a beep after which you should start typing. ' ...
%     'You can type at your own pace and press Enter when you are done typing. ']);

WriteCentered(w,'Start speaking after the beep',xcen,yup, black);
% Screen('DrawText',w,'Start typing after the beep',xcen-3*xoff,ycen-2*yoff, [], [], 1);
Screen('Flip',w); 
WaitSecs(2);

% Display of sequence should be different
% WriteCentered(w,sequence,xcen,ycen, black);
Screen('DrawText',w,sequence,xcen-2*xoff,ycen, [], [], 1);
vbl = Screen('Flip',w);
WaitSecs(2);


PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

training2.biponset(j) = GetSecs + 0.2 - slack;
training2.vbl(j) = Screen('Flip',w, training2.biponset(j)); 
PsychPortAudio('Start',pahandle,1,training2.biponset(j)); 
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
% %             WriteCentered(w,echo,xcen,ycen, black);
%            Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
        end
        
        training2.nrem(j,k) = nremaining; %sometimes it's not zero (when two events at the same time)

        % Save all events in a structure
        if k == 1, key = eventkey;
        else, key(k) = eventkey;
        end
        
        if eventkey.Keycode == 13
            outtrial = 1;
        end
            
    end
end
    
% make this training trial end with last keystroke

KbQueueStop;
training2.nfl(j) = KbQueueFlush;
training2.key{j} = key;
training2.kp{j} = kp;

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);



%% Experimental trials
% With time deadline (add beep/boop)
% Without stimulus on screen
% Repeat 4 times

% InstructionsScreen(w,black,gray,['Now, you will be asked to type the same sequence of words ' ...
%     'as fast and as accurately as possible. '...
%     'The sequence will appear once more on the screen. |' ...
%     'Once it disappears you will have to type the sequence four times in a row. ' ...
%     'Each time, you should wait until the beep to start typing ' ...
%     'and try to finish before you hear a boop. |' ...
%     'Press Enter whenever you are done typing each sequence. ']);

% Add screen for hearing the boop

WriteCentered(w,'Ready?',xcen,yup, black);
% Screen('DrawText',w,'Ready?',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(1);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);


WriteCentered(w,'Say the whole sequence before the boop!',xcen,yup, black);
% Screen('DrawText',w,'Finish typing ',xcen-3*xoff,ycen-2*yoff, [], [], 1);
% Screen('DrawText',w,'before the boop!',xcen-3*xoff,ycen-yoff, [], [], 1);
Screen('Flip',w); 
WaitSecs(2);

Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

% WriteCentered(w,sequence,xcen,ycen, black);
Screen('DrawText',w,sequence,xcen-2*xoff,ycen, [], [], 1); % leave stimulus on the screen
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

% WriteCentered(w,'+',xcen,ycen, black);
Screen('DrawText',w,'+',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

Screen('DrawText',w,'',xcen,ycen, [], [], 1);
Screen('Flip',w); 
WaitSecs(0.5);

PsychPortAudio('FillBuffer', pahandle, beep);
Screen('DrawText',w,'',xcen-xoff,ycen, [], [], 1);

trials.beeponset(j,ii) = GetSecs + 0.2 - slack;
PsychPortAudio('Start',pahandle,1,trials.beeponset(j,ii)); 
trials.vbl1(j,ii) = Screen('Flip',w, trials.beeponset(j,ii));  
trials.realbeeponset(j,ii) = PsychPortAudio('Stop',pahandle,1); 

trials.booponset(j,ii) = GetSecs + timeout;
incasetime = GetSecs + timeoutincase;

KbQueueStart;

PsychPortAudio('FillBuffer', pahandle, boop);
PsychPortAudio('Start',pahandle,1,trials.booponset(j,ii)); 

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
% %             WriteCentered(w,echo,xcen,ycen, black);
%             Screen('DrawText',w,echo,xcen-2*xoff,ycen, [], [], 1);
%             Screen('Flip',w); 
        end
        
        trials.nrem(j,k,ii) = nremaining; %sometimes it's not zero (when two events at the same time)

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
trials.vbl2(j,ii) = Screen('Flip',w); 
trials.realbooponset(j,ii) = PsychPortAudio('Stop',pahandle,1); 

% sav in trial structure
trials.nfl(j,ii) = KbQueueFlush;
trials.key{j,ii} = key;
trials.kp{j,ii} = kp;

WaitSecs(0.2);

end


% Save .mat for each trial in case something goes wrong

save([dir, 'inter_trials_' filename ], 'trials')

% b = GetSecs;
% total = b-a;

end

WaitSecs(0.5);
training.training1 = training1;
training.training2 = training2;
% save thatdate %save the whole workspace
% save trials trials %save only trials
save([dir, filename])
save([dir, 'trials_' filename], 'trials')

% Convert trials to text
FT_spoken_read_trials;


PsychPortAudio('Close', pahandle);
KbQueueRelease([]);
Priority(0);
ShowCursor;
sca;
