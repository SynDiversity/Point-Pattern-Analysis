% find nnd 
function [nnd_le]= nnds(l,x,y)

for i=1:l
   [k,DIX]=knnsearch([x(i); y(i)]', [x; y]', 'k',1);
   DIX=sort(DIX);
   nnd_le(i)=DIX(2);
    
end