% Maria Reva 20/12/2017
%generate garussian clusters for the "idealized AZ"

N=20; %number of clusters
n=180/N; % number of elemnts per cluster
ra=154; % radius of the area where calcuster centers can be places
max_d=60; %maximum distance between clusters
max_NND_lim=10.5; % maximum allowed NND
inter_cluster=17; % minimum intercluster distance 

%generate circular "AZ"
th = 0:pi/50:2*pi;
xunit1 = 175 * cos(th) ;
yunit1 = 175 * sin(th);
xunit = ra * cos(th) ;
yunit = ra * sin(th);


for k=1:10
    LL=1;
    while LL<N
        [xc, yc]=centers(ra,max_d); %generate N center of the cluster
        LL=length(xc);
    end
    xc=xc(1:N);  
    yc=yc(1:N);
    X1=[];
    Y1=[];
    for i=1:N
        ll1=1;
        %for each cluster center generate elemtns of the cluster
         while ll1<n
            [xx,yy]=subclust_gaus(ra,xc(i),yc(i),max_NND_lim, inter_cluster);
            ll1=length(xx);
         end
    X1=[X1 xx(1:n)];
    Y1=[Y1 yy(1:n)];  
    end
    % take number of generated poits that corresponds to the labeling
    % efficinecy
    ix = randperm(180);
    Xx=X1(ix);
    Yx=Y1(ix);
    Y=Yx(1:34);
    X=Xx(1:34);
    % plot
    figure, plot(X,Y,'ob') 
    hold on, plot(xunit1,yunit1)
    hold on , plot(xc,yc, 'or')

end

