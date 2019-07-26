function H = Hr(locs,dist,area,xp,yp)
% Calculate H(r) function for the point pattern 
%%input 
% - locs: location of the points
% - dist: range of distances for calculaing H(r) (r=dist)
% - area: area of the polygon (eg AZ)
% - DIST: distances between the points 
% - w: edge correction factor
%% output: H normilized Ripley function H(r)

%initialization
[N,~] = size(locs);
%distances among the points
an=pdist(locs);
DIST=squareform(an);
K = zeros(length(dist),1);
%calcualte weigths 
w=edge_corr(DIST,xp,yp,locs(:,1),locs(:,2));
for k=1:length(K)
    b=(DIST(1:end,:)<dist(k));
    K(k) = sum(sum(w(b)))/N;
end
%Normalization
lambda = N/area;
K = K/lambda;
H=sqrt(K/pi)-dist';