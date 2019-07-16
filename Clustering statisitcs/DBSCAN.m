%DBSACN

function [IDX, trash]=DBSCAN(X,epsilon,MinPts)

    cl=0;
    n=size(X,1);
    checked=false(n,1);
    trash=false(n,1);
   
    IDX=zeros(n,1);

    D=pdist2(X,X);
    
    for i=1:n
        if ~checked(i)
            checked(i)=true;
            
            locals=find(D(i,:)<=epsilon);
            if numel(locals)< MinPts
                trash(i)=true;
            else
                cl=cl+1;
                ExpandCluster(i,locals,cl);
            end      
        end
    end
    
    function ExpandCluster(i,locals,C)
        IDX(i)=C;
        k = 1;
        while true
            j = locals(k);
            
            if ~checked(j)
                checked(j)=true;
                locals_temp=find(D(j,:)<=epsilon);
                if numel(locals_temp)>=MinPts
                    locals=[locals locals_temp];  
                end
            end
            if IDX(j)==0
                IDX(j)=C;
            end
            k = k + 1;
            if k > numel(locals)
                break;
            end
        end
    end
    

end



