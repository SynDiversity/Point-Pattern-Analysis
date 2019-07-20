
function [ H,H_upper, H_lower, H_all]=H_fun_sim_bivar(loc,loc1,area,b,sims,poly,ce)
% calculation of the H(r) function and CE for bivariate pattern
%% input:
% - loc, loc1: coordinates of two point populations
% - area: AZ area 
% - b: 
% - sims: number of simulations 
% - poly: coordinates of the AZ
% - ce: confidence level 
%% output
% - H : H(r) function for the data
% - H_upper : upper CE
% - H_lower : lower CE
% - H_all : H(r) function for all the randomly generated samples
%%

[n_c,~]=size(loc);
[n_m,~]=size(loc1);
locs=[loc; loc1];

%% get the distance between two populations of poitns and edge correction
an=pdist(locs);
DIST=squareform(an); %distance
w=edge_corr(DIST,poly(:,1),poly(:,2),locs(:,1),locs(:,2)); % edge correction 
dist_int=DIST(1:n_c,n_c+1:end);
w_int=w(1:n_c,n_c+1:end); % take edge correction that corresponds only to the poin population of interest 
%% H(r) function for the data points
H = H_biv(loc,b,area,dist_int,w_int);

%% CE generation 
labels=[ones(1,n_c) , ones(1,n_m)*2];

for i = 1:sims
   ind_perm=randperm(length(labels)); % genrate bivarient random pattern
   DIST_R=DIST(ind_perm,ind_perm); % distance between pattern populations
   dist_r=DIST_R(1:n_c,n_m:end); %
   w_r=w(1:n_c,n_m:end); % edge correction factor 
   loc_c=locs(labels(ind_perm)==1,:); % take population 
   % H(r) function for the random pattern
   H_all(i,:) = H_biv(loc_c,b,area,dist_r,w_r);
   
end 

%Build envelopes
H_rank=sort(H_all);
ce_n=round(sims/ce);
H_upper =H_rank(ce_n,:);
H_lower = H_rank(end-ce_n,:);
