function [NND_ch_ez_t,NND_munc_t,NND_munc_to_ch,NND_chto_munc_ez]=gen_mod3(xr_i,yr_i,xu_c,yu_c,xm_i,ym_i,le_ca,le_munc)
% generate bivariant pattern as EZ ("Cav" outside EZ, "munc" random)
%%input
% - xr_i,yr_i:  "Cav" coordinates
% - xu_c,yu_c: EZ coordiantes
% - xm_i,ym_i: "munc" coordinates
% - le_ca: number of "Cav" in the data
% - le_mun: number of "munc" in the data
%%output:
% - NND_ch_ez_t
% - NND_munc_t
% - NND_munc_to_ch
% - NND_chto_munc_ez

% leave only "Cav" that are outside the EZ
[in1,~]=inpolygon(xr_i,yr_i,xu_c,yu_c);
ch_xi=xr_i(~in1);
ch_yi=yr_i(~in1);
ch_x_r=ch_xi(1:le_ca); 
ch_y_r=ch_yi(1:le_ca);
% "munc" random
mu_x=xm_i(1:le_munc);
mu_y=ym_i(1:le_munc);
% mean nnd distriburions
NND_ch_ez_t=mean(nnds(le_ca, ch_x_r,ch_y_r));
NND_munc_t=mean(nnds(le_munc, mu_x,mu_y));
NND_munc_to_ch=mean(corss_nnds(le_munc, mu_x,mu_y, ch_x_r,ch_y_r));
NND_chto_munc_ez=mean(corss_nnds(le_ca,ch_x_r,ch_y_r, mu_x,mu_y));
    
 