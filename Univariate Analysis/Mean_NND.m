d = dir('/Users/maria/Downloads/MATLAB 2/Munc SC');
d(1:3)=[];
ncols = length(d);

for i=1:10
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
    min_d=7.1;%minimum allowed distance between points
    
    %% generate null model
   for j=1:10
         [xr,yr]=points2(xp,yp,7.1);
         [in,on]=inpolygon(xr,yr,xp,yp);
          xr_i1=xr(in);
          yr_i1=yr(in);
          xr_i_le=xr_i1(1:num_ca(i));
          yr_i_le=yr_i1(1:num_ca(i));
         % find nnd of the randomchannels
          NND_rand=nnds(num_ca(i),xr_i_le,yr_i_le);
          Mean_NND_rand(i,j)=mean(NND_rand);
   end    
    
    %% generate EZ model
%   num_ves=8;
%   ez_rad=50;
%    for j=1:100
%         [xu_c,yu_c,keeperX1,keeperY1]=EZ(xp,yp,area,ez_rad,num_ves);
%         k=1;
%         while k<100
%               [xr,yr]=points2(xp,yp,min_d);
%               [in,on]=inpolygon(xr,yr,xp,yp);
%                xr_i=xr(in);
%                yr_i=yr(in);
%                [in1,on1]=inpolygon(xr_i,yr_i,xu_c,yu_c);
%                xr_i1=xr_i(~in1);
%                yr_i1=yr_i(~in1);
%                if length(yr_i1)>=num_ca(i)
%                    xr_i_le=xr_i1(1:num_ca(i));
%                    yr_i_le=yr_i1(1:num_ca(i));
%                    k=k+1;
%                    % find nnd of the randomchannels
%                    NND_ez=nnds(num_ca(i),xr_i_le,yr_i_le);
%                    temp_m(j,k)=mean(NND_ez);
%                end
%         end
%    Mean_NND_EZ(i,j)=mean(temp_m(j,:));
%    end

    % mean NND for the data
    NND_exp=nnds(num_ca(i),ca_x',ca_y');
    Mean_NND_ex(i)=mean(NND_exp);
end 
% MW test
[h_mean_NND,p_mean_NND]=ranksum(Mean_NND_ex,mean(Mean_NND_rand))
% plotting
figure, cdfplot(Mean_NND_ex)
hold on, cdfplot(mean(Mean_NND_rand))
