# Include

Repository contains all custom functions used in the lazytrade series. It is created to re-use content across various 
MT4 Trading Robots templates

# Synchronize or Deploy

## Setup Environmental Variables

Add these User Environmental Variables:

PATH_T2_I - path to Development Terminal MT4, folder *\MQL4\Include
PATH_T1_I, PATH_T3_I, etc - paths to the Terminals where all other terminals are located
PATH_DSS_Repo - path to the folder where this repository is stored on the local computer

## Scripts to synchronize code

Dedicated executable scripts will synchronize existing files from Repo to the working destinations.
It will only copy files with specific extension and only overwrite in case files were changed

1. To synchronize MT4 Development Terminal Folder to Version Control Repository: launch *_PullFromMT4Dev.bat*
2. To deploy reverted changes from Version Control to Development Terminal: launch *_PushToMT4Dev.bat*
3. To deploy reverted changes from Version Control to All Terminals: launch *_PushToMT4Prod*

## Courious how to apply?

This content is a result of a lot of dedication and time.
Please support this project by joining these courses using referral links published
here: https://vladdsm.github.io/myblog_attempt/topics/topics-my-promotions.html
