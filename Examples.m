clear
load mni_cortical_surface % load brain module
load PowLoc % load power spectrum, frequency and location
%%
clusters=findCluster(pow,AllLoc,freqs);
% running clustering algorithm
%% plot brain and the first cluster
figure()
hs = patch('faces',f,'vertices',v,'edgecolor','none','facecolor',[.5 .5 .5]);set(hs,'facealpha',.2)
axis equal;axis off;
Loc=clusters(1).Loc;
scatter3(Loc(1,:),Loc(2,:),Loc(3,:),'size',20,'color','r','filled')
Leftover=ismember(Loc,AllLoc,'rows');
scatter3(AllLoc(1,Leftover),AllLoc(2,Leftover),AllLoc(3,Leftover),'size',20,'color','r','filled')