function G=GreenFunction(Model,TimeHorizon);


AR_Poly=Model.a;
MA_Poly=Model.c;
l=roots(AR_Poly); 

n=length(l);

for i=1:n
    Down=1;
    Up=polyval(MA_Poly,l(i));
    for j=1:n
        if j~=i
            Down=Down*(l(i)-l(j));
        end
    end
    C(i)=Up/Down;
end

for i=1:TimeHorizon
    G(i)=0;
    for j=1:n
        G(i)=G(i)+C(j)*l(j)^i;
    end
end
        
G=[1 real(G)]; 
        