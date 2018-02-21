% clearvars;
% subj = 1;
% 
% 
% letters = {'D', 'A', 'B', 'C'}; %mod(1:4,4)+1
% list = letters{mod(subj,4)+1};
% 
% filename = ['trials_S' num2str(subj) '_list' list];
% filename = ['inter_trials_S' num2str(subj) '_list' list];
% % filename = ['trials_S' num2str(subj) '_list' list '_pilot'];
% % filename = 'trials_0118';
% 
% data_dir = [pwd '/data/'];
% cd(data_dir)
% load([filename '.mat'])
% 
% 
% % Some sanity checks
% [x,y]=find(trials.nfl ~= 0)
% % someting to check the onsets of sounds
% diffbeep = trials.realbeeponset - trials.beeponset; %try without screen sync
% diffbeep2 = trials.beeponset - trials.vbl1; %try without screen sync
% diffboop = trials.realbooponset - trials.booponset;
% diffboop2 = trials.realbooponset - trials.vbl2; %try without screen sync


% Convert data
data = [];
seq = {};

ntrials = size(trials.kp,1);
nrep = size(trials.kp,2);

for ii = 1:ntrials
    for irep = 1:nrep
        nkp = length(trials.kp{ii,irep});
        a = size(data,1);
        data(a+1,1) = ii; %trial
        data(a+1,2) = irep; %rep
        data(a+1,3) = trials.order(ii);
        
        seq{a+1} = trials.sequence{ii}; %sequence
    end
end

fileID = fopen(filenametxt,'w');
fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\n', 'Subject', 'List', 'Trial', 'Repetition', 'Order', 'Sequence');
for r = 1:length(seq)
fprintf(fileID, '%d\t%s\t%d\t%d\t%d\t%s\n', subj, list, data(r,:)', seq{r});
end
fclose(fileID);

