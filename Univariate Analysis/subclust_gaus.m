% Maria Reva 20/12/2017
%generate elements for a signle cluster according to gaussian distribtuion

function [keepX,keepY]=subclust_gaus(xc,yc,max_NND_lim, inter_cluster)

sigma = [-25 24; 24 25];
sigma = sigma*sigma';
X = mvnrnd([xc(1) yc(1)], sigma, 5000);
keepX(1) = xc;
keepY(1) = yc;
x=X(:,1);
y=X(:,2);

counter = 2;
for k = 1 :5000
    thisX = x(k);
	thisY = y(k);
	% See how far is is away from existing keeper points.
	distances = sqrt((thisX-keepX).^2 + (thisY - keepY).^2);
    distances_c = sqrt((thisX-xc).^2 + (thisY - yc).^2);

	minDistance = min(distances);
    minDistance_c = min(distances_c);
    
	if (minDistance >6 & minDistance <=max_NND_lim & minDistance_c<=inter_cluster)
		keepX(counter) = thisX;
		keepY(counter) = thisY;
		counter = counter + 1;
	end
end
