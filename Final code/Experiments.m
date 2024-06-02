clc

y= TestData;

z=TrainData;
acc=0;
inf=[1 1];

for k=1:18
    clear now
    now= nchoosek([1:19],k);
    accuracy=acc;
    
    for m=1:length(now)
        clear check;
        check=now(m,:);
        check=[1 3 5 7 9 11 13 15 17 19];  %give 68.2% accuracy
        check=[1 3 5 7 9 11 13 15 17 19]  ;    %elements of check is feature no.
        
        dist=0;
        decision=zeros(44,1);
        s=0;
        
        for i=1:44
            dist1=dist;
            for j=1:144
                dist= sum((y(i,check)-z(j,check)).^2);
                if dist<dist1
                    dist1=dist;
                    decision(i,1)=TrainClass(j,1);
                end
            end
            
            if TestClass(i,1)== decision(i,1)
                s=s+1;
            end
        end
        
        accuracy=s/44;
        
        if acc> accuracy
            accuracy=acc;
            inf=[k m];
            
        end
    end
end
    
    accuracy
