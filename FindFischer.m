function [F]=FindFischer(RestrParam,NumOfParams,f_95,ni1,ni2);






if RestrParam>120
    RestrParam=300; 
end

if NumOfParams>120
    NumOfParams=300; 
end




n1=RestrParam;
n2=NumOfParams;
%%%%%%%%%%%%%%

logic_ni1=(ni1-RestrParam)<0;
logic_ni2=(ni2-NumOfParams)<0;

ind1=find(logic_ni1==0);
ind2=find(logic_ni2==0);

if ind1(1)==1
    if ind2(1)==1
        F=f_95(1,1);
        Finished=1;
    else
        ni21=ni2(ind2(1)-1);
        ni22=ni2(ind2(1));
        C1=f_95(1,ind2(1)-1);C2=f_95(1,ind2(1));
        F=C1+[(C2-C1)/(ni22-ni21)]*(n2-ni21);
    end
        
    else
    ni11=ni1(ind1(1)-1);ni12=ni1(ind1(1));
    if ind2(1)==1
        C1=f_95(ind1(1)-1,1);C2=f_95(ind1(1),1);
        F=C1+[(C2-C1)/(ni12-ni11)]*(n1-ni11);
    else
        ni21=ni2(ind2(1)-1);
        ni22=ni2(ind2(1));
        F11=f_95(ind1(1)-1,ind2(1)-1);
        F12=f_95(ind1(1),ind2(1)-1);
        F22=f_95(ind1(1),ind2(1));
        F21=f_95(ind1(1)-1,ind2(1));
        C1=F11+[(F12-F11)/(ni12-ni11)]*(n1-ni11);
        C2=F21+[(F22-F21)/(ni12-ni11)]*(n1-ni11);
        F=C1+[(C2-C1)/(ni22-ni21)]*(n2-ni21);
    end
    
    
end

