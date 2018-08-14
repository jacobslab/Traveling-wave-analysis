function [peak,n]=getpeak(loggedPower,freqs,ll,ul,threshold)
% this is a peak picking program for mutiple peaks
freqs=log((2^(1/8)).^(8:.25:40));
%raw(freqs>ll&freqs<ul)=0;
brob=robustfit(freqs(freqs>ll&freqs<ul),raw(freqs>ll&freqs<ul));
sub=raw-(brob(1)+brob(2)*freqs);
TD=mean(sub)+threshold*std(sub);
sub(sub<TD)=min(sub);
if max(sub)==min(sub)
    peak=0;
    n=0;
elseif max(sub)==sub(1)
    peak=0;
    n=0;
else 
    n=(sum(sub>min(sub)));
    peak=exp(freqs(localmax(sub)));
end
peak(peak==2)=[]; 