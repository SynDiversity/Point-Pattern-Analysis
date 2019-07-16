% Maria Reva 2017.04.12

%% Run DBSCAN Clustering Algorithm

%%
 d = dir('/path to the floder');

 d(1:2)=[]; % cut the functional folders 

%just inialization of variables
di_cent=[];
areas=[];
distances_centers=[];
numofelem_b=[];
nnd_cl=[];
clusters=[];
cent=[];
epsilon=[];
chx=[];
chy=[];
count=1;
K_mean=[];
ic=0;
disatnces_cluster=[];
ncols = length(d);
count=1;
%%
% Go trough all the files in the folder

for i=1:ncols
    % read from the .gss files
  %  na=convertStringsToChars(dis(i));
   [scalebar_x,scalebar_y,synAreax,synAreay,ch_x,ch_y] = importfile_AZ(d(i).name); % read file
    scale= str2double(scalebar_x(1));
    sc=abs((str2double(scalebar_x(4))-str2double(scalebar_x(3)))/scale);
    xp=synAreax/sc;
    yp=synAreay/sc;
    ch_x=ch_x/sc;
    ch_y=ch_y/sc;
    xp=xp(3:end);
    yp=yp(3:end);
    xp=xp(xp<10e9 );
    yp=yp(yp<10e9 );
    ch_x=ch_x(ch_x<10e9 );
    ch_x=ch_x(ch_x>10 );
    ch_y=ch_y(ch_y<10e9);  
    le=length(ch_x);
    Xt=[ch_x ch_y];
    are(i)=polyarea(xp,yp);
    count=1;
    %% DBSCAN
    epsilon=46;
    MinPts=2;
    IDX=DBSCAN(Xt,epsilon,MinPts);
    %% nmber of clusters
    clusters=[clusters max(IDX)'];
    %% number of elements
    IDX_temp=IDX(IDX>0);
    ch_x=ch_x(IDX>0);
    ch_y=ch_y(IDX>0);
    X=[ch_x ch_y];
    h=hist(IDX_temp, 1:1:max(IDX));
    numofelem_b=[numofelem_b h];
    %% take area
    non2=find(h>2); % area only of those clusters that have more than 2 elemtns
    if length(non2)>2
    for q=1:length(non2)
         x1=ch_x(IDX_temp==non2(q)); 
         y1=ch_y(IDX_temp==non2(q)); 
         nnd_cl=[nnd_cl nnds(length(x1),x1',y1')];
         k = boundary(x1,y1,0.2);% generate boundary of data points. 
         X1=x1(k);Y1=y1(k);%return the original x,y coordinate corresponding to each index k
         A(q) = polyarea(X1,Y1);

    end
    areas=[areas A];

    %% get the distance between the closest boundary points of the clusters
    for l=1:length(h)
        for j=1:length(h)
            dist_cl(l,j)=min(min(pdist2(X((IDX_temp==l),:),X((IDX_temp==j),:))));    
        end
    end
    mask = triu(true(size(dist_cl)),1); % select only lower triangular elements 
    out = dist_cl(mask);
    disatnces_cluster=[disatnces_cluster out'];
    
    %% take the distcne between cluster censters
    for l=1:length(h)
       [trash,C(l,:)] = kmeans(X((IDX_temp==l),:),1) ; % find centers of the clusters using Kmeans
     
    end
    di_cen=pdist2(C,C);
    mask1 = triu(true(size(di_cen)),1);
    distances_centers = [distances_centers di_cen(mask1)'];

end
clear ch_x ch_y ddi X Xt Y1 X1 A out dist_cl mask C mask1 di_cen IDX


end 

