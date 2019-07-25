% Mean NND Bivariate analysis for patterns with double labeling
d = dir('/Users/maria/Downloads/031319/mu_ca');
d(1:2)=[];

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
    num_ca(i)=length(ca_x); %number of "cav" points
    num_munc(i)=length(munc_y); % number of "munc" points
    min_d_ca(i)=min(nnds(length(ca_y),ca_x',ca_y')); %min nnd in the "Cav" population
    min_d_munc(i)=min(nnds(length(munc_y), munc_x',munc_y')); %min nnd in the "Munc" population
    %mean NND for the data
    min_munc_to_ch(i)=min(corss_nnds(length(munc_y), munc_x',munc_y', ca_x',ca_y'));

    %% generate models for bivarite data 
    for j=1:100
         [xu_c,yu_c,keeperX1,keeperY1]=EZ(xp,yp,are(i),50,8); % generate EZ
        for k=1:100
            [xr1,yr1]=points2(xp,yp,min_d_ca(i)); % generate random points in the AZ
            [in,on]=inpolygon(xr1,yr1,xp,yp); 
            xr_i1=xr1(in); % keep olny those that insie the AZ
            yr_i1=yr1(in);
            % generate second set of poitns that are not closer than
            % min_munc_to_ch(i) to the previous one and not closer than
            % min_d_munc(i) to each other
            [xr2,yr2]=points_cross(xp,yp,xr_i1,yr_i1,min_d_munc(i),min_munc_to_ch(i));            
            [in_m,on_m]=inpolygon(xr2,yr2,xp,yp);
            xm_i=xr2(in_m);
            ym_i=yr2(in_m);
            % generate EZ model: "Cav" outside, "munc" inside
            [a_nnd_ch(k,j),a_nnd_munc(k,j),a_nnd_munc2ch(k,j),a_nnd_ch2munc(k,j)]=gen_mod1(xr_i1,yr_i1,xu_c,yu_c,xm_i,ym_i,num_ca(i),num_munc(i));
            % generate EZ model: "Cav" inside, "munc" inside
            [d_nnd_ch(k,j),d_nnd_munc(k,j),d_nnd_munc2ch(k,j),d_nnd_ch2munc(k,j)]=gen_mod2(xr_i1,yr_i1,xu_c,yu_c,xm_i,ym_i,num_ca(i),num_munc(i));
            % generate EZ model: "Cav" inside, "munc" random
            [b_nnd_ch(k,j),b_nnd_munc(k,j),b_nnd_munc2ch(k,j),b_nnd_ch2munc(k,j)]=gen_mod3(xr_i1,yr_i1,xu_c,yu_c,xm_i,ym_i,num_ca(i),num_munc(i));
            % generate EZ model: "Cav" outside, "munc" outside
            [c_nnd_ch(k,j),c_nnd_munc(k,j),c_nnd_munc2ch(k,j),c_nnd_ch2munc(k,j)]=gen_mod4(xr_i1,yr_i1,xu_c,yu_c,xm_i,ym_i,num_ca(i),num_munc(i));
            % genrate null model
            [rand_ch_nnd(k,i),rand_munc_nnd(k,j),munc2ch_rand_nnd(k,j),ch2munc_rand_nnd(k,i)]=gen_rand_to_rand(xr_i1,yr_i1,xm_i,ym_i,num_ca(i),num_munc(i));           
    end
    end
    
NND_ch_to_munc_data(i)=mean(corss_nnds(length(munc_y), munc_x',munc_y', ca_x',ca_y'));
% calculate mean nnd for each sample
d_nnd_ch_t(i)=mean(mean(d_nnd_ch));
d_nnd_munc_t(i)=mean(mean(d_nnd_munc));
d_nnd_munc2ch_t(i)=mean(mean(d_nnd_munc2ch));
d_nnd_ch2munc_t(i)=mean(mean(d_nnd_ch2munc));

a_nnd_ch_t(i)=mean(mean(a_nnd_ch));
b_nnd_ch_t(i)=mean(mean(b_nnd_ch));
c_nnd_ch_t(i)=mean(mean(c_nnd_ch));
rand_ch_nnd_t(i)=mean(mean(rand_ch_nnd));

a_nnd_munc_t(i)=mean(mean(a_nnd_munc));
b_nnd_munc_t(i)=mean(mean(b_nnd_munc));
c_nnd_munc_t(i)=mean(mean(c_nnd_munc));
rand_munc_nnd_t(i)=mean(mean(rand_munc_nnd));

a_nnd_munc2ch_t(i)=mean(mean(a_nnd_munc2ch));
b_nnd_munc2ch_t(i)=mean(mean(b_nnd_munc2ch));
c_nnd_munc2ch_t(i)=mean(mean(c_nnd_munc2ch));
rand_munc2ch_nnd_t(i)=mean(mean(munc2ch_rand_nnd));

a_nnd_ch2munc_t(i)=mean(mean(a_nnd_ch2munc));
b_nnd_ch2munc_t(i)=mean(mean(b_nnd_ch2munc));
c_nnd_ch2munc_t(i)=mean(mean(c_nnd_ch2munc));
rand_ch2munc_nnd_t(i)=mean(mean(ch2munc_rand_nnd));
end 
% stat test
x=[a_nnd_ch2munc_t' b_nnd_ch2munc_t' c_nnd_ch2munc_t' d_nnd_ch2munc_t' rand_ch2munc_nnd_t' NND_ch_to_munc_data'];
[p,tbl,stat] = kruskalwallis(x);
c = multcompare(stat,'CType','lsd')
