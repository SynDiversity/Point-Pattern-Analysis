function [keepX,keepY]=points_cross(xp,yp,x1,y1,m_d1,m_d2)
%generate a saet of points which on a given the previous one
%%input
% - xp,yp: coordinates of the polygon, where poitns are generated
% - x1,y1: set of preexisitn points
% - m_d1: minimum distance between points to be generated
% - m_d2: minimum distance between point to be generated and preexisted
% ones
%% output: keepX,keepY: coordinates of points

% take randomly placed points in the minimum rectangle around the polygon xp,yp
x=min(xp)+(max(xp)-min(xp))*rand(1,5000);
y=min(yp)+(max(yp)-min(yp))*rand(1,5000);

% take first point that is not closer than m_d2 to preexisting points
DIST=pdist2([x; y]', [x1;y1]');
ind_d=find(mean(DIST'>m_d2)==1);
keepX = x(ind_d(1));
keepY = y(ind_d(1));

% generate coordinates of points that will be not closer then m_d1 from
% each other and not closer than m_d2 to (x1,y1)
counter = 2;
for k = 2 :5000
thisX = x(k);
	thisY = y(k);
	distances = sqrt((thisX-keepX).^2 + (thisY - keepY).^2);
    distances_cross = sqrt((thisX-x1).^2 + (thisY - y1).^2);
	minDistance = min(distances);
    minDistance_cross=min(distances_cross);
	if (minDistance >=m_d1) && (minDistance_cross >=m_d2)
		keepX(counter) = thisX;
		keepY(counter) = thisY;
		counter = counter + 1;
	end
end


