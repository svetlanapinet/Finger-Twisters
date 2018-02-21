clearvars;
subj = 38;


letters = {'D', 'A', 'B', 'C'}; %mod(1:4,4)+1
list = letters{mod(subj,4)+1};

filename = ['trials_S' num2str(subj) '_list' list];
% filename = ['datatrials_S' num2str(subj) '_' list];
% filename = ['trials_S' num2str(subj) '_list' list '_pilot'];
% filename = 'trials_0118';

data_dir = [pwd '/data/data_typed'];
% analysis_dir = [pwd '/analysis/'];
cd(data_dir)

load([filename '.mat'])


% Some sanity checks
[x,y]=find(trials.nfl ~= 0)
% someting to check the onsets of sounds
diffbeep = trials.realbeeponset - trials.beeponset; %try without screen sync
diffbeep2 = trials.beeponset - trials.vbl1; %try without screen sync
diffboop = trials.realbooponset - trials.booponset;
diffboop2 = trials.realbooponset - trials.vbl2; %try without screen sync


% Convert data
data = [];
seq = {};

ntrials = size(trials.kp,1);
nrep = size(trials.kp,2);

for ii = 1:ntrials
    for irep = 1:nrep
        nkp = length(trials.kp{ii,irep});
        for jj = 1:nkp
        a = size(data,1);
        if ~isempty(fieldnames(trials.kp{ii,irep}))
        data(a+1,1) = trials.kp{ii,irep}(jj).Time;
        data(a+1,2) = trials.kp{ii,irep}(jj).Pressed;
        data(a+1,3) = trials.kp{ii,irep}(jj).Keycode;
        data(a+1,4) = trials.kp{ii,irep}(jj).CookedKey;
        data(a+1,5) = jj; %keypress
        end
        data(a+1,6) = trials.realbeeponset(ii,irep); %beep        
        data(a+1,7) = trials.realbooponset(ii,irep); %boop        
        data(a+1,8) = ii; %trial
        data(a+1,9) = irep; %rep
        data(a+1,10) = trials.order(ii);
        
        seq{a+1} = trials.sequence{ii}; %sequence
        end
    end
end


%Include bip/boop onsets after checking they are the same
% colnames = {'Time', 'Pressed', 'Keycode', 'CookedKey', 'Keypress', 'Boop', 'Trial', 'Repetition', 'Order', 'Sequence', 'List'};

% cd(analysis_dir)

fileID = fopen([filename '.txt'],'w');
fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'Subject', 'List', 'Time', 'Pressed', ...
    'Keycode', 'CookedKey', 'Keypress', 'Beep', 'Boop', 'Trial', 'Repetition', 'Order', 'Sequence');
for r = 1:length(seq)
fprintf(fileID, '%d\t%s\t%.9d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\n', subj, list, data(r,:)', seq{r});
end
fclose(fileID);

