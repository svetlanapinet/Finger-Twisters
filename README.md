# Finger-Twisters
Experimental scripts (Psychtoolbox) used in Pinet and Nozari (2018) - "Finger twisters": the case for interactivity in typed language production - Psychonomic Bulletin and Review.

*See the above reference for details about the experiment design.*  
Briefly, this experiment consisted in typing/saying finger/tongue twisters. Each subject ran both typed and spoken sessions but on different days. The order of sessions was counterbalanced between subjects.

### /typed  
- FingerTwisters_return.m: main experimental file.  
Prompts for subject number and choose a stimuli list (randomized over 4 subjects).  
Calls FT_training.m and textfiles carrierwords.txt, listA.txt, listB.txt, listC.txt, listD.txt.
Saves files in /data. All keypresses are recorded and saved.

- FT_read_trials.m: converts a .mat datafile to a textfile.

- carrierwords.txt, listA.txt, listB.txt, listC.txt, listD.txt: stimuli lists.


### /spoken
- FingerTwisters_spoken.m: main experimental file.  
Prompts for subject number and choose a stimuli list (randomized over 4 subjects).  
Calls FT_training_spoken.m and textfiles carrierwords.txt, listA.txt, listB.txt, listC.txt, listD.txt.
Saves files in /data. This script is **not** recording audio so a separate audio recording device should be set up.

- FT_spoken_read_trials.m: converts a .mat datafile to a textfile.

- carrierwords.txt, listA.txt, listB.txt, listC.txt, listD.txt: stimuli lists.
