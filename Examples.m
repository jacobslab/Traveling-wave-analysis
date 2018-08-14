

%% print brain
load mni_cortical_surface
hs = patch('faces',f,'vertices',v,'edgecolor','none','facecolor',[.5 .5 .5]);set(hs,'facealpha',.2)
axis equal;axis off;