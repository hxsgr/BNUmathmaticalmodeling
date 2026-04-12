## BNU Mathmatical Modeling Competition codes 

- It's a repo with jupyter notebooks used in the paper "正弦包络下的余弦退火学习" . The codes are runned on Linux system , if you are a Linux user , you can simply come to the address ".../scripts" and run "bash control.sh" . Windows/MacOS users need to convert this .sh file into their specific versions .

## WARNINGS 

- control.sh will shutdown your computer . If that's not hoped to happen , please delete the last line of control.sh
- There should be a folder in .../scripts/data with cifar-10 and cifar-100 datasets . If not , please change the dataloaders in notebooks in a way that you can load your datasets .
