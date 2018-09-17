function [peak]=getpeak(Pow,frequency,ll,ul,threshold)
% this is a peak picking program for mutiple peaks
freqs=log(frequency); % transform to log space
brob=robustfit(freqs(freqs>ll&freqs<ul),Pow(freqs>ll&freqs<ul)); %robust fit
sub=Pow-(brob(1)+brob(2)*freqs);
TD=mean(sub)+threshold*std(sub);
peak=frequency(sub>TD&islocalmax(sub)&freqs>ll&freqs<ul); %return peaks satisfying all criteria