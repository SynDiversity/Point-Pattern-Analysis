function H = H_biv(locs,dist,area,DIST,w)
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
K = zeros(length(dist),1);
% foe each distance calculate Ripley' K function
for k=1:length(K)
    b=(DIST(1:end,:)<dist(k));
    K(k) = sum(sum(w(b)))/N;
end
%Normalization
lambda = N/area;
K = K/lambda;
H=sqrt(K/pi)-dist';