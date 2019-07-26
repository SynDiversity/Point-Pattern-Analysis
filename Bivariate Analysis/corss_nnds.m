function [nnd_le]= corss_nnds(l,x,y,xr,yr)
% calculation of nnd from one type points to another
%% input
% -l : number of points of "type 1"
% x,y: coordinates of "type 1" points
% xr,yr: coordinates of "type 2" points
%% output: nnd_le: nnds

for i=1:l
   [k,DIX]=knnsearch([x(i); y(i)]', [xr; yr]', 'k',1);
   DIX=sort(DIX);
   nnd_le(i)=DIX(1);
    
end