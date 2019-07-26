% Bivariate analysis of the poin pattern

% read files
d = dir('/path');
d(1:2)=[];

%initialization 
sims=1000; % number of simulations
dist=0:5:1000; % spatial scale to calculate H(r)

H_all=[];
ncols = length(d);

figure, 
% loop trough all the files in the folder
for i=1:ncols
    %read file
    [scalebar_x,scalebar_y,synAreax,synAreay,munc_x,munc_y,ca_x,ca_y] = importfile1(d(i).name);
    %% normalize locations of both MUNC and CAV and AZ counture
    scale= str2double(scalebar_x(1));
    sc=abs((str2double(scalebar_x(4))-str2double(scalebar_x(3)))/scale);
    munc_x=munc_x/sc;
    munc_y=munc_y/sc;
    ca_y=ca_y/sc;
    ca_x=ca_x/sc;
    ca_x=ca_x(ca_x<10e9);
    ca_x=ca_x(ca_x>10);
    ca_y=ca_y(ca_y<10e9);
    ca_y=ca_y(ca_y>10);
    munc_x=munc_x(munc_x<10e9);
    munc_x=munc_x(munc_x>10);
    munc_y=munc_y(munc_y<10e9);
    munc_y=munc_y(munc_y>10);
    xp=synAreax/sc;
    yp=synAreay/sc;
    xp(1:2)=[];
    yp(1:2)=[];
    xp=xp(xp<10e9);
    yp=yp(yp<10e9);

    are(i)=polyarea(xp,yp); % area of the AZ
    nuc_ma(i)=length(ca_x); %number of "cav" points
    num_munc(i)=length(munc_y); % number of "munc" points    
    % Calculate H(r) for data, CE
    [H_data(i,:), H_upper(i,:), L_lower(i,:), H_rand_temp]=H_fun_sim_bivar([munc_x munc_y],[ca_x ca_y],are(i),dist,sims,[xp yp],99);
    %standartization of the H(r) (standartization of CE to -1 1)
    [H_data_norm(i,:)]=standartization(H_data(i,:), L_lower(i,:), H_upper(i,:));
    %plot 
    hold on, plot(dist,H_data(i,:))
    % store all the H(r) generated for CE
    H_all=[H_all; H_rand_temp];
    % MAD test for the current pattern
    [h_pattern(i,:),pval_pattern(i)]=mad_test1(H_rand_temp,sims,H_data(i,:),99);

         
end
    %pooled H(r)
    H_ncols=mean(H_data);
    % MAD test for the population
    [H_tot,pval_tot]=mad_test1(H_all,ncols*sims,ncols,99);
    % plot
    hold on, plot(dist, H_ncols)


