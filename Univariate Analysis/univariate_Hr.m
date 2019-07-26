% Univariate H(r) anlaysis
d = dir('/path');

%initialization 
sims=50; % number of simulations
dist=0:10:1000; % spatial scale to calculate H(r)
min_d=7.1; % set the minimum allowed distnce between poits for pattern generation 

H_all=[];
d(1:2)=[];
ncols = length(d);

figure, 
% loop trough all the files in the folder
for i=1
    %read file
    [scalebar_x,scalebar_y,synAreax,synAreay,ca_x,ca_y] = importfile_AZ(d(i).name);
    %% normalize locations of both MUNC and CAV and AZ counture
    scale= str2double(scalebar_x(1));
    sc=abs((str2double(scalebar_x(4))-str2double(scalebar_x(3)))/scale);
    ca_y=ca_y/sc;
    ca_x=ca_x/sc;
    ca_x=ca_x(ca_x<10e9);
    ca_x=ca_x(ca_x>10);
    ca_y=ca_y(ca_y<10e9);
    ca_y=ca_y(ca_y>10);
    xp=synAreax/sc;
    yp=synAreay/sc;
    xp(1:2)=[];
    yp(1:2)=[];
    xp=xp(xp<10e9);
    yp=yp(yp<10e9);
        
    are(i)=polyarea(xp,yp); % area of the AZ
    num_ca(i)=length(ca_x); %number of "cav" points
    %% Calculate H(r) for data, CE for randomly sampled patterns
    [H_data(i,:), H_upper(i,:), H_lower(i,:), H_rand_temp]=Hr_fun_sim([ca_x ca_y],are(i),dist,sims,[xp yp],min_d,99);
    %% Calculate H(r) for data, CE for EZ model
    %ez_sim=2; % number of EZ patterns generated
    %ez_rad=50; % radius of EZ
    %num_ves=4; % number of vesicels
    %[H_data(i,:), H_upper(i,:), H_lower(i,:), H_rand_temp]=Hr_fun_sim_ez([ca_x ca_y],are(i),dist,sims,ez_sim,[xp yp],min_d,99,ez_rad,num_ves);
    %% plot 
    hold on, plot(dist,H_data(i,:),'b')
    % store all the H(r) generated for CE
    H_all=[H_all; H_rand_temp];
    % MAD test for the current pattern
    [h_pattern(i,:),pval_pattern(i)]=mad_test1(H_rand_temp,sims,H_data(i,:),99);
end

%pooled H(r)
dens=num_ca./are;
[n_H,~]=size(H_data);
[n_Hall,~]=size(H_all);
H_ncols=pool_it(H_data,n_H,dens);
H_rank=sort(H_all);
ce_n=round(n_Hall/99);
H_upper =H_rank(ce_n,:);
H_lower = H_rank(end-ce_n,:);
% MAD test for the population
[H_tot,pval_tot]=mad_test1(H_all,ncols*sims,ncols,99);
% plot
hold on, plot(dist, H_ncols,'r')
hold on, plot(dist, H_upper,'b')
hold on, plot(dist, H_lower,'b')






