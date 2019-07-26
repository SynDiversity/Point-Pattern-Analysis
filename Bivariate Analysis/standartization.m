function [H_s]=standartization(H,H_99_l,H_99_u)
% compute standarazed CE and H(r)
%%input
% - H: H(r) function for the observed pattern
% - H_99_l,H_99_u : upper an lower CE
%% output: H_s: standartized H(r) 

for i=1:length(H)
   temp(i)=H_99_l(i)/(H_99_u(i)-H_99_l(i));
   H_s(i)=H(i)/(H_99_u(i)-H_99_l(i))-temp(i);
   
end
