function res=findCluster(pow,loc,freqs)
ClusterN=1;
n=length(loc(:,1));  % count number of electrodes
for i =1:n
    electrode_peak_frequency(i).f=getpeak(pow(i,:),freqs,log(2.1),log(30),1);% find peak frequencies of each electrode
end
steplength=1;windowLength=2;
v=zeros(1,length(1:steplength:30));nPeaks=1;
window=(2:steplength:30);distance=15;

for k=window % loop through each window
    for i=1:n % loop through each electrode
        ff=[electrode_peak_frequency(i).f];
        ff(ff<k)=[];
        ff(ff>k+windowLength)=[];
        if ~isempty(ff)     % Find if there's peak in the window for that electrode.
            v(nPeaks)=v(nPeaks)+1;  % count the number of electrode which has a peak frequency in the window
        end
    end
    nPeaks=nPeaks+1; % move to next window
    
end

x=localmax(v);  % find which frequencies, there are more electrode oscillating together.

for k=window(x) % loop through the frequencies there are local maximum electrode oscillating together
    ConnectM=zeros(n,n);  % create a Connectom matrix
    for i=1:n-1
        for j=i+1:n
            fi=[electrode_peak_frequency(i).f]; % peaks of electrode i
            fi(fi<k)=[];
            fi(fi>k+windowLength)=[];  % check for eletrode i, if there's a peak in this window
            
            fj=[electrode_peak_frequency(j).f]; % peaks of electrode j
            fj(fj<k)=[];
            fj(fj>k+windowLength)=[];  % check for eletrode j, if there's a peak in this window
            if (~isempty(fi))&&(~isempty(fj))&&norm(Loc(i,:)-Loc(j,:))<distance    % if both electrode have peak in this window and they are close.
                ConnectM(i,j)=1; % set the values to 1 to matrix(i,j)
                ConnectM(j,i)=1;
            end
        end
    end
    DG=sparse(ConnectM);  % calculate a sparse matrix using the Connectom matrix
    [S,C] = graphconncomp(DG);   % get groups of spatial clustered electrodes
    for i= 1:S     % for each group
        if length(C(C==i))>3  % if there are 4 or more electrode in this group, we count they are oscillation cluster.
            res(ClusterN).loc=loc((C==i),:); % find the electrode info
            ff=[electrode_peak_frequency(C==i).f];   % get the frequency
            ff(ff<k)=[];
            ff(ff>k+windowLength)=[];
            res(ClusterN).mf=mean(ff);    % the center frequency of the group is the mean of each electrode.
            ClusterN=ClusterN+1;                  % count next cluster
        end
    end
end
