% Maria Reva 20/12/2017
% generate cluster centers

function [keepX,keepY]=centers(ra,max_d)

 theta = rand(1,100000)*(2*pi);
 r1 = sqrt(rand(1,100000))*ra;
 x =  r1.*cos(theta);
 y = r1.*sin(theta);
keepX = x(1);
keepY = y(1);


counter = 2;
for k = 2 :100000
    thisX = x(k);
	thisY = y(k);
	% See how far is is away from existing keeper points.
	distances = sqrt((thisX-keepX).^2 + (thisY - keepY).^2);
    
	minDistance = min(distances);

	if (minDistance > max_d )
		keepX(counter) = thisX;
		keepY(counter) = thisY;
		counter = counter + 1;
	end
end


end
