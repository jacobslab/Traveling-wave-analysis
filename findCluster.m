clear
freqs=log((2^(1/8)).^(8:56));

% load('gridPower')
load ECoGgrid2
ClusterN=1;

clear a
for s=1:length(AllGrid)
    %     try % some patients do not have neocortex electrodes
    clear Connect electrode_peak_frequency
    %     si=t;
    
    %         filename=['/home1/honghui/TESTOUTPUTGRID/data_',subs{s}];
    %         load(filename);
    % load power and electrode infomation
    result=AllGrid(s);
    pow=result.Pow'; % get the power
    tal=result.tal; % get the electrode infos
    n=length(tal);  % count number of electrodes
    Tal=[tal.x;tal.y;tal.z]';
    for i =1:n
        electrode_peak_frequency(i).f=getpeak1(pow(i,:),log(2.1),log(30),1);% find peak frequencies of each electrode
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
                if (~isempty(fi))&&(~isempty(fj))&&norm(Tal(i,:)-Tal(j,:))<distance    % if both electrode have peak in this window and they are close.
                    ConnectM(i,j)=1; % set the values to 1 to matrix(i,j)
                    ConnectM(j,i)=1;
                end
            end
        end
        DG=sparse(ConnectM);  % calculate a sparse matrix using the Connectom matrix
        [S,C] = graphconncomp(DG);   % get groups of spatial clustered electrodes
        for i= 1:S     % for each group
            if length(C(C==i))>3  % if there are 4 or more electrode in this group, we count they are oscillation cluster.
                Result(ClusterN).patient=tal(1).subject; % find the subject
                Result(ClusterN).tal=tal((C==i)); % find the electrode info
                Result(ClusterN).electrode=[tal((C==i)).channel]; % find the electrode number
                ff=[electrode_peak_frequency(C==i).f];   % get the frequency
                ff(ff<k)=[];
                ff(ff>k+windowLength)=[];
                
                Result(ClusterN).mf=mean(ff);    % the center frequency of the group is the mean of each electrode.
                ClusterN=ClusterN+1;                  % count next cluster
            end
        end
    end
end
% end

% save Clusters Result
% 
% for i=1:218
%     n1(i)=length(Result(i).tal)
% end