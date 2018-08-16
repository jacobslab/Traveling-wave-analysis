function [peak]=getpeak(Power,frequency,ll,ul,threshold)
% this is a peak picking program for mutiple peaks
Pow=log(Power);
freqs=log(frequency);
brob=robustfit(freqs(frequency>ll&frequency<ul),Pow(frequency>ll&frequency<ul));
sub=Pow-(brob(1)+brob(2)*freqs);
TD=mean(sub)+threshold*std(sub);
peak=frequency(sub>TD&islocalmax(sub)&frequency>ll&frequency<ul);

