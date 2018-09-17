%demo to show how clustering algorithm works on real brain data.
clear
load mni_cortical_surface % load brain module
load PowCoords % load power spectrum, frequency and coordinates
%running cluster algo
clusters=findCluster(pow,coords,freqs);
% plot clustering result from the same subject on the brain
lc=jet(15);

%% plot the first cluster
c=1;
figure(1)
hs = patch('faces',f,'vertices',v,'edgecolor','none','facecolor',[.5 .5 .5]);set(hs,'facealpha',.2)
axis equal;axis off;
hold on
Loc=clusters(c).loc;
scatter3(Loc(:,1),Loc(:,2),Loc(:,3),40,lc(round(clusters(c).meanFrequency),:),'filled')
Leftover=~ismember(coords,Loc,'rows');
scatter3(coords(Leftover,1),coords(Leftover,2),coords(Leftover,3),40,'k','filled')
title(['Oscillation cluster at ' num2str(round(10*clusters(c).meanFrequency)/10) 'Hz'])
if mean(Loc(:,1))>0
    view(90,0)
else
    view(-90,0)
end
hb=colorbar;
colormap jet
set(hb,'ticks',[0,.5, 1])
set(hb,'ticklabels',{'1','8','15'})
set(hb,'fontsize',10)
set(hb,'Position',[0.88 0.200 0.02 0.60])

%% plot the second cluster
figure(2)
c=3;
hs = patch('faces',f,'vertices',v,'edgecolor','none','facecolor',[.5 .5 .5]);set(hs,'facealpha',.2)
axis equal;axis off;
hold on
Loc=clusters(c).loc;
scatter3(Loc(:,1),Loc(:,2),Loc(:,3),40,lc(round(clusters(c).meanFrequency),:),'filled')
Leftover=~ismember(coords,Loc,'rows');
scatter3(coords(Leftover,1),coords(Leftover,2),coords(Leftover,3),40,'k','filled')
title(['Oscillation cluster at ' num2str(round(10*clusters(c).meanFrequency)/10) 'Hz'])
if mean(Loc(:,1))>0
    view(90,0)
else
    view(-90,0)
end
hb=colorbar;
colormap jet
set(hb,'ticks',[0,.5, 1])
set(hb,'ticklabels',{'1','8','15'})
set(hb,'fontsize',10)
set(hb,'Position',[0.88 0.200 0.02 0.60])