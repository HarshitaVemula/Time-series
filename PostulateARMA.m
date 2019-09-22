function [m,Model,res]=PostulateARMA(ts,P,n);
N=length(ts);
m=mean(ts);
[n1,n2]=size(ts);
ts=ts-m*ones(n1,n2);
Cycle=1;

Data=iddata(ts);


CurrentModel=armax(Data,[2 1]);

r=resid(CurrentModel,Data);
residuals=r.y;
CurrentRSS=sum(residuals.^2);

while Cycle
    n=n+1;
    OldModel=CurrentModel;
    OldRSS=CurrentRSS;
    CurrentModel=armax(Data,[2*n 2*n-1]);
    
    r=resid(CurrentModel,Data);
    residuals=r.y;
    CurrentRSS=sum(residuals.^2); %residual sum of squares

    TestRatio=((OldRSS-CurrentRSS)/4)/(CurrentRSS/(N-4*n));
    Control=finv(P,4,N-4*n); 
    
    [TestRatio Control;2*n 2*n-1;2*n-2 2*n-3];
    if TestRatio<Control
        Cycle=0;
        PreliminaryModel=OldModel;
        PreliminaryRSS=OldRSS;
        [TestRatio Control;2*n-1 2*n-2]; 
    end
end
AR_Order=length(PreliminaryModel.a)-1;
MA_Order=length(PreliminaryModel.c)-1;



CurrentModel=armax(Data,[AR_Order-1 AR_Order-2]);
r=resid(CurrentModel,Data);
residuals=r.y;
CurrentRSS=sum(residuals.^2);
TestRatio=((CurrentRSS-PreliminaryRSS)/2)/(PreliminaryRSS/(N-(2*AR_Order-2)));

Control=finv(P,2,N-(2*AR_Order-2)); 
if TestRatio<Control
    PreliminaryModel=CurrentModel;
    PreliminaryRSS=CurrentRSS;
end


AR_Order=length(PreliminaryModel.a)-1;
MA_Order=length(PreliminaryModel.c)-1;
CurrMA=MA_Order;
CurrentModel=PreliminaryModel;
CurrentRSS=PreliminaryRSS;

if CurrMA>1
    Cycle=1;
else
    Cycle=0;
    Model=PreliminaryModel;
    RSS=PreliminaryRSS;
end

while Cycle
    
    if CurrMA>=1
        OldModel=CurrentModel;
        OldRSS=CurrentRSS;
        CurrMA=CurrMA-1;
        CurrMA
        CurrentModel=armax(Data,[AR_Order CurrMA]);
        r=resid(CurrentModel,Data);
        residuals=r.y;
        CurrentRSS=sum(residuals.^2);

        NumOfParams=AR_Order+CurrMA+1;
        TestRatio=((CurrentRSS-PreliminaryRSS)/1)/(PreliminaryRSS/(N-NumOfParams));
        
        Control=finv(P,1,NumOfParams);
        if TestRatio>Control
            Cycle=0;
            Model=OldModel;
            RSS=OldRSS;
        end
    else
        Model=armax(Data,[AR_Order CurrMA])
        break;
    end
end 

r=resid(Model,Data);
res=r.y;