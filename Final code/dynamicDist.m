function DTW=dynamicDist(m1,m2)

d=zeros(length(m1),length(m2));
for i=1:length(m1)
    for j=1:length(m2)
        if (i>1) && (j>1)
            if min(d(i-1,j-1),d(i-1,j))<d(i,j-1)
                d(i,j)=abs(m1(i)-m2(j))+min(d(i-1,j-1),d(i-1,j));
            else
                d(i,j)=abs(m1(i)-m2(j))+d(i,j-1);
            end
        elseif (i>1) && (j<=1)
            d(i,j)=abs(m1(i)-m2(j))+d(i-1,j);
        elseif (i<=1) && (j>1)
            d(i,j)=abs(m1(i)-m2(j))+d(i,j-1);
        elseif (i<=1) && (j<=1)
            d(i,j)=abs(m1(i)-m2(j));
        end
    end
end

i=length(m1);
j=length(m2);
DTW=d(i,j);
while i>=1||j>=1
    if i>1&&j>1
        if min(d(i-1,j-1),d(i-1,j))<d(i,j-1)
            DTW=DTW+min(d(i-1,j-1),d(i-1,j));
            if d(i-1,j-1)<d(i-1,j)
                i=i-1;
                j=j-1;
            else
                i=i-1;
                j=j;
            end
        else
            DTW=DTW+d(i,j-1);
            i=i;
            j=j-1;
        end
    elseif i==1&&j>1
        DTW=DTW+d(i,j-1);
        i=i;
        j=j-1;
    elseif j==1 && i>1
        DTW=DTW+d(i-1,j);
        i=i-1;
        j=j;
    else
        break
    end
end