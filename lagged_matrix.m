function Xl=lagged_matrix(X,n);
%n-number of lags
N=length(X);
for i=1:n
    Xl(i)=X(n+2-i:N+1-i)
end
for i=1:n
    z=zeros(1,i)
    Xl(i+n)=[z fliplr(X(1:n+1-i))]
end
Xl=Xl'